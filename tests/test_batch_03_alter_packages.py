"""PDF-derived ALTER cases: independent contracts, no database connection."""
import hashlib
import itertools
import re
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor


ROOT = Path(__file__).resolve().parents[1]
LINES = {"alter_view": 260, "alter_sequence": 105, "alter_index": 322}


def pair_set(rows):
    return {pair for row in rows
            for pair in itertools.combinations(sorted(row.items()), 2)}


class AlterBatchPackageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        generator = FactorPackageSQLGenerator(cls.registry)
        cls.generated = {
            mid: generator.generate_with_report(cls.registry.manifests[mid])
            for fid in LINES for mid in cls.registry.factors[fid].manifest_refs
        }

    def cases(self, factor, suffix):
        return self.generated[f"manifest_{factor}_{suffix}"][0]

    def value(self, factor, dimension, value_id):
        return next(v for c in self.registry.factors[factor].dimensions[dimension].classes
                    for v in c.values if v.id == value_id)

    def test_source_hashes_atomicity_and_finite_generation(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, lines in LINES.items():
            with self.subTest(factor=fid):
                factor = self.registry.factors[fid]
                ledger = self.registry.source_ledgers[factor.source_ledger_ref]
                self.assertEqual(ledger.source_line_count, lines)
                report = auditor.audit(fid)
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertTrue(report["conclusions"]["static_coverage_complete"])
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                source = ROOT / "work/doc2spec/batches/batch_03/corpus" / factor.source.catalog_chapter_ref.source_relpath
                if source.exists():
                    self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), factor.source.artifact_sha256)

    def test_all_manifests_unique_nonempty_and_pair_complete(self):
        ids = []
        for mid, (cases, report) in self.generated.items():
            with self.subTest(manifest=mid):
                self.assertTrue(cases)
                self.assertFalse(report.missing_pairs)
                for c in cases:
                    ids.append(c.case_id)
                    self.assertNotRegex(c.sql, r"\{|\}|\.\.\.|\[|\]")
                    self.assertEqual(c.sql.count(";"), 1)
        self.assertEqual(len(ids), len(set(ids)))

    def test_compile_and_rebuild_have_no_if_exists(self):
        for factor, suffix in [("alter_view", "compile"), ("alter_index", "rebuild"),
                               ("alter_index", "partition_rebuild")]:
            for c in self.cases(factor, suffix):
                self.assertNotIn("IF EXISTS", c.sql)
        self.assertEqual(self.cases("alter_view", "compile")[0].sql,
                         "ALTER VIEW v_av_base COMPILE;")

    def test_view_column_and_option_forms(self):
        defaults = self.cases("alter_view", "set_default")
        self.assertTrue(any("ALTER COLUMN col_1" in c.sql for c in defaults))
        self.assertTrue(any("ALTER col_2" in c.sql for c in defaults))
        options = {c.sql for c in self.cases("alter_view", "options")}
        self.assertIn("ALTER VIEW v_av_base SET (security_barrier);", options)
        self.assertTrue(any("check_option = 'CASCADED'" in s for s in options))
        self.assertTrue(any("check_option = 'LOCAL'" in s for s in options))
        self.assertTrue(any("," in s for s in options))
        self.assertFalse(any("SET (check_option)" in s for s in options))
        no_effect = next(f for f in self.registry.factors["alter_view"].facts
                         if f.id == "alter_view_fact_default_no_effect")
        self.assertIn("暂无实际意义", no_effect.statement)

    def test_view_schema_fixture_order_and_renamed_cleanup(self):
        c = self.cases("alter_view", "schema")[0]
        setup = "\n".join(c.setup_sqls)
        self.assertLess(setup.index("CREATE TABLE t_view_source"), setup.index("CREATE VIEW v_av_base"))
        self.assertIn("CREATE SCHEMA fp_cs_one;", c.setup_sqls)
        self.assertIn("DROP VIEW IF EXISTS fp_cs_one.v_av_base;", c.teardown_sqls)
        self.assertIn("DROP VIEW IF EXISTS v_av_new;", self.cases("alter_view", "rename")[0].teardown_sqls)

    def test_sequence_boundaries_from_sql_not_precomputed_booleans(self):
        for suffix, maximum in [("regular", 2**63 - 1), ("large", 2**127 - 1)]:
            seen = set()
            for c in self.cases("alter_sequence", suffix):
                self.assertFalse("MAXVALUE" in c.sql and "CACHE" in c.sql)
                number = re.search(r"\b(MAXVALUE|CACHE) (\d+)\b", c.sql)
                if number:
                    value = int(number[2])
                    self.assertLessEqual(value, maximum)
                    self.assertGreaterEqual(value, 1)
                    if number[1] == "MAXVALUE":
                        self.assertGreater(value, 101)
                    seen.add((number[1], value))
                self.assertNotRegex(c.sql, r"\b(INCREMENT|START|CYCLE|RESTART)\b")
                self.assertIn("SELECT nextval('seq_as_regular');", c.setup_sqls)
                self.assertIn("SELECT nextval('seq_as_large');", c.setup_sqls)
                self.assertFalse(any(s.startswith(("BEGIN", "START TRANSACTION")) for s in c.setup_sqls))
                gates = {g["key"]: g["allowed_values"] for g in c.environment_requirements}
                self.assertEqual(gates["execution_context"], ["top_level_autocommit"])
            self.assertIn(("MAXVALUE", maximum), seen)
            self.assertIn(("CACHE", maximum), seen)

    def test_sequence_large_marker_and_owned_by_shape(self):
        for c in self.cases("alter_sequence", "large"):
            self.assertTrue(c.sql.startswith("ALTER LARGE SEQUENCE"))
            self.assertIn("seq_as_large", c.sql)
        sqls = {c.sql for c in self.cases("alter_sequence", "regular")}
        self.assertTrue(any("OWNED BY t_cs_owner.id" in s for s in sqls))
        self.assertTrue(any("OWNED BY NONE" in s for s in sqls))
        self.assertTrue(any("NO MAXVALUE" in s for s in sqls))
        self.assertTrue(any("NOMAXVALUE" in s for s in sqls))

    def test_sequence_pairs_independently_enumerated(self):
        for suffix in ["regular", "large"]:
            mid = f"manifest_alter_sequence_{suffix}"
            bindings = self.registry.manifests[mid].bindings
            keys = sorted(bindings)
            combinations = []
            for row in itertools.product(*(bindings[k] for k in keys)):
                combo = dict(zip(keys, row))
                # Only empty-setting + empty-owned is excluded in these suites.
                if combo["setting"].endswith("_absent") and combo["owned_by"].endswith("_absent"):
                    continue
                combinations.append(combo)
            actual = [{k: c.params[k] for k in keys} for c in self.cases("alter_sequence", suffix)]
            self.assertEqual(pair_set(combinations), pair_set(actual))

    def test_index_partition_target_is_real_local_fixture(self):
        for suffix in ["partition", "partition_rebuild", "partition_tablespace"]:
            for c in self.cases("alter_index", suffix):
                self.assertIn("idx_ai_local", c.sql)
                setup = "\n".join(c.setup_sqls)
                self.assertLess(setup.index("CREATE TABLE t_ci_partitioned"), setup.index("CREATE INDEX idx_ai_local"))
                self.assertIn("LOCAL (PARTITION p_ai_low, PARTITION p_ai_max)", setup)
                part = self.value("alter_index", "partition_name", c.params["partition_name"]).render
                self.assertIn(part, setup)
                self.assertIn(part, c.sql)

    def test_external_tablespace_and_visibility_gates(self):
        for suffix in ["tablespace", "partition_tablespace"]:
            for c in self.cases("alter_index", suffix):
                gates = {g["key"]: g["allowed_values"] for g in c.environment_requirements}
                self.assertEqual(gates["prepared_tablespace"], ["fp_ai_tbs"])
        for c in self.cases("alter_index", "visibility"):
            gates = {g["key"]: g["allowed_values"] for g in c.environment_requirements}
            self.assertEqual(gates["visibility_keywords_enabled"], ["true"])
            self.assertEqual(gates["upgrade_stage"], ["normal_or_committed"])
        for cases, _ in self.generated.values():
            for c in cases:
                for s in c.setup_sqls + c.teardown_sqls:
                    self.assertNotRegex(s, r"\b(?:CREATE|DROP) (?:TABLESPACE|USER|ROLE)\b")
                self.assertNotIn("GSIVALID", c.sql)
                self.assertNotIn("GSIUSABLE", c.sql)

    def test_known_gaps_remain_explicit_and_negative_uncalibrated(self):
        for fid in LINES:
            factor = self.registry.factors[fid]
            self.assertEqual(factor.status, "needs_review")
            self.assertFalse(any(f.type == "open_question" and f.status == "needs_verification" for f in factor.facts))
            self.assertTrue(all(self.registry.scenarios[s].status == "planned" for s in factor.scenario_refs))
        for mid, (cases, _) in self.generated.items():
            if self.registry.manifests[mid].suite_type != "negative":
                continue
            self.assertEqual(len(self.registry.manifests[mid].violates_rule_refs), 1)
            for c in cases:
                self.assertEqual(c.expected, "error")
                self.assertEqual(c.expected_oracle_status, "needs_verification")
                self.assertFalse(c.expected_sqlstates)
                self.assertFalse(c.expected_error_regex)


if __name__ == "__main__":
    unittest.main()
