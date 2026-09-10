"""M SET schema syntax with owned DDL outside the target transaction."""
from pathlib import Path
import unittest
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_03 import set_command
from scripts.build_m_compat_batch_02 import transaction

ROOT = Path(__file__).resolve().parents[1]
NS = 'm_set_owned_namespace'
FORMS = ('schema_to','schema_equals','schema_string')


class MSetSchemaDefinitionTests(unittest.TestCase):
    def test_forms_reuse_scope_without_changing_existing_defaults(self):
        p=set_command()
        self.assertTrue(all(p.vid('form',f) in p.ast['branches'] for f in FORMS))
        self.assertEqual(set(p.dims),{'scope','timezone','form','assignment_operator','variable_value'})
        self.assertEqual(p.dims['form']['default_value_id'],'m_set_form_timezone')
        self.assertEqual(p.dims['scope']['default_value_id'],'m_set_scope_default')

    def test_exact_source_and_typed_transaction_providers(self):
        p=set_command(); facts={f['id']:f for f in p.facts}
        self.assertIn('m_set_fact_schema_syntax',facts)
        self.assertEqual(facts['m_set_fact_schema_syntax']['source_anchor'],'2.4.2.16.4 L16-18')
        self.assertEqual(facts['m_set_fact_schema_selected']['type'],'behavior_oracle')
        self.assertEqual(facts['m_set_fact_schema_absent']['type'],'behavior_oracle')
        for command in ('START TRANSACTION','ROLLBACK'):
            provider=transaction(command)
            self.assertIn(provider.fid('syntax'),provider.exports)


class MSetSchemaIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_m_set_schema'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_nine_complete_statements_have_all_form_scope_pairs(self):
        cases,report=self.cases()
        clauses=(f'CURRENT_SCHEMA TO {NS}',f'CURRENT_SCHEMA = {NS}',f"SCHEMA '{NS}'")
        self.assertEqual({c.sql for c in cases},{' '.join(('SET '+s+' '+v+';').split())
                         for s in ('','SESSION','LOCAL') for v in clauses})
        self.assertEqual(len(cases),9);self.assertTrue(report.pairwise_complete)
        for c in cases:
            self.assertEqual(set(c.consumed_dimension_ids),{'form','scope'})
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_creation_commit_precedes_target_transaction_and_cleanup_is_owned(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA {NS};','COMMIT;','START TRANSACTION;'])
            self.assertEqual(c.teardown_sqls,['ROLLBACK;',f'DROP SCHEMA {NS};','COMMIT;'])
        fx=self.r.fixtures['fixture_m_set_schema']
        self.assertFalse(fx.provides.tables)
        self.assertNotIn('CASCADE',' '.join(fx.execution.teardown_sqls))
        self.assertIn('归属',fx.execution.note)
        self.assertIn('同名用户',fx.execution.note)
        self.assertIn('DDL',fx.execution.note)

    def test_real_mode_authority_and_restoration_gates_are_not_guessed(self):
        cases,_=self.cases()
        for c in cases:
            gates={g['key']:g for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'],['M'])
            self.assertEqual(gates['session_lifecycle']['allowed_values'],['isolated_connection'])
            self.assertEqual(gates['namespace_create_authority']['fact_refs'],['m_create_schema::m_create_schema_fact_authority'])
            self.assertEqual(gates['namespace_drop_authority']['fact_refs'],['m_drop_schema::m_drop_schema_fact_authority'])
            self.assertEqual(gates['transaction_owner']['fact_refs'],['m_commit::m_commit_fact_authority'])
            self.assertEqual(gates['schema_lifecycle']['allowed_values'],['fresh_owned_non_current_namespace_restore_before_drop'])
        deps=self.r.factor_dependency_graph()['m_set']
        self.assertTrue({'m_create_schema','m_drop_schema','m_commit','m_start_transaction','m_rollback'} <= set(deps))

    def test_planned_restore_oracle_does_not_hardcode_public_or_error_for_missing_schema(self):
        self.cases()
        s=self.r.scenarios['scenario_m_set_schema_restore']
        self.assertEqual(s.status,'planned')
        self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('capture_pre_target_schema_and_search_path',s.execution_requirements)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in s.oracles))
        self.assertTrue(any(step.get('sql')=='ROLLBACK;' for step in s.steps))
        self.assertTrue(any('事前' in str(o['expected']) for o in s.oracles))
        self.assertNotIn('public',str(s.oracles))
        self.assertNotIn('target_error',str(s.oracles))

    def test_finite_domain_and_builders_match_without_closing_other_set_branches(self):
        self.cases()
        fs={f.id:f for f in self.r.matrices['matrix_m_set_schema_coverage'].documented_features}
        self.assertEqual(fs['m_set_feature_schema_existing'].coverage_mode,'representative')
        self.assertEqual(fs['m_set_feature_schema_extended'].status,'needs_profile')
        for directory,p in [('utility/m_set',set_command()),
                             ('tcl/m_start_transaction',transaction('START TRANSACTION')),
                             ('tcl/m_rollback',transaction('ROLLBACK'))]:
            for name,obj in p.finish().items():
                self.assertEqual(yaml.safe_load((ROOT/'specs'/directory/name).read_text()),obj,name)


if __name__=='__main__':unittest.main()
