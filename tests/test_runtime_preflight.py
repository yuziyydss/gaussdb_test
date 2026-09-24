"""Runtime preflight is read-only and does not execute target SQL."""
import unittest
from types import SimpleNamespace

from core.runtime_preflight import (
    PREFLIGHT_QUERIES,
    ScriptedPreflightTransport,
    run_preflight,
)


def ok(value):
    return SimpleNamespace(success=True, rows=[[value]], notices=[], error="")


def fail(error):
    return SimpleNamespace(success=False, rows=[], notices=[], error=error)


class RuntimePreflightTests(unittest.TestCase):
    def test_preflight_reads_connection_and_guc_metadata_only(self):
        transport = ScriptedPreflightTransport([
            ok("GaussDB 1.0"),
            ok("PG"),
            ok("on"),
            ok("off"),
            ok(""),
        ])
        result = run_preflight(transport)
        self.assertTrue(result.connected)
        self.assertTrue(result.metadata_read)
        self.assertFalse(result.target_sql_executed)
        self.assertFalse(result.guc_changed)
        self.assertFalse(result.object_created)
        self.assertEqual(len(result.queries), 5)
        self.assertEqual([q["key"] for q in result.queries], [
            "server_version",
            "sql_compatibility",
            "enable_seqscan",
            "default_transaction_read_only",
            "behavior_compat_options",
        ])
        self.assertEqual(result.queries[0]["value"], "GaussDB 1.0")
        self.assertEqual(result.queries[1]["value"], "PG")
        self.assertEqual(result.errors, [])
        self.assertEqual(
            [q["sql"] for q in result.queries],
            [q.sql for q in PREFLIGHT_QUERIES],
        )

    def test_preflight_reports_query_failure_without_faking_success(self):
        transport = ScriptedPreflightTransport([
            ok("GaussDB 1.0"),
            fail("parameter not found"),
            ok("on"),
            ok("off"),
            ok(""),
        ])
        result = run_preflight(transport)
        self.assertTrue(result.connected)
        self.assertFalse(result.metadata_read)
        self.assertEqual(result.errors, ["sql_compatibility: parameter not found"])
        self.assertEqual(result.queries[1]["status"], "error")
        self.assertIsNone(result.queries[1]["value"])

    def test_preflight_never_contains_target_sql_or_writes(self):
        for query in PREFLIGHT_QUERIES:
            self.assertTrue(query.sql.startswith("SELECT "))
            self.assertNotIn("SET ", query.sql)
            self.assertNotIn("INSERT ", query.sql)
            self.assertNotIn("UPDATE ", query.sql)
            self.assertNotIn("DELETE ", query.sql)
            self.assertNotIn("CREATE ", query.sql)
            self.assertNotIn("DROP ", query.sql)


if __name__ == "__main__":
    unittest.main()
