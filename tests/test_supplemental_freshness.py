"""Body-only PDF inputs must invalidate consumers without inventory refresh."""
import json
import copy
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import yaml

from scripts import manage_extraction_queue as queue


class SupplementalFreshnessTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.body = self.root / 'body.txt'
        self.body.write_text('documented supplemental rule\n')
        self.digest = queue.sha256_file(self.body)
        self.catalog = self.root / 'catalog.json'
        self.catalog.write_text(json.dumps({'document_id': 'pdf', 'product_version': 'v1',
            'chapters': [{'source_relpath': 'body.txt', 'chapter_sha256': self.digest}]}))
        self.tasks = {}
        for fid in ('provider', 'consumer', 'unrelated'):
            package = self.root / 'specs' / fid
            package.mkdir(parents=True)
            (package / (fid + '.factor.yaml')).write_text(yaml.safe_dump({
                'id': fid, 'source': {'artifact_sha256': self.digest}}))
            source = self.root / (fid + '.txt')
            source.write_text(fid)
            self.tasks[fid] = {'factor_id': fid, 'output_dir': str(package),
                'source_relpath': source.name, 'source_sha256': queue.sha256_file(source),
                'status': 'static_complete',
                'depends_on_factor_refs': ['provider'] if fid == 'consumer' else []}
        self.ledger = Path(self.tasks['provider']['output_dir']) / 'provider.source.yaml'
        self.ledger.write_text(yaml.safe_dump({'supplemental_sources': [{
            'version': 'v1', 'catalog_chapter_ref': {'document_id': 'pdf',
                'source_relpath': 'body.txt', 'chapter_sha256': self.digest}}]}))
        self.state = {'tasks': list(self.tasks.values()), 'specs_root': str(self.root / 'specs'),
                      'corpus_root': str(self.root), 'source_catalog_path': str(self.catalog)}

    def snapshots(self):
        for task in self.tasks.values():
            task['verification_snapshot'] = {
                'factor_package_sha256': queue.factor_package_sha256(Path(task['output_dir'])),
                'source_sha256': task['source_sha256'], 'toolchain_sha256': 'test-toolchain',
                'supplemental_sources': queue.supplemental_verification_snapshot(
                    Path(task['output_dir']), self.catalog, self.root),
                'dependencies': queue.dependency_verification_snapshot(self.state, task)}

    def fresh(self, fid, state=True):
        return queue.static_completion_freshness(self.tasks[fid],
            state=self.state if state else None, corpus_root=self.root,
            toolchain_sha256='test-toolchain')

    def test_body_change_invalidates_only_provider_and_consumer_online_and_offline(self):
        self.snapshots()
        for offline in (False, True):
            self.assertTrue(all(self.fresh(fid, not offline)[0] for fid in self.tasks))
        self.body.write_text('changed without inventory')
        for offline in (False, True):
            stale = {fid for fid in self.tasks if not self.fresh(fid, not offline)[0]}
            self.assertEqual(stale, {'provider', 'consumer'})

    def test_deleted_body_invalidates(self):
        self.snapshots()
        self.body.unlink()
        self.assertFalse(self.fresh('provider')[0])
        self.assertFalse(self.fresh('consumer', False)[0])

    def test_old_snapshot_with_supplement_is_not_proof(self):
        self.snapshots()
        del self.tasks['provider']['verification_snapshot']['supplemental_sources']
        self.assertFalse(self.fresh('provider')[0])
        del self.tasks['unrelated']['verification_snapshot']['supplemental_sources']
        self.assertTrue(self.fresh('unrelated')[0])

    def test_declared_hash_and_catalog_hash_must_match_actual_body(self):
        self.body.write_text('drift')
        with self.assertRaises(queue.QueueError):
            self.snapshots()

    def test_supplement_must_not_escape_corpus(self):
        ledger = yaml.safe_load(self.ledger.read_text())
        ledger['supplemental_sources'][0]['catalog_chapter_ref']['source_relpath'] = '../outside.txt'
        self.ledger.write_text(yaml.safe_dump(ledger))
        with self.assertRaises(queue.QueueError):
            self.snapshots()

    def test_external_url_has_no_local_freshness_proof(self):
        self.ledger.write_text(yaml.safe_dump({'supplemental_sources': [{'url': 'https://example.invalid'}]}))
        with self.assertRaises(queue.QueueError):
            self.snapshots()

    def test_snapshot_failure_keeps_task_unverified_instead_of_crashing(self):
        task = self.tasks['consumer']
        task['verification_snapshot'] = {'old': True}
        with patch.object(queue, 'validate_task_artifact', return_value={'returncode': 0}), \
             patch.object(queue, 'run_check', return_value={'returncode': 0}), \
             patch.object(queue, 'dependency_verification_snapshot', side_effect=queue.QueueError('body unavailable')):
            self.assertFalse(queue.verify_task(self.state, task, self.root / 'output'))
        self.assertEqual(task['status'], 'needs_review')
        self.assertNotIn('verification_snapshot', task)
        self.assertEqual(task['checks']['input_snapshot']['returncode'], 1)

    def test_malformed_dependency_entry_is_stale_online_and_offline(self):
        self.snapshots()
        snapshot = self.tasks['consumer']['verification_snapshot']
        original = copy.deepcopy(snapshot['dependencies'])
        for invalid in (None, [], 'not an evidence object', 7):
            for with_state in (True, False):
                with self.subTest(invalid=invalid, with_state=with_state):
                    snapshot['dependencies'] = {'provider': invalid}
                    fresh, reasons = self.fresh('consumer', with_state)
                    self.assertFalse(fresh)
                    self.assertIn('dependency_snapshot_invalid:provider', reasons)
        snapshot['dependencies'] = original

    def test_malformed_dependency_paths_do_not_crash_offline_audit(self):
        self.snapshots()
        snapshot = self.tasks['consumer']['verification_snapshot']
        original = copy.deepcopy(snapshot['dependencies']['provider'])
        for field in ('package_dir', 'source_path'):
            for invalid in (['bad path'], {'path': 'body.txt'}, 7):
                with self.subTest(field=field, invalid=invalid):
                    evidence = copy.deepcopy(original)
                    evidence[field] = invalid
                    snapshot['dependencies']['provider'] = evidence
                    self.assertFalse(self.fresh('consumer', False)[0])

    def test_malformed_supplement_paths_do_not_crash_audit(self):
        self.snapshots()
        for owner in ('provider', 'consumer'):
            snapshot = self.tasks[owner]['verification_snapshot']
            evidence = (snapshot['supplemental_sources'] if owner == 'provider'
                        else snapshot['dependencies']['provider']['supplemental_sources'])
            original = copy.deepcopy(evidence)
            for field in ('catalog_path', 'corpus_root'):
                for invalid in (['bad path'], {'path': 'body.txt'}, 7):
                    with self.subTest(owner=owner, field=field, invalid=invalid):
                        evidence.clear()
                        evidence.update(copy.deepcopy(original))
                        evidence[field] = invalid
                        self.assertFalse(self.fresh(owner, False)[0])


if __name__ == '__main__':
    unittest.main()
