"""Finite policy/package SQL and evidence-only external contracts; no DB execution."""
import hashlib
import itertools
import json
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class Batch10Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.plan = json.loads((ROOT / 'tests/data/batch_10.json').read_text())
        cls.factors = {f.id: f for f in cls.registry.factors.values()
                       if f.name in cls.plan['new_chapters']}

    def cases(self, mid):
        return self.generator.generate_with_report(self.registry.manifests[mid])[0]

    def factor_cases(self, fid):
        return [c for mid in self.factors[fid].manifest_refs for c in self.cases(mid)]

    def test_batch_count_and_source_identity(self):
        self.assertEqual(len(self.factors), 29)
        path = ROOT / self.plan['source_catalog']
        if not path.exists():
            self.skipTest('Local PDF corpus is not distributed')
        chapters = {c['title']: c for c in json.loads(path.read_text())['chapters']}
        for f in self.factors.values():
            raw = (path.parent / chapters[f.name]['source_relpath']).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), f.source.artifact_sha256)
            self.assertEqual(self.registry.source_ledgers[f.source_ledger_ref].source_line_count,
                             len(raw.decode().splitlines()))

    def test_source_atomicity_consumption_and_honest_status(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, f in self.factors.items():
            a = auditor.audit(fid)
            self.assertTrue(a['conclusions']['source_extraction_complete'], fid)
            self.assertFalse(a['conclusions']['behavior_coverage_complete'], fid)
            self.assertEqual(a['source_units']['atomicity']['gaps'], [], fid)
            self.assertEqual(a['facts']['unconsumed_confirmed'], [], fid)
            self.assertEqual(a['facts']['wrong_consumer_type'], [], fid)
            self.assertEqual(f.status, 'needs_review')

    def test_external_keys_links_and_fdw_are_not_fake_ordinary_cases(self):
        no_sql = {'create_global_index'}
        self.assertEqual({fid for fid, f in self.factors.items() if not f.manifest_refs}, no_sql)
        self.assertEqual(self.factors['alter_foreign_table'].manifest_refs, [
            'manifest_alter_foreign_table_log_implicit', 'manifest_alter_foreign_table_log_add',
            'manifest_alter_foreign_table_log_set', 'manifest_alter_foreign_table_log_drop'])
        for case in self.factor_cases('alter_foreign_table'):
            self.assertEqual(case.expected_scope, 'syntax_only')
            self.assertTrue(any('FOREIGN DATA WRAPPER log_fdw' in s for s in case.setup_sqls))
            self.assertNotIn('filename', ' '.join(case.setup_sqls+[case.sql]))
        self.assertFalse(FactorCoverageAuditor(self.registry).audit('alter_foreign_table')
                         ['conclusions']['behavior_coverage_complete'])
        for fid in ('create_foreign_table', 'drop_foreign_table'):
            expected = ['manifest_'+fid+'_log_catalog']
            if fid == 'create_foreign_table':
                expected += ['manifest_create_foreign_table_file_text', 'manifest_create_foreign_table_file_csv']
            self.assertEqual(self.factors[fid].manifest_refs, expected)
            case = self.factor_cases(fid)[0]
            self.assertEqual(case.expected_scope, 'syntax_only')
            self.assertTrue(any('FOREIGN DATA WRAPPER log_fdw' in s for s in case.setup_sqls))
            self.assertNotIn('filename', ' '.join(case.setup_sqls+[case.sql]))
            self.assertFalse(FactorCoverageAuditor(self.registry).audit(fid)['conclusions']['behavior_coverage_complete'])

    def test_gsi_is_not_partition_global_index_syntax(self):
        f = self.factors['create_global_index']
        self.assertTrue(any(x.type == 'environment' and '不支持' in x.statement for x in f.facts))
        self.assertEqual(self.registry.syntaxes[f.syntax_ref].status, 'draft')
        self.assertFalse(f.dimensions)

    def test_tde_rotation_is_not_client_master_key_dependency(self):
        self.assertEqual(self.plan['extraction_dependencies']['ALTER ASYNC ENCRYPTION KEY ROTATION'], [])
        f = self.factors['alter_async_encryption_key_rotation']
        self.assertTrue(any(x.type == 'environment' and '全局' in x.statement for x in f.facts))

    def test_key_manager_conflict_and_external_key_retention(self):
        f = self.factors['create_column_encryption_key']
        self.assertTrue(any(x.type == 'constraint' and x.status == 'confirmed' and 'third_kms' in x.statement for x in f.facts))
        f = self.factors['drop_client_master_key']
        self.assertTrue(any('不删除' in x.statement and '密钥实体' in x.statement for x in f.facts))
        f = self.factors['drop_column_encryption_key']
        self.assertTrue(any('不能删除' in x.statement and '加密列' in x.statement for x in f.facts))

    def test_fdw_has_actual_copy_source_not_log_fdw_substitution(self):
        for fid in ('create_foreign_table', 'alter_foreign_table'):
            ledger = self.registry.source_ledgers[self.factors[fid].source_ledger_ref]
            self.assertTrue(any('COPY' in x.document for x in ledger.supplemental_sources))
        self.assertTrue(any(x.type == 'constraint' and x.status == 'confirmed'
                            and 'OPTIONS' in x.statement
                            for x in self.factors['alter_foreign_table'].facts))

    def test_pair_projections_and_case_identity(self):
        ids = []
        for f in self.factors.values():
            sqls = []
            for mid in f.manifest_refs:
                m = self.registry.manifests[mid]
                cs, report = self.generator.generate_with_report(m)
                keys = sorted(m.bindings)
                all_pairs = set()
                for vs in itertools.product(*(m.bindings[k] for k in keys)):
                    all_pairs.update(itertools.combinations(zip(keys, vs), 2))
                actual = {pair for c in cs for pair in
                          itertools.combinations([(k, c.params[k]) for k in keys], 2)}
                has_rules = bool(self.registry.get_factor(m.factor_ref).rules)
                if m.violates_rule_refs or has_rules:
                    self.assertTrue(actual <= all_pairs, mid)
                else:
                    self.assertEqual(actual, all_pairs, mid)
                self.assertFalse(report.missing_pairs, mid)
                ids.extend(c.case_id for c in cs)
                sqls.extend(c.sql for c in cs)
            self.assertEqual(len(sqls), len(set(sqls)), f.id)
        self.assertEqual(len(ids), len(set(ids)))

    def test_audit_keyword_category_is_not_repeated_or_mixed(self):
        for c in self.factor_cases('create_audit_policy'):
            self.assertNotIn('PRIVILEGES ACCESS', c.sql)
            self.assertNotIn('ACCESS PRIVILEGES', c.sql)
            if 'ON LABEL' in c.sql:
                self.assertIn('ON LABEL (b9_rl_b)', c.sql)
                self.assertTrue(any('b9_rl_b' in s and 'CREATE RESOURCE LABEL' in s for s in c.setup_sqls))

    def test_policy_remove_and_drop_filter_have_matching_state(self):
        for c in self.cases('manifest_alter_audit_policy_remove'):
            self.assertTrue(any('ADD PRIVILEGES (DROP)' in s for s in c.setup_sqls))
        for c in self.cases('manifest_alter_masking_policy_remove'):
            self.assertTrue(any('ADD randommasking ON LABEL(b10_mask_b)' in s for s in c.setup_sqls))
        for mid in ('manifest_alter_audit_policy_drop_filter', 'manifest_alter_masking_policy_drop_filter'):
            for c in self.cases(mid):
                self.assertTrue(any('CREATE ' in s and "FILTER ON IP('127.0.0.1')" in s
                                    for s in c.setup_sqls))

    def test_masking_function_is_complete_and_has_real_text_columns(self):
        for c in self.factor_cases('create_masking_policy'):
            self.assertIn('ON LABEL (', c.sql)
            self.assertNotIn('regepmasking', c.sql)
            self.assertNotIn('regexpmasking', c.sql)
            self.assertTrue(any('CREATE TABLE b10_mask_source (col_1 TEXT' in s for s in c.setup_sqls))

    def test_event_create_is_disabled_and_schema_is_owned(self):
        for c in self.factor_cases('create_event'):
            self.assertIn('DISABLE', c.sql)
            self.assertIn('fp_cs_one.b10_event_new', c.sql)
            self.assertTrue(any(s == 'CREATE SCHEMA fp_cs_one;' for s in c.setup_sqls))
            self.assertIn('DROP EVENT IF EXISTS fp_cs_one.b10_event_new;', c.teardown_sqls)
            self.assertEqual({g['key']: g['allowed_values'] for g in c.environment_requirements}['sql_compatibility'], ['B'])

    def test_event_rename_cleans_both_names_without_generic_drop(self):
        c = self.cases('manifest_alter_event_rename')[0]
        self.assertIn('DROP EVENT IF EXISTS fp_cs_one.b10_event_existing;', c.teardown_sqls)
        self.assertIn('DROP EVENT IF EXISTS fp_cs_one.b10_event_renamed;', c.teardown_sqls)

    def test_rls_is_boolean_and_read_semantics_not_insert_rejection(self):
        f = self.factors['create_row_level_security_policy']
        self.assertTrue(any('不影响INSERT' in x.statement for x in f.facts))
        cs = self.factor_cases(f.id)
        self.assertTrue(any('NULL::boolean' in c.sql for c in cs))
        self.assertTrue(all('USING (' in c.sql for c in cs))
        for c in cs:
            self.assertIn('ALTER TABLE b10_rls_source ENABLE ROW LEVEL SECURITY;', c.setup_sqls)

    def test_package_body_has_declaration_and_named_end(self):
        for c in self.cases('manifest_create_package_body'):
            self.assertIn('PACKAGE BODY fp_cs_one.b10_package_new', c.sql)
            self.assertTrue(c.sql.endswith('END b10_package_new;'))
            self.assertTrue(any('CREATE PACKAGE fp_cs_one.b10_package_new' in s for s in c.setup_sqls))

    def test_no_secrets_pdf_notation_or_unbounded_cleanup(self):
        for fid in self.factors:
            for c in self.factor_cases(fid):
                if c.expected == 'success':
                    self.assertEqual(c.expected_scope, 'syntax_only')
                else:
                    self.assertEqual(c.expected_scope, 'syntax_and_semantics')
                for sql in c.setup_sqls + [c.sql] + c.teardown_sqls:
                    self.assertTrue(sql.endswith(';'))
                    self.assertNotRegex(sql, r'\{[a-z_]+\}|\.\.\.|gaussdb=#|\*{4}')
                    self.assertNotRegex(sql.upper(), r"PASSWORD\s+'|IDENTIFIED BY\s+'|DROP OWNED|EXCEPTION WHEN")


if __name__ == '__main__':
    unittest.main()
