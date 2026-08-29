"""不连接数据库的规格编译契约测试。"""
import os
import unittest

from pydantic import ValidationError

from core.combinator import generate_constraint_aware_pairwise
from core.constraint_solver import (
    ConstraintSolver,
    ConstraintSyntaxError,
    UnknownConstraintVariableError,
)
from core.spec_generator import GenerationValidationError, SpecSQLGenerator
from core.spec_model import ManifestDef, SpecRegistry


class TestStaticGenerationContract(unittest.TestCase):

    def setUp(self):
        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.registry = SpecRegistry(base_dir)
        self.registry.load_all()
        self.generator = SpecSQLGenerator(self.registry)

    def test_create_view_static_fixture_pairwise_and_report(self):
        manifest = self.registry.get_manifest("manifest_create_view_basic")
        cases, report = self.generator.generate_with_report(manifest)

        self.assertGreater(len(cases), 0)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(report.feasible_pair_count, report.covered_pair_count)
        self.assertEqual(report.missing_pairs, [])
        self.assertEqual(report.duplicate_case_ids, [])
        self.assertEqual(report.high_priority_pair_count, report.covered_high_priority_pair_count)
        self.assertTrue(all(case.preconditions == ["fixture_view_source_two_ints"] for case in cases))
        self.assertTrue(all("t_view_source" in case.sql for case in cases))
        self.assertTrue(any(case.params["post_query_option"] == "WITH CHECK OPTION" for case in cases))

        # 稳定 ID：同一 manifest 重复生成必须获得同一批 case ID。
        second_cases, second_report = self.generator.generate_with_report(manifest)
        self.assertEqual([case.case_id for case in cases], [case.case_id for case in second_cases])
        self.assertEqual(report.to_dict(), second_report.to_dict())

    def test_static_fixture_rejects_missing_query_column(self):
        manifest = self.registry.get_manifest("manifest_create_view_basic")
        bad_bindings = dict(manifest.bindings)
        bad_bindings["query"] = ["SELECT col_1, col_3 FROM t_view_source"]
        invalid_manifest = manifest.model_copy(update={"bindings": bad_bindings})

        with self.assertRaisesRegex(GenerationValidationError, "col_3"):
            self.generator.generate_with_report(invalid_manifest)

    def test_constraint_language_is_strict(self):
        with self.assertRaises(ConstraintSyntaxError):
            ConstraintSolver(["mode contains 'TEMP'"])

        solver = ConstraintSolver(["mode == 'TEMP' => storage != 'COLUMN'"])
        with self.assertRaises(UnknownConstraintVariableError):
            solver.validate_references(["mode"])

    def test_constraint_aware_pairwise_covers_only_feasible_pairs(self):
        domains = {
            "method": ["btree", "gin"],
            "unique": ["", "UNIQUE"],
            "order": ["", "DESC"],
        }
        solver = ConstraintSolver([
            "unique == 'UNIQUE' => method == 'btree'",
            "method == 'gin' => order == ''",
        ])
        result = generate_constraint_aware_pairwise(
            domains,
            solver=solver,
            high_priority_dimensions=[["method", "unique"]],
        )

        self.assertEqual(result.missing_pairs, set())
        self.assertEqual(result.feasible_pairs, result.covered_pairs & result.feasible_pairs)
        for combo in result.suite:
            valid, failed_rule = solver.is_valid(combo)
            self.assertTrue(valid, failed_rule)

    def test_manifest_rejects_unknown_fields(self):
        with self.assertRaises(ValidationError):
            ManifestDef(
                id="bad",
                name="bad",
                target_syntax="syntax_create_view",
                unexpected_field=True,
            )


if __name__ == "__main__":
    unittest.main()
