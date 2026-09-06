"""PDF-derived batch 03 contracts; no database calls."""
import hashlib
import itertools
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from scripts.generate_factor_package_sql import render_sql_snapshot


ROOT = Path(__file__).resolve().parents[1]
NEW_LINES = {
    "abort": 67, "start_transaction": 95, "savepoint": 73,
    "release_savepoint": 75, "rollback_to_savepoint": 70,
    "set_transaction": 81, "drop_view": 57, "drop_sequence": 43,
    "drop_index": 83,
}


def pairs(combinations):
    return {pair for combo in combinations
            for pair in itertools.combinations(sorted(combo.items()), 2)}


class Batch03PackageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.generated = {}
        for factor_id in NEW_LINES:
            for manifest_id in cls.registry.factors[factor_id].manifest_refs:
                cls.generated[manifest_id] = cls.generator.generate_with_report(
                    cls.registry.manifests[manifest_id])

    def cases(self, factor, suffix):
        return self.generated[f"manifest_{factor}_{suffix}"][0]

    def test_pdf_provenance_and_atomic_source_coverage(self):
        auditor = FactorCoverageAuditor(self.registry)
        for factor_id, line_count in NEW_LINES.items():
            with self.subTest(factor=factor_id):
                factor = self.registry.factors[factor_id]
                ledger = self.registry.source_ledgers[factor.source_ledger_ref]
                self.assertEqual(ledger.source_line_count, line_count)
                report = auditor.audit(factor_id)
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                self.assertEqual(factor.status, "needs_review")
                local_source = ROOT / "work/doc2spec/batches/batch_03/corpus" / factor.source.catalog_chapter_ref.source_relpath
                if local_source.exists():
                    self.assertEqual(hashlib.sha256(local_source.read_bytes()).hexdigest(), factor.source.artifact_sha256)

    def test_unique_ids_consumed_dimensions_and_finite_pair_coverage(self):
        all_ids = []
        for manifest_id, (cases, report) in self.generated.items():
            with self.subTest(manifest=manifest_id):
                self.assertTrue(cases)
                self.assertFalse(report.missing_pairs)
                all_ids.extend(c.case_id for c in cases)
                for case in cases:
                    self.assertEqual(set(case.params), set(case.consumed_dimension_ids))
                    self.assertNotRegex(case.sql, r"\{|\}|\.\.\.|\[|\]")
        self.assertEqual(len(all_ids), len(set(all_ids)))

    def test_abort_three_aliases_and_transaction_fixture_order(self):
        cases = self.cases("abort", "positive")
        self.assertEqual({c.sql for c in cases}, {"ABORT;", "ABORT WORK;", "ABORT TRANSACTION;"})
        setup = "\n".join(cases[0].setup_sqls)
        self.assertLess(setup.index("CREATE TABLE"), setup.index("BEGIN"))
        self.assertLess(setup.index("BEGIN"), setup.index("UPDATE"))
        self.assertTrue(cases[0].teardown_sqls[0].startswith("ROLLBACK"))

    def test_start_transaction_forms_and_optional_repeat(self):
        cases = self.cases("start_transaction", "forms")
        self.assertEqual(len(cases), 4 * 23)
        sqls = {c.sql for c in cases}
        self.assertTrue({"START TRANSACTION;", "BEGIN;", "BEGIN WORK;", "BEGIN TRANSACTION;"} <= sqls)
        self.assertIn("START TRANSACTION ISOLATION LEVEL READ COMMITTED, READ ONLY;", sqls)
        self.assertIn("START TRANSACTION READ ONLY, ISOLATION LEVEL READ COMMITTED;", sqls)
        self.assertFalse(any(s.endswith(",;") for s in sqls))

    def test_savepoint_fixture_dependency_order(self):
        case = self.cases("release_savepoint", "positive")[0]
        setup = "\n".join(case.setup_sqls)
        self.assertLess(setup.index("START TRANSACTION"), setup.index("SAVEPOINT sp_test"))
        order = self.registry.fixture_topological_order(["fixture_savepoint_defined"])
        self.assertLess(order.index("fixture_start_transaction_active_connection"), order.index("fixture_savepoint_defined"))

    def test_rollback_to_all_keyword_forms(self):
        sqls = {c.sql for c in self.cases("rollback_to_savepoint", "positive")}
        self.assertEqual(sqls, {
            " ".join(x for x in ["ROLLBACK", compatibility, "TO", keyword, "sp_test;"] if x)
            for compatibility in ["", "WORK", "TRANSACTION"] for keyword in ["", "SAVEPOINT"]
        })

    def test_set_transaction_scope_gates_and_single_characteristic(self):
        for suffix in ["current", "session_b", "global_b", "session_characteristics"]:
            cases = self.cases("set_transaction", suffix)
            for c in cases:
                self.assertFalse("ISOLATION LEVEL" in c.sql and ("READ ONLY" in c.sql or "READ WRITE" in c.sql))
                if suffix in {"session_b", "global_b"}:
                    gates = {r["key"]: r["allowed_values"] for r in c.environment_requirements}
                    self.assertEqual(gates["compatibility_mode"], ["B"])
                    self.assertIn("-- environment_requirements:", render_sql_snapshot("test", [c]))
                    if suffix == "session_b":
                        self.assertEqual(gates["b_format_behavior_compat_options"], ["set_session_transaction"])

    def test_drop_index_pairs_independently_recomputed(self):
        factor = self.registry.factors["drop_index"]
        values = {name: [v.id for c in dim.classes for v in c.values] for name, dim in factor.dimensions.items()}
        feasible = []
        for row in itertools.product(*(values[k] for k in sorted(values))):
            c = dict(zip(sorted(values), row))
            online = c["concurrently"].endswith("_present")
            if online and (c["targets"].endswith("_two") or c["behavior"].endswith("_cascade")):
                continue
            if c["targets"].endswith("_missing") and c["if_exists"].endswith("_absent"):
                continue
            feasible.append(c)
        produced = [c.params for suffix in ["ordinary", "online"] for c in self.cases("drop_index", suffix)]
        self.assertEqual(pairs(feasible), pairs(produced))
        for c in self.cases("drop_index", "online"):
            self.assertTrue(c.sql.startswith("DROP INDEX CONCURRENTLY "))
            self.assertNotIn(",", c.sql)
            self.assertNotIn("CASCADE", c.sql)
            self.assertFalse(any(s.startswith(("BEGIN", "START TRANSACTION")) for s in c.setup_sqls))
            self.assertIn("autocommit", c.environment_requirements[0]["allowed_values"])

    def test_drop_view_cascade_depends_on_existing_view_fixture(self):
        dependent = [c for c in self.cases("drop_view", "positive") if c.params["targets"].endswith("_dependent")]
        self.assertTrue(dependent)
        for c in dependent:
            self.assertTrue(c.sql.endswith("CASCADE;"))
            setup = "\n".join(c.setup_sqls)
            self.assertLess(setup.index("CREATE TABLE t_view_source"), setup.index("CREATE VIEW v_dv_base"))
            self.assertLess(setup.index("CREATE VIEW v_dv_base"), setup.index("CREATE VIEW v_dv_child"))

    def test_sequence_large_and_qualified_targets(self):
        for c in self.cases("drop_sequence", "large"):
            self.assertTrue(c.sql.startswith("DROP LARGE SEQUENCE"))
        for c in self.cases("drop_sequence", "qualified"):
            self.assertIn("ds_batch03.seq_qualified", c.sql)
            self.assertIn("CREATE SCHEMA ds_batch03;", c.setup_sqls)
            self.assertEqual(c.teardown_sqls[-1], "DROP SCHEMA ds_batch03;")

    def test_negative_cases_never_claim_calibrated_errors(self):
        count = 0
        for mid, (cases, _) in self.generated.items():
            manifest = self.registry.manifests[mid]
            if manifest.suite_type != "negative":
                continue
            count += len(cases)
            self.assertEqual(len(manifest.violates_rule_refs), 1)
            self.assertEqual(manifest.status, "needs_review")
            for c in cases:
                self.assertEqual(c.expected, "error")
                self.assertEqual(c.expected_oracle_status, "needs_verification")
                self.assertFalse(c.expected_sqlstates)
                self.assertFalse(c.expected_error_regex)
        self.assertGreater(count, 0)


if __name__ == "__main__":
    unittest.main()
