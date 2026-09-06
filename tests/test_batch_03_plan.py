from __future__ import annotations

import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from scripts.prepare_batch_03 import ROOT, source_records, validate_plan


class Batch03PlanTests(unittest.TestCase):
    def setUp(self):
        self.plan = json.loads((ROOT / "tests/data/batch_03.json").read_text())

    def test_closed_twenty_chapter_plan(self):
        validate_plan(self.plan)
        self.assertEqual(len(self.plan["new_chapters"]), 20)
        self.assertEqual(len(self.plan["existing_providers"]), 14)
        self.assertEqual(len(self.plan["supplemental_sections"]), 14)

    def test_unknown_dependency_rejected(self):
        self.plan["extraction_dependencies"]["PREPARE"].append("NOT A CHAPTER")
        with self.assertRaisesRegex(ValueError, "Unknown dependency"):
            validate_plan(self.plan)

    def test_related_links_are_not_scheduling_cycles(self):
        self.assertEqual(self.plan["extraction_dependencies"]["DEALLOCATE"], ["PREPARE"])
        self.assertNotIn("DEALLOCATE", self.plan["extraction_dependencies"]["PREPARE"])
        self.plan["extraction_dependencies"]["PREPARE"].append("DEALLOCATE")
        with self.assertRaisesRegex(ValueError, "cycle"):
            validate_plan(self.plan)

    def test_providers_not_counted_as_new(self):
        self.plan["existing_providers"].append("ABORT")
        with self.assertRaisesRegex(ValueError, "disjoint"):
            validate_plan(self.plan)

    def test_no_database_execution(self):
        self.plan["database_execution"] = True
        with self.assertRaisesRegex(ValueError, "database execution"):
            validate_plan(self.plan)

    def test_supplement_requires_known_consumer(self):
        self.plan["supplemental_sections"][0]["consumers"].append("UNKNOWN")
        with self.assertRaisesRegex(ValueError, "known consumers"):
            validate_plan(self.plan)

    def test_source_hash_rechecked_from_body(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            body = b"ABORT [ WORK | TRANSACTION ];\n"
            source = root / "abort.txt"
            source.write_bytes(body)
            catalog = root / "catalog.json"
            catalog.write_text(json.dumps({"chapters": [{
                "source_relpath": "abort.txt", "title": "ABORT",
                "section_number": "1.13.7.1", "chapter_sha256": hashlib.sha256(body).hexdigest(),
                "physical_page_start": 1193, "physical_page_end": 1194,
            }]}))
            _, records = source_records(catalog)
            self.assertEqual(records["ABORT"]["line_count"], 1)
            source.write_bytes(body + b"changed\n")
            with self.assertRaisesRegex(ValueError, "hash mismatch"):
                source_records(catalog)


if __name__ == "__main__":
    unittest.main()
