"""PDF cursor extraction contracts, independently checked without a database."""
import hashlib
import itertools
import json
import re
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from scripts.prepare_batch_03 import validate_plan


ROOT = Path(__file__).resolve().parents[1]
LINES = {"declare": 115, "fetch": 143, "move": 70, "close": 35}


def pairs(rows):
    return {pair for row in rows for pair in itertools.combinations(sorted(row.items()), 2)}


class Batch04CursorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        generator = FactorPackageSQLGenerator(cls.registry)
        cls.results = {
            mid: generator.generate_with_report(cls.registry.manifests[mid])
            for fid in LINES for mid in cls.registry.factors[fid].manifest_refs
        }

    def cases(self, fid, suite):
        return self.results[f"manifest_{fid}_{suite}"][0]

    def value(self, fid, dim, vid):
        return next(v for c in self.registry.factors[fid].dimensions[dim].classes
                    for v in c.values if v.id == vid)

    def test_batch_plan_has_twenty_new_chapters_and_real_providers(self):
        plan = json.loads((ROOT / "tests/data/batch_04.json").read_text())
        validate_plan(plan)
        self.assertEqual(len(plan["new_chapters"]), 20)
        self.assertEqual(len(plan["existing_providers"]), 23)
        self.assertNotIn("TRUNCATE", plan["new_chapters"])
        self.assertIn("TRUNCATE", plan["existing_providers"])
        self.assertEqual(plan["extraction_dependencies"]["MOVE"], ["DECLARE", "FETCH"])
        self.assertNotIn("CLOSE", plan["extraction_dependencies"]["DECLARE"])
        self.assertFalse(plan["database_execution"])

    def test_source_ledger_and_truthful_incomplete_status(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, line_count in LINES.items():
            with self.subTest(factor=fid):
                factor = self.registry.factors[fid]
                report = auditor.audit(fid)
                self.assertEqual(report["source_units"]["line_coverage"]["total"], line_count)
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertFalse(report["conclusions"]["static_coverage_complete"])
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                path = ROOT / "work/doc2spec/batches/batch_04/corpus" / factor.source.catalog_chapter_ref.source_relpath
                if path.exists():
                    self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), factor.source.artifact_sha256)
                self.assertTrue(all(self.registry.scenarios[s].status == "planned" for s in factor.scenario_refs))

    def test_all_cases_nonempty_unique_and_pairs_complete(self):
        ids, sqls = [], []
        for mid, (cases, report) in self.results.items():
            self.assertTrue(cases, mid)
            self.assertFalse(report.missing_pairs, mid)
            for case in cases:
                ids.append(case.case_id)
                sqls.append((case.factor_id, case.sql))
                self.assertNotRegex(case.sql, r"\{|\}|\.\.\.|\[|\]")
                self.assertTrue(case.sql.endswith(";"))
        self.assertEqual(len(ids), len(set(ids)))
        self.assertEqual(len(sqls), len(set(sqls)))

    def test_declare_both_forms_and_no_invented_scroll_keyword(self):
        cursor = self.cases("declare", "cursor")
        self.assertTrue(any("BINARY" in c.sql for c in cursor))
        self.assertTrue(any("NO SCROLL" in c.sql for c in cursor))
        self.assertTrue(any("WITH HOLD" in c.sql for c in cursor))
        self.assertTrue(any("WITHOUT HOLD" in c.sql for c in cursor))
        self.assertTrue(any("FOR VALUES (1, 1), (2, 2)" in c.sql for c in cursor))
        for case in cursor:
            self.assertNotIn("SCROLL", case.sql.replace("NO SCROLL", ""))
            self.assertIn("BEGIN;", case.setup_sqls)
            self.assertIn("ROLLBACK;", case.teardown_sqls)
        self.assertEqual(self.cases("declare", "anonymous")[0].sql,
                         "DECLARE num INTEGER := 10; BEGIN dbe_output.print_line(num); END;")

    def test_fetch_and_move_connector_difference(self):
        for fid in ["fetch", "move"]:
            self.assertEqual({c.sql for c in self.cases(fid, "implicit")},
                             {f"{fid.upper()} c_cursor_auto;", f"{fid.upper()} c_cursor_no_scroll;"})
        fetch = self.cases("fetch", "forward")
        self.assertTrue(any(" FROM " in c.sql for c in fetch))
        self.assertTrue(any(" IN " in c.sql for c in fetch))
        self.assertTrue(all(re.search(r" (FROM|IN) c_cursor_", c.sql) for c in fetch))
        self.assertTrue(any(c.sql == "MOVE NEXT c_cursor_auto;" for c in self.cases("move", "forward")))

    def test_signed_count_flags_match_sql_integer(self):
        for fid in ["fetch", "move"]:
            dim = self.registry.factors[fid].dimensions["count"]
            for eq in dim.classes:
                for value in eq.values:
                    number = int(value.render)
                    self.assertEqual(value.properties["number"], number)
                    self.assertEqual(value.properties["positive"], number > 0)
                    self.assertEqual(value.properties["negative"], number < 0)
            for case in self.cases(fid, "signed_count"):
                number = int(self.value(fid, "count", case.params["count"]).render)
                self.assertRegex(case.sql, rf"(?:ABSOLUTE|RELATIVE|BACKWARD) {number} (?:FROM |IN )?c_cursor_auto;")
            for case in self.cases(fid, "forward_count"):
                self.assertGreaterEqual(int(self.value(fid, "count", case.params["count"]).render), 0)

    def test_feasible_pairs_independently_recomputed(self):
        # These suites choose only plan-gated ordinary cursors or nonnegative
        # forward counts, so every selected Cartesian row is feasible.
        for fid in ["fetch", "move"]:
            for suite in ["signed_count", "forward_count"]:
                manifest = self.registry.manifests[f"manifest_{fid}_{suite}"]
                keys = sorted(manifest.bindings)
                feasible = [dict(zip(keys, row)) for row in itertools.product(*(manifest.bindings[k] for k in keys))]
                selected = [{k: c.params[k] for k in keys} for c in self.cases(fid, suite)]
                self.assertEqual(pairs(feasible), pairs(selected), (fid, suite))

    def test_reverse_suites_are_environment_gated(self):
        for fid in ["fetch", "move"]:
            for suite in ["positioned", "signed_count", "negative_forward_count"]:
                for case in self.cases(fid, suite):
                    gates = {g["key"]: g["allowed_values"] for g in case.environment_requirements}
                    self.assertEqual(gates["cursor_reverse_supported"], ["true"])
                    self.assertNotIn("NO SCROLL", "\n".join(case.setup_sqls))
            for case in self.cases(fid, "no_scroll_negative"):
                self.assertIn("NO SCROLL", "\n".join(case.setup_sqls))
                self.assertRegex(case.sql, r" (PRIOR|BACKWARD(?: ALL)?) (?:FROM |IN )?c_cursor_no_scroll;")
                self.assertEqual(case.expected, "error")
                self.assertEqual(case.expected_oracle_status, "needs_verification")
                self.assertFalse(case.expected_sqlstates)
                self.assertFalse(case.expected_error_regex)

    def test_fixture_chain_seed_and_cleanup(self):
        case = self.cases("fetch", "forward")[0]
        setup = "\n".join(case.setup_sqls)
        self.assertLess(setup.index("CREATE TABLE t_cursor_source"), setup.index("BEGIN;"))
        self.assertLess(setup.index("BEGIN;"), setup.index("DECLARE c_cursor_"))
        rows = self.registry.fixtures["fixture_declare_source"].seed.rows
        self.assertEqual(rows, [{"col_1": n, "col_2": n} for n in range(1, 21)])
        cleanup = "\n".join(case.teardown_sqls)
        self.assertLess(cleanup.index("ROLLBACK;"), cleanup.index("DROP TABLE"))
        self.assertNotIn("CLOSE ALL;", cleanup)
        for cases, _ in self.results.values():
            for case in cases:
                for sql in case.setup_sqls + case.teardown_sqls:
                    self.assertNotRegex(sql, r"\b(?:CREATE|DROP) (?:DATABASE|USER|ROLE|TABLESPACE)\b")

    def test_move_consumes_exported_fetch_facts(self):
        factor = self.registry.factors["move"]
        self.assertIn("fetch::fetch_fact_no_scroll", factor.rules[0].fact_refs)
        scenario = self.registry.scenarios["scenario_move_zero_current"]
        self.assertIn("fetch::fetch_fact_zero", scenario.fact_refs)
        self.assertIn("fetch_fact_zero", self.registry.factors["fetch"].exported_fact_refs)
        self.assertEqual(next(o["expected"] for o in scenario.oracles if o["after_step"] == "zero"), "MOVE 1")

    def test_close_target_state_and_all_scope(self):
        all_case = self.cases("close", "all")[0]
        self.assertEqual(all_case.sql, "CLOSE ALL;")
        gates = {g["key"]: g["allowed_values"] for g in all_case.environment_requirements}
        self.assertEqual(gates["session_ownership"], ["exclusive_test_connection"])
        case = self.cases("close", "closed_negative")[0]
        self.assertIn("CLOSE c_close_closed;", case.setup_sqls)
        self.assertEqual(case.sql, "CLOSE c_close_closed;")
        self.assertEqual(case.expected_oracle_status, "needs_verification")

    def test_ambiguous_boundaries_and_diagrams_not_silently_resolved(self):
        facts = {f.id: f for f in self.registry.factors["fetch"].facts}
        for key in ["all_boundary", "diagram_optional"]:
            self.assertEqual(facts["fetch_fact_" + key].status, "needs_verification")
        self.assertTrue(any(f.id == "move_fact_diagram_optional" and f.status == "needs_verification"
                            for f in self.registry.factors["move"].facts))


if __name__ == "__main__":
    unittest.main()
