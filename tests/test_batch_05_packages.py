"""Batch 05 finite PDF contracts. No database execution or behavior-pass claims."""
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
    "create_function": (2, 20), "alter_function": (4, 39), "drop_function": (3, 11),
    "call": (1, 4), "do": (1, 4), "create_aggregate": (2, 12),
    "alter_aggregate": (1, 2), "drop_aggregate": (2, 9),
    "create_text_search_configuration": (2, 12),
    "alter_text_search_configuration": (2, 12),
    "drop_text_search_configuration": (2, 9),
    "create_text_search_dictionary": (1, 3), "alter_text_search_dictionary": (1, 5),
    "drop_text_search_dictionary": (2, 9),
    "create_incremental_materialized_view": (1, 8),
    "refresh_incremental_materialized_view": (1, 1),
    "alter_materialized_view": (1, 6), "comment": (22, 124),
    "explain_plan": (1, 6), "rename_table": (1, 4),
}
STATIC_CLOSED = set(EXPECTED)


def pairs(rows):
    return {p for row in rows for p in itertools.combinations(sorted(row.items()), 2)}


class Batch05Tests(unittest.TestCase):
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

    def test_batch_plan_has_twenty_new_chapters_and_closed_sources(self):
        plan = json.loads((ROOT / "tests/data/batch_05.json").read_text())
        validate_plan(plan)
        self.assertEqual(len(plan["new_chapters"]), 20)
        self.assertFalse(plan["database_execution"])
        self.assertEqual({self.registry.factors[f].name for f in EXPECTED}, set(plan["new_chapters"]))
        catalog = ROOT / "work/doc2spec/batches/batch_05/corpus/catalog.json"
        if catalog.exists():
            c = json.loads(catalog.read_text())
            self.assertEqual({x["title"] for x in c["chapters"]},
                             set(plan["new_chapters"] + plan["existing_providers"] +
                                 [x["title"] for x in plan["supplemental_sections"]]))
            for ch in c["chapters"]:
                self.assertEqual(hashlib.sha256((catalog.parent / ch["source_relpath"]).read_bytes()).hexdigest(),
                                 ch["chapter_sha256"])

    def test_source_audit_is_distinct_from_full_static_and_behavior(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid in EXPECTED:
            with self.subTest(factor=fid):
                f = self.registry.factors[fid]
                report = auditor.audit(fid)
                self.assertEqual(f.status, "needs_review")
                gaps = report["source_units"]["atomicity"]["gaps"]
                self.assertEqual(gaps, [])
                self.assertTrue(report["conclusions"]["source_extraction_complete"])
                self.assertEqual(report["facts"]["unconsumed_confirmed"], [])
                self.assertEqual(report["facts"]["wrong_consumer_type"], [])
                self.assertTrue(report["conclusions"]["generation_model_complete"])
                self.assertEqual(
                    report["conclusions"]["static_coverage_complete"],
                    fid in STATIC_CLOSED,
                )
                self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
                path = ROOT / "work/doc2spec/batches/batch_05/corpus" / f.source.catalog_chapter_ref.source_relpath
                if path.exists():
                    self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), f.source.artifact_sha256)
                    self.assertEqual(len(path.read_text().splitlines()), report["source_units"]["line_coverage"]["total"])

    def test_case_inventory_and_no_duplicate_sql_or_ids(self):
        expected_count = sum(count for _, count in EXPECTED.values())
        self.assertEqual(len(self.all_cases), expected_count)
        self.assertEqual(len({c.case_id for c in self.all_cases}), expected_count)
        self.assertEqual(len({(c.factor_id, c.sql) for c in self.all_cases}), expected_count)
        self.assertEqual(len([c for c in self.all_cases if c.params.get('target')=='comment_target_function_fresh']),4)
        for target in ('comment_target_enum_fresh', 'comment_target_composite_fresh', 'comment_target_aggregate_fresh', 'comment_target_rule_fresh'):
            self.assertEqual(len([c for c in self.all_cases if c.params.get('target') == target]), 4)
        for fid, (manifests, count) in EXPECTED.items():
            self.assertEqual(len(self.registry.factors[fid].manifest_refs), manifests)
            self.assertEqual(len(self.cases(fid)), count)
        for cases, report in self.results.values():
            self.assertTrue(cases)
            self.assertEqual(report.missing_pairs, [])
            self.assertEqual(report.feasible_pair_count, report.covered_pair_count)

    def test_independent_pairwise_projection(self):
        for fid, suite in [("create_function", "sql_options"), ("create_aggregate", "modern"),
                           ("create_text_search_configuration", "ngram_options"),
                           ("comment", "table_and_columns"), ("rename_table", "ordinary")]:
            mid = f"manifest_{fid}_{suite}"
            m = self.registry.manifests[mid]
            keys = sorted(m.bindings)
            rows = [dict(zip(keys, vs)) for vs in itertools.product(*(m.bindings[k] for k in keys))]
            actual = [{k: c.params[k] for k in keys} for c in self.cases(fid, suite)]
            self.assertEqual(pairs(rows), pairs(actual), mid)

    def test_statements_are_terminated_and_not_raw_bnf(self):
        for c in self.all_cases:
            for sql in c.setup_sqls + [c.sql] + c.teardown_sqls:
                self.assertTrue(sql.rstrip().endswith(";"), (c.case_id, sql))
                self.assertNotRegex(sql, r"\{[a-z_]+\}|\[\s*(?:IF|OR|CASCADE)|\.\.\.")
                self.assertNotIn("gaussdb=#", sql)

    def test_no_dangerous_fixture_shortcuts(self):
        for c in self.all_cases:
            sql = "\n".join(c.setup_sqls + [c.sql] + c.teardown_sqls)
            dedicated_comment_object = (
                c.factor_id == "comment"
                and any(name in sql for name in (
                    "g_comment_role", "g_comment_database", "g_comment_tbspc"
                ))
            )
            if not dedicated_comment_object:
                self.assertNotRegex(sql.upper(), r"\b(?:CREATE|ALTER|DROP) (?:ROLE|USER|DATABASE|TABLESPACE)\b")
            else:
                self.assertTrue(any(s.startswith("CREATE ") for s in c.setup_sqls))
                self.assertTrue(any(s.startswith("DROP ") for s in c.teardown_sqls))
            self.assertNotIn("DROP OWNED", sql.upper())
            self.assertNotIn("EXCEPTION WHEN", sql.upper())
            self.assertNotIn("file://", sql)
            self.assertNotIn("SECURITY DEFINER", sql.upper())

    def test_no_fake_database_expected_success(self):
        for c in self.all_cases:
            if c.expected == "success":
                self.assertEqual(c.expected_scope, "syntax_only")
            else:
                self.assertEqual(c.expected_oracle_status, "needs_verification")
                self.assertTrue(c.expected_error_category)
                self.assertFalse(c.expected_sqlstates)
                self.assertFalse(c.expected_error_regex)

    def test_actual_dependency_dag_and_fixture_topology(self):
        graph = self.registry.factor_dependency_graph()
        for child, provider in [
            ("call", "create_function"), ("create_aggregate", "create_function"),
            ("alter_aggregate", "create_aggregate"),
            ("alter_text_search_configuration", "create_text_search_configuration"),
            ("alter_text_search_configuration", "create_text_search_dictionary"),
            ("refresh_incremental_materialized_view", "create_incremental_materialized_view"),
        ]:
            self.assertIn(provider, graph[child])
        order = self.registry.fixture_topological_order(["fixture_create_aggregate_sum"])
        self.assertLess(order.index("fixture_create_function_callable"), order.index("fixture_create_aggregate_sum"))
        c, = self.cases("refresh_incremental_materialized_view", "incremental")
        self.assertLess(next(i for i, s in enumerate(c.setup_sqls) if s.startswith("CREATE TABLE")),
                        next(i for i, s in enumerate(c.setup_sqls) if s.startswith("CREATE INCREMENTAL")))
        self.assertTrue(c.teardown_sqls[1].startswith("DROP MATERIALIZED VIEW"), c.teardown_sqls)

    def test_function_replace_has_existing_function_but_new_creation_does_not(self):
        for c in self.cases("create_function", "sql_options"):
            self.assertFalse(any(s.startswith("CREATE FUNCTION fp_cf_add") for s in c.setup_sqls))
            self.assertIn("RETURNS INTEGER LANGUAGE SQL", c.sql)
            self.assertIn("AS 'SELECT $1 + $2;'", c.sql)
            self.assertNotIn("OUT", c.sql)
        c, = self.cases("create_function", "replace_existing")
        self.assertTrue(c.sql.startswith("CREATE OR REPLACE FUNCTION fp_cf_replace"))
        self.assertTrue(any(s.startswith("CREATE FUNCTION fp_cf_replace") for s in c.setup_sqls))

    def test_alter_function_branch_order_and_compile(self):
        for c in self.cases("alter_function", "attributes"):
            self.assertRegex(c.sql, r"ALTER FUNCTION fp_cf_callable \(.+\) .+;")
            self.assertNotIn("ROWS ", c.sql)
        c, = self.cases("alter_function", "compile")
        self.assertEqual(c.sql, "ALTER FUNCTION fp_cf_callable COMPILE;")
        for c in self.cases("alter_function", "schema"):
            self.assertTrue(any(s == "CREATE SCHEMA fp_af_schema;" for s in c.setup_sqls))
            self.assertIn("SET SCHEMA fp_af_schema;", c.sql)

    def test_drop_function_behavior_only_with_signature(self):
        for c in self.cases("drop_function"):
            if "CASCADE" in c.sql or "RESTRICT" in c.sql:
                self.assertIn("(INTEGER", c.sql) if "num1" not in c.sql else self.assertIn("(num1", c.sql)
        for c in self.cases("drop_function", "missing"):
            self.assertIn("IF EXISTS fp_df_missing", c.sql)

    def test_call_uses_real_named_inputs_and_no_placeholder(self):
        calls = {c.sql for c in self.cases("call")}
        self.assertIn("CALL fp_cf_callable (1, 3);", calls)
        self.assertIn("CALL fp_cf_callable (num2 := 3, num1 := 1);", calls)
        for c in self.cases("call"):
            self.assertTrue(any("CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER)" in s for s in c.setup_sqls))

    def test_aggregate_transition_contract_and_legacy_branch(self):
        for c in self.cases("create_aggregate"):
            self.assertIn("SFUNC = fp_cf_callable", c.sql)
            self.assertIn("STYPE = INTEGER", c.sql)
            self.assertTrue(any("fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER" in s for s in c.setup_sqls))
            self.assertNotIn("SFUNC1", c.sql)
        for c in self.cases("create_aggregate", "legacy"):
            self.assertIn("(BASETYPE = INTEGER", c.sql)
            self.assertNotIn("SHIPPABLE", c.sql)

    def test_all_text_search_manifests_have_internal_gate(self):
        for mid in self.results:
            m = self.registry.manifests[mid]
            if "text_search" not in m.factor_ref:
                continue
            keys = {r.key for r in m.environment_requirements}
            self.assertIn("internal_text_search_testing", keys, mid)
            if "dictionary" in m.factor_ref or m.factor_ref == "alter_text_search_configuration":
                self.assertIn("sysadmin", keys, mid)

    def test_config_parser_copy_exclusion_and_ngram_limits(self):
        for c in self.cases("create_text_search_configuration"):
            self.assertNotEqual("PARSER =" in c.sql, "COPY =" in c.sql)
            if "gram_size =" in c.sql:
                self.assertIn(int(re.search(r"gram_size = (\d+)", c.sql).group(1)), (1, 2, 3, 4))
                self.assertNotIn("PARSER = default", c.sql)
        self.assertTrue(any("COPY = fp_tsc_copy" in c.sql for c in self.cases("create_text_search_configuration")))

    def test_mapping_fixture_is_consumed_before_replace(self):
        for c in self.cases("alter_text_search_configuration", "mapping"):
            if "REPLACE simple WITH fp_tsd_simple" in c.sql:
                self.assertTrue(any("ADD MAPPING FOR word WITH simple" in s for s in c.setup_sqls))
                self.assertTrue(any("CREATE TEXT SEARCH DICTIONARY fp_tsd_simple" in s for s in c.setup_sqls))
        for c in self.cases("alter_text_search_dictionary"):
            self.assertNotIn("ALTER TEXT SEARCH DICTIONARY simple ", c.sql)

    def test_alter_mv_does_not_invent_schema_or_structure_branch(self):
        for c in self.cases("alter_materialized_view"):
            self.assertNotIn("SET SCHEMA", c.sql)
            self.assertNotRegex(c.sql, r"ADD COLUMN|DROP COLUMN|ALTER COLUMN")
            self.assertIn("RENAME", c.sql)

    def test_comment_null_is_not_string_null_and_quotes_survive(self):
        sql = {c.sql for c in self.cases("comment")}
        self.assertIn("COMMENT ON TABLE t_comment_source IS NULL;", sql)
        self.assertIn("COMMENT ON TABLE t_comment_source IS 'owner''s note';", sql)
        self.assertNotIn("COMMENT ON TABLE t_comment_source IS 'NULL';", sql)

    def test_plan_labels_measure_bytes_and_session_gate(self):
        for c in self.cases("explain_plan"):
            m = re.search(r"STATEMENT_ID = '([^']*)'", c.sql)
            if m:
                n = len(m.group(1).encode("ascii"))
                self.assertLessEqual(n, 30) if c.expected == "success" else self.assertEqual(n, 31)
        for mid in self.registry.factors["explain_plan"].manifest_refs:
            gate = self.registry.manifests[mid].environment_requirements
            self.assertTrue(any(r.key == "execution_session" and r.allowed_values == ["fresh_dedicated"] for r in gate))
        ledger = self.registry.source_ledgers["source_ledger_explain_plan"]
        self.assertTrue(any(s.catalog_chapter_ref.source_relpath.endswith("/plan_table.txt") for s in ledger.supplemental_sources))

    def test_rename_table_keyword_independent_of_repeat_count(self):
        sql = {c.sql for c in self.cases("rename_table")}
        self.assertEqual(sql, {
            f"RENAME {keyword} {targets};"
            for keyword in ("TABLE", "TABLES")
            for targets in ("t_rename_one TO t_renamed_one",
                            "t_rename_one TO t_renamed_one, t_rename_two TO t_renamed_two")
        })
