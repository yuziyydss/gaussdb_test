import unittest
from pathlib import Path
from unittest.mock import patch
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_batch_06 import generated_update_system
from scripts.generate_m_compat_review_only import FACTOR_ID,build_review,render_review_sql

ROOT=Path(__file__).resolve().parents[1]


class MGeneratedUpdateSystemTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.f=cls.r.factors[FACTOR_ID]

    def test_exact_reconstruction_and_source_lines(self):
        p=generated_update_system()
        for rel,obj in p.finish().items():
            self.assertEqual((ROOT/'specs/utility'/p.id/rel).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
        ledger=self.r.source_ledgers[self.f.source_ledger_ref]
        covered=[n for u in ledger.units for n in range(u.line_start,u.line_end+1)]+[x.line for x in ledger.ignored_lines]
        self.assertEqual(sorted(covered),list(range(1,15)))

    def test_review_uses_m_syntax_and_is_not_executable_sql(self):
        review=build_review(self.r)
        self.assertEqual(review['review_sql'],'GENERATED UPDATE SYSTEM;')
        self.assertNotIn('OBJECT',review['review_sql'])
        self.assertFalse(review['executable']);self.assertFalse(review['database_executed'])
        self.assertEqual(review['generated_case_count'],0)
        self.assertTrue(all(not line.strip() or line.startswith('-- ') for line in render_review_sql(review).splitlines()))

    def test_environment_and_unknown_artifacts_are_preserved(self):
        review=build_review(self.r)
        pre={x['key']:x for x in review['preconditions']}
        self.assertEqual(pre['compatibility_mode']['allowed_values'],['M'])
        self.assertEqual(pre['actor_identity']['requirement'],'initial_user')
        self.assertIn('actual_OM_upgrade',pre['upgrade_context']['requirement'])
        self.assertIn('upgrade_mode != 0',pre['upgrade_context']['requirement'])
        self.assertEqual(len(review['pending_contracts']),2)
        for ref in self.f.matrix_refs:
            matrix=self.r.matrices[ref]
            self.assertFalse(matrix.profiles)
            self.assertTrue(all(f.status=='needs_profile' for f in matrix.documented_features))

    def test_unknown_fixture_cannot_silently_compile_empty_lifecycle(self):
        g=FactorPackageSQLGenerator(self.r)
        with self.assertRaisesRegex(GenerationValidationError,'not_implemented'):
            g._compile_fixture_lifecycle(self.f.fixture_refs)
        fixture=self.r.fixtures[self.f.fixture_refs[0]]
        self.assertEqual(fixture.status,'planned')
        self.assertFalse(fixture.execution.setup_sqls);self.assertFalse(fixture.execution.teardown_sqls)

    def test_review_rejects_accidental_ready_fixture_or_ordinary_manifest(self):
        fixture=self.r.fixtures[self.f.fixture_refs[0]]
        with patch.object(fixture.execution,'status','ready'):
            with self.assertRaisesRegex(ValueError,'unresolved OM'):build_review(self.r)
        with patch.object(self.f,'manifest_refs',['accidental_manifest']):
            with self.assertRaisesRegex(ValueError,'manifest'):build_review(self.r)

    def test_registration_does_not_claim_generation_or_behavior(self):
        self.assertFalse(self.f.manifest_refs)
        self.assertFalse(any(m.factor_ref==FACTOR_ID for m in self.r.manifests.values()))
        audit=FactorCoverageAuditor(self.r).audit(FACTOR_ID)
        self.assertFalse(audit['facts']['wrong_consumer_type'])
        self.assertFalse(audit['manifests']['errors'])
        for key in ('generation_model_complete','static_coverage_complete','behavior_coverage_complete'):
            self.assertFalse(audit['conclusions'][key])


if __name__=='__main__':unittest.main()
