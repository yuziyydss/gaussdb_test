"""Static contract tests for Factor Package V1 SQL snapshots."""
from __future__ import annotations

import hashlib
import os
import re
import unittest
from collections import Counter
from itertools import combinations
from pathlib import Path

from pydantic import ValidationError

from core.combinator import generate_cartesian
from core.constraint_solver import ConstraintSolver
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import (
    DocumentedFeatureCoverageDef,
    EnvironmentRequirementDef,
    FactorManifestDef,
    FactorPackageRegistry,
    FactorScenarioDef,
    FactorSourceLedgerDef,
    ExpectedDef,
    IdentifierPolicyDef,
    SourceDef,
    SupplementalSourceDef,
)
from core.spec_generator import GenerationValidationError


PDF_FACTOR_BASELINES = {
    "create_view": {
        "source_relpath": "general/ddl/create_view.txt",
        "sha256": "e66079b4f289b10874a1e5fa5abdfc5fdc8b1d026ebdfb05e3c593d64f7eedc5",
        "lines": 406,
        "units": 116,
        "manifests": 7,
        "cases": 122,
    },
    "create_index": {
        "source_relpath": "general/ddl/create_index.txt",
        "sha256": "7a8ce69c11e865868cb75fd990000d6a41ceb91ce200dd3e882dc41496863d0d",
        "lines": 899,
        "units": 209,
        "manifests": 22,
        "cases": 335,
    },
    "alter_table": {
        "source_relpath": "general/ddl/alter_table.txt",
        "sha256": "ff15f5547fd4f2b5aa4888b0d8c67b74f0586098cf3c87d3b2628506562e786e",
        "lines": 1636,
        "units": 209,
        "manifests": 16,
        "cases": 277,
    },
    "insert": {
        "source_relpath": "general/dml/insert.txt",
        "sha256": "5383f2eca79ecbe64ce3e880c8e3a2a39178a6bd93ca328401740bf36c16fae5",
        "lines": 918,
        "units": 245,
        "manifests": 14,
        "cases": 98,
    },
    "select": {
        "source_relpath": "general/dml/select.txt",
        "sha256": "704be074e80aa4db10f5bd8f4c587e31be2602640aced00c4985610d674fa4cc",
        "lines": 2333,
        "units": 373,
        "manifests": 16,
        "cases": 110,
    },
}


