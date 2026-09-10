"""Actual RANGE/RANGE fixture and LOCAL mapping, not database execution proof."""
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_create_index_subpartition_local_fresh'
FIXTURE = 'fixture_create_index_subpartition_fresh'


class IndexSubpartitionContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def generate(self):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_two_real_local_shapes_share_owned_range_range_asset(self):
        cases, report = self.generate()
        self.assertEqual(len(cases), 2)
        self.assertEqual(len({case.case_id for case in cases}), 2)
        self.assertTrue(report.pairwise_complete)
        for case in cases:
            self.assertIn(' ON g_ci_sub_source USING btree (id) LOCAL', case.sql)
            self.assertEqual(len(case.setup_sqls), 1)
            self.assertIn('SUBPARTITION BY RANGE (region)', case.setup_sqls[0])
            self.assertEqual(case.teardown_sqls, ['DROP TABLE g_ci_sub_source;'])
        named = next(case for case in cases if '(PARTITION' in case.sql)
        self.assertEqual(named.sql.count('SUBPARTITION'), 4)
        self.assertNotIn(' FOR ', named.sql)
        self.assertTrue(any(case.sql.endswith(' LOCAL;') for case in cases))

    def test_wrong_table_engine_key_or_bounds_are_rejected(self):
        self.generate()
        fixture = self.r.fixtures[FIXTURE]
        old = list(fixture.execution.setup_sqls)
        try:
            for before, after in [('storage_type=astore', 'storage_type=ustore'),
                                  ('RANGE (region)', 'RANGE (missing)'),
                                  ('id INTEGER', 'id TEXT'),
                                  ('PARTITION p2 VALUES LESS THAN (20)', 'PARTITION p2 VALUES LESS THAN (5)'),
                                  ('SUBPARTITION p2s2 VALUES LESS THAN (20)', 'SUBPARTITION p2s1 VALUES LESS THAN (20)')]:
                with self.subTest(after=after):
                    fixture.execution.setup_sqls = [old[0].replace(before, after)]
                    with self.assertRaises(GenerationValidationError):
                        self.generate()
        finally:
            fixture.execution.setup_sqls = old

    def test_missing_or_extra_index_subpartitions_cannot_pass(self):
        self.generate()
        values = self.r.factors['create_index'].dimensions['scope_clause'].classes[0].values
        named = next(v for v in values if v.id == 'ci_scope_local_subpartition_named_fresh')
        old = named.render
        try:
            for replacement in [old.replace(', SUBPARTITION idx_p2s2', ''),
                                old.replace('idx_p2s2', 'idx_p1s1'),
                                old.replace('PARTITION idx_p1 (', 'PARTITION idx_p1 FOR p1 (')]:
                named.render = replacement
                with self.assertRaises(GenerationValidationError):
                    self.generate()
        finally:
            named.render = old

    def test_missing_contract_or_declared_layout_drift_is_rejected(self):
        self.generate()
        profile = next(p for p in self.r.matrices['matrix_create_index_table_profiles'].profiles
                       if p.id == 'ci_table_subpartition_fresh')
        import copy
        old = copy.deepcopy(profile.properties)
        try:
            profile.properties['partition_layout'][0]['name'] = 'not_p1'
            with self.assertRaises(GenerationValidationError):
                self.generate()
            profile.properties = copy.deepcopy(old)
            profile.properties.pop('index_partition_contract')
            with self.assertRaises(GenerationValidationError):
                self.generate()
        finally:
            profile.properties = old

    def test_rollback_and_unscoped_cleanup_do_not_prove_owned_cleanup(self):
        self.generate()
        fixture = self.r.fixtures[FIXTURE]
        old = list(fixture.execution.teardown_sqls)
        try:
            for sql in ['ROLLBACK;', 'DROP TABLE other;', 'DROP TABLE g_ci_sub_source CASCADE;']:
                fixture.execution.teardown_sqls = [sql]
                with self.assertRaises(GenerationValidationError):
                    self.generate()
        finally:
            fixture.execution.teardown_sqls = old

    def test_original_generic_value_and_runtime_gaps_remain(self):
        self.generate()
        values = self.r.resolve_dimension_values('create_index')['table_profile']
        self.assertEqual(values['ci_table_subpartitioned'].validity, 'conditional')
        self.assertEqual(values['ci_table_subpartitioned'].fixture_refs, [])
        scenario = self.r.scenarios['scenario_create_index_subpartition_local_fresh']
        self.assertEqual(scenario.status, 'planned')

    def test_actual_setup_cannot_hide_behind_an_ordinary_profile_flag(self):
        self.generate()
        profile = next(p for p in self.r.matrices['matrix_create_index_table_profiles'].profiles
                       if p.id == 'ci_table_subpartition_fresh')
        old = profile.properties['subpartitioned']
        try:
            profile.properties['subpartitioned'] = False
            with self.assertRaises(GenerationValidationError):
                self.generate()
        finally:
            profile.properties['subpartitioned'] = old

    def test_positional_mapping_and_out_of_domain_sql(self):
        from core.index_partition_contract import check_index_partition
        cases, _ = self.generate()
        case = next(c for c in cases if '(PARTITION' in c.sql)
        profile = next(p for p in self.r.matrices['matrix_create_index_table_profiles'].profiles
                       if p.id == 'ci_table_subpartition_fresh')
        gates = {g.key: g.allowed_values for g in self.r.manifests[MID].environment_requirements}
        def check(sql, actual_gates=gates):
            return check_index_partition(sql, case.setup_sqls, case.teardown_sqls,
                target=profile.render, properties=profile.properties, gates=actual_gates)
        result = check(case.sql)
        self.assertEqual(result['positional_mapping'], [
            {'index': 'idx_p1', 'table': 'p1', 'children': [
                {'index': 'idx_p1s1', 'table': 'p1s1'}, {'index': 'idx_p1s2', 'table': 'p1s2'}]},
            {'index': 'idx_p2', 'table': 'p2', 'children': [
                {'index': 'idx_p2s1', 'table': 'p2s1'}, {'index': 'idx_p2s2', 'table': 'p2s2'}]}])
        self.assertFalse(result['runtime_proven'])
        self.assertFalse(result['cleanup_ownership_proven'])
        for before, after in [('CREATE INDEX', 'CREATE UNIQUE INDEX'),
                              (' ON ', ' CONCURRENTLY ON '), ('USING btree', 'USING gin'),
                              (' LOCAL ', ' GLOBAL '), ('(id) LOCAL', '(missing) LOCAL')]:
            with self.subTest(after=after), self.assertRaises(ValueError):
                check(case.sql.replace(before, after))
        with self.assertRaises(ValueError):
            check(case.sql, {key: value for key, value in gates.items() if key != 'case_namespace'})


if __name__ == '__main__':
    unittest.main()
