from tests.evolved_asset_assertions import assert_evolved_asset
import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_06 import create_table_partition

ROOT=Path(__file__).resolve().parents[1]


class MCreatePartitionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)
        cls.cases=[c for mid in cls.r.factors['m_create_table_partition'].manifest_refs for c in cls.g.generate_cases_for_manifest(cls.r.manifests[mid])]

    def test_branches_are_complete_and_no_raw_bnf(self):
        forms=set()
        for c in self.cases:
            forms.add(c.params['form'])
            self.assertIn(' (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE',c.sql)
            self.assertNotIn('[',c.sql);self.assertNotIn('...',c.sql)
            self.assertTrue(c.sql.endswith(';'))
        self.assertEqual(len(forms),5)

    def test_partition_counts_and_ranges(self):
        for c in self.cases:
            if 'START(' in c.sql:
                self.assertNotIn('LESS THAN',c.sql);self.assertNotIn('PARTITIONS 3',c.sql)
                self.assertIn('START(0) END(10)',c.sql)
            if 'PARTITIONS 3 (' in c.sql:self.assertEqual(c.sql.count('PARTITION p'),3)
            if c.expected=='success' and 'LESS THAN' in c.sql:
                self.assertLess(c.sql.index('LESS THAN (10)'),c.sql.index('LESS THAN (20)'))
            if 'HASH' in c.sql or 'KEY (id)' in c.sql:self.assertNotIn('COLUMNS',c.sql)

    def test_negative_keeps_its_target_rule(self):
        bad=[c for c in self.cases if c.expected=='error'];self.assertEqual(len(bad),1)
        self.assertEqual(bad[0].expected_error_category,'ascending_bounds')
        self.assertEqual(bad[0].expected_oracle_status,'needs_verification')
        self.assertLess(bad[0].sql.index('LESS THAN (20)'),bad[0].sql.index('LESS THAN (10)'))

    def test_real_namespace_prerequisite_no_target_precreation(self):
        for c in self.cases:
            self.assertEqual(c.setup_sqls,['CREATE SCHEMA m_create_partition_namespace;'])
            self.assertEqual(c.teardown_sqls,['DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;','DROP SCHEMA m_create_partition_namespace;'])

    def test_exact_reconstruction(self):
        p=create_table_partition()
        for name,obj in p.finish().items():assert_evolved_asset(self, (ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
if __name__=='__main__':unittest.main()
