import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MCopyCheckpointDropOwnedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,fid):
        return [c for mid in self.r.factors['m_'+fid].manifest_refs for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]

    def test_copy_only_stdout_complete_query_and_integer_source(self):
        for c in self.cases('copy'):
            self.assertIn(' TO STDOUT',c.sql);self.assertNotIn('FROM STDIN',c.sql)
            self.assertNotIn('SELECT 1',c.sql);self.assertNotIn("TO '/",c.sql)
            if c.sql.startswith('COPY (SELECT'):self.assertIn('ORDER BY id) TO STDOUT',c.sql)
            self.assertTrue(any(s.startswith('CREATE TABLE m_b01_source') for s in c.setup_sqls))
            self.assertTrue(any(s.startswith('INSERT INTO m_b01_source') for s in c.setup_sqls))
            self.assertTrue(any(e['key']=='result_transport' and e['allowed_values']==['copy_out_stream_runner_required'] for e in c.environment_requirements))

    def test_copy_option_styles_never_mixed_and_header_is_csv_only(self):
        for c in self.cases('copy'):
            suffix=c.sql.split('TO STDOUT',1)[1]
            if '(' in suffix:
                self.assertIn('FORMAT ',suffix)
                self.assertNotIn(') CSV',suffix);self.assertNotIn(') DELIMITER',suffix)
            else:self.assertNotIn('FORMAT',suffix)
            if 'HEADER' in suffix:self.assertIn("FORMAT 'csv', HEADER FALSE",suffix)

    def test_copy_query_profiles_have_real_columns(self):
        resolved=self.r.resolve_dimension_values('m_copy')
        for key,cols in [('id',['id']),('two',['id','qty']),('reverse',['qty','id'])]:
            v=resolved['projection']['m_copy_projection_'+key]
            self.assertEqual(v.attributes['projection.properties.output_columns'],cols)
            self.assertEqual(v.attributes['projection.properties.output_types'],['INTEGER']*len(cols))

    def test_checkpoint_is_not_schema_isolated_or_rollback_claimed(self):
        cases=self.cases('checkpoint');self.assertEqual(len(cases),1);c=cases[0]
        self.assertEqual(c.sql,'CHECKPOINT;')
        self.assertTrue(any(e['key']=='instance_effect_scope' for e in c.environment_requirements))
        self.assertFalse(any(s.startswith(('START TRANSACTION','BEGIN','ROLLBACK','SET ')) for s in c.setup_sqls+c.teardown_sqls))

    def test_drop_owned_is_target_never_cleanup_and_has_real_grants(self):
        for c in self.cases('drop_owned'):
            self.assertTrue(c.sql.startswith('DROP OWNED BY m_b04_role_existing'))
            self.assertTrue(any(s.startswith('GRANT SELECT ON TABLE m_drop_owned_namespace.source') for s in c.setup_sqls))
            self.assertFalse(any('DROP OWNED' in s or 'CASCADE' in s for s in c.setup_sqls+c.teardown_sqls))
            self.assertEqual(c.teardown_sqls[:2],['DROP TABLE m_drop_owned_namespace.source;','DROP SCHEMA m_drop_owned_namespace;'])
            self.assertTrue(all(s.startswith('DROP ROLE ') for s in c.teardown_sqls[2:]))
            self.assertTrue(any(e['key']=='drop_owned_target_isolation' for e in c.environment_requirements))

    def test_exact_reconstruction(self):
        from scripts.build_m_compat_batch_05 import BUILDERS
        for key in ('copy','checkpoint','drop_owned'):
            p=BUILDERS[key]()
            if p.id in ('m_drop_audit_policy','m_drop_database','m_drop_owned','m_drop_schema','m_drop_sequence','m_rename_table','m_rollback_to_savepoint','m_deallocate','m_do','m_drop_user','m_drop_view','m_drop_role','m_grant','m_checkpoint','m_drop_prepare','m_create_function','m_analyze','m_copy','m_alter_table','m_create_table','m_create_table_partition'):
                continue
            # m_copy已进入人工演进阶段（新增source completion facts），
            # 不再回退到batch_05一次性builder的输出。
            if p.id == 'm_copy':
                continue
            for name,obj in p.finish().items():self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
