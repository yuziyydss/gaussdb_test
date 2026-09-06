import contextlib
import copy
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from scripts import reconcile_quality_round as reconciliation


class GenerationEvidenceTests(unittest.TestCase):
    def report(self, digest='a' * 64):
        result = {'cases': [{'case_id': 'c1', 'factor_id': 'insert', 'manifest_id': 'm1',
                            'expected': 'success', 'write_contract': {
                                'status': 'checked', 'issues': []}}]}
        if digest is not None:
            result['generation_report_sha256'] = digest
        return result

    def test_same_report_hash_is_separate_from_identity_evidence(self):
        old = self.report()
        result = reconciliation.reconcile_cases(old, copy.deepcopy(old))
        evidence = result['generation_evidence']
        self.assertEqual(evidence['status'], 'same_report_hash')
        self.assertTrue(evidence['reported_inputs_unchanged'])
        self.assertFalse(evidence['database_verified'])
        self.assertEqual(evidence['before_sha256'], 'a' * 64)

    def test_different_hash_cannot_be_hidden_by_identical_case_ids(self):
        result = reconciliation.reconcile_cases(self.report(), self.report('b' * 64))
        self.assertEqual(result['identity_checked_cases'], 1)
        self.assertEqual(result['generation_evidence']['status'], 'different_report_hash')
        self.assertFalse(result['generation_evidence']['reported_inputs_unchanged'])

    def test_legacy_missing_hash_is_unavailable_and_bad_hash_is_rejected(self):
        for old, new in ((None, None), (None, 'a' * 64), ('a' * 64, None)):
            with self.subTest(old=old, new=new):
                evidence = reconciliation.reconcile_cases(
                    self.report(old), self.report(new))['generation_evidence']
                self.assertEqual(evidence['status'], 'unavailable')
                self.assertIsNone(evidence['reported_inputs_unchanged'])
        for bad in (None, '', 'a' * 63, 'g' * 64, [], {}, 123):
            for side in ('before', 'after'):
                with self.subTest(bad=bad, side=side):
                    old, new = self.report(), self.report()
                    (old if side == 'before' else new)['generation_report_sha256'] = bad
                    with self.assertRaisesRegex(ValueError, 'Invalid generation report SHA'):
                        reconciliation.reconcile_cases(old, new)

    def test_strict_cli_requires_matching_generation_evidence_without_rebaselining(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            before, after, backlog, catalog, output = [root / (s + '.json')
                for s in ('before', 'after', 'backlog', 'catalog', 'output')]
            before.write_text(json.dumps(self.report()))
            backlog.write_text('{"factors": []}')
            catalog.write_text('{}')
            sources = {'factor_count': 0, 'bound': 0, 'supplemental_edges': 0, 'rows': []}
            for digest, strict, expected_exit in (
                    ('a' * 64, True, 0), ('b' * 64, True, 1),
                    (None, True, 1), ('b' * 64, False, 0)):
                with self.subTest(digest=digest, strict=strict):
                    after.write_text(json.dumps(self.report(digest)))
                    argv = ['reconcile', '--before', str(before), '--after', str(after),
                            '--backlog', str(backlog), '--catalog', str(catalog),
                            '--output', str(output)]
                    if strict:
                        argv.append('--require-same-generation')
                    original = before.read_bytes()
                    with patch('sys.argv', argv), patch.object(
                            reconciliation, 'audit_sources', return_value=sources), \
                            contextlib.redirect_stdout(io.StringIO()):
                        self.assertEqual(reconciliation.main(), expected_exit)
                    self.assertEqual(before.read_bytes(), original)
                    saved = json.loads(output.read_text())
                    self.assertIn('generation_evidence', saved['cases'])
