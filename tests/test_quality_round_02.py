"""Independent contracts for the second finite-quality batch; no DB execution."""
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write


class QualityRound02Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def cases(self, manifest):
        self.assertTrue(manifest in self.registry.manifests, manifest)
        return self.generator.generate_with_report(self.registry.manifests[manifest])[0]

    def test_partition_payload_is_real_nonkey_data(self):
        cases = self.cases('manifest_update_partition_payload_positive')
        self.assertGreaterEqual(len(cases), 12)
        for c in cases:
            self.assertIn('payload', c.sql)
            self.assertEqual(inspect_write(c.sql, c.setup_sqls)['status'], 'checked')
            self.assertTrue(any('payload INT' in s and 'CREATE TABLE' in s for s in c.setup_sqls))
            self.assertFalse(any('BY RANGE (payload)' in s for s in c.setup_sqls))
            self.assertTrue(any('INSERT INTO' in s and ',100)' in s for s in c.setup_sqls))
        self.assertTrue(any('payload = 42' in c.sql for c in cases))
        self.assertTrue(any('payload = payload + 1' in c.sql for c in cases))

    def test_new_partition_lifecycle_starts_transaction_before_schema(self):
        for fid in ('update', 'delete'):
            for c in self.cases('manifest_' + fid + '_partition_payload_positive'):
                self.assertEqual(c.setup_sqls[0], 'BEGIN;')
                self.assertEqual(c.setup_sqls[1], 'CREATE SCHEMA fp_q2;')
                self.assertEqual(c.teardown_sqls[-1], 'ROLLBACK;')
                self.assertNotIn('DROP SCHEMA', '\n'.join(c.teardown_sqls))
                self.assertNotIn('COMMIT;', c.setup_sqls)
                self.assertEqual(c.expected_scope, 'syntax_only')

    def test_copy_subset_and_order_keep_documented_stream_formats(self):
        for mid in ('manifest_copy_text_stdout', 'manifest_copy_csv_stdout'):
            sqls = [c.sql for c in self.cases(mid)]
            for columns in ('(col_1)', '(col_2)', '(col_2, col_1)'):
                self.assertTrue(any(columns in s for s in sqls), columns)
            self.assertTrue(all('TO STDOUT' in s and "'binary'" not in s.lower() for s in sqls))

    def test_replace_three_rows_and_all_forms_use_real_fixture_shape(self):
        for form in ('values', 'value', 'query', 'set'):
            cases = self.cases('manifest_replace_' + form)
            self.assertTrue(cases)
            for c in cases:
                self.assertEqual(inspect_write(c.sql, c.setup_sqls)['status'], 'checked', c.sql)
            if form in ('values', 'value'):
                self.assertTrue(any('(1,12)' in c.sql and '(3,30)' in c.sql for c in cases))

    def test_values_nested_expression_survives_ast_rendering(self):
        cases = self.cases('manifest_values_single')
        fetch_cases = self.cases('manifest_values_fetch')
        self.assertTrue(any('(1 + 2) * 3' in c.sql for c in cases))
        self.assertTrue(any('OFFSET 1 ROW' in c.sql and 'FETCH' in c.sql for c in fetch_cases))
        self.assertFalse(any('LIMIT' in c.sql and 'FETCH' in c.sql for c in cases))

    def test_select_into_expression_has_explicit_distinct_output_names(self):
        cases = self.cases('manifest_select_into_positive')
        self.assertTrue(any('col_1 + 1 AS shifted, col_2 AS kept' in c.sql for c in cases))

    def test_single_delete_self_using_is_not_promoted_past_conditional_gate(self):
        factor = self.registry.factors['delete']
        values = [v for cl in factor.dimensions['single_using_clause'].classes for v in cl.values]
        self.assertEqual(next(v for v in values if v.id == 'delete_using_target_b').validity, 'conditional')
        self.assertEqual(self.registry.scenarios['scenario_delete_single_using_target_b'].status, 'planned')
        self.assertNotIn('manifest_delete_single_using_target_b', self.registry.manifests)

    def test_update_subquery_shapes_are_checked_without_claiming_cardinality(self):
        for c in self.cases('manifest_update_assignment_subquery_positive'):
            check = inspect_write(c.sql, c.setup_sqls)
            self.assertEqual(check['status'], 'checked', (c.sql, check))
            self.assertEqual(check['scope'], 'finite_write_shape_only')

    def test_protocol_and_uncalibrated_oracles_stay_planned(self):
        for sid in ('scenario_copy_stream_contract', 'scenario_alter_sequence_quality_gaps',
                    'scenario_create_sequence_system_column_oracle'):
            self.assertEqual(self.registry.scenarios[sid].status, 'planned')


if __name__ == '__main__':
    unittest.main()
