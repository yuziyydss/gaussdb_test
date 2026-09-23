"""Fixed V1 productions have one empty assignment, not an empty domain."""
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]


class ZeroDimensionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()

    def test_fixed_productions_have_one_case_under_both_strategies(self):
        for mid, sql in [("manifest_checkpoint_explicit_admin", "CHECKPOINT;")]:
            for strategy in ("pairwise", "cartesian"):
                with self.subTest(manifest=mid, strategy=strategy):
                    m = self.registry.manifests[mid].model_copy(update={"strategy": strategy})
                    cases, report = FactorPackageSQLGenerator(self.registry).generate_with_report(m)
                    self.assertEqual([c.sql for c in cases], [sql])
                    self.assertEqual(cases[0].params, {})
                    self.assertEqual(report.candidate_combination_estimate, 1)
                    self.assertEqual(report.feasible_combination_count, 1)
                    self.assertEqual(report.feasible_pair_count, 0)
                    self.assertEqual(report.missing_pairs, [])

    def test_fixed_production_still_applies_constraints(self):
        g = FactorPackageSQLGenerator(self.registry)
        m = self.registry.manifests["manifest_checkpoint_explicit_admin"]
        solver = SimpleNamespace(filter_combos=lambda rows: [])
        with patch.object(g, "_build_solver", return_value=solver):
            with self.assertRaises(GenerationValidationError):
                g.generate_with_report(m)

    def test_empty_value_domain_remains_infeasible(self):
        solver = SimpleNamespace(filter_combos=lambda rows: rows)
        with self.assertRaises(GenerationValidationError):
            FactorPackageSQLGenerator._small_space_pairwise({"x": []}, solver)
