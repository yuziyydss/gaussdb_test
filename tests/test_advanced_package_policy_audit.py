"""Static coverage and execution-policy audit for expansion packages stays honest."""
import json
import unittest
from pathlib import Path

from core.advanced_package import AdvancedPackageRegistry
from core.advanced_package_policy_audit import (
    AUDITED_PACKAGE_IDS,
    build_advanced_package_policy_audit,
    verify_advanced_package_policy_audit,
)

ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackagePolicyAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.audit = build_advanced_package_policy_audit(ROOT)
        cls.registry = AdvancedPackageRegistry(ROOT)
        cls.registry.load_all()

    def test_expansion_packages_are_audited(self):
        self.assertEqual(len(self.audit.packages), 8)
        self.assertEqual({item.package_id for item in self.audit.packages}, AUDITED_PACKAGE_IDS)
        self.assertEqual(self.audit.summary.documented_callable_count, 99)
        self.assertEqual(self.audit.summary.modeled_callable_count, 99)
        self.assertEqual(self.audit.summary.documented_type_count, 10)
        self.assertEqual(self.audit.summary.modeled_type_count, 10)
        self.assertEqual(self.audit.summary.missing_callable_count, 0)
        self.assertEqual(self.audit.summary.missing_overload_count, 0)
        self.assertEqual(self.audit.summary.complete_package_count, 8)
        self.assertEqual(self.audit.summary.partial_package_count, 0)

    def test_partial_packages_have_explicit_gaps(self):
        packages = {item.package_id: item for item in self.audit.packages}
        self.assertEqual(packages["dbe_stats"].coverage_scope, "complete")
        self.assertEqual(packages["dbe_stats"].modeled_callable_count, 36)
        self.assertEqual(packages["dbe_stats"].missing_callable_count, 0)
        self.assertEqual(packages["dbe_xmldom"].coverage_scope, "complete")
        self.assertEqual(packages["dbe_xmldom"].modeled_callable_count, 41)
        self.assertEqual(packages["dbe_xmldom"].modeled_signature_count, 68)
        self.assertEqual(packages["dbe_xmldom"].missing_overload_count, 0)
        self.assertEqual(packages["dbe_xmldom"].missing_interfaces, [])

        for package_id in (
            "dbe_compression", "dbe_describe", "dbe_heat_map", "dbe_ilm",
            "dbe_ilm_admin", "dbe_xmlparser",
        ):
            with self.subTest(package=package_id):
                self.assertEqual(packages[package_id].coverage_scope, "complete")
                self.assertEqual(packages[package_id].missing_interfaces, [])

    def test_every_expansion_interface_has_one_policy_decision(self):
        expected_ids = {
            interface.id
            for package_id in AUDITED_PACKAGE_IDS
            for interface in self.registry.interfaces_for_package(package_id)
        }
        decision_ids = {item.interface_id for item in self.audit.decisions}
        self.assertEqual(len(self.audit.decisions), 136)
        self.assertEqual(decision_ids, expected_ids)
        self.assertEqual(self.audit.summary.static_type_count, 10)
        self.assertEqual(self.audit.summary.promote_after_case_design_count, 38)
        self.assertEqual(self.audit.summary.keep_manual_review_count, 82)
        self.assertEqual(self.audit.summary.block_for_runtime_pilot_count, 6)

        decision_by_id = {item.interface_id: item for item in self.audit.decisions}
        for item in self.audit.decisions:
            with self.subTest(interface=item.interface_id):
                self.assertEqual(
                    item.current_policy,
                    self.registry.interfaces[item.interface_id].execution_policy,
                )
                self.assertTrue(item.reasons)
                self.assertTrue(item.prerequisites)

        self.assertEqual(
            decision_by_id["adv_dbe_ilm_execute_ilm"].recommended_policy,
            "blocked",
        )
        self.assertEqual(
            decision_by_id["adv_dbe_ilm_admin_enable_ilm"].recommended_policy,
            "blocked",
        )
        self.assertEqual(
            decision_by_id["adv_dbe_xmlparser_newparser"].recommended_policy,
            "runtime_candidate",
        )
        self.assertEqual(
            decision_by_id["adv_dbe_stats_get_stats_history_retention"].recommended_policy,
            "runtime_candidate",
        )
        self.assertEqual(
            decision_by_id["adv_dbe_describe_number_table"].recommended_policy,
            "static_probe",
        )

    def test_written_audit_is_current_and_verifiable(self):
        path = ROOT / "generated/advanced_package_pilot/policy_audit.json"
        self.assertTrue(path.is_file())
        result = verify_advanced_package_policy_audit(ROOT)
        self.assertEqual(result.summary.modeled_callable_count, 99)
        self.assertEqual(result.summary.recommended_runtime_candidate_count, 38)

    def test_verification_detects_stale_artifact(self):
        path = ROOT / "generated/advanced_package_pilot/policy_audit.json"
        original = path.read_text(encoding="utf-8")
        try:
            payload = json.loads(original)
            payload["summary"]["modeled_callable_count"] += 1
            path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "stale|invalid"):
                verify_advanced_package_policy_audit(ROOT)
        finally:
            path.write_text(original, encoding="utf-8")


if __name__ == "__main__":
    unittest.main()
