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

