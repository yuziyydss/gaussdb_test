"""Batch 03 schema / VALUES / prepared-statement contracts, without a DB."""
import hashlib
import itertools
import re
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from scripts.generate_factor_package_sql import render_sql_snapshot


ROOT = Path(__file__).resolve().parents[1]
LINES = {"create_schema": 149, "alter_schema": 189, "drop_schema": 54,
         "values": 87, "prepare": 37, "execute": 54, "deallocate": 70}


def pairs(rows):
    return {pair for row in rows
            for pair in itertools.combinations(sorted(row.items()), 2)}


class SchemaPreparedBatchTests(unittest.TestCase):
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

    def test_source_hashes_atomic_units_and_honest_behavior_status(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, count in LINES.items():
            with self.subTest(factor=fid):
                factor = self.registry.factors[fid]
                ledger = self.registry.source_ledgers[factor.source_ledger_ref]
                self.assertEqual(ledger.source_line_count, count)
                report = auditor.audit(fid)
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                self.assertEqual(factor.status, "needs_review")
                source = ROOT / "work/doc2spec/batches/batch_03/corpus" / factor.source.catalog_chapter_ref.source_relpath
                if source.exists():
                    self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), factor.source.artifact_sha256)

    def test_all_manifests_nonempty_unique_and_pair_complete(self):
        ids = []
        for mid, (cases, report) in self.generated.items():
            with self.subTest(manifest=mid):
                self.assertTrue(cases)
                self.assertFalse(report.missing_pairs)
                for c in cases:
                    ids.append(c.case_id)
                    self.assertNotRegex(c.sql, r"\{|\}|\.\.\.|\[|\]")
                    self.assertTrue(c.sql.endswith(";"))
                    self.assertEqual(c.sql.count(";"), 1)
        self.assertEqual(len(ids), len(set(ids)))

    def test_prepare_pair_set_recomputed_independently(self):
        mid = "manifest_prepare_families"
        bindings = self.registry.manifests[mid].bindings
        keys = sorted(bindings)
        feasible = [dict(zip(keys, row)) for row in itertools.product(*(bindings[k] for k in keys))]
        generated = [{k: c.params[k] for k in keys} for c in self.cases("prepare", "families")]
        self.assertEqual(pairs(feasible), pairs(generated))
        self.assertEqual(len(feasible), 24)
        self.assertLess(len(generated), len(feasible))

    def test_prepare_types_match_referenced_parameters(self):
        for suffix in ["families", "two_parameters"]:
            for case in self.cases("prepare", suffix):
                ids = {int(n) for n in re.findall(r"\$(\d+)", case.sql)}
                self.assertEqual(ids, set(range(1, max(ids) + 1)))
                signature = self.value("prepare", "signature", case.params["signature"])
                if signature.properties["count"]:
                    self.assertEqual(signature.properties["count"], max(ids))
                self.assertIn("CAST($1 AS INTEGER)", case.sql)
                if "MERGE INTO" in case.sql:
                    self.assertIn("WHEN MATCHED THEN UPDATE SET note", case.sql)
                    self.assertNotIn("UPDATE SET id", case.sql)

    def test_execute_zero_binding_exception_and_typed_contracts(self):
        cases = self.cases("execute", "compatible")
        zero = [c for c in cases if c.params["name"] == "execute_name_zero"]
        self.assertEqual(len(zero), 7)
        self.assertIn("EXECUTE p_ps_zero('not_integer');", {c.sql for c in zero})
        self.assertIn("EXECUTE p_ps_zero(1, 2);", {c.sql for c in zero})
        for c in cases:
            signature = self.value("execute", "name", c.params["name"]).properties
            args = self.value("execute", "parameters", c.params["parameters"]).properties
            self.assertTrue(args["legal"])
            if signature["count"]:
                self.assertEqual(signature["count"], len(args["items"]))
                self.assertIn(signature["signature"], args["compatible_signatures"])

    def test_prepared_fixture_order_signatures_and_exclusive_gate(self):
        for mid, (cases, _) in self.generated.items():
            if self.registry.manifests[mid].factor_ref not in {"prepare", "execute", "deallocate"}:
                continue
            for c in cases:
                gates = {g["key"]: g["allowed_values"] for g in c.environment_requirements}
                self.assertEqual(gates["session_ownership"], ["exclusive_test_connection"])
                self.assertIn("exclusive_test_connection", render_sql_snapshot(mid, [c]))
                self.assertIn("DEALLOCATE ALL;", c.teardown_sqls)
        case = self.cases("execute", "compatible")[0]
        setup = "\n".join(case.setup_sqls)
        self.assertLess(setup.index("DEALLOCATE ALL;"), setup.index("PREPARE p_ps_zero"))
        self.assertLess(setup.index("CREATE TABLE"), setup.index("PREPARE p_ps_three"))
        self.assertIn("PREPARE p_ps_one(INTEGER)", setup)
        self.assertIn("PREPARE p_ps_three(INTEGER, VARCHAR(10), VARCHAR(10))", setup)
        teardown = "\n".join(case.teardown_sqls)
        self.assertLess(teardown.index("DEALLOCATE ALL;"), teardown.index("DROP TABLE"))

    def test_values_rectangular_rows_and_default_context(self):
        for mid, (cases, _) in self.generated.items():
            manifest = self.registry.manifests[mid]
            if manifest.factor_ref != "values" or manifest.suite_type != "positive":
                continue
            for c in cases:
                first = self.value("values", "first_row", c.params["first_row"]).properties
                if c.params["more_rows"] == "values_more_rows_present":
                    second = self.value("values", "second_row", c.params["second_row"]).properties
                    self.assertEqual(len(first["items"]), len(second["items"]))
                    self.assertEqual(first["types"], second["types"])
                if "DEFAULT" in c.sql:
                    self.assertTrue(c.sql.startswith("INSERT INTO t_values_test"))
                    self.assertTrue(any(s.startswith("CREATE TABLE t_values_test") for s in c.setup_sqls))
                self.assertFalse("LIMIT" in c.sql and "FETCH" in c.sql)

    def test_schema_rename_and_drop_dependency_preconditions(self):
        renamed = {c.sql for c in self.cases("alter_schema", "rename")}
        self.assertIn("ALTER SCHEMA fp_as_occupied RENAME TO fp_as_renamed;", renamed)
        for c in self.cases("drop_schema", "positive"):
            setup = "\n".join(c.setup_sqls)
            self.assertLess(setup.index("CREATE SCHEMA fp_cs_two"), setup.index("CREATE TABLE fp_cs_two.ds_probe"))
            self.assertIn("DROP SCHEMA IF EXISTS fp_ds_missing;", c.setup_sqls)
            if "fp_cs_two" in c.sql:
                self.assertIn("CASCADE", c.sql)
            if "fp_ds_missing" in c.sql:
                self.assertIn("IF EXISTS", c.sql)

    def test_inline_schema_elements_and_environment_separation(self):
        sqls = {c.sql for c in self.cases("create_schema", "basic")}
        self.assertIn("CREATE SCHEMA fp_cs_new;", sqls)
        both = next(s for s in sqls if "CREATE VIEW" in s)
        self.assertLess(both.index("CREATE TABLE"), both.index("CREATE VIEW"))
        for c in self.cases("create_schema", "ledger"):
            self.assertIn("WITH BLOCKCHAIN", c.sql)
            self.assertTrue(c.environment_requirements)
        for c in self.cases("alter_schema", "charset"):
            gates = {g["key"]: g["allowed_values"] for g in c.environment_requirements}
            self.assertEqual(gates["compatibility_mode"], ["B"])
            self.assertEqual(gates["server_encoding"], ["UTF8"])

    def test_negative_oracles_remain_pending_not_any_error(self):
        for mid, (cases, _) in self.generated.items():
            manifest = self.registry.manifests[mid]
            if manifest.suite_type != "negative":
                continue
            self.assertEqual(len(manifest.violates_rule_refs), 1)
            for c in cases:
                self.assertEqual(c.expected, "error")
                self.assertEqual(c.expected_oracle_status, "needs_verification")
                self.assertFalse(c.expected_sqlstates)
                self.assertFalse(c.expected_error_regex)


if __name__ == "__main__":
    unittest.main()
