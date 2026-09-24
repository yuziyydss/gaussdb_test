"""Batch 08 PDF contracts and finite SQL; never connects to a database."""
import hashlib
import itertools
import json
import re
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class Batch08Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.plan = json.loads((ROOT / "tests/data/batch_08.json").read_text())
        cls.factors = {f.id: f for f in cls.registry.factors.values()
                       if f.name in cls.plan["new_chapters"]}

    def cases(self, mid):
        return self.generator.generate_with_report(self.registry.manifests[mid])[0]

    def test_batch_count_and_pdf_identity(self):
        self.assertEqual(len(self.factors), 25)
        path = ROOT / self.plan["source_catalog"]
        if not path.exists():
            self.skipTest("Local PDF corpus is not distributed")
        chapters = {c["title"]: c for c in json.loads(path.read_text())["chapters"]}
        for f in self.factors.values():
            raw = (path.parent / chapters[f.name]["source_relpath"]).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), f.source.artifact_sha256)
            self.assertEqual(self.registry.source_ledgers[f.source_ledger_ref].source_line_count,
                             len(raw.decode().splitlines()))

    def test_source_atomicity_and_fact_consumers(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid in self.factors:
            a = auditor.audit(fid)
            self.assertEqual(a["source_units"]["atomicity"]["gaps"], [], fid)
            self.assertTrue(a["conclusions"]["source_extraction_complete"], fid)
            self.assertEqual(a["facts"]["unconsumed_confirmed"], [], fid)
            self.assertEqual(a["facts"]["wrong_consumer_type"], [], fid)
            self.assertFalse(a["conclusions"]["behavior_coverage_complete"], fid)

    def test_only_runtime_bound_commands_have_no_manifest(self):
        expected_no_manifest = {"alter_system_kill_session", "lock_buckets", "mark_buckets"}
        self.assertEqual(
            {fid for fid, f in self.factors.items() if not f.manifest_refs},
            expected_no_manifest,
        )
        for fid, f in self.factors.items():
            self.assertEqual(f.status, "needs_review")

    def test_unsupported_bucket_commands_do_not_invent_syntax(self):
        for fid in ("lock_buckets", "mark_buckets"):
            f = self.factors[fid]
            self.assertFalse(f.dimensions)
            self.assertEqual(self.registry.syntaxes[f.syntax_ref].status, "draft")

    def test_pdb_import_ambiguity_and_danger_are_preserved(self):
        f = self.factors["impdp_pluggable_database_create"]
        self.assertTrue(any(x.type == "constraint" and x.status == "confirmed"
                            and "name_optional" in x.id for x in f.facts))
        self.assertTrue(any(x.type == "environment" and "异常重启" in x.statement
                            for x in f.facts))
        self.assertIn("{pdb_name}", self.registry.syntaxes[f.syntax_ref].production)

    def test_recover_uses_documented_database_keyword(self):
        syntax = self.registry.syntaxes[self.factors["impdp_recover"].syntax_ref]
        self.assertTrue(syntax.production.startswith("IMPDP DATABASE RECOVER "))

    def test_live_session_identifiers_are_not_hardcoded(self):
        f = self.factors["alter_system_kill_session"]
        syntax = self.registry.syntaxes[f.syntax_ref]
        self.assertIn("{session_sid}", syntax.production)
        self.assertIn("{session_serial}", syntax.production)
        self.assertFalse(f.manifest_refs)
        self.assertTrue(any(x.type == "open_question" and "runtime_binding" in x.id
                            for x in f.facts))

    def test_encoding_table_is_not_all_server_capability(self):
        d = self.factors["create_database"].dimensions["encoding"]
        values = [v for c in d.classes if c.id != 'create_database_encoding_c_template0_profiles' for v in c.values]
        self.assertEqual(len(values), 44)
        contextual = [v for c in d.classes if c.id == 'create_database_encoding_c_template0_profiles' for v in c.values]
        self.assertEqual(len(contextual), 37)
        self.assertEqual({v.properties['original_value_ref'] for v in contextual},
                         {v.id for v in values if v.validity == 'conditional'})
        unknown = {v.id.removeprefix("create_database_encoding_")
                   for v in values if v.validity == "unknown"}
        self.assertEqual(unknown, {"big5", "johab", "sjis", "shift_jis_2004", "uhc"})
        selected = self.registry.manifests["manifest_create_database_encoding_limit"].bindings["encoding"]
        self.assertEqual(set(selected), {"create_database_encoding_utf8",
                                         "create_database_encoding_latin1"})

    def test_database_connection_limit_is_power_not_pdf_flattening(self):
        values = self.factors["create_database"].dimensions["connection_limit"]
        renders = {v.render for c in values.classes for v in c.values}
        self.assertIn("2147483647", renders)
        self.assertNotIn("230", renders)
        for c in self.cases("manifest_create_database_encoding_limit"):
            self.assertIn("TEMPLATE = template0", c.sql)
            self.assertIn("LC_COLLATE = 'C'", c.sql)
            self.assertIn("LC_CTYPE = 'C'", c.sql)

    def test_database_ddl_is_not_wrapped_in_begin(self):
        for fid in ("create_database", "alter_database", "drop_database"):
            for mid in self.factors[fid].manifest_refs:
                for c in self.cases(mid):
                    self.assertTrue(c.environment_requirements)
                    self.assertFalse(any(re.match(r"\s*(BEGIN|START TRANSACTION)\b", s, re.I)
                                         for s in c.setup_sqls), mid)

    def test_database_rename_cleans_old_and_new_owned_names(self):
        c = self.cases("manifest_alter_database_rename")[0]
        self.assertIn("RENAME TO b8_database_renamed", c.sql)
        self.assertIn("DROP DATABASE IF EXISTS b8_database_renamed PURGE;", c.teardown_sqls)
        self.assertIn("DROP DATABASE IF EXISTS b8_database PURGE;", c.teardown_sqls)
        self.assertTrue(any("assert_rename_target_absent" in s for s in c.setup_sqls))

    def test_drop_database_is_gated_to_no_recyclebin(self):
        m = self.registry.manifests["manifest_drop_database_existing"]
        gates = {g.key: g.allowed_values for g in m.environment_requirements}
        self.assertEqual(gates["enable_db_recyclebin"], ["off"])
        self.assertEqual(gates["test_database_has_connections"], ["false"])

    def test_session_schema_refers_to_provided_schema(self):
        for mid in ("manifest_alter_session_schema", "manifest_alter_session_current_schema"):
            for c in self.cases(mid):
                self.assertIn("CREATE SCHEMA fp_cs_one;", c.setup_sqls)
                self.assertNotIn("fp_schema_a", c.sql)
                self.assertIn("BEGIN;", c.setup_sqls)
                self.assertIn("ROLLBACK;", c.teardown_sqls)

    def test_pair_projections_and_unique_candidate_sql(self):
        for f in self.factors.values():
            sqls = []
            for mid in f.manifest_refs:
                m = self.registry.manifests[mid]
                cases, report = self.generator.generate_with_report(m)
                keys = sorted(m.bindings)
                expected = set()
                for vs in itertools.product(*(m.bindings[k] for k in keys)):
                    expected.update(itertools.combinations(zip(keys, vs), 2))
                actual = {pair for c in cases for pair in
                          itertools.combinations([(k, c.params[k]) for k in keys], 2)}
                self.assertEqual(actual, expected, mid)
                self.assertEqual(report.missing_pairs, [], mid)
                sqls.extend(c.sql for c in cases)
            self.assertEqual(len(sqls), len(set(sqls)), f.id)

    def test_generated_envelopes_have_no_secrets_or_pdf_notation(self):
        for f in self.factors.values():
            for mid in f.manifest_refs:
                for c in self.cases(mid):
                    if mid == "manifest_create_database_client_encoding_negative":
                        self.assertEqual(c.expected_scope, "syntax_and_semantics")
                        self.assertEqual(c.expected, "error")
                        self.assertEqual(c.expected_oracle_status, "needs_verification")
                        self.assertEqual(c.expected_sqlstates, [])
                    else:
                        self.assertEqual(c.expected_scope, "syntax_only")
                    for sql in c.setup_sqls + [c.sql] + c.teardown_sqls:
                        self.assertTrue(sql.endswith(";"))
                        self.assertNotRegex(sql, r"\{[a-z_]+\}|\.\.\.|gaussdb=#|\*{4}")
                        self.assertNotRegex(sql.upper(), r"\bPASSWORD\b|DROP OWNED|EXCEPTION WHEN")


if __name__ == "__main__":
    unittest.main()
