"""M UPDATE's own L16 forbids a known named view in multi-table UPDATE."""
from tests.evolved_asset_assertions import assert_evolved_asset
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write
from scripts.build_m_compat_pilot import update


class MUpdateViewGuardTests(unittest.TestCase):
    setup=['CREATE TABLE t(id INT,qty INT)','CREATE TABLE aux(id INT,qty INT)',
           'CREATE VIEW v AS SELECT id,qty FROM t']

    def inspect(self,sql,setup=None,scope='m_compat'):
        return inspect_write(sql,self.setup if setup is None else setup,conflict_source_scope=scope)

    def test_m_named_view_uses_its_own_source_restriction(self):
        result=self.inspect('UPDATE v AS u,aux AS a SET u.qty=99 WHERE u.id=a.id')
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'multi_update_view_not_supported')
        self.assertIn('M UPDATE L16',result['issues'][0]['detail'])

    def test_restriction_is_independent_of_assignment_and_view_position(self):
        for sql in ('UPDATE aux AS a,v AS u SET a.qty=99',
                    'UPDATE v AS u,aux AS a SET u.qty=DEFAULT',
                    'UPDATE v AS u,t AS a SET u.qty=99'):
            self.assertEqual(self.inspect(sql)['status'],'rejected')

    def test_no_ban_for_single_view_plain_tables_or_unreviewed_mode(self):
        for sql in ('UPDATE v SET qty=99','UPDATE t AS u,aux AS a SET u.qty=99'):
            self.assertEqual(self.inspect(sql)['status'],'checked')
        self.assertNotEqual(self.inspect('UPDATE v AS u,aux AS a SET u.qty=99',scope='unreviewed')['status'],'rejected')
        tables=['CREATE TABLE v(id INT,qty INT)',self.setup[1]]
        self.assertEqual(self.inspect('UPDATE v AS u,aux AS a SET u.qty=99',tables)['status'],'checked')

    def test_dropped_or_ambiguous_view_identity_is_not_assumed(self):
        for extra in ('DROP VIEW v','ALTER VIEW v RENAME TO renamed'):
            self.assertEqual(self.inspect('UPDATE v AS u,aux AS a SET u.qty=99',self.setup+[extra])['status'],'needs_review')

    def test_fact_is_extracted_from_m_body_and_consumed_by_real_planned_scenario(self):
        package=update()
        facts={f['id']:f for f in package.facts}
        fid='m_update_fact_multi_view'
        self.assertTrue(fid in facts,fid)
        self.assertEqual(facts[fid]['source_anchor'],'2.4.2.18.1 L16-16')
        self.assertEqual((facts[fid]['type'],facts[fid]['status']),('constraint','confirmed'))
        scenario=package.files['scenarios/multi_view_rejected.scenario.yaml']
        self.assertIn(fid,scenario['fact_refs'])
        self.assertEqual(scenario['status'],'planned')
        self.assertIn('database_authorization',scenario['execution_requirements'])
        self.assertTrue(all('sql' in step and 'action' not in step for step in scenario['steps']))

    def test_scenario_has_real_two_table_control_and_target_error_not_arbitrary_failure(self):
        package=update()
        path='scenarios/multi_view_rejected.scenario.yaml'
        self.assertTrue(path in package.files,path)
        scenario=package.files[path]
        fixture=package.files['fixtures/multi_view.fixture.yaml']['execution']
        steps={s['id']:s for s in scenario['steps']}
        setup=fixture['setup_sqls']
        self.assertEqual(self.inspect(steps['control']['sql'],setup)['status'],'checked')
        result=self.inspect(steps['target']['sql'],setup)
        self.assertEqual(result['status'],'rejected',result)
        oracle=next(o for o in scenario['oracles'] if o['kind']=='target_error')
        self.assertEqual(oracle['step_id'],'target')
        self.assertEqual(oracle['stage'],'target')
        self.assertEqual(oracle['error_category'],'multi_table_view')
        self.assertEqual(oracle['oracle_status'],'needs_verification')
        self.assertEqual(oracle['sqlstates'],[])
        self.assertTrue(all('ORDER BY' not in s['sql'] and 'LIMIT' not in s['sql']
                            for s in scenario['steps'] if s['id'] in ('control','target')))


class MUpdateViewIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.root=Path(__file__).resolve().parents[1]
        cls.registry=FactorPackageRegistry(cls.root/'specs');cls.registry.load_all()

    def test_builder_and_saved_package_match_including_new_source_unit(self):
        import yaml
        for name,value in update().finish().items():
            path=self.root/'specs/dml/m_update'/name
            self.assertTrue(path.exists(),name)
            assert_evolved_asset(self, yaml.safe_load(path.read_text()),value,name)
    def test_generator_rejects_forged_positive_using_actual_m_source_mode(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        factor=self.registry.factors['m_update']
        target=next(v for c in factor.dimensions['target'].classes for v in c.values if v.id=='m_update_target_view')
        assignment=next(v for c in factor.dimensions['assignments'].classes for v in c.values if v.id=='m_update_assignments_literal')
        original_target,original_items=target.render,assignment.properties['items']
        try:
            target.render='m_b01_view AS v,m_b01_source AS a'
            assignment.properties['items']=['v.qty = 99']
            manifest=self.registry.manifests['manifest_m_update_view_derived'].model_copy(deep=True)
            manifest.bindings['target']=['m_update_target_view']
            manifest.bindings['assignments']=['m_update_assignments_literal']
            with self.assertRaisesRegex(GenerationValidationError,'multi_update_view_not_supported'):
                FactorPackageSQLGenerator(self.registry).generate_with_report(manifest)
        finally:
            target.render=original_target
            assignment.properties['items']=original_items


if __name__=='__main__':
    unittest.main()
