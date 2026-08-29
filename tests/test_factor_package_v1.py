"""Static contract tests for Factor Package V1 SQL snapshots."""
from __future__ import annotations

import os
import unittest
from itertools import combinations
from pathlib import Path

from pydantic import ValidationError

from core.combinator import generate_cartesian
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import (
    FactorManifestDef,
    FactorPackageRegistry,
    FactorSourceLedgerDef,
    IdentifierPolicyDef,
)
from core.spec_generator import GenerationValidationError


class TestFactorPackageV1(unittest.TestCase):

    def setUp(self):
        self.root = Path(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        self.registry = FactorPackageRegistry(self.root / "specs")
        self.registry.load_all()
        self.generator = FactorPackageSQLGenerator(self.registry)

    def test_strict_registry_and_references(self):
        self.assertEqual(
            set(self.registry.factors),
            {"alter_table", "create_index", "create_view", "select", "insert"},
        )

        factor = self.registry.factors["create_view"]
        self.assertEqual(
            set(factor.manifest_refs),
            {item.id for item in self.registry.manifests.values() if item.factor_ref == factor.id},
        )
        self.assertEqual(
            set(factor.matrix_refs),
            {item.id for item in self.registry.matrices.values() if item.factor_ref == factor.id},
        )
        self.assertEqual(
            set(factor.fixture_refs),
            {item.id for item in self.registry.fixtures.values() if item.factor_ref == factor.id},
        )
        self.assertEqual(
            set(factor.scenario_refs),
            {item.id for item in self.registry.scenarios.values() if item.factor_ref == factor.id},
        )
        self.assertEqual(factor.source_ledger_ref, "source_ledger_create_view")
        ledger = self.registry.get_source_ledger(factor.source_ledger_ref)
        self.assertEqual(ledger.factor_ref, factor.id)
        self.assertEqual(ledger.artifact_sha256, factor.source.artifact_sha256)

        manifest = self.registry.get_manifest("manifest_create_view_basic_positive")
        raw = manifest.model_dump()
        raw["unknown_field"] = True
        with self.assertRaises(ValidationError):
            FactorManifestDef(**raw)

    def test_source_unit_ledger_is_explicit_and_fact_provenance_is_closed(self):
        ledger = self.registry.get_source_ledger("source_ledger_create_view")
        self.assertEqual(len(ledger.units), 64)
        self.assertEqual(ledger.source_line_count, 71)
        self.assertEqual({item.line for item in ledger.ignored_lines}, {2, 7, 10, 12, 15, 44, 57})
        status_counts = {}
        for unit in ledger.units:
            status_counts[unit.status] = status_counts.get(unit.status, 0) + 1
        self.assertEqual(status_counts, {
            "mapped": 51,
            "open_question": 10,
            "out_of_scope": 3,
        })
        self.assertEqual([unit.id for unit in ledger.units if unit.status == "unmapped"], [])
        self.assertEqual(
            {source.id for source in ledger.supplemental_sources},
            {"gaussdb_select_centralized_v8", "gaussdb_flashback_distributed_v8"},
        )

    def test_source_ledger_rejects_missing_mapping_and_hash_drift(self):
        ledger = self.registry.get_source_ledger("source_ledger_create_view")
        raw = ledger.model_dump()
        raw["units"][0]["fact_refs"] = []
        with self.assertRaises(ValidationError):
            FactorSourceLedgerDef(**raw)

        raw = ledger.model_dump()
        raw["source_line_count"] = 72
        with self.assertRaisesRegex(ValidationError, "原文存在未登记行"):
            FactorSourceLedgerDef(**raw)

        raw = ledger.model_dump()
        raw["units"][0]["supplemental_source_refs"] = ["missing_source"]
        with self.assertRaisesRegex(ValidationError, "未知 supplemental source"):
            FactorSourceLedgerDef(**raw)

        self.registry.source_ledgers[ledger.id] = ledger.model_copy(
            update={"artifact_sha256": "0" * 64}
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(
            any("artifact_sha256 与 factor.source.artifact_sha256 不一致" in error for error in errors),
            errors,
        )

    def test_factor_global_coverage_audit_requires_atomicity_review(self):
        audit = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertEqual(audit["source_units"]["accounted"], 64)
        self.assertEqual(audit["source_units"]["total"], 64)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 71,
            "covered_by_units": 64,
            "ignored": 7,
            "missing": [],
        })
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 10)
        self.assertEqual(audit["values"]["valid_total"], 43)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["pairwise_incomplete"], [])
        self.assertEqual(audit["documented_features"]["needs_profile"], [])
        self.assertEqual(audit["source_units"]["atomicity"]["unreviewed"], 64)
        self.assertEqual(len(audit["source_units"]["atomicity"]["gaps"]), 64)
        self.assertFalse(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

    def test_global_audit_rejects_documented_profile_not_selected_by_any_manifest(self):
        for manifest_id in (
            "manifest_create_view_non_updatable_option_negative",
            "manifest_create_view_non_updatable_trailing_negative",
            "manifest_create_view_read_only_non_updatable_positive",
        ):
            manifest = self.registry.manifests[manifest_id]
            manifest.bindings["query_profile"].remove("query_unpivot_two_columns")
        audit = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertIn("unpivot", audit["documented_features"]["needs_profile"])
        self.assertIn(
            "query_profile.query_unpivot_two_columns",
            audit["values"]["valid_unselected"],
        )
        self.assertFalse(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])

    def test_all_manifests_have_complete_pairs_unique_ids_and_valid_sql_shape(self):
        global_case_ids = set()
        total_cases = 0
        expected_counts = {
            "manifest_create_view_basic_positive": 18,
            "manifest_create_view_invalid_options_negative": 3,
            "manifest_create_view_non_updatable_option_negative": 32,
            "manifest_create_view_non_updatable_trailing_negative": 48,
            "manifest_create_view_options_positive": 22,
            "manifest_create_view_read_only_non_updatable_positive": 16,
            "manifest_create_view_schema_qualified_positive": 1,
        }
        feasible_combo_counts = {
            "manifest_create_view_basic_positive": 408,
            "manifest_create_view_invalid_options_negative": 3,
            "manifest_create_view_non_updatable_option_negative": 64,
            "manifest_create_view_non_updatable_trailing_negative": 96,
            "manifest_create_view_options_positive": 128,
            "manifest_create_view_read_only_non_updatable_positive": 16,
            "manifest_create_view_schema_qualified_positive": 1,
        }
        for manifest_id in self.registry.factors["create_view"].manifest_refs:
            manifest = self.registry.manifests[manifest_id]
            cases, report = self.generator.generate_with_report(manifest)
            self.assertEqual(len(cases), expected_counts[manifest_id])
            self.assertEqual(report.feasible_combination_count, feasible_combo_counts[manifest_id])
            self.assertTrue(report.pairwise_complete, report.to_dict())
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)
            self.assertEqual(report.missing_pairs, [])
            self.assertEqual(len({case.case_id for case in cases}), len(cases))
            self.assertFalse(global_case_ids & {case.case_id for case in cases})
            global_case_ids.update(case.case_id for case in cases)
            total_cases += len(cases)
            for case in cases:
                self.assertTrue(case.sql.startswith("CREATE "), case.sql)
                self.assertIn(" VIEW ", case.sql)
                self.assertIn(" AS ", case.sql)
                self.assertTrue(case.sql.endswith(";"), case.sql)
                self.assertNotIn("{", case.sql)
                self.assertEqual(case.sql.count("("), case.sql.count(")"), case.sql)
        self.assertEqual(total_cases, 140)

    def test_positive_and_negative_semantic_intent(self):
        resolved = self.registry.resolve_dimension_values("create_view")
        for manifest_id in self.registry.factors["create_view"].manifest_refs:
            manifest = self.registry.manifests[manifest_id]
            cases, _ = self.generator.generate_with_report(manifest)
            for case in cases:
                query = resolved["query_profile"][case.params["query_profile"]]
                updatable = query.attributes["query_profile.properties.updatable"]
                trailing_check = case.params["post_query_option"] in {
                    "check_default", "check_cascaded", "check_local",
                }
                option_check = case.params["view_options_profile"] in {
                    "view_option_check_cascaded", "view_option_check_local",
                    "view_options_security_true_check_local",
                    "view_options_security_false_check_cascaded",
                    "view_options_check_local_security_true",
                    "view_options_check_cascaded_security_false",
                }
                if manifest.suite_type == "positive":
                    self.assertEqual(case.expected, "success")
                    if trailing_check or option_check:
                        self.assertIs(updatable, True)
                    if case.params["query_profile"] == "query_values_two_columns":
                        self.assertIn(
                            case.params["post_query_option"],
                            {"post_query_none", "read_only"},
                        )
                else:
                    self.assertEqual(case.expected, "error")
                    if manifest.id == "manifest_create_view_invalid_options_negative":
                        self.assertIn(case.params["view_options_profile"], {
                            "view_option_unknown_name",
                            "view_option_security_invalid",
                            "view_option_check_invalid",
                        })
                    else:
                        self.assertIs(updatable, False)
                        self.assertTrue(trailing_check or option_check)

    def test_documented_non_updatable_features_are_covered_or_explicit_gaps(self):
        matrix = self.registry.matrices["matrix_create_view_query_capabilities"]
        features = matrix.documented_non_updatable_features
        self.assertEqual(len(features), 16)
        self.assertEqual(sum(item.status == "covered" for item in features), 16)
        self.assertEqual({item.id for item in features if item.status == "needs_profile"}, set())
        covered_profiles = {
            profile_id
            for item in features if item.status == "covered"
            for profile_id in item.profile_refs
        }
        for manifest_id in (
            "manifest_create_view_non_updatable_option_negative",
            "manifest_create_view_non_updatable_trailing_negative",
            "manifest_create_view_read_only_non_updatable_positive",
        ):
            self.assertEqual(
                set(self.registry.manifests[manifest_id].bindings["query_profile"]),
                covered_profiles,
            )

    def test_schema_qualified_identifier_is_rendered(self):
        manifest = self.registry.get_manifest("manifest_create_view_schema_qualified_positive")
        cases, _ = self.generator.generate_with_report(manifest)
        self.assertEqual(len(cases), 1)
        self.assertIn("CREATE VIEW public.v_cv_schema_", cases[0].sql)

    def test_positive_manifest_cannot_bind_unknown_value(self):
        manifest = self.registry.manifests["manifest_create_view_basic_positive"]
        manifest.bindings["view_options_profile"] = ["view_option_security_bare"]
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(
            any(
                "positive manifest 不能绑定 validity='unknown'" in error
                for error in errors
            ),
            errors,
        )

    def test_identifier_policy_and_suffix_are_manifest_scoped(self):
        with self.assertRaises(ValidationError):
            IdentifierPolicyDef(
                generator="deterministic",
                prefix="v;drop_view",
                unique_per_case=True,
            )
        combo = {"query_profile": "query_simple_two_columns"}
        left = self.generator._stable_case_id("manifest_left", combo).rsplit("_", 1)[-1]
        right = self.generator._stable_case_id("manifest_right", combo).rsplit("_", 1)[-1]
        self.assertNotEqual(left, right)

    def test_pair_coverage_is_independently_recomputed(self):
        for manifest in self.registry.manifests.values():
            factor = self.registry.factors[manifest.factor_ref]
            resolved = self.registry.resolve_dimension_values(factor.id)
            param_space = self.generator.build_param_space(factor, manifest)
            solver = self.generator._build_solver(factor, manifest, resolved)
            feasible = solver.filter_combos(generate_cartesian(param_space))
            parameters = list(param_space)

            def pairs(combos):
                return {
                    (left, combo[left], right, combo[right])
                    for combo in combos
                    for left, right in combinations(parameters, 2)
                }

            cases, _ = self.generator.generate_with_report(manifest)
            actual_combos = [case.params for case in cases]
            self.assertEqual(pairs(feasible), pairs(actual_combos))

    def test_fixture_contract_rejects_missing_column(self):
        fixture_id = "fixture_create_view_source_two_ints"
        fixture = self.registry.fixtures[fixture_id]
        table = fixture.provides.tables[0]
        bad_table = table.model_copy(update={"columns": [table.columns[0]]})
        bad_provides = fixture.provides.model_copy(update={"tables": [bad_table]})
        self.registry.fixtures[fixture_id] = fixture.model_copy(update={"provides": bad_provides})

        manifest = self.registry.get_manifest("manifest_create_view_basic_positive")
        with self.assertRaisesRegex(GenerationValidationError, "col_2"):
            self.generator.generate_with_report(manifest)

    def test_wildcard_profile_tracks_fixture_column_count(self):
        fixture_id = "fixture_create_view_source_two_ints"
        fixture = self.registry.fixtures[fixture_id]
        table = fixture.provides.tables[0]
        extra_column = table.columns[0].model_copy(update={"name": "col_3"})
        wider_table = table.model_copy(update={"columns": table.columns + [extra_column]})
        wider_provides = fixture.provides.model_copy(update={"tables": [wider_table]})
        self.registry.fixtures[fixture_id] = fixture.model_copy(update={"provides": wider_provides})

        manifest = self.registry.get_manifest("manifest_create_view_basic_positive")
        with self.assertRaisesRegex(GenerationValidationError, "SELECT \\* 实际输出 3 列"):
            self.generator.generate_with_report(manifest)

    def test_structural_check_rejects_alias_count_mismatch(self):
        factor = self.registry.factors["create_view"]
        column_dimension = factor.dimensions["column_list"]
        explicit_value = column_dimension.classes[1].values[0]
        explicit_value.output_column_count = 1

        manifest = self.registry.get_manifest("manifest_create_view_basic_positive")
        param_space = self.generator.build_param_space(factor, manifest)
        combo = {dimension_id: values[0] for dimension_id, values in param_space.items()}
        combo["column_list"] = "column_list_two_aliases"
        combo["query_profile"] = "query_simple_two_columns"
        resolved = self.registry.resolve_dimension_values("create_view")
        with self.assertRaisesRegex(GenerationValidationError, "有 1 个名称"):
            self.generator._validate_structural_contract(factor, combo, resolved)

    def test_generated_sql_snapshots_match_current_generator(self):
        for manifest_id, manifest in self.registry.manifests.items():
            cases, _ = self.generator.generate_with_report(manifest)
            snapshot_dir = self.root / "generated" / "factor_packages" / manifest.factor_ref
            snapshot_path = snapshot_dir / f"{manifest_id}.sql"
            lines = snapshot_path.read_text(encoding="utf-8").splitlines()
            snapshot_sql = [
                lines[index + 1]
                for index, line in enumerate(lines[:-1])
                if line == "-- test_sql:"
            ]
            self.assertEqual(snapshot_sql, [case.sql for case in cases])

    def test_recursive_ast_renders_top_level_repeat_and_nested_subgrammar(self):
        syntax = self.registry.syntaxes["syntax_select_v1"]
        self.assertIsNotNone(syntax.ast)
        self.assertIn("select_statement", syntax.subgrammars)
        self.assertIn("nested_select", syntax.subgrammars)
        self.assertEqual(
            syntax.ast_subgrammar_refs(),
            set(syntax.subgrammars),
        )

        nested_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_select_ast_nested_positive"]
        )
        self.assertTrue(any(
            "FROM (SELECT col_1 FROM t_select_source AS ast_inner) AS ast_s"
            in case.sql for case in nested_cases
        ))
        table_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_select_ast_table_positive"]
        )
        self.assertEqual([case.sql for case in table_cases], ["TABLE t_select_source;"])

    def test_select_expression_contract_rejects_incompatible_shapes(self):
        factor = self.registry.factors["select"]
        resolved = self.registry.resolve_dimension_values("select")
        manifest = self.registry.manifests["manifest_select_ast_core_positive"]
        defaults = {
            dimension_id: values[0]
            for dimension_id, values in self.generator.build_param_space(
                factor, manifest
            ).items()
        }
        defaults.update({
            "statement_form": "select_statement_ast",
            "source_form": "select_source_table",
        })

        column_mismatch = dict(defaults)
        column_mismatch.update({
            "target_list": "select_target_col1_col2",
            "source_form": "select_source_subquery",
            "inner_target_list": "select_inner_target_col1",
        })
        with self.assertRaisesRegex(GenerationValidationError, "查询源不存在的列"):
            self.generator._validate_structural_contract(
                factor, column_mismatch, resolved
            )

        group_mismatch = dict(defaults)
        group_mismatch.update({
            "target_list": "select_target_col1_col2",
            "group_by_list": "select_group_col1",
        })
        with self.assertRaisesRegex(GenerationValidationError, "未完整进入 GROUP BY"):
            self.generator._validate_structural_contract(
                factor, group_mismatch, resolved
            )

        set_mismatch = dict(defaults)
        set_mismatch.update({
            "target_list": "select_target_col1_col2",
            "set_operator": "select_set_union",
            "right_target_list": "select_right_target_col1",
        })
        with self.assertRaisesRegex(GenerationValidationError, "输出列数不一致"):
            self.generator._validate_structural_contract(
                factor, set_mismatch, resolved
            )

    def test_fixture_lifecycle_and_negative_oracles_are_materialized(self):
        source_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_select_ast_core_positive"]
        )
        case = source_cases[0]
        self.assertTrue(any(sql.startswith("CREATE TABLE t_select_source") for sql in case.setup_sqls))
        self.assertTrue(any(sql.startswith("INSERT INTO t_select_source") for sql in case.setup_sqls))
        self.assertEqual(case.teardown_sqls[-1], "DROP TABLE IF EXISTS t_select_source CASCADE;")

        no_from_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_select_ast_no_from_positive"]
        )
        self.assertTrue(all(not case.setup_sqls and not case.teardown_sqls for case in no_from_cases))

        negative_manifests = [
            manifest for manifest in self.registry.manifests.values()
            if manifest.suite_type == "negative"
        ]
        self.assertTrue(negative_manifests)
        for manifest in negative_manifests:
            self.assertTrue(manifest.expected.error_category)
            self.assertTrue(
                manifest.expected.sqlstates or manifest.expected.error_message_regex
            )
            cases, _ = self.generator.generate_with_report(manifest)
            self.assertTrue(all(case.expected_error_category for case in cases))
            self.assertTrue(all(
                case.expected_sqlstates or case.expected_error_regex for case in cases
            ))

    def test_select_adaptation_audit_and_generation(self):
        audit = FactorCoverageAuditor(self.registry).audit("select")
        self.assertEqual(audit["source_units"]["accounted"], 43)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 553,
            "covered_by_units": 553,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(audit["values"]["valid_total"], 93)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 99)
        self.assertFalse(audit["manifests"]["profile_enumeration_only"])
        self.assertEqual(audit["documented_features"]["covered"], 21)
        self.assertEqual(len(audit["documented_features"]["needs_profile"]), 9)
        self.assertEqual(len(audit["source_units"]["atomicity"]["gaps"]), 43)
        self.assertFalse(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertTrue(audit["conclusions"]["pairwise_interaction_coverage_present"])

        cases = []
        for manifest_id in self.registry.factors["select"].manifest_refs:
            generated, report = self.generator.generate_with_report(
                self.registry.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        self.assertEqual(len(cases), 99)
        self.assertEqual(len({case.case_id for case in cases}), 99)
        self.assertEqual(sum(case.expected == "success" for case in cases), 93)
        self.assertEqual(sum(case.expected == "error" for case in cases), 6)
        self.assertTrue(all(
            case.sql.startswith(("SELECT ", "WITH ", "TABLE ")) for case in cases
        ))

    def test_insert_source_audit_and_generation_quality(self):
        audit = FactorCoverageAuditor(self.registry).audit("insert")
        self.assertEqual(audit["source_units"]["total"], 116)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 276,
            "covered_by_units": 267,
            "ignored": 9,
            "missing": [],
        })
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 2)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 45)
        self.assertEqual(
            audit["documented_features"]["needs_profile"],
            ["insert_feature_dblink", "insert_feature_plan_hint"],
        )
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

        cases = []
        for manifest_id in self.registry.factors["insert"].manifest_refs:
            generated, report = self.generator.generate_with_report(
                self.registry.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)
            cases.extend(generated)
        self.assertEqual(len({case.case_id for case in cases}), 45)
        self.assertEqual(sum(case.expected == "success" for case in cases), 40)
        self.assertEqual(sum(case.expected == "error" for case in cases), 5)
        self.assertTrue(all(case.sql.endswith(";") for case in cases))
        self.assertTrue(all(
            case.sql.startswith(("INSERT ", "WITH ")) for case in cases
        ))
        self.assertTrue(all(case.setup_sqls for case in cases))

    def test_insert_input_contract_rejects_arity_type_and_missing_cte(self):
        factor = self.registry.factors["insert"]
        resolved = self.registry.resolve_dimension_values("insert")
        base = {
            "with_clause": "insert_with_none",
            "plan_hint": "insert_hint_none",
            "ignore_modifier": "insert_ignore_none",
            "target_profile": "insert_target_table_note",
            "source_profile": "insert_source_values_id",
            "conflict_clause": "insert_conflict_none",
            "returning_clause": "insert_returning_none",
        }
        with self.assertRaisesRegex(GenerationValidationError, "类型不兼容"):
            self.generator._validate_structural_contract(factor, base, resolved)

        mismatched = dict(base)
        mismatched["target_profile"] = "insert_target_table_two_columns"
        with self.assertRaisesRegex(GenerationValidationError, "目标列数与输入列数不一致"):
            self.generator._validate_structural_contract(factor, mismatched, resolved)

        missing_cte = dict(base)
        missing_cte["target_profile"] = "insert_target_table_two_columns"
        missing_cte["source_profile"] = "insert_source_cte_query"
        with self.assertRaisesRegex(GenerationValidationError, "要求 WITH"):
            self.generator._validate_structural_contract(factor, missing_cte, resolved)

    def test_create_index_source_audit_and_generation_quality(self):
        audit = FactorCoverageAuditor(self.registry).audit("create_index")
        self.assertEqual(audit["source_units"]["total"], 63)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 164,
            "covered_by_units": 164,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 5)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 308)
        self.assertEqual(audit["documented_features"]["needs_profile"], [
            "ci_feature_default_partition_scope",
            "ci_feature_if_not_exists_unnamed",
            "ci_feature_partial_index_grammar",
            "ci_feature_subpartition_table",
            "ci_feature_tde_fixture",
        ])
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

        cases = []
        for manifest_id in self.registry.factors["create_index"].manifest_refs:
            generated, report = self.generator.generate_with_report(
                self.registry.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)
            cases.extend(generated)
        self.assertEqual(len({case.case_id for case in cases}), 308)
        self.assertEqual(sum(case.expected == "success" for case in cases), 299)
        self.assertEqual(sum(case.expected == "error" for case in cases), 9)
        self.assertTrue(all(case.sql.startswith("CREATE ") for case in cases))
        self.assertTrue(all(" INDEX " in case.sql for case in cases))
        self.assertTrue(all(case.sql.endswith(";") for case in cases))
        self.assertFalse(any(
            method in case.sql.lower()
            for case in cases
            for method in (" using gin", " using gist", " using ubtree", " using ugin")
        ))
        self.assertTrue(all(case.setup_sqls for case in cases))

    def test_create_index_contract_rejects_include_overlap_and_online_limit(self):
        factor = self.registry.factors["create_index"]
        resolved = self.registry.resolve_dimension_values("create_index")
        overlap = {
            "key_profile": "ci_key_id_note",
            "include_profile": "ci_include_note",
            "table_profile": "ci_table_regular",
            "scope_clause": "ci_scope_none",
            "concurrently": "ci_concurrently_none",
        }
        with self.assertRaisesRegex(GenerationValidationError, "INCLUDE 必须是非键列"):
            self.generator._validate_structural_contract(factor, overlap, resolved)

        key_matrix = self.registry.matrices["matrix_create_index_key_profiles"]
        key_profile = next(item for item in key_matrix.profiles if item.id == "ci_key_id")
        key_profile.properties["items"] = [f"id + {index}" for index in range(30)]
        key_profile.properties["key_column_count"] = 30
        resolved = self.registry.resolve_dimension_values("create_index")
        too_wide = {
            "key_profile": "ci_key_id",
            "include_profile": "ci_include_none",
            "table_profile": "ci_table_regular",
            "scope_clause": "ci_scope_none",
            "concurrently": "ci_concurrently",
        }
        with self.assertRaisesRegex(GenerationValidationError, "超过当前形态上限 29"):
            self.generator._validate_structural_contract(factor, too_wide, resolved)

    def test_alter_table_source_audit_and_generation_quality(self):
        audit = FactorCoverageAuditor(self.registry).audit("alter_table")
        self.assertEqual(audit["source_units"]["total"], 69)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 566,
            "covered_by_units": 566,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 10)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 273)
        self.assertEqual(audit["documented_features"]["needs_profile"], [
            "at_feature_a_rowid",
            "at_feature_b_actions",
            "at_feature_b_compatibility",
            "at_feature_colview",
            "at_feature_encrypted_column",
            "at_feature_external_table",
            "at_feature_ilm",
            "at_feature_subpartition",
            "at_feature_tde_rotation",
            "at_feature_tde_table",
        ])
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

        cases = []
        for manifest_id in self.registry.factors["alter_table"].manifest_refs:
            generated, report = self.generator.generate_with_report(
                self.registry.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)
            cases.extend(generated)
        self.assertEqual(len({case.case_id for case in cases}), 273)
        self.assertEqual(sum(case.expected == "success" for case in cases), 261)
        self.assertEqual(sum(case.expected == "error" for case in cases), 12)
        self.assertTrue(all(case.sql.startswith("ALTER TABLE ") for case in cases))
        self.assertTrue(all(case.sql.endswith(";") for case in cases))
        self.assertTrue(all(case.setup_sqls for case in cases))

        positive_sql = "\n".join(case.sql for case in cases if case.expected == "success")
        for unsupported in (
            " MODIFY ", " CHANGE ", " AUTO_INCREMENT", "ENCRYPTION KEY ROTATION",
            " ILM ", " COLVIEW", "SET WITH ROWID", "GSIWAITALL",
        ):
            self.assertNotIn(unsupported, positive_sql)
        self.assertNotIn("DEFAULT nextval", positive_sql)
        self.assertNotIn("orientation =", positive_sql.lower())


if __name__ == "__main__":
    unittest.main()
