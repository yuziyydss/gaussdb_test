"""An M-only frozen baseline must not silently authorize arbitrary general SQL."""
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import unittest
from unittest.mock import Mock, patch

from scripts import verify_m_compat_remaining as audit


class GeneralSnapshotReconciliationTests(unittest.TestCase):
    def setUp(self):
        self.directory = TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.old = 'generated/factor_packages/old/manifest_old.sql'
        self.new = 'generated/factor_packages/grant/manifest_grant_new.sql'
        for name, body in ((self.old, 'OLD;'), (self.new, 'NEW;')):
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(body)
        self.before = {self.old: audit.sha(self.root / self.old)}
        self.manifest = SimpleNamespace(id='manifest_grant_new', factor_ref='grant')
        self.registry = SimpleNamespace(
            manifests={self.manifest.id: self.manifest},
            factors={'grant': SimpleNamespace(manifest_refs=[self.manifest.id])})
        self.generator = Mock()
        self.generator.generate_with_report.return_value = (
            [SimpleNamespace(case_id='grant_case_new')], SimpleNamespace(pairwise_complete=True))
        self.approval = {self.manifest.id: {
            'factor_ref': 'grant', 'snapshot_sha256': audit.sha(self.root / self.new),
            'case_ids': ['grant_case_new']}}

    def verify(self, approvals=None):
        with patch.object(audit, 'render_sql_snapshot', return_value='NEW;'):
            return audit.verify_general_snapshots(
                self.before, self.registry, self.generator,
                self.approval if approvals is None else approvals, root=self.root)

    def test_explicit_fresh_addition_preserves_frozen_baseline(self):
        actual, additions = self.verify()
        self.assertEqual(len(actual), 2)
        self.assertEqual(additions, self.approval)
        self.assertEqual(self.before, {self.old: audit.sha(self.root / self.old)})

    def test_unregistered_addition_rejected(self):
        with self.assertRaisesRegex(AssertionError, 'unapproved general snapshots'):
            self.verify({})

    def test_old_change_and_old_removal_rejected(self):
        (self.root / self.old).write_text('CHANGED;')
        with self.assertRaisesRegex(AssertionError, 'frozen general snapshot'):
            self.verify()
        (self.root / self.old).unlink()
        with self.assertRaisesRegex(AssertionError, 'frozen general snapshot'):
            self.verify()

    def test_wrong_factor_ownership_rejected(self):
        self.registry.factors['grant'].manifest_refs = []
        with self.assertRaisesRegex(AssertionError, 'ownership'):
            self.verify()

    def test_even_reapproved_snapshot_must_match_actual_generator(self):
        (self.root / self.new).write_text('BAD SQL;')
        self.approval[self.manifest.id]['snapshot_sha256'] = audit.sha(self.root / self.new)
        with self.assertRaisesRegex(AssertionError, 'render drift'):
            self.verify()

    def test_case_id_drift_rejected(self):
        self.approval[self.manifest.id]['case_ids'] = ['made_up']
        with self.assertRaisesRegex(AssertionError, 'case IDs'):
            self.verify()

    def test_incomplete_coverage_rejected(self):
        self.generator.generate_with_report.return_value[1].pairwise_complete = False
        with self.assertRaisesRegex(AssertionError, 'generation coverage'):
            self.verify()

    def test_strict_empty_additions_still_work(self):
        (self.root / self.new).unlink()
        actual, additions = self.verify({})
        self.assertEqual(actual, self.before)
        self.assertEqual(additions, {})


if __name__ == '__main__':
    unittest.main()
