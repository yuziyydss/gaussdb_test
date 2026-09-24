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
