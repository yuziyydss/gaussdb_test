"""Phase 1 execution reports are audited before runtime claims are accepted."""
import copy
import json
import tempfile
import unittest
from pathlib import Path

from core.phase1_report_audit import audit_phase1_report


def result(index, stage="target", status="PASS"):
    return {
        "id": "P1-SETUP" if stage == "setup" else "P1-CLEANUP" if stage == "teardown" else f"P1-{index:03d}",
        "desc": "setup" if stage == "setup" else "cleanup" if stage == "teardown" else f"target {index}",
        "sql": "SELECT 1;",
        "expected": {"kind": "command", "tags": ["SELECT 1"]},
        "actual": "SELECT 1",
        "status": status,
        "error": "",
        "stage": stage,
        "returncode": 0,
    }


def report(results=None):
    results = results or [result(0, "setup")] + [result(i) for i in range(1, 11)] + [result(11, "teardown")]
    passed = sum(item["status"] == "PASS" for item in results)
    failed = sum(item["status"] == "FAIL" for item in results)
    blocked = sum(item["status"] == "BLOCKED" for item in results)
    executed = sum(item["returncode"] is not None for item in results)
    return {
        "summary": {
            "total": len(results),
            "passed": passed,
            "failed": failed,
            "blocked": blocked,
            "executed": executed,
            "pass_rate": f"{passed * 100 // len(results)}%",
            "database": "host:5432/db",
            "user": "user",
            "start": "2026-09-24T00:00:00",
            "end": "2026-09-24T00:01:00",
            "duration_sec": 60.0,
        },
        "environment": {"version": "GaussDB"},
        "results": results,
    }


class Phase1ReportAuditTests(unittest.TestCase):
    def test_valid_full_pass_report_is_runtime_verified(self):
        audit = audit_phase1_report(report())
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.runtime_verified)
        self.assertEqual(audit.summary, {
            "total": 12, "passed": 12, "failed": 0, "blocked": 0, "executed": 12,
        })

    def test_missing_cleanup_is_not_runtime_verified(self):
        payload = report(results=[result(0, "setup")] + [result(i) for i in range(1, 11)])
        payload["summary"]["total"] = 11
        audit = audit_phase1_report(payload)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.runtime_verified)
        self.assertTrue(any("exactly one setup and one teardown" in error for error in audit.errors), audit.errors)

    def test_count_mismatch_is_rejected(self):
        payload = report()
        payload["summary"]["passed"] = 11
        audit = audit_phase1_report(payload)
        self.assertFalse(audit.valid)
        self.assertIn("passed count mismatch", audit.errors[0])

    def test_blocked_target_requires_prior_failure(self):
        payload = report()
        payload["results"][2]["status"] = "BLOCKED"
        payload["summary"]["passed"] = 11
        payload["summary"]["blocked"] = 1
        audit = audit_phase1_report(payload)
        self.assertFalse(audit.valid)
        self.assertIn("BLOCKED without a prior target/setup failure", audit.errors[0])

    def test_target_failure_prevents_runtime_verification(self):
        payload = report()
        payload["results"][2]["status"] = "FAIL"
        payload["results"][2]["error"] = "target failed"
        payload["summary"]["passed"] = 11
        payload["summary"]["failed"] = 1
        audit = audit_phase1_report(payload)
        self.assertTrue(audit.valid, audit.errors)
        self.assertFalse(audit.runtime_verified)

    def test_cli_audits_report_and_rejects_overwrite(self):
        import tempfile
        from scripts.audit_phase1_report import main as audit_main

        with tempfile.TemporaryDirectory() as directory:
            report_path = Path(directory) / "report.json"
            output_path = Path(directory) / "audit.json"
            report_path.write_text(json.dumps(report(), ensure_ascii=False) + "\n")
            audit_main(["--report", str(report_path), "--output", str(output_path)])
            payload = json.loads(output_path.read_text())
            self.assertTrue(payload["valid"])
            self.assertTrue(payload["runtime_verified"])
            with self.assertRaisesRegex(SystemExit, "already exists"):
                audit_main(["--report", str(report_path), "--output", str(output_path)])

if __name__ == "__main__":
    unittest.main()