class TestFactorPackageV1(unittest.TestCase):

    def test_documented_feature_distinguishes_representative_from_full_domain(self):
        feature = DocumentedFeatureCoverageDef(
            id="feature_test",
            profile_refs=["profile_a", "profile_b"],
            status="covered",
            coverage_mode="representative",
            fact_refs=["fact_a"],
        )
        self.assertEqual(feature.coverage_mode, "representative")
        with self.assertRaisesRegex(ValidationError, "不应声明 coverage_mode"):
            DocumentedFeatureCoverageDef(
                id="feature_missing",
                status="needs_profile",
                coverage_mode="representative",
                fact_refs=["fact_a"],
            )

    def test_ready_scenario_requires_structured_execution_and_oracle(self):
        common = {
            "schema_version": 1,
            "kind": "scenario",
            "id": "scenario_test",
            "name": "test",
            "description": "test",
            "factor_ref": "create_view",
        }
        with self.assertRaisesRegex(ValidationError, "steps 或 variants"):
            FactorScenarioDef(**common, status="ready")
        with self.assertRaisesRegex(ValidationError, "oracles"):
            FactorScenarioDef(
                **common,
                status="ready",
                steps=[{"id": "s1", "action": "execute_sql", "sql": "SELECT 1"}],
            )
        scenario = FactorScenarioDef(
            **common,
            status="ready",
            steps=[{"id": "s1", "action": "execute_sql", "sql": "SELECT 1"}],
            oracles=[{"kind": "statement_result", "expected": "success"}],
        )
        self.assertEqual(scenario.status, "ready")

    def test_unverified_negative_oracle_is_explicit_and_catch_all_is_rejected(self):
        unresolved = ExpectedDef(
            default="error",
            scope="syntax_and_semantics",
            error_category="invalid_view_option",
            oracle_status="needs_verification",
        )
        self.assertEqual(unresolved.oracle_status, "needs_verification")
        self.assertEqual(unresolved.sqlstates, [])
        self.assertIsNone(unresolved.error_message_regex)

        with self.assertRaisesRegex(ValidationError, "不能匹配任意错误"):
            ExpectedDef(
                default="error",
                scope="syntax_and_semantics",
                error_category="invalid_view_option",
                error_message_regex="(?s).+",
                fact_refs=["cv_fact_invalid_view_option_error"],
            )

        with self.assertRaisesRegex(ValidationError, "必须引用 fact_refs"):
            ExpectedDef(
                default="error",
                scope="syntax_and_semantics",
                error_category="invalid_view_option",
                error_message_regex="invalid option",
            )


    def setUp(self):
        self.root = Path(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        self.registry = FactorPackageRegistry(self.root / "specs")
        self.registry.load_all()
        self.generator = FactorPackageSQLGenerator(self.registry)

    def test_strict_registry_and_references(self):
        self.assertTrue(
            set(PDF_FACTOR_BASELINES).issubset(self.registry.factors),
            set(PDF_FACTOR_BASELINES) - set(self.registry.factors),
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

    def test_scenario_fixture_references_must_resolve(self):
        scenario_id = "scenario_create_view_or_replace"
        scenario = self.registry.scenarios[scenario_id]
        self.registry.scenarios[scenario_id] = scenario.model_copy(
            update={"fixture_refs": ["fixture_does_not_exist"]}
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(
            any(
                "fixture_refs 引用不存在: 'fixture_does_not_exist'" in error
                for error in errors
            ),
            errors,
        )

    def test_qualified_fact_refs_resolve_and_build_factor_dependency_dag(self):
        scenario_id = "scenario_insert_view_subquery"
        scenario = self.registry.scenarios[scenario_id]
        qualified_ref = "create_view::cv_fact_key_preserved_definition"
        self.registry.scenarios[scenario_id] = scenario.model_copy(
            update={"fact_refs": [*scenario.fact_refs, qualified_ref]}
        )

        errors = []
        self.registry._validate_references(errors)
        self.assertEqual(errors, [])
        self.assertEqual(
            self.registry.resolve_fact_ref("insert", qualified_ref).id,
            "cv_fact_key_preserved_definition",
        )
        graph = self.registry.factor_dependency_graph()
        self.assertIn("create_view", graph["insert"])
        order = self.registry.factor_topological_order({"insert", "create_view"})
        self.assertLess(order.index("create_view"), order.index("insert"))

    def test_qualified_fact_refs_reject_missing_fact_wrong_type_and_cycles(self):
        scenario_id = "scenario_insert_view_subquery"
        scenario = self.registry.scenarios[scenario_id]
        self.registry.scenarios[scenario_id] = scenario.model_copy(
            update={"fact_refs": [*scenario.fact_refs, "create_view::missing_fact"]}
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(any("create_view::missing_fact" in item for item in errors), errors)

        self.registry.scenarios[scenario_id] = scenario.model_copy(
            update={
                "fact_refs": [
                    *scenario.fact_refs,
                    "create_view::cv_fact_main_grammar",
                ]
            }
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(
            any("create_view::cv_fact_main_grammar" in item for item in errors),
            errors,
        )

        self.registry.scenarios[scenario_id] = scenario
        manifest_id = "manifest_insert_core_positive"
        manifest = self.registry.manifests[manifest_id]
        requirement = EnvironmentRequirementDef(
            key="cross_fact_type_probe",
            allowed_values=["enabled"],
            fact_refs=["create_view::cv_fact_key_preserved_definition"],
        )
        self.registry.manifests[manifest_id] = manifest.model_copy(
            update={
                "environment_requirements": [
                    *manifest.environment_requirements,
                    requirement,
                ]
            }
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(
            any(
                "type='constraint' 不能由 environment_gate 消费" in item
                and "cv_fact_key_preserved_definition" in item
                for item in errors
            ),
            errors,
        )

        self.registry.manifests[manifest_id] = manifest
        create_view_scenario_id = "scenario_create_view_or_replace"
        create_view_scenario = self.registry.scenarios[create_view_scenario_id]
        self.registry.scenarios[scenario_id] = scenario.model_copy(
            update={
                "fact_refs": [
                    *scenario.fact_refs,
                    "create_view::cv_fact_key_preserved_definition",
                ]
            }
        )
        self.registry.scenarios[create_view_scenario_id] = create_view_scenario.model_copy(
            update={
                "fact_refs": [
                    *create_view_scenario.fact_refs,
                    "insert::insert_fact_view_subquery_grammar",
                ]
            }
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(any("因子依赖存在环" in item for item in errors), errors)

    def test_fixture_dependencies_are_topologically_sorted_and_cycles_fail(self):
        dependent_id = "fixture_insert_target"
        prerequisite_id = "fixture_create_view_source_two_ints"
        dependent = self.registry.fixtures[dependent_id]
        prerequisite = self.registry.fixtures[prerequisite_id]
        self.registry.fixtures[dependent_id] = dependent.model_copy(
            update={"requires_fixture_refs": [prerequisite_id]}
        )

        errors = []
        self.registry._validate_references(errors)
        self.assertEqual(errors, [])
        self.assertEqual(
            self.registry.fixture_topological_order([dependent_id]),
            [prerequisite_id, dependent_id],
        )
        self.assertIn("create_view", self.registry.factor_dependency_graph()["insert"])
        cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_insert_core_positive"]
        )
        case = cases[0]
        self.assertLess(
            case.preconditions.index(prerequisite_id),
            case.preconditions.index(dependent_id),
        )
        self.assertLess(
            next(i for i, sql in enumerate(case.setup_sqls) if "CREATE TABLE t_view_source" in sql),
            next(i for i, sql in enumerate(case.setup_sqls) if "CREATE TABLE t_insert_target" in sql),
        )
        self.assertLess(
            next(i for i, sql in enumerate(case.teardown_sqls) if "t_insert_target" in sql),
            next(i for i, sql in enumerate(case.teardown_sqls) if "t_view_source" in sql),
        )

        self.registry.fixtures[prerequisite_id] = prerequisite.model_copy(
            update={"requires_fixture_refs": [dependent_id]}
        )
        errors = []
        self.registry._validate_references(errors)
        self.assertTrue(any("fixture 依赖存在环" in item for item in errors), errors)

    def test_coverage_audit_reports_external_fact_consumers(self):
        scenario_id = "scenario_insert_view_subquery"
        scenario = self.registry.scenarios[scenario_id]
        qualified_ref = "create_view::cv_fact_key_preserved_definition"
        self.registry.scenarios[scenario_id] = scenario.model_copy(
            update={"fact_refs": [*scenario.fact_refs, qualified_ref]}
        )

        report = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertEqual(
            report["facts"]["external_consumers"][
                "cv_fact_key_preserved_definition"
            ],
            ["delete:scenario", "insert:scenario", "update:scenario"],
        )

    def test_source_unit_ledger_is_explicit_and_fact_provenance_is_closed(self):
        ledger = self.registry.get_source_ledger("source_ledger_create_view")
        self.assertEqual(len(ledger.units), 116)
        self.assertEqual(ledger.source_line_count, 406)
        self.assertEqual(
            {item.line for item in ledger.ignored_lines},
            {1, 40, 87, 144, 215, 285, 356},
        )
        self.assertEqual(
            Counter(unit.status for unit in ledger.units),
            {"mapped": 90, "open_question": 15, "out_of_scope": 11},
        )
        self.assertEqual([unit.id for unit in ledger.units if unit.status == "unmapped"], [])
        self.assertEqual(ledger.supplemental_sources, [])

    def test_five_packages_are_bound_to_exact_pdf_chapter_artifacts(self):
        self.assertTrue(set(PDF_FACTOR_BASELINES).issubset(self.registry.factors))
        self.assertEqual(
            sum(
                1
                for manifest in self.registry.manifests.values()
                if manifest.factor_ref in PDF_FACTOR_BASELINES
            ),
            75,
        )

        for factor_id, baseline in PDF_FACTOR_BASELINES.items():
            with self.subTest(factor=factor_id):
                factor = self.registry.get_factor(factor_id)
                ledger = self.registry.get_source_ledger(factor.source_ledger_ref)
                source_path = self.root / "intranet_corpus" / baseline["source_relpath"]
                source_bytes = source_path.read_bytes()

                self.assertEqual(hashlib.sha256(source_bytes).hexdigest(), baseline["sha256"])
                self.assertEqual(len(source_path.read_text(encoding="utf-8").splitlines()), baseline["lines"])
                self.assertEqual(factor.source.artifact_sha256, baseline["sha256"])
                self.assertEqual(ledger.artifact_sha256, baseline["sha256"])
                self.assertEqual(ledger.source_line_count, baseline["lines"])
                self.assertEqual(len(ledger.units), baseline["units"])
                self.assertEqual(
                    factor.source.catalog_chapter_ref.source_relpath,
                    baseline["source_relpath"],
                )
                self.assertEqual(
                    factor.source.catalog_chapter_ref.chapter_sha256,
                    baseline["sha256"],
                )
                self.assertEqual(len(factor.manifest_refs), baseline["manifests"])

    def test_source_ledger_rejects_missing_mapping_and_hash_drift(self):
        ledger = self.registry.get_source_ledger("source_ledger_create_view")
        raw = ledger.model_dump()
        mapped_index = next(
            index for index, unit in enumerate(raw["units"])
            if unit["status"] == "mapped" and unit["fact_refs"]
        )
        raw["units"][mapped_index]["fact_refs"] = []
        with self.assertRaises(ValidationError):
            FactorSourceLedgerDef(**raw)

        raw = ledger.model_dump()
        raw["source_line_count"] = ledger.source_line_count + 1
        with self.assertRaisesRegex(ValidationError, "原文存在未登记行"):
            FactorSourceLedgerDef(**raw)

        raw = ledger.model_dump()
        raw["units"][0]["supplemental_source_refs"] = ["missing_source"]
        with self.assertRaisesRegex(ValidationError, "未知 supplemental source"):
            FactorSourceLedgerDef(**raw)

        raw = ledger.model_dump()
        overlapping = next(
            unit for unit in raw["units"] if unit.get("overlap_group")
        )
        overlapping["overlap_group"] = None
        overlapping["overlap_rationale"] = None
        with self.assertRaisesRegex(ValidationError, "行区间重叠"):
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

    def test_supplemental_source_accepts_exactly_one_external_or_catalog_reference(self):
        common = {
            "id": "gaussdb_select_same_pdf",
            "document": "GaussDB SQL参考",
            "version": "V2.0-10.0.0",
            "retrieval_date": "2026-09-04",
            "source_anchor": "SELECT",
        }
        external = SupplementalSourceDef(
            **common,
            url="https://support.huaweicloud.com/gaussdb/select.html",
        )
        self.assertIsNone(external.catalog_chapter_ref)

        local = SupplementalSourceDef(
            **common,
            catalog_chapter_ref={
                "document_id": "gaussdb-centralized-reference-v10",
                "source_relpath": "general/dml/select.txt",
                "chapter_sha256": "a" * 64,
            },
        )
        self.assertIsNone(local.url)
        self.assertEqual(
            local.catalog_chapter_ref.source_relpath,
            "general/dml/select.txt",
        )

        with self.assertRaisesRegex(ValidationError, "必须且只能提供"):
            SupplementalSourceDef(**common)
        with self.assertRaisesRegex(ValidationError, "url 必须是非空字符串"):
            SupplementalSourceDef(**common, url="   ")
        with self.assertRaisesRegex(ValidationError, "必须且只能提供"):
            SupplementalSourceDef(
                **common,
                url="https://support.huaweicloud.com/gaussdb/select.html",
                catalog_chapter_ref={
                    "document_id": "gaussdb-centralized-reference-v10",
                    "source_relpath": "general/dml/select.txt",
                    "chapter_sha256": "a" * 64,
                },
            )
        with self.assertRaisesRegex(ValidationError, "安全相对路径"):
            SupplementalSourceDef(
                **common,
                catalog_chapter_ref={
                    "document_id": "gaussdb-centralized-reference-v10",
                    "source_relpath": "../select.txt",
                    "chapter_sha256": "a" * 64,
                },
            )
        with self.assertRaisesRegex(ValidationError, "SHA-256"):
            SupplementalSourceDef(
                **common,
                catalog_chapter_ref={
                    "document_id": "gaussdb-centralized-reference-v10",
                    "source_relpath": "general/dml/select.txt",
                    "chapter_sha256": "not-a-digest",
                },
            )

    def test_factor_source_optionally_pins_its_catalog_chapter(self):
        common = {
            "product": "GaussDB",
            "document": "CREATE VIEW",
            "version": "V2.0-10.0.0",
            "artifact_sha256": "a" * 64,
            "extraction_date": "2026-09-04",
        }
        legacy = SourceDef(**common)
        self.assertIsNone(legacy.catalog_chapter_ref)

        catalog_backed = SourceDef(
            **common,
            parent_pdf_sha256="f" * 64,
            extraction_rule_version="gaussdb-pdf-outline-v1",
            catalog_chapter_ref={
                "document_id": "gaussdb-centralized-reference-v10",
                "source_relpath": "general/ddl/create_view.txt",
                "chapter_sha256": "a" * 64,
            },
        )
        self.assertEqual(
            catalog_backed.catalog_chapter_ref.document_id,
            "gaussdb-centralized-reference-v10",
        )
        with self.assertRaisesRegex(ValidationError, "SHA-256"):
            SourceDef(**{**common, "artifact_sha256": "not-a-digest"})
        with self.assertRaisesRegex(ValidationError, "必须相同"):
            SourceDef(
                **common,
                parent_pdf_sha256="f" * 64,
                extraction_rule_version="gaussdb-pdf-outline-v1",
                catalog_chapter_ref={
                    "document_id": "gaussdb-centralized-reference-v10",
                    "source_relpath": "general/ddl/create_view.txt",
                    "chapter_sha256": "b" * 64,
                },
            )
        with self.assertRaisesRegex(ValidationError, "必须同时声明"):
            SourceDef(
                **common,
                catalog_chapter_ref={
                    "document_id": "gaussdb-centralized-reference-v10",
                    "source_relpath": "general/ddl/create_view.txt",
                    "chapter_sha256": "a" * 64,
                },
            )

    def test_factor_global_coverage_audit_tracks_atomic_source_units(self):
        audit = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertEqual(audit["source_units"]["accounted"], 116)
        self.assertEqual(audit["source_units"]["total"], 116)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 406,
            "covered_by_units": 399,
            "ignored": 7,
            "missing": [],
        })
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 11)
        self.assertEqual(audit["values"]["valid_total"], 40)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["pairwise_incomplete"], [])
        self.assertEqual(
            audit["documented_features"]["needs_profile"],
            ["flashback", "start_with_connect_by", "unpivot"],
        )
        self.assertEqual(audit["source_units"]["atomicity"]["reviewed"], 116)
        self.assertEqual(audit["source_units"]["atomicity"]["unreviewed"], 0)
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertFalse(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

    def test_atomicity_audit_rejects_one_bulk_waiver_for_many_units(self):
        ledger = self.registry.get_source_ledger("source_ledger_create_view")
        self.assertIsNotNone(ledger)
        units = ledger.units[:9]
        originals = [
            (unit.statement, unit.atomicity, unit.atomicity_rationale)
            for unit in units
        ]
        try:
            for unit in units:
                unit.statement = "甲、乙、丙共同构成一个待复核摘要。"
                unit.atomicity = "atomic"
                unit.atomicity_rationale = "同一模板理由。"
            audit = FactorCoverageAuditor(self.registry).audit("create_view")
            gaps = {
                gap["id"]: gap["reasons"]
                for gap in audit["source_units"]["atomicity"]["gaps"]
            }
            for unit in units:
                self.assertIn(
                    "atomicity_rationale_reused_as_bulk_waiver",
                    gaps[unit.id],
                )
        finally:
            for unit, original in zip(units, originals):
                unit.statement, unit.atomicity, unit.atomicity_rationale = original

    def test_generation_coverage_does_not_ignore_known_non_valid_values(self):
        factor = self.registry.get_factor("create_view")
        values = [
            value
            for equivalence_class in factor.dimensions["view_options_profile"].classes
            for value in equivalence_class.values
        ]
        unresolved = next(
            value for value in values if value.id == "view_option_security_bare"
        )

        unresolved.validity = "conditional"
        audit = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertIn(
            "view_options_profile.view_option_security_bare",
            audit["values"]["conditional_unselected"],
        )
        self.assertIn(
            "view_options_profile.view_option_security_bare",
            audit["values"]["coverage_gaps"],
        )
        self.assertFalse(audit["conclusions"]["generation_model_complete"])

        unresolved.validity = "invalid"
        audit = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertIn(
            "view_options_profile.view_option_security_bare",
            audit["values"]["invalid_without_negative"],
        )
        self.assertFalse(audit["conclusions"]["generation_model_complete"])

    def test_global_audit_rejects_documented_profile_not_selected_by_any_manifest(self):
        for manifest_id in (
            "manifest_create_view_non_updatable_option_negative",
            "manifest_create_view_non_updatable_trailing_negative",
            "manifest_create_view_read_only_non_updatable_positive",
        ):
            manifest = self.registry.manifests[manifest_id]
            manifest.bindings["query_profile"].remove("query_distinct_two_columns")
        audit = FactorCoverageAuditor(self.registry).audit("create_view")
        self.assertIn("distinct", audit["documented_features"]["needs_profile"])
        self.assertIn(
            "query_profile.query_distinct_two_columns",
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
            "manifest_create_view_non_updatable_option_negative": 26,
            "manifest_create_view_non_updatable_trailing_negative": 39,
            "manifest_create_view_options_positive": 22,
            "manifest_create_view_read_only_non_updatable_positive": 13,
            "manifest_create_view_schema_qualified_positive": 1,
        }
        feasible_combo_counts = {
            "manifest_create_view_basic_positive": 408,
            "manifest_create_view_invalid_options_negative": 3,
            "manifest_create_view_non_updatable_option_negative": 52,
            "manifest_create_view_non_updatable_trailing_negative": 78,
            "manifest_create_view_options_positive": 128,
            "manifest_create_view_read_only_non_updatable_positive": 13,
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
        self.assertEqual(total_cases, PDF_FACTOR_BASELINES["create_view"]["cases"])

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
        self.assertEqual(sum(item.status == "covered" for item in features), 13)
        self.assertEqual(
            {item.id for item in features if item.status == "needs_profile"},
            {"flashback", "start_with_connect_by", "unpivot"},
        )
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

    def test_all_pdf_pilot_sql_is_fully_rendered_unique_and_traceable(self):
        raw_bnf = re.compile(
            r"\.{3}|\s\|\s|\[[^\]]*\]|"
            r"\b(?:table_name|column_name|view_name|index_name|query|predicate|"
            r"expression|tablespace_name)\b",
            re.IGNORECASE,
        )
        all_cases = []

        for syntax in self.registry.syntaxes.values():
            referenced_slots = (
                syntax.production_placeholders()
                if syntax.production
                else syntax.ast_slots()
            )
            self.assertEqual(referenced_slots, set(syntax.slots), syntax.id)
            self.assertEqual(
                syntax.ast_subgrammar_refs(),
                set(syntax.subgrammars),
                syntax.id,
            )
            literal_texts = []
            if syntax.production:
                literal_texts.append(re.sub(r"\{[A-Za-z_][A-Za-z0-9_]*\}", "", syntax.production))
            else:
                roots = [syntax.ast, *syntax.subgrammars.values()]
                literal_texts.extend(
                    node.text
                    for root in roots
                    for node in root.walk()
                    if node.text
                )
            self.assertFalse(
                any(raw_bnf.search(text) for text in literal_texts),
                syntax.id,
            )

        for manifest in self.registry.manifests.values():
            cases, report = self.generator.generate_with_report(manifest)
            self.assertTrue(report.pairwise_complete, manifest.id)
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)
            self.assertEqual(report.missing_pairs, [])
            for case in cases:
                self.assertTrue(case.consumed_dimension_ids, case.case_id)
                self.assertTrue(
                    set(case.consumed_dimension_ids).issubset(case.params),
                    case.case_id,
                )
                self.assertTrue(case.sql.endswith(";"), case.sql)
                self.assertNotIn("{", case.sql)
                self.assertNotIn("}", case.sql)
                self.assertIsNone(raw_bnf.search(case.sql), case.sql)
            all_cases.extend(cases)

        self.assertGreaterEqual(len(all_cases), 942)
        self.assertEqual(len({case.case_id for case in all_cases}), len(all_cases))
        self.assertEqual(len({case.sql for case in all_cases}), len(all_cases))
        counts = Counter(case.factor_id for case in all_cases)
        self.assertEqual(
            {factor_id: counts[factor_id] for factor_id in PDF_FACTOR_BASELINES},
            {
                factor_id: baseline["cases"]
                for factor_id, baseline in PDF_FACTOR_BASELINES.items()
            },
        )

    def test_render_consumption_tracks_only_the_selected_ast_branch(self):
        regular_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_create_index_regular_positive"]
        )
        self.assertTrue(regular_cases)
        for case in regular_cases:
            self.assertIn("statement_form", case.consumed_dimension_ids)
            self.assertIn("predicate_clause", case.consumed_dimension_ids)
            self.assertNotIn("scope_clause", case.consumed_dimension_ids)

        partition_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_create_index_partition_positive"]
        )
        self.assertTrue(partition_cases)
        for case in partition_cases:
            self.assertIn("statement_form", case.consumed_dimension_ids)
            self.assertIn("scope_clause", case.consumed_dimension_ids)
            self.assertNotIn("predicate_clause", case.consumed_dimension_ids)

        table_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_select_ast_table_positive"]
        )
        self.assertEqual(
            table_cases[0].consumed_dimension_ids,
            ["statement_form", "table_target"],
        )

        select_ast_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_select_ast_core_positive"]
        )
        self.assertTrue(select_ast_cases)
        for case in select_ast_cases:
            self.assertIn("target_list", case.consumed_dimension_ids)
            self.assertIn("set_operator", case.consumed_dimension_ids)
            self.assertNotIn("right_target_list", case.consumed_dimension_ids)
            if case.params["source_form"] == "select_source_subquery":
                self.assertIn("inner_target_list", case.consumed_dimension_ids)
            else:
                self.assertNotIn("inner_target_list", case.consumed_dimension_ids)

        linear_cases, _ = self.generator.generate_with_report(
            self.registry.manifests["manifest_create_view_basic_positive"]
        )
        self.assertEqual(
            set(linear_cases[0].consumed_dimension_ids),
            set(linear_cases[0].params),
        )
        self.assertEqual(
            linear_cases[0].to_dict()["consumed_dimension_ids"],
            linear_cases[0].consumed_dimension_ids,
        )

    def test_fixture_contract_rejects_conflicting_same_name_tables(self):
        fixture_id = "fixture_create_view_source_two_ints"
        fixture = self.registry.fixtures[fixture_id]
        table = fixture.provides.tables[0]
        conflicting_table = table.model_copy(update={"columns": [table.columns[0]]})
        conflicting_provides = fixture.provides.model_copy(
            update={"tables": [conflicting_table]}
        )
        conflicting_fixture = fixture.model_copy(update={
            "id": "fixture_conflicting_view_source",
            "provides": conflicting_provides,
        })
        self.registry.fixtures[conflicting_fixture.id] = conflicting_fixture

        with self.assertRaisesRegex(
            GenerationValidationError,
            "同名表 't_view_source'.*契约冲突",
        ):
            self.generator._compile_fixture_lifecycle(
                [fixture_id, conflicting_fixture.id]
            )

    def test_fixture_columns_are_scoped_to_the_profile_source_tables(self):
        fixture_id = "fixture_create_view_source_two_ints"
        fixture = self.registry.fixtures[fixture_id]
        source_table = fixture.provides.tables[0]
        source_without_col_2 = source_table.model_copy(
            update={"columns": [source_table.columns[0]]}
        )
        self.registry.fixtures[fixture_id] = fixture.model_copy(update={
            "provides": fixture.provides.model_copy(
                update={"tables": [source_without_col_2]}
            )
        })

        unrelated_table = source_table.model_copy(update={
            "name": "t_unrelated",
            "columns": [source_table.columns[1]],
        })
        unrelated_fixture = fixture.model_copy(update={
            "id": "fixture_unrelated_col_2",
            "provides": fixture.provides.model_copy(
                update={"tables": [unrelated_table]}
            ),
        })
        self.registry.fixtures[unrelated_fixture.id] = unrelated_fixture

        manifest = self.registry.get_manifest("manifest_create_view_basic_positive")
        self.registry.manifests[manifest.id] = manifest.model_copy(update={
            "fixture_refs": [fixture_id, unrelated_fixture.id]
        })
        with self.assertRaisesRegex(
            GenerationValidationError,
            "表 't_view_source'.*不存在的列.*col_2",
        ):
            self.generator.generate_with_report(self.registry.manifests[manifest.id])

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

    def test_multitable_fixture_columns_must_exist_on_the_declared_table(self):
        fixture_id = "fixture_select_source"
        fixture = self.registry.fixtures[fixture_id]
        table = fixture.provides.tables[0]
        table_without_col_1 = table.model_copy(update={
            "columns": [column for column in table.columns if column.name != "col_1"]
        })
        self.registry.fixtures[fixture_id] = fixture.model_copy(update={
            "provides": fixture.provides.model_copy(
                update={"tables": [table_without_col_1]}
            )
        })

        resolved = self.registry.resolve_dimension_values("select")
        with self.assertRaisesRegex(
            GenerationValidationError,
            "t_select_source.*不存在的列.*col_1",
        ):
            self.generator._validate_fixture_contract(
                {"query_profile": "select_inner_join"},
                resolved,
                ["fixture_select_source", "fixture_select_right_source"],
                {"query_profile"},
            )

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
        self.assertEqual(
            [case.sql for case in table_cases],
            [
                "TABLE t_select_source;",
                "TABLE ONLY t_select_source;",
                "TABLE ONLY (t_select_source);",
                "TABLE t_select_source *;",
            ],
        )

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

    def test_select_set_contract_requires_exact_types_and_right_source(self):
        factor = self.registry.factors["select"]

        def set_combo():
            combo = {
                dimension_id: dimension.default_value_id
                for dimension_id, dimension in factor.dimensions.items()
            }
            combo.update({
                "statement_form": "select_statement_ast",
                "source_form": "select_source_table",
                "target_list": "select_target_col1",
                "set_operator": "select_set_union",
                "right_target_list": "select_right_target_col1",
            })
            return combo

        numeric_resolved = self.registry.resolve_dimension_values("select")
        numeric_resolved["right_target_list"][
            "select_right_target_col1"
        ].attributes["right_target_list.properties.output_types"] = ["NUMERIC"]
        with self.assertRaisesRegex(GenerationValidationError, "类型不兼容"):
            self.generator._validate_structural_contract(
                factor, set_combo(), numeric_resolved
            )

        text_resolved = self.registry.resolve_dimension_values("select")
        text_resolved["target_list"][
            "select_target_col1"
        ].attributes["target_list.properties.output_types"] = ["VARCHAR"]
        text_resolved["right_target_list"][
            "select_right_target_col1"
        ].attributes["right_target_list.properties.output_types"] = ["TEXT"]
        with self.assertRaisesRegex(GenerationValidationError, "类型不兼容"):
            self.generator._validate_structural_contract(
                factor, set_combo(), text_resolved
            )

        drifted_contract = self.registry.resolve_dimension_values("select")
        drifted_contract["right_target_list"][
            "select_right_target_col1"
        ].attributes[
            "right_target_list.properties.source_columns_by_table"
        ] = {"t_select_right": ["col_2"]}
        with self.assertRaisesRegex(
            GenerationValidationError,
            "source_columns_by_table.*source_columns 不一致",
        ):
            self.generator._validate_fixture_contract(
                set_combo(),
                drifted_contract,
                ["fixture_select_source", "fixture_select_right_source"],
                {"source_form", "right_target_list"},
            )

        fixture_id = "fixture_select_right_source"
        fixture = self.registry.fixtures[fixture_id]
        right_table = fixture.provides.tables[0]
        without_col_1 = right_table.model_copy(update={
            "columns": [
                column for column in right_table.columns
                if column.name != "col_1"
            ]
        })
        self.registry.fixtures[fixture_id] = fixture.model_copy(update={
            "provides": fixture.provides.model_copy(
                update={"tables": [without_col_1]}
            )
        })
        with self.assertRaisesRegex(
            GenerationValidationError,
            "t_select_right.*不存在的列.*col_1",
        ):
            self.generator._validate_fixture_contract(
                set_combo(),
                self.registry.resolve_dimension_values("select"),
                ["fixture_select_source", fixture_id],
                {"source_form", "right_target_list"},
            )

    def test_select_environment_manifests_are_truthfully_gated(self):
        pivot_manifest = self.registry.manifests[
            "manifest_select_pivot_xml_negative"
        ]
        self.assertEqual(
            [requirement.model_dump() for requirement in pivot_manifest.environment_requirements],
            [{
                "key": "compatibility_mode",
                "allowed_values": ["A"],
                "fact_refs": ["select_fact_pivot"],
            }],
        )
        pivot_cases, _ = self.generator.generate_with_report(pivot_manifest)
        self.assertTrue(all(
            case.environment_requirements
            == [{
                "key": "compatibility_mode",
                "allowed_values": ["A"],
                "fact_refs": ["select_fact_pivot"],
            }]
            for case in pivot_cases
        ))

        heterogeneous = self.registry.manifests[
            "manifest_select_environment_positive"
        ]
        self.assertEqual(heterogeneous.expected.scope, "syntax_only")
        self.assertEqual(heterogeneous.status, "needs_review")
        self.assertEqual(heterogeneous.environment_requirements, [])

    def test_fixture_lifecycle_and_unverified_negative_oracles_are_explicit(self):
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
            cases, _ = self.generator.generate_with_report(manifest)
            self.assertTrue(all(case.expected_error_category for case in cases))
            if manifest.expected.oracle_status == "confirmed":
                self.assertTrue(manifest.expected.fact_refs)
                self.assertTrue(
                    manifest.expected.sqlstates
                    or manifest.expected.error_message_regex
                )
                self.assertTrue(all(
                    case.expected_sqlstates or case.expected_error_regex
                    for case in cases
                ))
            else:
                self.assertEqual(manifest.status, "needs_review")
                self.assertEqual(manifest.expected.sqlstates, [])
                self.assertIsNone(manifest.expected.error_message_regex)
                self.assertTrue(all(
                    case.expected_oracle_status == "needs_verification"
                    and not case.expected_sqlstates
                    and not case.expected_error_regex
                    for case in cases
                ))

    def test_select_adaptation_audit_and_generation(self):
        audit = FactorCoverageAuditor(self.registry).audit("select")
        self.assertEqual(audit["source_units"]["accounted"], 373)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 2333,
            "covered_by_units": 2333,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 14)
        self.assertEqual(audit["values"]["valid_total"], 104)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(audit["values"]["coverage_gaps"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 110)
        self.assertFalse(audit["manifests"]["profile_enumeration_only"])
        self.assertEqual(audit["documented_features"]["covered"], 20)
        self.assertEqual(audit["documented_features"]["represented"], 25)
        self.assertEqual(
            audit["documented_features"]["needs_profile"],
            [
                "alias_reference_full_expression_matrix",
                "cte_data_modifying_body",
                "dense_rank",
                "from_function_contract",
                "full_group_mode_matrix",
                "into_outfile_dumpfile",
                "into_user_variable",
                "legacy_outer_join_full_matrix",
                "order_expression_equivalence",
                "plan_hint_full_grammar",
                "set_operations_recursive_ast_matrix",
                "xmltable_full_compatibility_matrix",
            ],
        )
        self.assertEqual(len(audit["documented_features"]["coverage_gaps"]), 17)
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
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
        self.assertEqual(len(cases), 110)
        self.assertEqual(len({case.case_id for case in cases}), 110)
        self.assertEqual(sum(case.expected == "success" for case in cases), 104)
        self.assertEqual(sum(case.expected == "error" for case in cases), 6)
        self.assertTrue(all(
            case.sql.startswith(("SELECT ", "WITH ", "TABLE ")) for case in cases
        ))

    def test_insert_source_audit_and_generation_quality(self):
        audit = FactorCoverageAuditor(self.registry).audit("insert")
        self.assertEqual(audit["source_units"]["total"], 245)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 918,
            "covered_by_units": 918,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 7)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(len(audit["values"]["coverage_gaps"]), 4)
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 98)
        self.assertEqual(
            audit["documented_features"]["needs_profile"],
            [
                "insert_feature_complex_column_designator",
                "insert_feature_dblink_target",
                "insert_feature_ignore_modifier",
                "insert_feature_ignore_object_matrix",
                "insert_feature_on_conflict",
                "insert_feature_plan_hint",
                "insert_feature_subpartition_target",
            ],
        )
        self.assertEqual(audit["documented_features"]["covered"], 17)
        self.assertEqual(audit["documented_features"]["represented"], 20)
        self.assertEqual(len(audit["documented_features"]["coverage_gaps"]), 10)
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertFalse(audit["conclusions"]["generation_model_complete"])
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
        self.assertEqual(len(cases), 98)
        self.assertEqual(len({case.case_id for case in cases}), 98)
        self.assertEqual(sum(case.expected == "success" for case in cases), 87)
        self.assertEqual(sum(case.expected == "error" for case in cases), 11)
        self.assertTrue(all(case.sql.endswith(";") for case in cases))
        self.assertTrue(all(
            case.sql.startswith(("INSERT ", "WITH ")) for case in cases
        ))
        self.assertTrue(all(case.setup_sqls for case in cases))

        for manifest_id in (
            "manifest_insert_conflict_view_negative",
            "manifest_insert_conflict_query_negative",
            "manifest_insert_ignore_view_negative",
        ):
            self.assertTrue(
                self.registry.manifests[manifest_id].environment_requirements,
                manifest_id,
            )

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
        self.assertEqual(audit["source_units"]["total"], 209)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 899,
            "covered_by_units": 899,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 9)
        self.assertEqual(audit["values"]["valid_unselected"], [])
        self.assertEqual(
            audit["values"]["coverage_gaps"],
            [
                "comment_clause.ci_comment_basic",
                "storage_profile.ci_active_pages_manual",
                "storage_profile.ci_enable_tde_on",
                "storage_profile.ci_fastupdate_off_ugin",
                "storage_profile.ci_gin_pending_63",
                "table_profile.ci_table_subpartitioned",
                "visibility_clause.ci_visibility_invisible",
                "visibility_clause.ci_visibility_visible",
            ],
        )
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 335)
        self.assertEqual(audit["documented_features"]["needs_profile"], [
            "ci_feature_active_pages_execution_profile",
            "ci_feature_deduplication_full_domain",
            "ci_feature_fastupdate_full_domain",
            "ci_feature_gin_key_full_domain",
            "ci_feature_gist_buffering_full_domain",
            "ci_feature_gist_key_full_domain",
            "ci_feature_ilm_full_domain",
            "ci_feature_index_txntype_full_domain",
            "ci_feature_indexsplit_full_domain",
            "ci_feature_lpi_full_domain",
            "ci_feature_prefix_length_boundaries",
            "ci_feature_sort_and_nulls_full_domain",
            "ci_feature_stat_state_full_domain",
            "ci_feature_subpartition_table",
            "ci_feature_tde_environment_profile",
            "ci_feature_ugin_key_full_domain",
        ])
        self.assertEqual(audit["documented_features"]["covered"], 16)
        self.assertEqual(audit["documented_features"]["represented"], 35)
        self.assertEqual(len(audit["documented_features"]["coverage_gaps"]), 35)
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertFalse(audit["conclusions"]["generation_model_complete"])
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
        self.assertEqual(len(cases), 335)
        self.assertEqual(len({case.case_id for case in cases}), 335)
        self.assertEqual(sum(case.expected == "success" for case in cases), 307)
        self.assertEqual(sum(case.expected == "error" for case in cases), 28)
        self.assertTrue(all(case.sql.startswith("CREATE ") for case in cases))
        self.assertTrue(all(" INDEX " in case.sql for case in cases))
        self.assertTrue(all(case.sql.endswith(";") for case in cases))
        all_sql = "\n".join(case.sql.lower() for case in cases)
        for method in ("btree", "ubtree", "ugin", "gin", "gist"):
            self.assertIn(f"using {method}", all_sql)
        self.assertTrue(all(case.setup_sqls for case in cases))
        resolved = self.registry.resolve_dimension_values("create_index")
        self.assertFalse(any(
            case.params.get("unique_modifier") == "ci_unique"
            and case.params.get("scope_clause") in {
                "ci_scope_local", "ci_scope_local_named",
            }
            and not resolved["key_profile"][
                case.params["key_profile"]
            ].attributes.get("key_profile.properties.contains_partition_key", False)
            for case in cases
            if case.case_id.startswith("manifest_create_index_partition_positive_")
        ))

    def test_create_index_contract_rejects_include_overlap_and_key_limits(self):
        factor = self.registry.factors["create_index"]
        self.assertIn(
            "index_column_count_contract",
            {check.kind for check in factor.structural_checks},
        )
        resolved = self.registry.resolve_dimension_values("create_index")
        overlap = {
            "key_profile": "ci_key_id_note",
            "include_profile": "ci_include_note",
            "table_profile": "ci_table_astore_regular",
            "scope_clause": "ci_scope_none",
            "concurrently": "ci_concurrently_none",
        }
        with self.assertRaisesRegex(GenerationValidationError, "INCLUDE 必须是非键列"):
            self.generator._validate_structural_contract(factor, overlap, resolved)

        key_matrix = self.registry.matrices["matrix_create_index_key_profiles"]
        key_profile = next(item for item in key_matrix.profiles if item.id == "ci_key_id")
        key_profile.properties["items"] = [f"id + {index}" for index in range(32)]
        key_profile.properties["key_column_count"] = 32
        resolved = self.registry.resolve_dimension_values("create_index")
        regular_with_include = {
            "key_profile": "ci_key_id",
            "include_profile": "ci_include_note",
            "table_profile": "ci_table_astore_regular",
            "scope_clause": "ci_scope_none",
        }
        self.generator._validate_structural_contract(
            factor, regular_with_include, resolved
        )

        global_too_wide = dict(regular_with_include)
        global_too_wide.update({
            "include_profile": "ci_include_none",
            "table_profile": "ci_table_astore_partitioned",
            "scope_clause": "ci_scope_global",
        })
        with self.assertRaisesRegex(GenerationValidationError, "键列数 32.*上限 31"):
            self.generator._validate_structural_contract(
                factor, global_too_wide, resolved
            )

        implicit_global_too_wide = dict(global_too_wide)
        implicit_global_too_wide.update({
            "scope_clause": "ci_scope_none",
            "unique_modifier": "ci_unique_none",
        })
        with self.assertRaisesRegex(GenerationValidationError, "键列数 32.*上限 31"):
            self.generator._validate_structural_contract(
                factor, implicit_global_too_wide, resolved
            )

        implicit_local_at_limit = dict(implicit_global_too_wide)
        implicit_local_at_limit["unique_modifier"] = "ci_unique"
        self.generator._validate_structural_contract(
            factor, implicit_local_at_limit, resolved
        )

        key_profile.properties["items"].append("id + 32")
        key_profile.properties["key_column_count"] = 33
        resolved = self.registry.resolve_dimension_values("create_index")
        with self.assertRaisesRegex(GenerationValidationError, "键列数 33.*上限 32"):
            self.generator._validate_structural_contract(
                factor, regular_with_include, resolved
            )

    def test_create_index_ugin_ilm_capability_is_not_guessed(self):
        factor = self.registry.factors["create_index"]
        resolved = self.registry.resolve_dimension_values("create_index")
        method = resolved["method"]["ci_method_ugin"]
        self.assertEqual(
            method.attributes["method.properties.compression_supported"],
            "unknown",
        )
        self.assertIn(
            "ci_open_ugin_ilm_compression_support",
            {fact.id for fact in factor.facts if fact.type == "open_question"},
        )

        rule = next(
            item for item in factor.rules if item.id == "ci_rule_ilm_method_supported"
        )
        solver = ConstraintSolver([rule.expression])
        for method_id, expected in (("ci_method_ugin", True), ("ci_method_gin", False)):
            combo = {
                "method": method_id,
                "ilm_clause": "ci_ilm_turbo_high",
            }
            enriched = dict(combo)
            for dimension_id, value_id in combo.items():
                enriched.update(resolved[dimension_id][value_id].attributes)
            self.assertEqual(solver.is_valid(enriched)[0], expected)

    def test_alter_table_source_audit_and_generation_quality(self):
        audit = FactorCoverageAuditor(self.registry).audit("alter_table")
        self.assertEqual(audit["source_units"]["total"], 209)
        self.assertEqual(audit["source_units"]["line_coverage"], {
            "total": 1636,
            "covered_by_units": 1636,
            "ignored": 0,
            "missing": [],
        })
        self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [])
        self.assertEqual(audit["facts"]["unledgered"], [])
        self.assertEqual(audit["facts"]["unconsumed_confirmed"], [])
        self.assertEqual(len(audit["facts"]["unresolved_open_questions"]), 19)
        self.assertEqual(
            audit["values"]["valid_unselected"],
            ["modify_column_items.at_modify_columns_two"],
        )
        self.assertEqual(len(audit["values"]["coverage_gaps"]), 14)
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["manifests"]["generated_case_count"], 277)
        self.assertEqual(audit["documented_features"]["needs_profile"], [
            "at_feature_a_rowid",
            "at_feature_b_actions",
            "at_feature_b_compatibility",
            "at_feature_colview",
            "at_feature_cross_chapter_index_method",
            "at_feature_encrypted_column",
            "at_feature_external_table",
            "at_feature_foreign_key_and_deferrable",
            "at_feature_generated_column",
            "at_feature_ilm",
            "at_feature_inheritance_scope_behavior",
            "at_feature_internal_distribution",
            "at_feature_m_action_variant",
            "at_feature_m_compatibility",
            "at_feature_online_alter_type_using",
            "at_feature_owner",
            "at_feature_subpartition",
            "at_feature_tablespace",
            "at_feature_tde_rotation",
            "at_feature_tde_table",
            "at_feature_triggers",
        ])
        self.assertEqual(audit["documented_features"]["covered"], 15)
        self.assertEqual(audit["documented_features"]["represented"], 17)
        self.assertEqual(len(audit["documented_features"]["coverage_gaps"]), 23)
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertFalse(audit["conclusions"]["generation_model_complete"])
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
        self.assertEqual(len(cases), 277)
        self.assertEqual(len({case.case_id for case in cases}), 277)
        self.assertEqual(sum(case.expected == "success" for case in cases), 266)
        self.assertEqual(sum(case.expected == "error" for case in cases), 11)
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
