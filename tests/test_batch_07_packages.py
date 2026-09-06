"""Batch 07 finite domains and safety boundaries, no database."""
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


class Batch07Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.plan = json.loads((ROOT / "tests/data/batch_07.json").read_text())
        cls.factors = {f.id: f for f in cls.registry.factors.values()
                       if f.name in cls.plan["new_chapters"]}

    def cases(self, manifest):
        return self.generator.generate_with_report(self.registry.manifests[manifest])[0]

    def test_empty_type_lists_follow_optional_grammar(self):
        composite = self.cases("manifest_create_type_composite")
        enum = self.cases("manifest_create_type_enum")
        self.assertEqual(len(composite), 3)
        self.assertEqual(len(enum), 4)
        self.assertTrue(any(re.search(r" AS \(\s*\);$", c.sql) for c in composite))
        self.assertTrue(any(re.search(r" AS ENUM \(\s*\);$", c.sql) for c in enum))

    def test_extension_member_cleanup_does_not_repeat_target(self):
        cases = self.cases("manifest_alter_extension_drop_member")
        for c in cases:
            self.assertIn("DROP TABLE ext_b7_member", c.sql)
            self.assertTrue(all(s.strip().upper() == "ROLLBACK;" for s in c.teardown_sqls),
                            c.teardown_sqls)

    def test_documented_no_language_syntax_is_not_invented(self):
        for fid in ("create_language", "alter_language", "drop_language"):
            f = self.factors[fid]
            self.assertEqual(f.manifest_refs, [])
            self.assertEqual(f.dimensions, {})
            self.assertEqual(self.registry.syntaxes[f.syntax_ref].status, "draft")
            self.assertTrue(any(x.type == "environment" and x.status == "confirmed"
                                for x in f.facts))

    def test_unreviewed_internal_functions_are_not_positive(self):
        for fid in ("create_conversion", "create_operator_class"):
            f = self.factors[fid]
            self.assertEqual(f.manifest_refs, [])
            for d in f.dimensions.values():
                self.assertTrue(all(v.validity in ("conditional", "unknown")
                                    for cl in d.classes for v in cl.values))

    def test_all_new_manifest_pairs_independently(self):
        for f in self.factors.values():
            for mid in f.manifest_refs:
                m = self.registry.manifests[mid]
                cases, report = self.generator.generate_with_report(m)
                keys = sorted(m.bindings)
                expected = set()
                for values in itertools.product(*(m.bindings[k] for k in keys)):
                    expected.update(itertools.combinations(zip(keys, values), 2))
                actual = set()
                for c in cases:
                    actual.update(itertools.combinations([(k, c.params[k]) for k in keys], 2))
                self.assertEqual(actual, expected, mid)
                self.assertEqual(report.missing_pairs, [])
                self.assertEqual(report.feasible_pair_count, report.covered_pair_count)

    def test_all_new_sql_has_no_secret_or_document_metasyntax(self):
        seen = set()
        for f in self.factors.values():
            for mid in f.manifest_refs:
                for c in self.cases(mid):
                    self.assertNotIn(c.case_id, seen)
                    seen.add(c.case_id)
                    self.assertEqual(c.expected_scope, "syntax_only")
                    for s in c.setup_sqls + [c.sql] + c.teardown_sqls:
                        self.assertTrue(s.endswith(";"), s)
                        self.assertNotRegex(s, r"\{[a-z_]+\}|\.\.\.|gaussdb=#|\*{4}")
                        self.assertNotRegex(s.upper(), r"\bPASSWORD\b|DROP OWNED|EXCEPTION WHEN")
                        self.assertNotRegex(s.upper(), r"^\s*(?:CREATE|ALTER|DROP) (?:ROLE|USER)\b(?! MAPPING)")
                        self.assertNotIn("plpgsql UPDATE", s)
                        self.assertNotIn("security_plugin", s)

    def test_operator_arity_matches_declared_function(self):
        for c in self.cases("manifest_create_operator_arity"):
            if c.params["arity"].endswith("_binary"):
                self.assertIn("fp_cf_callable", c.sql)
                self.assertIn("LEFTARG = INTEGER", c.sql)
                self.assertIn("RIGHTARG = INTEGER", c.sql)
            else:
                self.assertIn("op_b7_unary", c.sql)
                self.assertEqual(c.sql.count("ARG = INTEGER"), 1)

    def test_mapping_user_option_exists_before_set_drop(self):
        for c in self.cases("manifest_alter_user_mapping_non_secret"):
            setup = "\n".join(c.setup_sqls)
            self.assertIn("CREATE SERVER srv_map_b7", setup)
            self.assertIn("FOR CURRENT_USER SERVER srv_map_b7 OPTIONS (user ", setup)
            self.assertIn("FOR PUBLIC SERVER srv_map_b7 OPTIONS (user ", setup)
            self.assertIn("ROLLBACK;", c.teardown_sqls)

    def test_directory_replace_has_existing_state_and_gates(self):
        c = self.cases("manifest_create_directory_replace")[0]
        self.assertTrue(any(s.startswith("CREATE DIRECTORY dir_b7 ") for s in c.setup_sqls))
        m = self.registry.manifests["manifest_create_directory_replace"]
        self.assertEqual({g.key for g in m.environment_requirements},
                         {"directory_creator_authorized", "pdb_context",
                          "approved_isolated_directory_path"})

    def test_enum_alter_uses_autocommit_fixture(self):
        for c in self.cases("manifest_alter_type_enum_add"):
            self.assertFalse(any(s.strip().upper().startswith("BEGIN") for s in c.setup_sqls))
            self.assertTrue(any(s.startswith("CREATE TYPE type_enum_alter_b7 AS ENUM")
                                for s in c.setup_sqls))
            self.assertTrue(any(s.startswith("DROP TYPE IF EXISTS type_enum_alter_b7")
                                for s in c.teardown_sqls))

    def test_doc_hashes_and_source_ledger_lines(self):
        catalog_path = ROOT / self.plan["source_catalog"]
        if not catalog_path.exists():
            self.skipTest("Local PDF corpus is not included in public checkout")
        catalog = json.loads(catalog_path.read_text())
        chapters = {c["title"]: c for c in catalog["chapters"]}
        self.assertEqual(len(self.factors), 26)
        for f in self.factors.values():
            ch = chapters[f.name]
            raw = (catalog_path.parent / ch["source_relpath"]).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), f.source.artifact_sha256)
            ledger = self.registry.source_ledgers[f.source_ledger_ref]
            self.assertEqual(ledger.source_line_count, len(raw.decode().splitlines()))
            self.assertEqual(ledger.artifact_sha256, f.source.artifact_sha256)

    def test_all_new_cases_are_unique_within_factor(self):
        for f in self.factors.values():
            sqls = [c.sql for mid in f.manifest_refs for c in self.cases(mid)]
            self.assertEqual(len(sqls), len(set(sqls)), f.id)

    def test_source_units_and_consumers_are_audited(self):
        auditor = FactorCoverageAuditor(self.registry)
        for fid in self.factors:
            audit = auditor.audit(fid)
            self.assertEqual(audit["source_units"]["atomicity"]["gaps"], [], fid)
            self.assertTrue(audit["conclusions"]["source_extraction_complete"], fid)
            self.assertEqual(audit["facts"]["unconsumed_confirmed"], [], fid)
            self.assertEqual(audit["facts"]["wrong_consumer_type"], [], fid)
            self.assertFalse(audit["conclusions"]["behavior_coverage_complete"], fid)


if __name__ == "__main__":
    unittest.main()
