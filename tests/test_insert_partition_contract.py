"""Finite single-key RANGE routing; not partition execution or a SQL oracle."""
import json
import unittest
from pathlib import Path

from core.finite_sql_contract import inspect_write, inspect_lifecycle


class InsertPartitionContractTests(unittest.TestCase):
    ddl = ("CREATE TABLE t (id INTEGER NOT NULL, note VARCHAR(64)) PARTITION BY RANGE(id) "
           "(PARTITION p_low VALUES LESS THAN(5), PARTITION p_high VALUES LESS THAN(MAXVALUE));")

    def check(self, sql, status, code=None, ddl=None):
        result = inspect_write(sql, [self.ddl if ddl is None else ddl])
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [issue['code'] for issue in result['issues']])
        if status == 'checked':
            self.assertIn('finite_explicit_partition_routing', result['checks'])

    def test_named_partition_and_exact_upper_boundary(self):
        for key, part, status in [(1, 'p_low', 'checked'), (-10, 'p_low', 'checked'),
                                  (5, 'p_low', 'rejected'), (5, 'p_high', 'checked'),
                                  (1000, 'p_high', 'checked')]:
            with self.subTest(key=key, part=part):
                self.check(f"INSERT INTO t PARTITION({part}) VALUES ({key}, 'x');", status)

    def test_for_value_selects_partition_not_equal_input_key(self):
        self.check("INSERT INTO t PARTITION FOR(2) VALUES(1, 'x');", 'checked')
        self.check("INSERT INTO t PARTITION FOR(5) VALUES(1, 'x');", 'rejected', 'partition_mismatch')

    def test_checks_all_rows_and_explicit_column_order(self):
        self.check("INSERT INTO t PARTITION(p_low) VALUES(1,'x'),(5,'y');", 'rejected')
        self.check("INSERT INTO t PARTITION(p_low) AS dst (dst.note,dst.id) "
                   "VALUES('x',1) RETURNING *;", 'checked')
        self.check("INSERT INTO t PARTITION(p_low) (note,id) VALUE('x',2);", 'checked')

    def test_missing_partition_and_outside_all_finite_bounds(self):
        self.check("INSERT INTO t PARTITION(missing) VALUES(1,'x');", 'rejected', 'missing_partition')
        ddl = self.ddl.replace('MAXVALUE', '10')
        self.check("INSERT INTO t PARTITION(p_high) VALUES(10,'x');", 'rejected', 'partition_out_of_range', ddl)
        self.check("INSERT INTO t PARTITION FOR(10) VALUES(1,'x');", 'rejected', 'partition_out_of_range', ddl)

    def test_unsupported_or_ambiguous_ddl_stays_unknown(self):
        variants = [
            self.ddl.replace('RANGE(id)', 'RANGE(id,note)'),
            self.ddl.replace('RANGE(id)', 'HASH(id)'),
            self.ddl.replace('RANGE(id)', 'LIST(id)'),
            self.ddl.replace('RANGE(id)', 'RANGE(id) INTERVAL(5)'),
            self.ddl.replace('RANGE(id)', 'RANGE(id) SUBPARTITION BY RANGE(id)'),
            self.ddl.replace('MAXVALUE', '4'),
            self.ddl.replace('p_high', 'p_low'),
            self.ddl.replace('THAN(5)', 'THAN(MAXVALUE)'),
            self.ddl.replace('VALUES LESS THAN(5)', 'START(0) END(5)'),
            self.ddl.replace('THAN(5)', 'THAN(5,6)'),
            self.ddl.replace(';', ' UNSUPPORTED TAIL;'),
            self.ddl.replace('INTEGER NOT NULL', 'VARCHAR(64)'),
            self.ddl.replace('THAN(5)', "THAN('5')"),
            self.ddl.replace(';', '; DROP TABLE other;'),
        ]
        for ddl in variants:
            with self.subTest(ddl=ddl):
                self.check("INSERT INTO t PARTITION(p_low) VALUES(1,'x');", 'needs_review', ddl=ddl)

    def test_unknown_inputs_and_selectors_are_not_proofs(self):
        for target, source in [
            ('PARTITION(p_low)', "VALUES(DEFAULT,'x')"),
            ('PARTITION(p_low)', "VALUES(NULL,'x')"),
            ('PARTITION(p_low)', "VALUES(1+1,'x')"),
            ('PARTITION(p_low)', "SELECT 1,'x'"),
            ('PARTITION(p_low) (note)', "VALUES('x')"),
            ('PARTITION(p_low,p_high)', "VALUES(1,'x')"),
            ('SUBPARTITION(p_low)', "VALUES(1,'x')"),
            ('PARTITION FOR(1+1)', "VALUES(1,'x')"),
            ('PARTITION(p_low) dst', "VALUES(1,'x')"),
        ]:
            with self.subTest(target=target, source=source):
                self.check(f'INSERT INTO t {target} {source};', 'needs_review')

    def test_real_six_candidates_get_route_evidence_not_cleanup_approval(self):
        path = Path(__file__).resolve().parents[1] / 'generated/factor_packages/generation_report.json'
        report = json.loads(path.read_text())
        cases = report['manifests']['manifest_insert_partition_positive']['cases']
        self.assertEqual(len(cases), 6)
        for case in cases:
            with self.subTest(case_id=case['case_id']):
                self.assertEqual(inspect_write(case['sql'], case['setup_sqls'])['status'], 'checked')
                self.assertEqual(inspect_lifecycle(case['setup_sqls'], case['teardown_sqls'])['status'],
                                 'needs_review')
        negative = report['manifests']['manifest_insert_partition_alias_negative']['cases']
        self.assertEqual(len(negative), 1)
        for case in negative:
            self.assertEqual(inspect_write(case['sql'], case['setup_sqls'])['status'], 'rejected')

    def test_real_generator_rejects_injected_partition_mismatch(self):
        from core.factor_package_model import FactorPackageRegistry
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        registry.load_all()
        manifest = registry.manifests['manifest_insert_partition_positive']
        profiles = registry.matrices['matrix_insert_source_profiles'].profiles
        for profile in profiles:
            if profile.id in manifest.bindings['source_profile']:
                # Mutation is in memory only; real source spec/expectation is unchanged.
                profile.render = "VALUES (5, 'wrong partition')"
        with self.assertRaisesRegex(GenerationValidationError, 'partition_mismatch'):
            FactorPackageSQLGenerator(registry).generate_with_report(manifest)


if __name__ == '__main__':
    unittest.main()
