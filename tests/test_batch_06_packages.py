"""Batch 06: independently check finite PDF contracts without a database."""
import hashlib
import itertools
import json
import re
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from scripts.prepare_batch_03 import validate_plan

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    "alter_procedure": (3, 17), "alter_trigger": (1, 2),
    "create_cast": (1, 3), "create_procedure": (2, 9),
    "create_rule": (3, 19), "create_trigger": (2, 19),
    "drop_cast": (2, 7), "drop_procedure": (2, 3), "drop_rule": (1, 6),
    "drop_trigger": (1, 6), "commit_prepared": (1, 1),
    "prepare_transaction": (1, 2), "rollback_prepared": (1, 1),
    "checkpoint": (1, 1), "clean_connection": (1, 4), "cluster": (4, 6),
    "cursor": (1, 7), "set_role": (2, 2), "set_session_authorization": (2, 5),
    "vacuum": (3, 23),
}


def pairs(rows):
    return {pair for row in rows for pair in itertools.combinations(sorted(row.items()), 2)}


STATIC_COMPLETE = set(EXPECTED)


class Batch06Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.results = {
            mid: cls.generator.generate_with_report(cls.registry.manifests[mid])
            for fid in EXPECTED for mid in cls.registry.factors[fid].manifest_refs
        }
        cls.all_cases = [c for cases, _ in cls.results.values() for c in cases]

    def cases(self, fid, suite=None):
        if suite:
            return self.results[f"manifest_{fid}_{suite}"][0]
        return [c for c in self.all_cases if c.factor_id == fid]

    def test_plan_and_source_hashes(self):
        plan = json.loads((ROOT / "tests/data/batch_06.json").read_text())
        validate_plan(plan)
        self.assertEqual(set(plan["new_chapters"]), {self.registry.factors[f].name for f in EXPECTED})
        path = ROOT / plan["source_catalog"]
        if path.exists():
            c = json.loads(path.read_text())
            self.assertEqual({x["title"] for x in c["chapters"]},
                             set(plan["new_chapters"] + plan["existing_providers"]))
            for ch in c["chapters"]:
                self.assertEqual(hashlib.sha256((path.parent / ch["source_relpath"]).read_bytes()).hexdigest(),
                                 ch["chapter_sha256"])

    def test_source_and_generation_are_not_full_coverage(self):
        a = FactorCoverageAuditor(self.registry)
        for fid in EXPECTED:
            with self.subTest(factor=fid):
                r = a.audit(fid)
                self.assertEqual(r["source_units"]["atomicity"]["gaps"], [])
                self.assertEqual(r["facts"]["unconsumed_confirmed"], [])
                self.assertEqual(r["facts"]["wrong_consumer_type"], [])
                self.assertTrue(r["conclusions"]["source_extraction_complete"])
                self.assertTrue(r["conclusions"]["generation_model_complete"])
                self.assertEqual(
                    r["conclusions"]["static_coverage_complete"],
                    fid in STATIC_COMPLETE,
                )
                self.assertFalse(r["conclusions"]["behavior_coverage_complete"])

    def test_counts_ids_and_sql_uniqueness(self):
        self.assertEqual(len(self.all_cases), 143)
        self.assertEqual(len({c.case_id for c in self.all_cases}), 143)
        self.assertEqual(len({(c.factor_id, c.sql) for c in self.all_cases}), 143)
        for fid, (manifests, count) in EXPECTED.items():
            self.assertEqual(len(self.registry.factors[fid].manifest_refs), manifests)
            self.assertEqual(len(self.cases(fid)), count)
        for cases, report in self.results.values():
            self.assertTrue(cases)
            self.assertEqual(report.missing_pairs, [])
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)

    def test_independent_feasible_pairs_for_every_manifest(self):
        # Only two nontrivial rules in this batch; implement the PDF conditions
        # here independently rather than calling the generator's constraint solver.
        for mid, (cases, report) in self.results.items():
            m = self.registry.manifests[mid]
            keys = sorted(m.bindings)
            rows = []
            for vs in itertools.product(*(m.bindings[k] for k in keys)):
                row = dict(zip(keys, vs))
                illegal = False
                if m.factor_ref == "cluster":
                    illegal = row["target"] != "cluster_target_repeat" and row["index"] == "cluster_index_none"
                if illegal == (m.suite_type == "negative"):
                    rows.append(row)
            self.assertTrue(rows, mid)
            actual = [{k: c.params[k] for k in keys} for c in cases]
            self.assertEqual(pairs(rows), pairs(actual), mid)
            if not keys:
                self.assertEqual(actual, [{}])

    def test_sql_terminated_and_no_pdf_metasyntax(self):
        for c in self.all_cases:
            for sql in c.setup_sqls + [c.sql] + c.teardown_sqls:
                self.assertTrue(sql.rstrip().endswith(";"), (c.case_id, sql))
                self.assertNotRegex(sql, r"\{[a-z_]+\}|\[\s*(?:IF|OR|CASCADE)|\.\.\.")
                self.assertNotIn("gaussdb=#", sql)
                self.assertNotEqual(sql.strip(), "/")

    def test_no_credentials_or_broad_cleanup(self):
        dedicated_prefixes = (
            "manifest_set_role_fresh_switch_",
            "manifest_set_session_authorization_fresh_switch_",
        )
        for c in self.all_cases:
            sql = "\n".join(c.setup_sqls + [c.sql] + c.teardown_sqls)
            if c.case_id.startswith(dedicated_prefixes):
                self.assertIn("set_role_fresh" if c.factor_id == "set_role" else "set_session_auth_fresh", sql)
                self.assertNotIn("DROP OWNED", sql.upper())
                self.assertNotIn("EXCEPTION WHEN", sql.upper())
                self.assertNotIn("online_ddl_cleanup()", sql)
                continue
            self.assertNotRegex(sql.upper(), r"\b(?:CREATE|ALTER|DROP) (?:ROLE|USER|DATABASE|TABLESPACE)\b")
            self.assertNotRegex(sql.upper(), r"\bPASSWORD\b|DROP OWNED|EXCEPTION WHEN")
            self.assertNotIn("online_ddl_cleanup()", sql)

    def test_expected_scope_and_negative_oracle_are_honest(self):
        for c in self.all_cases:
            if c.expected == "success":
                self.assertEqual(c.expected_scope, "syntax_only")
            else:
                self.assertIn(c.expected_oracle_status, {"confirmed", "needs_verification"})
                self.assertTrue(c.expected_error_category)
                if c.expected_oracle_status == "needs_verification":
                    self.assertFalse(c.expected_sqlstates)
                    self.assertFalse(c.expected_error_regex)

    def test_function_fixture_dependency_order(self):
        order = self.registry.fixture_topological_order(["fixture_create_trigger_existing_trigger"])
        self.assertLess(order.index("fixture_create_trigger_source"), order.index("fixture_create_trigger_functions"))
        self.assertLess(order.index("fixture_create_trigger_functions"), order.index("fixture_create_trigger_existing_trigger"))
        graph = self.registry.factor_dependency_graph()
        for consumer, provider in [("alter_trigger", "create_trigger"), ("drop_trigger", "create_trigger"),
                                  ("alter_procedure", "create_procedure"), ("drop_procedure", "create_procedure"),
                                  ("drop_cast", "create_cast"), ("drop_rule", "create_rule"),
                                  ("cursor", "declare"), ("commit_prepared", "prepare_transaction")]:
            self.assertIn(provider, graph[consumer])

    def test_procedure_actual_replace_and_no_fake_signature(self):
        c, = self.cases("create_procedure", "replace_existing")
        self.assertIn("CREATE OR REPLACE PROCEDURE fp_proc_replace", c.sql)
        self.assertTrue(any(s.startswith("CREATE PROCEDURE fp_proc_replace") for s in c.setup_sqls))
        for c in self.cases("create_procedure"):
            self.assertIn("SECURITY INVOKER", c.sql)
            self.assertIn("v := a; END;", c.sql)
            self.assertNotIn("RETURN SET", c.sql)
        for c in self.cases("drop_procedure"):
            self.assertNotIn("(", c.sql)
            self.assertNotRegex(c.sql, r"CASCADE|RESTRICT")

    def test_compile_with_and_without_signature(self):
        sql = {c.sql for c in self.cases("alter_procedure", "compile")}
        self.assertEqual(sql, {"ALTER PROCEDURE fp_proc_ready COMPILE;",
                               "ALTER PROCEDURE fp_proc_ready(INTEGER) COMPILE;",
                               "ALTER PROCEDURE fp_proc_ready(a IN INTEGER) COMPILE;"})

    def test_trigger_truncate_level_and_delete_handler(self):
        for c in self.cases("create_trigger", "ordinary"):
            if c.params["event"] == "create_trigger_event_delete":
                self.assertIn("EXECUTE PROCEDURE fp_trigger_old()", c.sql)
            else:
                self.assertIn("EXECUTE PROCEDURE fp_trigger_new()", c.sql)
            self.assertTrue(any("RETURNS TRIGGER" in s for s in c.setup_sqls))

    def test_trigger_replace_fixture_and_rename_boundary(self):
        c, = self.cases("create_trigger", "replace_existing")
        self.assertTrue(any(s.startswith("CREATE TRIGGER fp_trigger AFTER") for s in c.setup_sqls))
        for c in self.cases("alter_trigger"):
            name = c.sql.removesuffix(";").split(" RENAME TO ")[1]
            self.assertIn(len(name), (18, 63))

    def test_rule_actions_are_structured_and_nonrecursive(self):
        c, = self.cases("create_rule", "multiple_actions")
        self.assertIn("DO ALSO (INSERT INTO t_rule_log VALUES (1, 2); INSERT INTO t_rule_log VALUES (3, 4))", c.sql)
        self.assertIn("TO t_rule_source", c.sql)
        for c in self.cases("create_rule"):
            self.assertNotIn("ON SELECT", c.sql)
            if "INSERT INTO" in c.sql:
                self.assertTrue(any(s.startswith("CREATE TABLE t_rule_log") for s in c.setup_sqls))

    def test_cast_lifecycle_is_transactional_without_deleting_existing_cast(self):
        for fid in ("create_cast", "drop_cast"):
            manifests = ["manifest_drop_cast_owned_conversion"] if fid == "drop_cast" else self.registry.factors[fid].manifest_refs
            for c in [x for mid in manifests for x in self.cases(mid)]:
                self.assertEqual(c.setup_sqls[0], "BEGIN;")
                self.assertEqual(c.teardown_sqls, ["ROLLBACK;"])
                self.assertFalse(any("DROP CAST" in s for s in c.setup_sqls))
                self.assertTrue(any("RETURNS timestamp with time zone" in s for s in c.setup_sqls))

    def test_two_phase_is_gated_and_exact_id_cleanup(self):
        for fid in ("prepare_transaction", "commit_prepared", "rollback_prepared"):
            for mid in self.registry.factors[fid].manifest_refs:
                keys = {r.key for r in self.registry.manifests[mid].environment_requirements}
                self.assertIn("internal_two_phase_testing", keys)
                self.assertIn("prepared_transactions_capacity_ready", keys)
            f = self.registry.factors[fid]
            if fid == "rollback_prepared":
                fact_ids = {x.id for x in f.facts}
                self.assertIn("rollback_prepared_fact_identifier_conflict", fact_ids)
                self.assertIn("rollback_prepared_fact_failure_cleanup", fact_ids)
        for c in self.cases("prepare_transaction"):
            gid = re.search(r"'([^']*)'", c.sql).group(1)
            self.assertIn(len(gid.encode("ascii")), (11, 199))
            self.assertIn("ROLLBACK PREPARED '" + gid + "';", c.teardown_sqls)
        for c in self.cases("commit_prepared"):
            self.assertNotIn(" WITH ", c.sql)

    def test_clean_connection_never_defaults_to_all_users_or_databases(self):
        for c in self.cases("clean_connection"):
            self.assertIn("TO ALL", c.sql)
            self.assertIn("FOR DATABASE fp_cc_isolated TO USER fp_cc_test_user", c.sql)
            self.assertNotRegex(c.sql, r"COORDINATOR|NODE")
            self.assertGreaterEqual(len(c.environment_requirements), 2)

    def test_role_outputs_use_reset_and_dedicated_static_switch(self):
        self.assertEqual([c.sql for c in self.cases("set_role")], [
            "RESET ROLE;",
            "SET SESSION ROLE set_role_fresh PASSWORD 'SetRole_2026_Aa9';",
        ])
        session_sqls = {c.sql for c in self.cases("set_session_authorization")}
        self.assertIn("SET SESSION SESSION AUTHORIZATION set_session_auth_fresh PASSWORD 'SetSessionAuth_2026_Aa9';", session_sqls)
        self.assertTrue(session_sqls <= {
            "RESET SESSION AUTHORIZATION;",
            "SET SESSION AUTHORIZATION DEFAULT;",
            "SET SESSION SESSION AUTHORIZATION DEFAULT;",
            "SET LOCAL SESSION AUTHORIZATION DEFAULT;",
            "SET SESSION SESSION AUTHORIZATION set_session_auth_fresh PASSWORD 'SetSessionAuth_2026_Aa9';",
        })
        for fid in ("set_role", "set_session_authorization"):
            fact = next(x for x in self.registry.factors[fid].facts if x.id.endswith("static_switch_environment"))
            self.assertEqual((fact.type, fact.status), ("environment", "confirmed"))

    def test_maintenance_never_wraps_target_in_transaction(self):
        for fid in ("cluster", "vacuum"):
            for c in self.cases(fid):
                self.assertNotIn("BEGIN;", c.setup_sqls)
                self.assertTrue(any(r["key"] == "autocommit_no_transaction" for r in c.environment_requirements))
        for c in self.cases("cluster", "repeat"):
            self.assertNotIn("USING", c.sql)
            self.assertTrue(any(s.startswith("CLUSTER t_cluster_source USING") for s in c.setup_sqls))

    def test_vacuum_column_and_option_order(self):
        for c in self.cases("vacuum", "plain"):
            self.assertRegex(c.sql, r"^VACUUM(?: FULL)?(?: FREEZE)?(?: VERBOSE)? t_vacuum_source(?: OFFLINE)?;$")
            self.assertNotIn("(col_", c.sql)
        for c in self.cases("vacuum", "analyze"):
            self.assertRegex(c.sql, r"^VACUUM(?: FULL)?(?: FREEZE)?(?: VERBOSE)? ANALY[ZS]E ")
        for c in self.cases("vacuum", "parenthesized"):
            self.assertTrue(c.sql.startswith("VACUUM ("))
            self.assertIn("ANALYZE", c.sql)
        for c in self.cases("vacuum"):
            self.assertNotIn("ONLINE", c.sql)

    def test_online_fallback_types_stay_separate_static_boundaries(self):
        m = self.registry.matrices["matrix_vacuum_coverage"]
        features = {x.id: x for x in m.documented_features}
        for kind in ("database", "index", "subpartition_table", "segment", "hash_bucket", "temporary", "unlogged", "htap"):
            feature = features["vacuum_feature_online_" + kind]
            self.assertEqual(feature.status, "covered")
            self.assertEqual(feature.coverage_mode, "any")
        audit = FactorCoverageAuditor(self.registry).audit("vacuum")
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])

    def test_cursor_uses_existing_source_and_same_session_lifecycle(self):
        for c in self.cases("cursor"):
            self.assertIn("BEGIN;", c.setup_sqls)
            self.assertIn("CLOSE fp_cursor;", c.teardown_sqls)
            self.assertIn("ROLLBACK;", c.teardown_sqls)
            self.assertTrue(c.sql.startswith("CURSOR fp_cursor"))
            self.assertNotRegex(c.sql, r"(?<!NO )SCROLL")
