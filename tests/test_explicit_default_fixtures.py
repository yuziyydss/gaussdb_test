"""Declared DEFAULT inputs must reach real fixture SQL, not only profile labels."""
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write, inspect_lifecycle


ROOT = Path(__file__).resolve().parents[1]


class ExplicitDefaultFixtureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def cases_for(self, factor):
        manifest_id = f"manifest_{factor}_declared_default_positive"
        self.assertIn(manifest_id, self.registry.factors[factor].manifest_refs)
        manifest = self.registry.manifests[manifest_id]
        self.assertEqual(manifest.status, "needs_review")
        cases, report = self.generator.generate_with_report(manifest)
        self.assertTrue(cases)
        self.assertTrue(report.pairwise_complete, report.to_dict())
        self.assertEqual(len(cases), len({case.case_id for case in cases}))
        for case in cases:
            self.assertEqual(case.expected, "success")
            self.assertEqual(case.expected_scope, "syntax_only")
            self.assertEqual(case.setup_sqls[0], "BEGIN;")
            self.assertEqual(case.teardown_sqls, ["ROLLBACK;"])
            self.assertEqual(inspect_lifecycle(case.setup_sqls, case.teardown_sqls)["status"],
                             "transaction_scoped")
            self.assertNotIn("DROP ", " ".join(case.setup_sqls).upper())
            self.assertNotIn("COMMIT", " ".join(case.setup_sqls).upper())
            # Approved finite constants now have a shared static contract, not
            # a general default evaluator or runtime/manifest status upgrade.
            result = inspect_write(case.sql, case.setup_sqls)
            self.assertEqual(result["status"], "checked", result)
            self.assertEqual(result["scope"], "finite_write_shape_only")
            self.assertIn('shared_constant_or_null_defaults', result['checks'])
        return cases

    def test_insert_declared_default_reaches_ddl_and_all_input_branches(self):
        cases = self.cases_for("insert")
        self.assertEqual({case.params["source_profile"] for case in cases}, {
            "insert_source_default_values", "insert_source_values_with_default",
            "insert_source_value_many",
        })
        for case in cases:
            self.assertIn("t_insert_declared_defaults", case.sql)
            ddl = next(sql for sql in case.setup_sqls if sql.startswith("CREATE TABLE"))
            self.assertIn("id INTEGER DEFAULT 701", ddl)
            self.assertIn("note VARCHAR(64) DEFAULT 'declared'", ddl)

    def test_update_default_changes_a_seeded_non_default_value(self):
        cases = self.cases_for("update")
        for case in cases:
            self.assertIn("UPDATE t_update_declared_defaults SET note = DEFAULT", case.sql)
            self.assertIn("WHERE id = 2", case.sql)
            self.assertIn("CREATE TABLE t_update_declared_defaults (id INTEGER NOT NULL, "
                          "note VARCHAR(64) DEFAULT 'declared', qty INTEGER DEFAULT 7);", case.setup_sqls)
            self.assertIn("INSERT INTO t_update_declared_defaults (id, note, qty) "
                          "VALUES (2, 'before', 99);", case.setup_sqls)
        fixture = self.registry.fixtures["fixture_update_declared_defaults"]
        self.assertEqual(fixture.seed.rows, [{"id": 2, "note": "before", "qty": 99}])

    def test_original_no_declared_default_cases_are_preserved(self):
        for factor in ("insert", "update"):
            cases = self.generator.generate_cases_for_manifest(
                self.registry.manifests[f"manifest_{factor}_core_positive"])
            for case in cases:
                for sql in case.setup_sqls:
                    if sql.startswith("CREATE TABLE"):
                        self.assertNotIn("DEFAULT", sql)
            self.assertTrue(any("DEFAULT" in case.sql for case in cases))


if __name__ == "__main__":
    unittest.main()
