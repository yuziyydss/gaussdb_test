from tests.evolved_asset_assertions import assert_evolved_asset
import unittest
from pathlib import Path
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_batch_06 import generated_update_system

ROOT=Path(__file__).resolve().parents[1]
FACTOR_ID='m_generated_update_system'
MANIFEST_ID='manifest_m_generated_update_system_fresh_syntax'


class MGeneratedUpdateSystemTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)
        cls.f=cls.r.factors[FACTOR_ID]

    def test_exact_reconstruction_and_source_lines(self):
        p=generated_update_system()
        for rel,obj in p.finish().items():
            assert_evolved_asset(self, (ROOT/'specs/utility'/p.id/rel).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
        ledger=self.r.source_ledgers[self.f.source_ledger_ref]
        covered=[n for u in ledger.units for n in range(u.line_start,u.line_end+1)]+[x.line for x in ledger.ignored_lines]
        self.assertEqual(sorted(covered),list(range(1,15)))

    def test_one_fixed_syntax_candidate_keeps_external_gates(self):
        cases,report=self.g.generate_with_report(self.r.manifests[MANIFEST_ID])
        self.assertEqual(len(cases),1);self.assertTrue(report.pairwise_complete)
        case=cases[0]
        self.assertEqual(case.sql,'GENERATED UPDATE SYSTEM;')
        self.assertEqual(case.expected,'success');self.assertEqual(case.expected_scope,'syntax_only')
        gates={gate['key']:gate for gate in case.environment_requirements}
        self.assertEqual(gates['upgrade_context']['allowed_values'],['authoritative_OM_upgrade'])
        self.assertEqual(gates['initial_user_identity']['allowed_values'],['true'])
        self.assertEqual(gates['command_usage']['allowed_values'],['internal_static_review_only'])

    def test_static_closure_does_not_claim_om_or_artifact_behavior(self):
        self.g.generate_with_report(self.r.manifests[MANIFEST_ID])
        audit=FactorCoverageAuditor(self.r).audit(FACTOR_ID)
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['documented_features']['coverage_gaps'],[])
        self.assertEqual(audit['facts']['unresolved'],[])
        for matrix_ref in self.f.matrix_refs:
            features=self.r.matrices[matrix_ref].documented_features
            self.assertTrue(all(f.status=='covered' and f.coverage_mode=='any' for f in features))

    def test_unknown_fixture_cannot_silently_compile_empty_lifecycle(self):
        with self.assertRaisesRegex(GenerationValidationError,'not_implemented'):
            self.g._compile_fixture_lifecycle(self.f.fixture_refs)
        fixture=self.r.fixtures[self.f.fixture_refs[0]]
        self.assertEqual(fixture.status,'planned')
        self.assertFalse(fixture.execution.setup_sqls);self.assertFalse(fixture.execution.teardown_sqls)


if __name__=='__main__':unittest.main()
