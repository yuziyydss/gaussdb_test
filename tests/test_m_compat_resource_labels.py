import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MResourceLabelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_actual_resource_paths_and_scoped_cleanup(self):
        for name in ('create_resource_label_finite','alter_resource_label_add','alter_resource_label_remove','drop_resource_label_finite'):
            for c in self.cases(name):
                self.assertIn('CREATE SCHEMA m_label_namespace;',c.setup_sqls)
                self.assertIn('CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);',c.setup_sqls)
                self.assertIn('CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;',c.setup_sqls)
                clean=c.teardown_sqls
                self.assertEqual(clean[-3:],['DROP VIEW m_label_namespace.source_view;','DROP TABLE m_label_namespace.source;','DROP SCHEMA m_label_namespace;'])
                self.assertTrue(all(s.startswith('DROP RESOURCE LABEL IF EXISTS ') for s in clean[:-3]))
                self.assertNotIn('FUNCTION',c.sql)
                self.assertTrue(any(e['key']=='actor_authority' and e['allowed_values']==['sysadmin'] for e in c.environment_requirements))

    def test_creation_owns_only_its_target_cleanup(self):
        for c in self.cases('create_resource_label_finite'):
            self.assertEqual(c.teardown_sqls[0],'DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;')
        for name in ('alter_resource_label_add','alter_resource_label_remove','drop_resource_label_finite'):
            for c in self.cases(name):self.assertNotIn('DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;',c.teardown_sqls)

    def test_add_remove_initial_membership_and_nonempty_remainder(self):
        for action in ('add','remove'):
            for c in self.cases('alter_resource_label_'+action):
                setup=next(s for s in c.setup_sqls if s.startswith('CREATE RESOURCE LABEL m_alter_resource_label_existing'))
                self.assertIn('COLUMN (m_label_namespace.source.id)',setup)
                resource=c.sql.split(' '+action.upper()+' ',1)[1].removesuffix(';')
                if action=='add':self.assertNotIn(resource,setup)
                else:self.assertIn(resource,setup)

    def test_drop_list_targets_created_in_setup(self):
        cases=self.cases('drop_resource_label_finite');self.assertEqual(len(cases),4)
        for c in cases:
            self.assertTrue(any(s.startswith('CREATE RESOURCE LABEL m_drop_resource_label_one ') for s in c.setup_sqls))
            if 'm_drop_resource_label_two' in c.sql:self.assertTrue(any(s.startswith('CREATE RESOURCE LABEL m_drop_resource_label_two ') for s in c.setup_sqls))

    def test_exact_builder_reconstruction(self):
        from scripts.build_m_compat_batch_05 import BUILDERS
        for key in ('create_resource_label','alter_resource_label','drop_resource_label'):
            p=BUILDERS[key]()
            for name,obj in p.finish().items():
                self.assertEqual((ROOT/'specs/ddl'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
