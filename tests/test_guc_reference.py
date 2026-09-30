"""GUC Reference Schema V2 is source-bound, explicit, and pilot-linked."""
import unittest
from pathlib import Path

from core.guc_reference import GucReferenceLoadError, GucReferenceRegistry


ROOT = Path(__file__).resolve().parents[1]


class GucReferenceSchemaV2Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.catalog = GucReferenceRegistry(ROOT).load()

    def test_v2_extracts_the_full_guc_chapter(self):
        summary = self.catalog.summary
        self.assertEqual(self.catalog.schema_version, 2)
        self.assertEqual(self.catalog.kind, "guc_reference_catalog")
        self.assertEqual(summary.definition_count, 1177)
        self.assertEqual(summary.parameter_count, 1175)
        self.assertEqual(summary.duplicate_name_count, 2)
        self.assertEqual(summary.section_count, 82)
        self.assertEqual(summary.reserved_name_count, 15)
        self.assertEqual(summary.deprecated_name_count, 35)
        self.assertEqual(summary.pilot_parameter_count, 20)
        self.assertEqual(summary.pilot_context_match_count, 20)

    def test_each_definition_keeps_required_raw_fields_and_provenance(self):
        for parameter in self.catalog.parameters:
            for occurrence in parameter.occurrences:
                with self.subTest(occurrence=occurrence.id):
                    self.assertTrue(occurrence.description)
                    self.assertTrue(occurrence.parameter_type)
                    self.assertTrue(occurrence.parameter_unit)
                    self.assertTrue(occurrence.value_domain)
                    self.assertTrue(occurrence.default_value)
                    self.assertTrue(occurrence.setting_method)
                    self.assertTrue(occurrence.recommendation)
                    self.assertTrue(occurrence.risk_impact)
                    self.assertTrue(occurrence.source_anchor)
                    self.assertTrue(occurrence.physical_pages)
                    self.assertIn(occurrence.context_status, {"explicit", "conditional", "unspecified"})

    def test_duplicate_names_are_not_silently_merged(self):
        by_name = {item.name: item for item in self.catalog.parameters}
        self.assertEqual(by_name["unix_socket_directory"].occurrence_count, 2)
        self.assertEqual(by_name["enable_hypo_index"].occurrence_count, 2)
        for parameter in self.catalog.parameters:
            self.assertEqual(parameter.occurrence_count, len(parameter.occurrences))
            self.assertEqual({item.name for item in parameter.occurrences}, {parameter.name})

    def test_v1_pilot_is_linked_and_contexts_agree(self):
        by_name = {item.name: item for item in self.catalog.parameters}
        self.assertEqual(len(self.catalog.pilot_links), 20)
        for link in self.catalog.pilot_links:
            with self.subTest(parameter=link.name):
                self.assertEqual(link.reference_id, by_name[link.name].id)
                self.assertTrue(link.context_matches)
                self.assertIn(link.pilot_context_type, link.reference_context_types)

    def test_wrapped_default_value_label_is_supported(self):
        occurrence = next(
            item
            for parameter in self.catalog.parameters
            for item in parameter.occurrences
            if parameter.name == "exec_behavior_knob"
        )
        self.assertIn("默认 值", occurrence.default_value)

    def test_source_is_bound_to_authoritative_full_document_catalog(self):
        source = self.catalog.source
        self.assertEqual(source.section_number, "7.3")
        self.assertEqual(source.title, "GUC参数说明")
        self.assertEqual(
            source.outline_path,
            ["7 数据库运行参数说明", "7.3 GUC参数说明"],
        )
        self.assertEqual(source.source_sha256, "5413f28cf4e845e98d13afacaad8286de7be7a65b6169938326e4ac771f139e1")
        self.assertEqual(
            self.catalog.parent_pdf_sha256,
            "716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe",
        )

    def test_generated_catalog_fails_closed_on_internal_count_drift(self):
        payload = self.catalog.model_dump()
        payload["parameters"][0]["occurrence_count"] += 1
        registry = GucReferenceRegistry(ROOT)
        with self.assertRaises(GucReferenceLoadError) as caught:
            registry.load_payload(payload)
        self.assertIn("occurrence_count", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
