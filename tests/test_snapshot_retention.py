"""Generation may not delete an unclassified snapshot or retained evidence."""
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace as NS
import unittest

from scripts import generate_factor_package_sql as generation


class SnapshotRetentionTests(unittest.TestCase):
    def test_unclassified_snapshot_aborts_before_any_write(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'f').mkdir()
            old, active = root/'f/old.sql', root/'f/new.sql'
            old.write_text('HISTORY;')
            active.write_text('PREVIOUS;')
            registry = NS(factors={'f': NS(manifest_refs=['new'])})
            with self.assertRaisesRegex(ValueError, 'unclassified'):
                generation.publish_snapshots(root, {'f': {'new'}}, registry,
                                             {active: 'RENDERED;'}, set())
            self.assertEqual(old.read_text(), 'HISTORY;')
            self.assertEqual(active.read_text(), 'PREVIOUS;')

    def test_verified_history_is_kept_and_active_snapshot_updated(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'f').mkdir()
            old, active = root/'f/old.sql', root/'f/new.sql'
            old.write_text('HISTORY;')
            registry = NS(factors={'f': NS(manifest_refs=['new'])})
            generation.publish_snapshots(root, {'f': {'new'}}, registry,
                                         {active: 'RENDERED;'}, {old.resolve()})
            self.assertEqual(old.read_text(), 'HISTORY;')
            self.assertEqual(active.read_text(), 'RENDERED;')

    def test_partial_generation_does_not_retire_unselected_active_files(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'f').mkdir()
            other, active = root/'f/other.sql', root/'f/new.sql'
            other.write_text('OTHER;')
            registry = NS(factors={'f': NS(manifest_refs=['new', 'other'])})
            generation.publish_snapshots(root, {'f': {'new'}}, registry,
                                         {active: 'RENDERED;'}, set())
            self.assertEqual(other.read_text(), 'OTHER;')


if __name__ == '__main__':
    unittest.main()
