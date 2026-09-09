"""M command audit reads only actually referenced shared PDF catalogs."""
from pathlib import Path
from types import SimpleNamespace
import unittest

from scripts import verify_m_compat_remaining as audit


class MSumSourceCatalogTests(unittest.TestCase):
    def registry(self, paths):
        return SimpleNamespace(source_ledgers={'test': SimpleNamespace(supplemental_sources=[
            SimpleNamespace(catalog_chapter_ref=SimpleNamespace(source_relpath=p)) for p in paths])})

    def test_m_aggregate_catalog_is_available_for_its_actual_reference(self):
        registry = self.registry(['m_compat/utility/section_2_5_11.txt'])
        catalogs = audit.source_catalog_paths(registry)
        expected = audit.ROOT/'work/pdf_tiered_2026_09_07/batch_22/corpus/catalog.json'
        self.assertIn(expected, catalogs)
        self.assertEqual(catalogs.count(expected), 1)

    def test_unreferenced_foundation_catalog_is_not_globbed_in(self):
        catalogs = audit.source_catalog_paths(self.registry([]))
        self.assertTrue(catalogs)
        self.assertTrue(all('m_compat_batch_' in str(path) for path in catalogs))


if __name__ == '__main__':
    unittest.main()
