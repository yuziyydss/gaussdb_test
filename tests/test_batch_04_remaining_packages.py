"""Independent PDF/SQL contracts for the final thirteen batch-04 chapters.

No database is contacted. Finite generation completeness is not behavior proof.
"""
import hashlib
import itertools
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]
LINES = {
    "lock": 201, "set_constraints": 43,
    "create_synonym": 134, "alter_synonym": 62, "drop_synonym": 37,
    "create_table_as": 320, "select_into": 110,
    "create_materialized_view": 99, "refresh_materialized_view": 54,
    "drop_materialized_view": 46, "analyze_analyse": 333,
    "reindex": 161, "explain": 333,
}


def pairs(rows):
    return {p for row in rows for p in itertools.combinations(sorted(row.items()), 2)}


class Batch04RemainingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        generator = FactorPackageSQLGenerator(cls.registry)
        cls.results = {
            mid: generator.generate_with_report(cls.registry.manifests[mid])
            for fid in LINES for mid in cls.registry.factors[fid].manifest_refs
        }
        cls.all_cases = [c for cases, _ in cls.results.values() for c in cases]

    def cases(self, fid, suite):
        return self.results[f"manifest_{fid}_{suite}"][0]

    def value(self, fid, dim, vid):
        return next(v for c in self.registry.factors[fid].dimensions[dim].classes
                    for v in c.values if v.id == vid)

    def test_source_lines_hashes_atomicity_and_fact_consumers(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid, lines in LINES.items():
            with self.subTest(factor=fid):
                f = self.registry.factors[fid]
                report = auditor.audit(fid)
                self.assertEqual(f.status, "needs_review")
                self.assertEqual(report["source_units"]["line_coverage"]["total"], lines)
                self.assertEqual(report["source_units"]["atomicity"]["gaps"], [])
                self.assertEqual(report["facts"]["unconsumed_confirmed"], [])
                self.assertEqual(report["facts"]["wrong_consumer_type"], [])
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertFalse(report["conclusions"]["static_coverage_complete"])
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                path = ROOT / "work/doc2spec/batches/batch_04/corpus" / f.source.catalog_chapter_ref.source_relpath
                if path.exists():
                    self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), f.source.artifact_sha256)

    def test_finite_case_inventory_and_unique_ids_and_sql(self):
        self.assertEqual(len(self.results), 36)
        self.assertEqual(len(self.all_cases), 236)
        self.assertEqual(len({c.case_id for c in self.all_cases}), 236)
        self.assertEqual(len({(c.factor_id, c.sql) for c in self.all_cases}), 236)
        for cases, report in self.results.values():
            self.assertTrue(cases)
            self.assertEqual(report.missing_pairs, [])
            self.assertEqual(report.covered_pair_count, report.feasible_pair_count)

    def test_exported_sql_and_fixture_statements_are_terminated(self):
        # Without these semicolons a valid per-statement candidate becomes a
        # broken concatenated .sql snapshot. Do not rely only on basic lint.
        for case in self.all_cases:
            for sql in case.setup_sqls + [case.sql] + case.teardown_sqls:
                self.assertTrue(sql.rstrip().endswith(";"), (case.case_id, sql))
                self.assertNotRegex(sql, r"\{|\}|\.\.\.|\[|\]")

    def test_no_instance_mutation_or_blanket_error_swallowing(self):
        for case in self.all_cases:
            sql = "\n".join(case.setup_sqls + [case.sql] + case.teardown_sqls)
            self.assertNotRegex(sql, r"\b(?:CREATE|ALTER|DROP) (?:DATABASE|ROLE|USER|TABLESPACE)\b")
            self.assertNotRegex(sql, r"DROP OWNED|EXCEPTION WHEN|REINDEX (?:DATABASE|SYSTEM)|CHECKPOINT")

    def test_positive_candidates_do_not_claim_database_verification(self):
        for case in self.all_cases:
            if case.expected == "success":
                self.assertEqual(case.expected_scope, "syntax_only")
            else:
                self.assertEqual(case.expected_oracle_status, "needs_verification")
                self.assertTrue(case.expected_error_category)
                self.assertFalse(case.expected_sqlstates)
                self.assertFalse(case.expected_error_regex)

    def test_pairs_independently_recomputed_from_selected_domains(self):
        for fid, suite in [("lock", "ordinary"), ("create_table_as", "temporary"),
                           ("select_into", "positive"), ("explain", "options")]:
            m = self.registry.manifests[f"manifest_{fid}_{suite}"]
            keys = sorted(m.bindings)
            feasible = []
            for values in itertools.product(*(m.bindings[k] for k in keys)):
                row = dict(zip(keys, values))
                if fid == "select_into" and row["limit"] != "select_into_limit_none" and row["order"] == "select_into_order_none":
                    continue
                if fid == "explain" and row["analyze"] == "explain_analyze_false" and row["resource"] != "explain_resource_none":
                    continue
                feasible.append(row)
            actual = [{k: c.params[k] for k in keys} for c in self.cases(fid, suite)]
            self.assertEqual(pairs(feasible), pairs(actual), (fid, suite))

    def test_lock_matrix_matches_all_64_pdf_cells(self):
        modes = ["ACCESS SHARE", "ROW SHARE", "ROW EXCLUSIVE", "SHARE UPDATE EXCLUSIVE",
                 "SHARE", "SHARE ROW EXCLUSIVE", "EXCLUSIVE", "ACCESS EXCLUSIVE"]
        masks = ["00000001", "00000011", "00001111", "00011111",
                 "00110111", "00111111", "01111111", "11111111"]
        values = [v for c in self.registry.factors["lock"].dimensions["mode"].classes for v in c.values]
        for mode, mask in zip(modes, masks):
            value = next(v for v in values if v.render == f"IN {mode} MODE")
            self.assertEqual(set(value.properties["conflicts"]), {m for m, bit in zip(modes, mask) if bit == "1"})
        for i in range(8):
            for j in range(8):
                self.assertEqual(masks[i][j], masks[j][i])

    def test_lock_transaction_state_is_actually_compiled(self):
        for c in self.cases("lock", "ordinary"):
            self.assertIn("BEGIN;", c.setup_sqls)
            self.assertEqual(c.teardown_sqls[0], "ROLLBACK;")
        c, = self.cases("lock", "outside_negative")
        self.assertNotIn("BEGIN;", c.setup_sqls)
        self.assertIn("t_lock_outside", c.sql)

    def test_deferred_constraint_negative_has_pending_violation(self):
        c, = self.cases("set_constraints", "pending_negative")
        self.assertIn("BEGIN;", c.setup_sqls)
        self.assertTrue(any("INSERT INTO t_constraints" in s and "(1, 2), (3, 2)" in s for s in c.setup_sqls))
        self.assertEqual(c.sql, "SET CONSTRAINTS uq_sc_two IMMEDIATE;")
        self.assertEqual(c.teardown_sqls[0], "ROLLBACK;")
        for c in self.cases("set_constraints", "all") + self.cases("set_constraints", "named"):
            self.assertIn("BEGIN;", c.setup_sqls)
            self.assertFalse(any("INSERT INTO t_constraints" in s for s in c.setup_sqls))

    def test_constraints_outside_transaction_is_noop_not_error(self):
        f = self.registry.factors["set_constraints"]
        fact = next(fact for fact in f.facts if fact.id == "set_constraints_fact_outside")
        self.assertIn("不", fact.statement)
        for mid in f.manifest_refs:
            if self.registry.manifests[mid].suite_type == "negative":
                self.assertIn("pending", mid)

    def test_missing_synonym_target_is_positive_and_not_fixture_created(self):
        cases = [c for c in self.cases("create_synonym", "new") if "fp_syn_absent_object" in c.sql]
        self.assertTrue(cases)
        for c in cases:
            self.assertEqual(c.expected, "success")
            self.assertNotIn("fp_syn_absent_object", "\n".join(c.setup_sqls))

    def test_owner_change_is_environment_gated_without_creating_roles(self):
        c, = self.cases("alter_synonym", "owner")
        self.assertEqual(c.sql, "ALTER SYNONYM s_alter_syn OWNER TO fp_syn_owner;")
        gates = {g["key"]: g["allowed_values"] for g in c.environment_requirements}
        self.assertEqual(gates["synonym_owner_change_authority"], ["granted"])
        self.assertEqual(gates["new_owner_fp_syn_owner_schema_create"], ["granted"])
        for c in self.all_cases:
            if "synonym" in c.factor_id:
                self.assertNotRegex(c.sql, r"\bPUBLIC\b")

    def test_drop_dependency_negatives_have_real_dependents(self):
        for fid, marker in [("drop_synonym", "CREATE VIEW v_syn_dep"),
                            ("drop_materialized_view", "CREATE VIEW v_mv_dep")]:
            for c in self.cases(fid, "restrict_negative"):
                self.assertIn(marker, "\n".join(c.setup_sqls))
                self.assertNotIn("CASCADE", c.sql)
                self.assertEqual(c.expected_error_category, "dependent_objects_exist")

    def test_ctas_commit_clause_only_on_temporary_targets(self):
        for c in self.cases("create_table_as", "ordinary"):
            self.assertNotIn("ON COMMIT", c.sql)
        for c in self.cases("create_table_as", "temporary"):
            self.assertRegex(c.sql, r"CREATE (?:GLOBAL |LOCAL )?TEMP(?:ORARY)? TABLE")
            self.assertIn("BEGIN;", c.setup_sqls)
            self.assertIn("ROLLBACK;", c.teardown_sqls)

    def test_ctas_no_data_and_engine_are_not_mv_features(self):
        self.assertTrue(any("WITH NO DATA" in c.sql for c in self.cases("create_table_as", "ordinary")))
        for c in self.cases("create_table_as", "engine_b"):
            self.assertIn("ENGINE", c.sql)
            self.assertIn({"key": "sql_compatibility", "allowed_values": ["B"],
                           "fact_refs": ["create_table_as_fact_engine"]}, c.environment_requirements)
        for c in self.cases("create_materialized_view", "positive"):
            self.assertNotIn("WITH NO DATA", c.sql)
            self.assertNotIn("ENGINE", c.sql)

    def test_select_into_position_and_projection_contract(self):
        for c in self.cases("select_into", "positive"):
            self.assertLess(c.sql.index("SELECT"), c.sql.index(" INTO "))
            self.assertLess(c.sql.index(" INTO "), c.sql.index(" FROM "))
            self.assertNotIn("ON COMMIT", c.sql)
            v = self.value("select_into", "projection", c.params["projection"])
            self.assertEqual(len(v.properties["items"]), 2)
            self.assertEqual(v.properties["column_count"], 2)

    def test_mv_source_is_explicit_astore_nonsegment(self):
        for c in self.all_cases:
            if "materialized_view" in c.factor_id:
                setup = "\n".join(c.setup_sqls)
                if "CREATE TABLE t_mv_source" in setup:
                    self.assertIn("WITH (STORAGE_TYPE=ASTORE, segment=off)", setup)
                    self.assertNotIn("USTORE", setup)

    def test_mv_column_count_negative_changes_only_alias_count(self):
        c, = self.cases("create_materialized_view", "column_count_negative")
        self.assertIn("mv_candidate (a) AS SELECT col_1, col_2", c.sql)
        self.assertEqual(c.expected_error_category, "projection_column_count_mismatch")

    def test_refresh_seed_occurs_after_both_views_are_created(self):
        for c in self.cases("refresh_materialized_view", "full_refresh"):
            setup = c.setup_sqls
            seed = next(i for i, s in enumerate(setup) if s.startswith("INSERT INTO t_mv_source"))
            for prefix in ["CREATE MATERIALIZED VIEW mv_full", "CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental"]:
                self.assertLess(next(i for i, s in enumerate(setup) if s.startswith(prefix)), seed)
            self.assertRegex(c.sql, r"^REFRESH MATERIALIZED VIEW mv_(?:full|incremental);$")

    def test_real_cross_factor_dependencies_and_topological_order(self):
        graph = self.registry.factor_dependency_graph()
        self.assertEqual(graph["select_into"], {"create_table_as"})
        self.assertEqual(graph["refresh_materialized_view"], {"create_materialized_view"})
        self.assertEqual(graph["drop_materialized_view"], {"create_materialized_view", "refresh_materialized_view"})
        order = self.registry.fixture_topological_order(["fixture_refresh_materialized_view_changed"])
        self.assertLess(order.index("fixture_create_materialized_view_source"), order.index("fixture_create_materialized_view_full"))
        self.assertLess(order.index("fixture_create_materialized_view_full"), order.index("fixture_refresh_materialized_view_changed"))

    def test_analyze_joint_columns_and_verify_cascade_are_distinct(self):
        stats = {c.sql for c in self.cases("analyze_analyse", "statistics")}
        self.assertTrue(any("((col_1, col_2))" in s for s in stats))
        for c in self.cases("analyze_analyse", "verify_objects"):
            self.assertRegex(c.sql, r"^(?:ANALYZE|ANALYSE) VERIFY (?:FAST|COMPLETE) [ti]_analyze_source")
            if "i_analyze_source" in c.sql:
                self.assertNotIn("CASCADE", c.sql)
            self.assertNotIn("BEGIN;", c.setup_sqls)

    def test_reindex_online_is_outside_transaction_except_target_negative(self):
        ordinary_tx = [c for c in self.cases("reindex", "ordinary") if "i_reindex_tx" in c.sql]
        self.assertEqual(len(ordinary_tx), 2)
        for c in ordinary_tx:
            self.assertEqual(c.expected, "success")
            self.assertIn("BEGIN;", c.setup_sqls)
            self.assertNotIn("CONCURRENTLY", c.sql)
        for c in self.cases("reindex", "online"):
            self.assertNotIn("BEGIN;", c.setup_sqls)
            self.assertRegex(c.sql, r"^REINDEX (?:INDEX|TABLE) CONCURRENTLY [it]_reindex_source")
        c, = self.cases("reindex", "transaction_negative")
        self.assertIn("CREATE INDEX i_reindex_tx", "\n".join(c.setup_sqls))
        self.assertIn("BEGIN;", c.setup_sqls)
        self.assertEqual(c.sql, "REINDEX INDEX CONCURRENTLY i_reindex_tx;")
        self.assertEqual(c.teardown_sqls[0], "ROLLBACK;")

    def test_explain_runtime_options_require_execution_in_positive_domain(self):
        for c in self.cases("explain", "options"):
            if c.params["resource"] != "explain_resource_none":
                self.assertNotIn("ANALYZE FALSE", c.sql)
            self.assertNotIn(", )", c.sql)
        for c in self.all_cases:
            if c.factor_id == "explain":
                self.assertIn("BEGIN;", c.setup_sqls)
                self.assertIn("SET LOCAL explain_perf_mode=normal;", c.setup_sqls)
                self.assertEqual(c.teardown_sqls[0], "ROLLBACK;")

    def test_unimplemented_features_and_scenarios_stay_visible(self):
        for fid in LINES:
            factor = self.registry.factors[fid]
            self.assertTrue(any(f.type == "open_question" for f in factor.facts))
            self.assertTrue(factor.scenario_refs)
            for sid in factor.scenario_refs:
                self.assertEqual(self.registry.scenarios[sid].status, "planned")
        for fid, feature in [("create_table_as", "prepared"), ("analyze_analyse", "database"),
                             ("reindex", "broad"), ("explain", "plan")]:
            matrix = self.registry.matrices[f"matrix_{fid}_coverage"]
            self.assertEqual(next(f.status for f in matrix.documented_features
                                  if f.id == f"{fid}_feature_{feature}"), "needs_profile")


if __name__ == "__main__":
    unittest.main()
