import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from scripts.audit_foundation_draft import audit


class FoundationDraftTests(unittest.TestCase):
    def review(self):
        return {'ignored_lines': [{'line': 1, 'rationale': 'heading'}], 'units': [
            {'id': 'u1', 'section': 'boolean', 'source_anchor': 'L2-L2',
             'line_start': 2, 'line_end': 2, 'statement': 'NULL means unknown',
             'status': 'mapped', 'fact_refs': ['boolean_null'], 'atomicity': 'atomic'},
            {'id': 'u2', 'section': 'boolean', 'source_anchor': 'L3-L3',
             'line_start': 3, 'line_end': 3, 'statement': 'unprocessed',
             'status': 'unmapped', 'rationale': 'pending review'}]}

    def fixture(self, directory):
        root = Path(directory)
        source = root/'source.txt'
        source.write_text('heading\nNULL means unknown\nunprocessed\n', encoding='utf-8')
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        catalog = {'parent_pdf_sha256': 'a'*64, 'chapters': [
            {'section_number': '1.3.3', 'source_relpath': 'source.txt', 'chapter_sha256': digest}]}
        draft = {'parent_pdf_sha256': 'a'*64, 'chapters': [
            {'section_number': '1.3.3', 'sha256': digest, 'claims': [
                {'id': 'boolean_null', 'type': 'constraint', 'statement': 'NULL means unknown',
                 'status': 'confirmed', 'source_anchor': 'L2-L2', 'line_start': 2, 'line_end': 2,
                 'evidence_contains': ['NULL', 'unknown']}]}]}
        cp, dp = root/'catalog.json', root/'draft.json'
        cp.write_text(json.dumps(catalog), encoding='utf-8')
        dp.write_text(json.dumps(draft), encoding='utf-8')
        return cp, dp, source

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_unmapped_lines_remain_visible(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            report = audit(cp, dp)
            self.assertEqual(report['rows'][0]['unmapped_lines'], [1, 3])
            self.assertFalse(report['rows'][0]['generator_integrated'])
            self.assertFalse(report['semantic_truth_proved_by_this_check'])
            self.assertEqual(report['draft_sha256'], hashlib.sha256(dp.read_bytes()).hexdigest())
            self.assertEqual(report['catalog_sha256'], hashlib.sha256(cp.read_bytes()).hexdigest())

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_changed_source_is_rejected(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, source = self.fixture(directory)
            source.write_text('changed', encoding='utf-8')
            with self.assertRaisesRegex(ValueError, 'source drift'):
                audit(cp, dp)

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_wrong_anchor_and_quote_are_rejected(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            draft = json.loads(dp.read_text())
            draft['chapters'][0]['claims'][0]['evidence_contains'] = ['not present']
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'missing evidence'):
                audit(cp, dp)
            draft['chapters'][0]['claims'][0]['line_start'] = 9
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'invalid source anchor'):
                audit(cp, dp)

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_review_records_unmapped_even_when_all_lines_accounted(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            draft = json.loads(dp.read_text())
            draft['chapters'][0]['source_review'] = self.review()
            dp.write_text(json.dumps(draft))
            row = audit(cp, dp)['rows'][0]
            self.assertTrue(row['source_lines_accounted'])
            self.assertEqual(row['unmapped_lines'], [3])
            self.assertFalse(row['source_extraction_complete'])

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_review_rejects_missing_fact_and_duplicate_units(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            draft = json.loads(dp.read_text())
            review = self.review()
            draft['chapters'][0]['source_review'] = review
            review['units'][0]['fact_refs'] = ['nonexistent']
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'Unknown review fact'):
                audit(cp, dp)
            review['units'][0]['fact_refs'] = ['boolean_null']
            review['units'][1]['id'] = 'u1'
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'duplicate review unit'):
                audit(cp, dp)

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_review_cannot_map_wrong_line_or_hide_claim(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            draft = json.loads(dp.read_text())
            review = self.review()
            draft['chapters'][0]['source_review'] = review
            review['units'][0]['source_anchor'] = 'L3-L3'
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'review source anchor'):
                audit(cp, dp)
            review['units'][0]['source_anchor'] = 'L2-L2'
            review['units'][0].update(status='unmapped', fact_refs=[], rationale='pending')
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'Unreferenced review claims'):
                audit(cp, dp)

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_review_requires_every_line_and_declared_overlaps(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            draft = json.loads(dp.read_text())
            review = self.review()
            draft['chapters'][0]['source_review'] = review
            review['ignored_lines'] = []
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, '未登记行'):
                audit(cp, dp)
            review['ignored_lines'] = self.review()['ignored_lines']
            review['units'][1].update(line_start=2, source_anchor='L2-L3')
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, '重叠必须'):
                audit(cp, dp)

    @patch('scripts.audit_foundation_draft.load_source_catalog')
    def test_open_question_is_not_a_resolved_fact(self, _):
        with tempfile.TemporaryDirectory() as directory:
            cp, dp, _ = self.fixture(directory)
            draft = json.loads(dp.read_text())
            review = self.review()
            draft['chapters'][0]['source_review'] = review
            draft['chapters'][0]['claims'][0].update(type='open_question', status='needs_verification')
            dp.write_text(json.dumps(draft))
            with self.assertRaisesRegex(ValueError, 'cannot be mapped as resolved'):
                audit(cp, dp)
            review['units'][0]['status'] = 'open_question'
            dp.write_text(json.dumps(draft))
            row = audit(cp, dp)['rows'][0]
            self.assertEqual(row['open_question_lines'], [2])
            self.assertTrue(row['source_lines_accounted'])
            self.assertFalse(row['source_extraction_complete'])


if __name__ == '__main__':
    unittest.main()
