"""Documented inverted-index errors need valid, isolated prerequisites and controls."""
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT=Path(__file__).resolve().parents[1]


class GeneralIndexStorageNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def one(self, suffix):
        mid='manifest_create_index_'+suffix
        self.assertTrue(mid in self.r.manifests,mid)
        cases,report=self.g.generate_with_report(self.r.manifests[mid])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        return cases[0]

    def test_two_target_errors_have_exact_method_key_parameter_and_uncalibrated_oracles(self):
        for suffix,fragment,category in [
            ('ugin_fastupdate_negative','ON g_ci_ugin_storage USING ugin (tags _bool_ops) WITH (fastupdate = off);','ugin_fastupdate_disabled'),
            ('gin_pending_negative','ON g_ci_gin_storage USING gin (info) WITH (gin_pending_list_limit = 63);','gin_pending_list_limit_out_of_range')]:
            with self.subTest(suffix=suffix):
                case=self.one(suffix)
                self.assertTrue(case.sql.startswith('CREATE INDEX '))
                self.assertTrue(case.sql.endswith(fragment),case.sql)
                self.assertEqual(case.expected,'error')
                self.assertEqual(case.expected_error_category,category)
                self.assertEqual(case.expected_sqlstates,[])
                self.assertEqual(case.expected_oracle_status,'needs_verification')
                m=self.r.manifests['manifest_create_index_'+suffix]
                self.assertEqual(m.violates_rule_refs,['ci_rule_storage_parameter_domain'])

    def test_each_negative_has_a_valid_control_with_identical_owned_setup(self):
        for family,valid_fragment,table in [
            ('ugin_fastupdate','WITH (fastupdate = on);','g_ci_ugin_storage'),
            ('gin_pending','WITH (gin_pending_list_limit = 64);','g_ci_gin_storage')]:
            with self.subTest(family=family):
                control=self.one(family+'_control');negative=self.one(family+'_negative')
                self.assertEqual(control.expected,'success')
                self.assertTrue(control.sql.endswith(valid_fragment),control.sql)
                self.assertEqual(control.setup_sqls,negative.setup_sqls)
                self.assertEqual(control.teardown_sqls,negative.teardown_sqls)
                self.assertEqual(len(control.setup_sqls),1)
                self.assertTrue(control.setup_sqls[0].startswith('CREATE TABLE '+table))
                self.assertEqual(control.teardown_sqls,['DROP TABLE '+table+';'])
                self.assertFalse(any('CASCADE' in s or s.startswith('DROP ') for s in control.setup_sqls))
                gates={g['key']:g['allowed_values'] for g in negative.environment_requirements}
                self.assertEqual(gates['compatibility_mode'],['A'])
                self.assertEqual(gates['actor_authority'],['create_any_index'])
                self.assertEqual(gates['case_namespace'],['isolated_user_schema'])
                mode=next(g for g in negative.environment_requirements if g['key']=='compatibility_mode')
                self.assertIn('create_database::create_database_fact_compatibility_environment',mode['fact_refs'])
                self.assertEqual('ci_fact_ugin_non_m_environment' in mode['fact_refs'],family=='ugin_fastupdate')

    def test_non_target_constraints_still_reject_bad_method_and_legal_value_is_not_negative(self):
        resolved=self.r.resolve_dimension_values('create_index')
        for family,valid in [('ugin_fastupdate','ci_fastupdate_on'),('gin_pending','ci_gin_pending_64')]:
            with self.subTest(family=family):
                case=self.one(family+'_negative')
                m=self.r.manifests['manifest_create_index_'+family+'_negative']
                solver=self.g._build_solver(self.r.factors['create_index'],m,resolved)
                self.assertTrue(solver.is_valid(case.params)[0])
                self.assertFalse(solver.is_valid(dict(case.params,method='ci_method_btree'))[0])
                allowed,reason=solver.is_valid(dict(case.params,storage_profile=valid))
                self.assertFalse(allowed)
                self.assertIn('negative case must violate',reason)

    def test_fresh_profiles_have_exact_nullable_array_columns_without_old_fixture_reuse(self):
        for suffix,table,column,datatype,engine in [
            ('ugin_storage','g_ci_ugin_storage','tags','BOOL[]','ustore'),
            ('gin_storage','g_ci_gin_storage','info','INT[]','astore')]:
            with self.subTest(suffix=suffix):
                fid='fixture_create_index_'+suffix
                self.assertTrue(fid in self.r.fixtures,fid)
                fx=self.r.fixtures[fid]
                self.assertEqual(fx.requires_fixture_refs,[])
                self.assertEqual(fx.execution.setup_sqls,[f'CREATE TABLE {table} ({column} {datatype}) WITH (storage_type={engine});'])
                self.assertEqual(len(fx.provides.tables),1)
                columns=fx.provides.tables[0].columns
                self.assertEqual(len(columns),1)
                self.assertEqual((columns[0].name,columns[0].type,columns[0].nullable),(column,datatype,True))

    def test_gap_reduction_does_not_claim_behavior_or_turn_arbitrary_errors_into_success(self):
        self.one('ugin_fastupdate_negative');self.one('gin_pending_negative')
        audit=FactorCoverageAuditor(self.r).audit('create_index')
        gaps=audit['values']['coverage_gaps']
        for removed in ['storage_profile.ci_fastupdate_off_ugin','storage_profile.ci_gin_pending_63']:
            self.assertNotIn(removed,gaps)
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        for family in ('ugin_fastupdate','gin_pending'):
            mid='manifest_create_index_'+family+'_negative'
            self.assertIn(mid,audit['manifests']['unresolved_error_oracles'])
            scenario=self.r.scenarios['scenario_create_index_'+family+'_target_error']
            self.assertEqual(scenario.status,'planned')
            target=[o for o in scenario.oracles if o['kind']=='target_error']
            self.assertEqual(len(target),1)
            self.assertEqual(target[0]['step_id'],'negative')
            self.assertEqual(target[0]['stage'],'target')
            self.assertEqual(target[0]['oracle_status'],'needs_verification')
            self.assertEqual(target[0]['sqlstates'],[])


if __name__=='__main__':unittest.main()
