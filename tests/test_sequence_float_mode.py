"""B acceptance and PG rejection remain separate, with no guessed rounding."""
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]
POS='manifest_create_sequence_float_b_fresh'
NEG='manifest_create_sequence_float_pg_negative'


class SequenceFloatModeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(POS in self.r.manifests and NEG in self.r.manifests, 'Missing two scoped manifests')
        return [self.g.generate_with_report(self.r.manifests[mid])[0][0] for mid in (POS,NEG)]

    def test_two_scoped_candidates_and_owned_cleanup(self):
        for case, mode, expected in zip(self.cases(),['B','PG'],['success','error']):
            self.assertRegex(case.sql,r'^CREATE SEQUENCE seq_cs_float_[0-9a-f]+ INCREMENT 1\.5 MINVALUE 1 MAXVALUE 100 START 1 NO CYCLE OWNED BY t_cs_float_owner\.id;$')
            self.assertEqual(case.expected,expected)
            self.assertEqual(case.setup_sqls,['CREATE TABLE t_cs_float_owner (id INTEGER);'])
            self.assertEqual(case.teardown_sqls,['DROP TABLE t_cs_float_owner;'])
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'],[mode])
            self.assertEqual(gates['case_namespace']['allowed_values'],['fresh_user_schema'])

    def test_missing_or_broadened_mode_does_not_export(self):
        self.cases()
        for allowed in (None,['PG'],['B','PG']):
            manifest=self.r.manifests[POS].model_copy(deep=True)
            if allowed is None:
                manifest.environment_requirements=[g for g in manifest.environment_requirements if g.key!='compatibility_mode']
            else:
                next(g for g in manifest.environment_requirements if g.key=='compatibility_mode').allowed_values=allowed
            with self.assertRaisesRegex(GenerationValidationError,'compatibility_mode'):
                self.g.generate_with_report(manifest)

    def test_cleanup_dependency_cannot_be_removed_from_scope(self):
        positive,_=self.cases()
        f=self.r.factors['create_sequence'];m=self.r.manifests[POS]
        solver=self.g._build_solver(f,m,self.r.resolve_dimension_values(f.id))
        self.assertTrue(solver.is_valid(positive.params)[0])
        self.assertFalse(solver.is_valid(dict(positive.params,owned_by_clause='cs_owned_none'))[0])
        self.assertFalse(solver.is_valid(dict(positive.params,sequence_kind='cs_kind_temporary'))[0])

    def test_generic_condition_and_uncalibrated_oracle_stay_open(self):
        _,negative=self.cases()
        self.assertEqual(negative.expected_sqlstates,[])
        self.assertEqual(negative.expected_oracle_status,'needs_verification')
        self.assertEqual(negative.expected_error_category,'float_increment_not_supported')
        audit=FactorCoverageAuditor(self.r).audit('create_sequence')
        self.assertIn('increment_clause.cs_increment_float_b',audit['values']['conditional_unselected'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(self.r.scenarios['scenario_create_sequence_float_increment'].status,'planned')


if __name__=='__main__': unittest.main()
