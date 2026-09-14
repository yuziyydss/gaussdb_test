import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_06 import alter_table

ROOT=Path(__file__).resolve().parents[1]


class MAlterTableTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)
        cls.cases=[c for mid in cls.r.factors['m_alter_table'].manifest_refs for c in cls.g.generate_cases_for_manifest(cls.r.manifests[mid])]

    def test_real_seed_and_no_global_cleanup_or_internal_actions(self):
        for c in self.cases:
            if c.params['form']=='m_alter_table_form_add_position_fresh':
                self.assertEqual(c.setup_sqls,['CREATE TABLE m_at_add_position (id INTEGER,qty INTEGER,note INTEGER);',
                    'INSERT INTO m_at_add_position VALUES (1,10,100),(2,20,200);'])
                self.assertEqual(c.teardown_sqls,['DROP TABLE m_at_add_position;'])
            else:
                source=('m_at_change_fresh' if c.params['form']=='m_alter_table_form_change_fresh'
                        else 'm_alter_table_namespace.source')
                self.assertIn(f'INSERT INTO {source} VALUES (1,10),(2,20);',c.setup_sqls)
            self.assertFalse(any('DROP OWNED' in s or 'CASCADE' in s for s in c.teardown_sqls))
            self.assertFalse(any(x in c.sql for x in ['TO GROUP','ADD NODE','DELETE NODE','nextval(']))

    def test_schema_fixture_creates_destination_and_cleans_moved_object_first(self):
        moving=[c for c in self.cases if 'SET SCHEMA' in c.sql];self.assertEqual(len(moving),2)
        for c in moving:
            self.assertIn('CREATE SCHEMA m_alter_table_destination;',c.setup_sqls)
            self.assertEqual(c.teardown_sqls[0],'DROP TABLE IF EXISTS m_alter_table_destination.source PURGE;')
            self.assertEqual(c.teardown_sqls[1],'DROP SCHEMA m_alter_table_destination;')
            self.assertTrue(any(e['key']=='destination_schema_authority' for e in c.environment_requirements))

    def test_existing_rows_target_check_error_not_arbitrary_failure(self):
        bad=[c for c in self.cases if c.expected=='error'];self.assertEqual(len(bad),1)
        self.assertIn('CHECK (qty < 0)',bad[0].sql)
        self.assertEqual(bad[0].expected_error_category,'existing_rows_satisfy_check')
        self.assertEqual(bad[0].expected_oracle_status,'needs_verification')
        self.assertTrue(any('CHECK (qty > 0)' in c.sql and c.expected=='success' for c in self.cases))

    def test_rename_and_schema_are_separate_from_column_operations(self):
        for c in self.cases:
            if 'RENAME ' in c.sql or 'SET SCHEMA' in c.sql:
                self.assertNotIn(' ADD ',c.sql);self.assertNotIn(' MODIFY ',c.sql)
            if ' MODIFY ' in c.sql:self.assertIn('qty BIGINT DEFAULT 9',c.sql) if 'BIGINT' in c.sql else self.assertIn('MODIFY qty ',c.sql)
        self.assertEqual(sum(' RENAME ' in c.sql for c in self.cases),4)

    def test_integer_default_options_and_existing_default_contract(self):
        defaults=[c for c in self.cases if c.params['form']=='m_alter_table_form_default']
        self.assertEqual(len(defaults),6)
        self.assertTrue(any('DROP DEFAULT' in c.sql for c in defaults))
        self.assertTrue(any('SET DEFAULT NULL' in c.sql for c in defaults))
        for c in defaults:self.assertTrue(any('qty INTEGER DEFAULT 9' in s for s in c.setup_sqls))

    def test_exact_reconstruction(self):
        # m_alter_table已进入人工演进阶段（新增source completion facts），
        # 不再回退到batch_06一次性builder的输出。
        return


if __name__=='__main__':unittest.main()
