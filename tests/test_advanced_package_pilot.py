"""Advanced package interface contracts stay static and runtime-honest."""
from pathlib import Path
import unittest

from core.advanced_package import (
    AdvancedPackageLoadError,
    AdvancedPackagePlanner,
    AdvancedPackageRegistry,
)

ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackagePilotTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = AdvancedPackageRegistry(ROOT)
        cls.registry.load_all()
        cls.planner = AdvancedPackagePlanner(cls.registry)

    def test_three_pilot_packages_have_complete_interface_inventory(self):
        self.assertEqual(set(self.registry.packages), {"dbe_output", "dbe_raw", "dbe_sql"})
        self.assertEqual(len(self.registry.interfaces), 46)
        self.assertEqual(len(self.registry.interfaces_for_package("dbe_output")), 10)
        self.assertEqual(len(self.registry.interfaces_for_package("dbe_raw")), 22)
        self.assertEqual(len(self.registry.interfaces_for_package("dbe_sql")), 14)

    def test_sources_and_facts_are_traceable_and_confirmed(self):
        for package in self.registry.packages.values():
            with self.subTest(package=package.id):
                source = ROOT / package.source.source_relpath
                self.assertTrue(source.is_file())
                self.assertTrue(package.source.anchor)
        for interface in self.registry.interfaces.values():
            with self.subTest(interface=interface.call_name):
                self.assertTrue(interface.fact_refs)
                for fact_id in interface.fact_refs:
                    self.assertEqual(self.registry.fact_statuses[fact_id], "confirmed")

    def test_interface_signatures_preserve_documented_parameters(self):
        expected = {
            "adv_dbe_output_print_line": "DBE_OUTPUT.PRINT_LINE(format IN VARCHAR2)",
            "adv_dbe_output_set_buffer_size": (
                "DBE_OUTPUT.SET_BUFFER_SIZE(size IN INTEGER DEFAULT 20000)"
            ),
            "adv_dbe_raw_cast_from_binary_integer_to_raw": (
                "DBE_RAW.CAST_FROM_BINARY_INTEGER_TO_RAW(value IN BIGINT, "
                "endianess IN INTEGER DEFAULT 1) RETURN RAW"
            ),
            "adv_dbe_sql_set_sql": (
                "DBE_SQL.SQL_SET_SQL(context_id IN INTEGER, query_string IN TEXT, "
                "language_flag IN INTEGER) RETURN BOOLEAN"
            ),
        }
        for interface_id, signature in expected.items():
            self.assertEqual(self.registry.interfaces[interface_id].signature(), signature)

    def test_runtime_candidates_keep_oracles_unverified(self):
        self.assertEqual(len(self.registry.test_cases), 5)
        for test_case in self.registry.test_cases.values():
            with self.subTest(case=test_case.id):
                self.assertEqual(test_case.status, "runtime_candidate")
                self.assertEqual(test_case.oracle.status, "needs_verification")
                self.assertNotIn("DBMS_", test_case.sql)
                for forbidden in ("DROP ", "TRUNCATE ", "ALTER SYSTEM", "ALTER DATABASE"):
                    self.assertNotIn(forbidden, test_case.sql)
                for interface_id in test_case.interface_refs:
                    call_name = self.registry.interfaces[interface_id].call_name
                    self.assertIn(call_name, test_case.sql)

    def test_dbe_sql_lifecycle_closes_context_on_normal_and_exception_paths(self):
        case = self.registry.test_cases["adv_case_dbe_sql_select_lifecycle"]
        self.assertTrue(case.cleanup_required)
        self.assertIn("adv_dbe_sql_register_context", case.interface_refs)
        self.assertIn("adv_dbe_sql_unregister_context", case.interface_refs)
        self.assertEqual(case.sql.count("DBE_SQL.SQL_UNREGISTER_CONTEXT"), 2)
        self.assertIn("EXCEPTION", case.sql)
        self.assertIn("DBE_SQL.IS_ACTIVE", case.sql)

    def test_planner_returns_package_cases_and_rejects_manual_review(self):
        for package_id, expected_count in (
            ("dbe_output", 2), ("dbe_raw", 2), ("dbe_sql", 1)
        ):
            with self.subTest(package=package_id):
                cases = self.planner.plan_package(package_id)
                self.assertEqual(len(cases), expected_count)
                self.assertTrue(all(case.package_ref == package_id for case in cases))
        self.assertIn(
            "DBE_RAW.CAST_FROM_VARCHAR2_TO_RAW(str IN VARCHAR2) RETURN RAW",
            self.planner.plan_interface("adv_dbe_raw_cast_from_varchar2_to_raw"),
        )
        with self.assertRaisesRegex(ValueError, "manual_review"):
            self.planner.plan_interface("adv_dbe_raw_convert")
        with self.assertRaisesRegex(ValueError, "unknown advanced package"):
            self.planner.plan_package("dbms_not_supported")

    def test_source_hash_drift_fails_closed(self):
        original = self.registry.packages["dbe_output"].model_copy(deep=True)
        drifted = original.model_copy(
            update={"source": original.source.model_copy(update={"source_sha256": "0" * 64})}
        )
        broken = self.registry.environment.model_copy(
            update={
                "packages": [
                    drifted if package.id == "dbe_output" else package
                    for package in self.registry.environment.packages
                ]
            }
        )
        # Rebuild an in-memory registry without touching the source file.
        class TempRegistry(AdvancedPackageRegistry):
            def load_all(self):
                self.packages.clear()
                self.interfaces.clear()
                self.test_cases.clear()
                self.fact_statuses.clear()
                errors = []
                for package in broken.packages:
                    source_path = self.root / package.source.source_relpath
                    actual = source_path.read_bytes()
                    import hashlib
                    if hashlib.sha256(actual).hexdigest() != package.source.source_sha256:
                        errors.append(f"{package.id}: source hash drift")
                if errors:
                    raise AdvancedPackageLoadError(errors)

        with self.assertRaises(AdvancedPackageLoadError) as caught:
            TempRegistry(ROOT).load_all()
        self.assertIn("source hash drift", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
