"""GUC candidate matrix turns V2 references into a fail-closed review queue."""
import unittest
from pathlib import Path

from core.guc_candidate import GucCandidateLoadError, GucCandidateRegistry


ROOT = Path(__file__).resolve().parents[1]


class GucCandidateMatrixTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.matrix = GucCandidateRegistry(ROOT).load()

    def test_matrix_classifies_all_v2_parameters(self):
        summary = self.matrix.summary
        self.assertEqual(self.matrix.schema_version, 1)
        self.assertEqual(self.matrix.kind, "guc_candidate_matrix")
        self.assertEqual(summary.parameter_count, 1175)
        self.assertEqual(summary.occurrence_count, 1177)
        self.assertEqual(summary.disposition_counts, {
            "boolean_session_candidate": 158,
            "context_not_user_set": 753,
            "duplicate_definition_requires_review": 2,
            "pilot_already_modeled": 20,
            "reserved_or_deprecated": 4,
            "value_domain_model_required": 238,
        })
        self.assertEqual(summary.boolean_session_candidate_count, 158)
        self.assertEqual(summary.fact_backed_candidate_count, 7)
        self.assertEqual(summary.unverified_fact_candidate_count, 1)
        self.assertEqual(summary.next_batch_count, 7)

    def test_next_batch_contains_only_confirmed_fact_backed_boolean_userset_parameters(self):
        expected = {
            "a_format_enable_copy_empty_lobs",
            "enable_copy_case_sensitive",
            "enable_copy_when_filler",
            "enable_log_copy_illegal_chars",
            "enable_plan_trace",
            "enable_save_datachanged_timestamp",
            "track_procedure_sql",
        }
        self.assertEqual({item.name for item in self.matrix.next_batch}, expected)
        for item in self.matrix.next_batch:
            with self.subTest(parameter=item.name):
                self.assertTrue(item.confirmed_fact_refs)
                self.assertFalse(item.unverified_fact_refs)
                self.assertIn("on", item.value_domain)
                self.assertIn("off", item.value_domain)
                self.assertTrue(item.source_anchor)
        by_name = {item.name: item for item in self.matrix.parameters}
        self.assertTrue(all(by_name[name].next_batch for name in expected))

    def test_needs_verification_fact_does_not_enter_next_batch(self):
        by_name = {item.name: item for item in self.matrix.parameters}
        td = by_name["td_compatible_truncation"]
        self.assertEqual(td.disposition, "boolean_session_candidate")
        self.assertTrue(td.unverified_fact_refs)
        self.assertFalse(td.confirmed_fact_refs)
        self.assertFalse(td.next_batch)
        self.assertEqual(
            {item.name for item in self.matrix.deferred_unverified_facts},
            {"td_compatible_truncation"},
        )

    def test_duplicates_and_reserved_parameters_are_reviewed_before_eligibility(self):
        by_name = {item.name: item for item in self.matrix.parameters}
        self.assertEqual(
            by_name["enable_hypo_index"].disposition,
            "duplicate_definition_requires_review",
        )
        self.assertEqual(
            by_name["unix_socket_directory"].disposition,
            "duplicate_definition_requires_review",
        )
        self.assertEqual(
            by_name["enable_adio_debug"].disposition,
            "reserved_or_deprecated",
        )

    def test_matrix_is_bound_to_v2_reference_and_runtime_fact_sources(self):
        source = self.matrix.source
        self.assertEqual(
            source.reference_catalog_relpath,
            "generated/guc_reference_catalog/catalog.json",
        )
        self.assertEqual(len(source.runtime_fact_files), 12)
        self.assertEqual(sum(item.fact_count for item in source.runtime_fact_files), 174)
        self.assertTrue(all(len(item.sha256) == 64 for item in source.runtime_fact_files))

    def test_generated_matrix_fails_closed_on_summary_drift(self):
        payload = self.matrix.model_dump()
        payload["summary"]["next_batch_count"] += 1
        registry = GucCandidateRegistry(ROOT)
        with self.assertRaises(GucCandidateLoadError) as caught:
            registry.load_payload(payload)
        self.assertIn("summary", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
