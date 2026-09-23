"""PDF-backed settings contracts; no database or session configuration changes."""
import hashlib
import itertools
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry


ROOT = Path(__file__).resolve().parents[1]
LINES = {"show": 73, "set": 200, "reset": 59}


def pairs(rows):
    return {pair for row in rows for pair in itertools.combinations(sorted(row.items()), 2)}


class Batch04SettingsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.results = {
            mid: cls.generator.generate_with_report(cls.registry.manifests[mid])
            for fid in LINES for mid in cls.registry.factors[fid].manifest_refs
        }

    def cases(self, fid, suite):
        return self.results[f"manifest_{fid}_{suite}"][0]

    def value(self, fid, dim, vid):
        return next(v for eq in self.registry.factors[fid].dimensions[dim].classes
                    for v in eq.values if v.id == vid)

    def test_source_hash_lines_atomicity_and_honest_status(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, lines in LINES.items():
            with self.subTest(factor=fid):
                factor = self.registry.factors[fid]
                report = auditor.audit(fid)
                self.assertEqual(factor.status, "needs_review")
                self.assertEqual(report["source_units"]["line_coverage"]["total"], lines)
                self.assertEqual(report["source_units"]["atomicity"]["gaps"], [])
                self.assertEqual(report["facts"]["unconsumed_confirmed"], [])
                self.assertEqual(report["facts"]["wrong_consumer_type"], [])
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertTrue(report["conclusions"]["static_coverage_complete"])
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                source = ROOT / "work/doc2spec/batches/batch_04/corpus" / factor.source.catalog_chapter_ref.source_relpath
                if source.exists():
                    self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), factor.source.artifact_sha256)

    def test_cases_are_unique_static_candidates_without_raw_bnf(self):
        cases = [c for batch, _ in self.results.values() for c in batch]
        self.assertEqual(len(cases), 89)
        self.assertEqual(len({c.case_id for c in cases}), len(cases))
        self.assertEqual(len({(c.factor_id, c.sql) for c in cases}), len(cases))
        for batch, report in self.results.values():
            self.assertTrue(batch)
            self.assertFalse(report.missing_pairs)
            for case in batch:
                self.assertNotRegex(case.sql, r"\{|\}|\[|\]|\.\.\.")
                self.assertTrue(case.sql.endswith(";"))
                if case.expected == "success":
                    self.assertEqual(case.expected_scope, "syntax_only")

    def test_show_branches_do_not_leak_default_slots(self):
        sqls = {c.sql for mid, (cases, _) in self.results.items()
                if mid.startswith("manifest_show_") for c in cases}
        self.assertEqual(sqls, {
            "SHOW timezone;", "SHOW max_datanodes;", "SHOW VARIABLES LIKE var;",
            "SHOW CURRENT_SCHEMA;", "SHOW TIME ZONE;", "SHOW TRANSACTION ISOLATION LEVEL;",
            "SHOW SESSION AUTHORIZATION;", "SHOW ALL;",
        })
        for mid, (cases, _) in self.results.items():
            if mid.startswith("manifest_show_"):
                for c in cases:
                    self.assertEqual(c.setup_sqls + c.teardown_sqls, [])

    def test_set_branch_shapes_and_scope(self):
        forms = {c.params["form"] for mid, (cases, _) in self.results.items()
                 if mid.startswith("manifest_set_") for c in cases}
        self.assertEqual(len(forms), 9)
        for case in self.cases("set", "from_current"):
            self.assertRegex(case.sql, r"^SET (?:SESSION |LOCAL )?(client_encoding|datestyle|search_path) FROM CURRENT;$")
            self.assertNotIn(" TO ", case.sql)
            self.assertNotIn(" = ", case.sql)
        for c in self.cases("set", "schema"):
            self.assertRegex(c.sql, r" SCHEMA '(?:fp_cs_one|public)';$")
        for c in self.cases("set", "current_schema"):
            self.assertRegex(c.sql, r" CURRENT_SCHEMA (?:TO|=) (?:fp_cs_one|DEFAULT);$")
        self.assertTrue(any(c.sql == "SET SESSION XML OPTION CONTENT;" for c in self.cases("set", "xml")))

    def test_generic_rhs_contract_is_selection_not_invented_product_error(self):
        factor = self.registry.factors["set"]
        self.assertNotIn("set_rule_rhs_matches", {r.id for r in factor.rules})
        manifest = self.registry.manifests["manifest_set_generic"]
        self.assertEqual(len(manifest.local_rules), 1)
        allowed = {
            "client_encoding": {"utf8", "DEFAULT"},
            "datestyle": {"postgres, dmy", "DEFAULT"},
            "search_path": {"fp_cs_one, public", "DEFAULT"},
        }
        for case in self.cases("set", "generic"):
            parameter = self.value("set", "parameter", case.params["parameter"]).render
            rhs = self.value("set", "rhs", case.params["rhs"]).render
            self.assertIn(rhs, allowed[parameter])

    def test_pairs_recomputed_without_generator_solver(self):
        # Recompute from the manifest, not from reported feasible_pair_count.
        for suite in ["generic", "current_schema", "b_expression", "timezone", "timezone_b"]:
            manifest = self.registry.manifests[f"manifest_set_{suite}"]
            keys = sorted(manifest.bindings)
            feasible = []
            for row in itertools.product(*(manifest.bindings[k] for k in keys)):
                combo = dict(zip(keys, row))
                if suite == "generic" and combo["rhs"] != "set_rhs_default":
                    # Independent ID mapping, not the stored .properties flags.
                    if combo["rhs"].removeprefix("set_rhs_") != combo["parameter"].removeprefix("set_parameter_"):
                        continue
                feasible.append(combo)
            selected = [{k: c.params[k] for k in keys} for c in self.cases("set", suite)]
            self.assertEqual(pairs(feasible), pairs(selected), suite)
            if suite == "generic":
                self.assertEqual(len(feasible), 36)
                self.assertEqual(len(selected), 12)

    def test_all_mutating_candidates_have_transaction_cleanup_and_session_gate(self):
        for cases, _ in self.results.values():
            for case in cases:
                if case.factor_id == "show":
                    continue
                self.assertIn("BEGIN;", case.setup_sqls)
                self.assertIn("ROLLBACK;", case.teardown_sqls)
                self.assertTrue(any(g["key"] == "session_ownership" and
                                    g["allowed_values"] == ["exclusive_test_connection"]
                                    for g in case.environment_requirements))
                self.assertFalse(any(sql.startswith("RESET ") for sql in case.teardown_sqls))
                joined = "\n".join(case.setup_sqls + [case.sql] + case.teardown_sqls)
                self.assertNotRegex(joined, r"\b(?:CREATE|DROP) (?:DATABASE|ROLE|USER|TABLESPACE)\b|DROP OWNED|EXCEPTION WHEN|SET GLOBAL")

    def test_fixture_dag_rolls_back_before_dropping_provider_schemas(self):
        graph = self.registry.factor_dependency_graph()
        self.assertEqual(graph["show"], set())
        self.assertEqual(graph["set"], {"create_schema"})
        self.assertEqual(graph["reset"], {"set"})
        case = self.cases("set", "schema")[0]
        self.assertLess(case.setup_sqls.index("CREATE SCHEMA fp_cs_one;"), case.setup_sqls.index("BEGIN;"))
        self.assertLess(case.teardown_sqls.index("ROLLBACK;"),
                        case.teardown_sqls.index("DROP SCHEMA IF EXISTS fp_cs_one CASCADE;"))
        order = self.registry.fixture_topological_order(["fixture_reset_changed_timezone"])
        self.assertLess(order.index("fixture_set_transaction"), order.index("fixture_reset_changed_timezone"))

    def test_reset_target_shape_and_not_restore_previous_confusion(self):
        sqls = {c.sql for c in self.cases("reset", "targets")}
        self.assertEqual(sqls, {
            "RESET timezone;", "RESET CURRENT_SCHEMA;", "RESET TIME ZONE;",
            "RESET TRANSACTION ISOLATION LEVEL;", "RESET SESSION AUTHORIZATION;", "RESET ALL;",
        })
        for case in self.cases("reset", "targets"):
            self.assertLess(case.setup_sqls.index("BEGIN;"), case.setup_sqls.index("SET timezone TO 'Europe/Rome';"))
        scenario = self.registry.scenarios["scenario_reset_rollback"]
        self.assertIn("set::set_fact_session_rollback", scenario.fact_refs)
        self.assertEqual(scenario.oracles, [{"after_step": "after", "kind": "result_equals_step", "expected": "before"}])
        self.assertEqual(next(s["sql"] for s in scenario.steps if s["id"] == "rollback"), "ROLLBACK;")

    def test_document_examples_are_not_fixed_environment_oracles(self):
        for fid in ["show", "reset"]:
            for sid in self.registry.factors[fid].scenario_refs:
                scenario = self.registry.scenarios[sid]
                self.assertEqual(scenario.status, "planned")
                for oracle in scenario.oracles:
                    self.assertNotIn("PRC", str(oracle))
                    self.assertNotIn("omm1", str(oracle))

    def test_storage_effects_have_separate_source_facts(self):
        factor = self.registry.factors["set"]
        facts = {f.id for f in factor.facts}
        self.assertTrue({"set_fact_user_int", "set_fact_user_float", "set_fact_user_bit",
                         "set_fact_user_other", "set_fact_user_null", "set_fact_user_text"} <= facts)
        ledger = self.registry.source_ledgers[factor.source_ledger_ref]
        unit = next(u for u in ledger.units if u.id == "set_su_b_names_effect_73")
        self.assertEqual(unit.atomicity, "grouped")
        self.assertEqual(unit.independent_claim_count, 4)
        self.assertEqual(len(set(unit.fact_refs)), 4)


if __name__ == "__main__":
    unittest.main()
