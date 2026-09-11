"""Offline input evidence includes fixture file bytes, not just their YAML name."""
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from scripts import prepare_execution_batch as preparation


class ExecutionInputSnapshotTests(unittest.TestCase):
    def script(self, root):
        script=root/'scripts/prepare_execution_batch.py';script.parent.mkdir()
        script.write_text('# test input compiler\n')
        return str(script)

    def test_fixture_asset_mutation_addition_and_removal_invalidate_snapshot(self):
        with tempfile.TemporaryDirectory() as d:
            root=Path(d);assets=root/'specs/ddl/example/fixtures/assets/nested';assets.mkdir(parents=True)
            (root/'core').mkdir();(root/'core/checker.py').write_text('version = 1\n')
            asset=assets/'seed.csv';asset.write_text('1,2\n')
            with patch.multiple(preparation, ROOT=root, __file__=self.script(root)):
                first=preparation.inputs_snapshot()
                self.assertIn('specs/ddl/example/fixtures/assets/nested/seed.csv',first)
                asset.write_text('3,4\n');second=preparation.inputs_snapshot()
                self.assertNotEqual(first,second)
                extra=assets/'other.bin';extra.write_bytes(b'\x00\x01')
                self.assertNotEqual(second,preparation.inputs_snapshot())
                extra.unlink();asset.unlink()
                self.assertNotEqual(first,preparation.inputs_snapshot())

    def test_non_asset_notes_are_not_execution_inputs(self):
        with tempfile.TemporaryDirectory() as d:
            root=Path(d);(root/'specs').mkdir();(root/'core').mkdir()
            note=root/'specs/notes.md';note.write_text('review only')
            with patch.multiple(preparation, ROOT=root, __file__=self.script(root)):
                before=preparation.inputs_snapshot();note.write_text('new review')
                self.assertEqual(before,preparation.inputs_snapshot())

    def test_asset_symlink_is_not_silently_followed(self):
        with tempfile.TemporaryDirectory() as d:
            root=Path(d);assets=root/'specs/fixtures/assets';assets.mkdir(parents=True);(root/'core').mkdir()
            target=root/'external.csv';target.write_text('not an owned asset')
            (assets/'linked.csv').symlink_to(target)
            with patch.multiple(preparation, ROOT=root, __file__=self.script(root)), self.assertRaises(ValueError):
                preparation.inputs_snapshot()
