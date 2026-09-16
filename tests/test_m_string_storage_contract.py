"""M source conditions are not interchangeable with general-mode typmods."""
import unittest
from types import SimpleNamespace

from core.finite_sql_contract import inspect_write


REQUIREMENTS = [
    {'key': 'compatibility_mode', 'allowed_values': ['M']},
    {'key': 'server_encoding', 'allowed_values': ['UTF8']},
    {'key': 'client_encoding', 'allowed_values': ['UTF8']},
    {'key': 'character_set_connection', 'allowed_values': ['utf8mb4']},
    {'key': 'character_set_database', 'allowed_values': ['utf8mb4']},
]


class MStringStorageContractTests(unittest.TestCase):
    def inspect(self, sql, ddl, requirements=REQUIREMENTS):
        return inspect_write(sql, [ddl], conflict_source_scope='m_compat',
                             environment_requirements=requirements)

    def test_m_text_byte_ceiling_cannot_be_treated_as_unbounded(self):
        literal = "'" + 'a' * 65536 + "'"
        for sql in (f'INSERT INTO t VALUES ({literal})', f'UPDATE t SET note={literal}'):
            result = self.inspect(sql, 'CREATE TABLE t (note TEXT)')
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], 'string_length_unknown')
        result = self.inspect('UPDATE t SET note=DEFAULT', f'CREATE TABLE t (note TEXT DEFAULT {literal})')
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'default_length_unknown')

    def test_utf8_character_length_and_byte_storage_are_separate(self):
        for typ, literal, status in (
            ('VARCHAR(2)', "'中文'", 'checked'),
            ('VARCHAR(2)', "'😀好'", 'checked'),
            ('VARCHAR(2)', "'中文好'", 'needs_review'),
            ('TEXT', "'" + '中' * 21845 + "'", 'checked'),
            ('TEXT', "'" + '中' * 21846 + "'", 'needs_review'),
            ('VARCHAR(20000)', "'a'", 'needs_review'),
            ('VARCHAR', "'a'", 'needs_review'),
            ('VARCHAR(0)', "''", 'needs_review'),
        ):
            with self.subTest(typ=typ, literal_length=len(literal)):
                result = self.inspect(f'INSERT INTO t VALUES ({literal})', f'CREATE TABLE t (note {typ})')
                self.assertEqual(result['status'], status, result)
                if status == 'checked':
                    self.assertIn('shared_m_utf8_string_storage', result['checks'])
                    self.assertNotIn('shared_ascii_string_literal_lengths', result['checks'])

    def test_default_explicit_and_omitted_paths_use_the_same_contract(self):
        for literal, status in (("'中文'", 'checked'), ("'中文好'", 'needs_review')):
            ddl = f'CREATE TABLE t (id INT, note VARCHAR(2) DEFAULT {literal})'
            for sql in ('INSERT INTO t (id) VALUES (1)', 'INSERT INTO t VALUES (1,DEFAULT)',
                        'UPDATE t SET note=DEFAULT', f'UPDATE t SET note={literal}'):
                result = self.inspect(sql, ddl)
                self.assertEqual(result['status'], status, result)
                if status == 'checked':
                    self.assertIn('shared_m_utf8_string_storage', result['checks'])

    def test_missing_duplicate_or_wrong_mode_encoding_gates_are_not_proof(self):
        for requirements in (None, [], REQUIREMENTS[1:], REQUIREMENTS[:-1],
                             REQUIREMENTS + [REQUIREMENTS[0]],
                             [dict(r, allowed_values=['PG']) if r['key']=='compatibility_mode' else r
                              for r in REQUIREMENTS],
                             [dict(r, allowed_values=['LATIN1']) if r['key']=='client_encoding' else r
                              for r in REQUIREMENTS]):
            result = self.inspect("INSERT INTO t VALUES ('ab')", 'CREATE TABLE t (note VARCHAR(2))', requirements)
            self.assertEqual(result['status'], 'needs_review', result)

    def test_general_source_and_opaque_ddl_do_not_borrow_m_proof(self):
        result = inspect_write("INSERT INTO t VALUES ('中文')", ['CREATE TABLE t (note VARCHAR(2))'],
                               environment_requirements=REQUIREMENTS)
        self.assertEqual(result['status'], 'needs_review', result)
        for ddl in ('CREATE TABLE t (note VARCHAR(2) CHARACTER SET latin1)',
                    'CREATE TABLE t (note CHAR(2))'):
            result = self.inspect("INSERT INTO t VALUES ('a')", ddl)
            self.assertNotIn('shared_m_utf8_string_storage', result['checks'])

    def test_current_schema_encoding_cannot_prove_another_schema(self):
        result = self.inspect("INSERT INTO other_schema.t VALUES ('中文')",
                              'CREATE TABLE other_schema.t (note VARCHAR(2))')
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'm_string_environment_unknown')

    def test_audit_report_transports_requirements_without_runtime_promotion(self):
        from scripts.audit_rendered_sql_contracts import audit_report
        case = dict(case_id='m_text_case', factor_id='m_insert', expected='success',
                    sql="INSERT INTO t VALUES ('中文')", setup_sqls=['CREATE TABLE t (note VARCHAR(2))'],
                    teardown_sqls=['DROP TABLE t'], environment_requirements=REQUIREMENTS)
        result = audit_report({'manifests': {'manifest_m_text': {'cases': [case]}}})
        self.assertEqual(result['cases'][0]['write_contract']['status'], 'checked')
        self.assertFalse(result['database_executed'])
        case['environment_requirements'] = []
        result = audit_report({'manifests': {'manifest_m_text': {'cases': [case]}}})
        self.assertEqual(result['cases'][0]['write_contract']['status'], 'needs_review')

    def test_fixture_seed_uses_the_same_m_requirements(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        factor = SimpleNamespace(
            structural_checks=[SimpleNamespace(kind='fixture_write_contract', fact_refs=['f'])],
            facts=[SimpleNamespace(id='f', type='constraint', status='confirmed')],
            source=SimpleNamespace(catalog_chapter_ref=SimpleNamespace(source_relpath='m_compat/dml/insert.txt')))
        setup = ['CREATE TABLE t (note VARCHAR(2))', "INSERT INTO t VALUES ('中文')"]
        check = FactorPackageSQLGenerator._validate_fixture_write_contract
        check(factor, setup, environment_requirements=REQUIREMENTS)
        with self.assertRaisesRegex(GenerationValidationError, 'm_string_environment_unknown'):
            check(factor, setup)

    def test_escape_nul_and_view_defaults_remain_unproved(self):
        for literal in ("'a\\n'", "'\x00'", "'\ud800'"):
            self.assertEqual(self.inspect(f'INSERT INTO t VALUES ({literal})',
                                         'CREATE TABLE t (note VARCHAR(8))')['status'], 'needs_review')
        result = inspect_write('UPDATE v SET label=DEFAULT',
            ["CREATE TABLE t (note VARCHAR(2) DEFAULT '中文')", 'CREATE VIEW v(label) AS SELECT note FROM t'],
            conflict_source_scope='m_compat', environment_requirements=REQUIREMENTS)
        self.assertEqual(result['status'], 'needs_review', result)
