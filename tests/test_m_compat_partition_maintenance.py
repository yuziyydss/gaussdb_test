from tests.evolved_asset_assertions import assert_evolved_asset
import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_06 import BUILDERS,RANGE_SOURCE,SUB_SOURCE,RANGE_FIXTURE,SUB_FIXTURE

ROOT=Path(__file__).resolve().parents[1]
NAMES=('create_table_subpartition','alter_table_partition','alter_table_subpartition')


class MPartitionMaintenanceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return [c for mid in self.r.factors['m_'+name].manifest_refs for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]

    def test_four_subpartition_combinations_with_single_column_keys(self):
        seen=set()
        for c in self.cases('create_table_subpartition'):
            if c.expected!='success':continue
            seen.add((c.params['root'],c.params['sub']))
            self.assertIn(' (id) ',c.sql);self.assertIn(' (qty) ',c.sql)
            self.assertNotIn('PARTITION BY HASH (id)',c.sql)
            self.assertNotIn('SUBPARTITION BY RANGE',c.sql)
            self.assertIn('storage_type = ASTORE',c.sql)
        self.assertEqual(len(seen),4)

    def test_shared_fixture_is_real_range_source_and_not_duplicated(self):
        self.assertEqual(self.r.fixtures[RANGE_FIXTURE].provides.tables[0].table_kind,'range_partitioned')
        for c in self.cases('alter_table_partition'):
            self.assertEqual(sum(s.startswith('CREATE TABLE '+RANGE_SOURCE+' ') for s in c.setup_sqls),1)
            self.assertIn('INSERT INTO '+RANGE_SOURCE+' VALUES (1,10),(11,20),(21,30);',c.setup_sqls)
            self.assertIn('VALUES LESS THAN (30)',c.setup_sqls[0])
            self.assertEqual(c.teardown_sqls,['DROP TABLE '+RANGE_SOURCE+' PURGE;'])

    def test_range_actions_respect_fixture_bounds(self):
        cases=self.cases('alter_table_partition');self.assertEqual(len(cases),18)
        for c in cases:
            if 'ADD PARTITION' in c.sql:
                self.assertIn('LESS THAN (40)' if c.expected=='success' else 'LESS THAN (15)',c.sql)
            if 'SPLIT PARTITION' in c.sql:self.assertIn('p_mid AT (15)',c.sql)
            if 'MERGE PARTITIONS' in c.sql:self.assertIn('p_low, p_mid',c.sql)
            self.assertNotIn('EXCHANGE',c.sql);self.assertNotIn('UPDATE GLOBAL INDEX',c.sql)

    def test_subpartition_targets_have_deterministic_seed_and_both_for_keys(self):
        fx=self.r.fixtures[SUB_FIXTURE]
        self.assertEqual(fx.provides.tables[0].table_kind,'range_hash_subpartitioned')
        for c in self.cases('alter_table_subpartition'):
            self.assertIn('(SUBPARTITION s_low)',c.setup_sqls[0])
            self.assertIn('(SUBPARTITION s_high)',c.setup_sqls[0])
            self.assertIn('INSERT INTO '+SUB_SOURCE+' VALUES (1,10),(2,20),(11,30);',c.setup_sqls)
            if 'FOR (' in c.sql:self.assertIn('FOR (1, 10)',c.sql)
            self.assertFalse(any(x in c.sql for x in ['ADD SUBPARTITION','DROP SUBPARTITION','SPLIT','MERGE']))
            if 'TRUNCATE' in c.sql:self.assertNotIn('IF EXISTS',c.sql)
            self.assertEqual(c.teardown_sqls,['DROP TABLE '+SUB_SOURCE+' PURGE;'])

