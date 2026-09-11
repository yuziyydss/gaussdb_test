"""Reviewed source anchors must support claims, not just point inside a chapter."""
import hashlib
from pathlib import Path
import re
import unittest
import yaml

ROOT = Path(__file__).resolve().parents[1]


class AutohintProvenanceTests(unittest.TestCase):
    def test_runtime_question_points_to_context_and_identifier_contracts(self):
        factor = yaml.safe_load((ROOT/'specs/utility/explain_autohint/explain_autohint.factor.yaml').read_text())
        source = factor['source']['catalog_chapter_ref']
        path = ROOT/'work/doc2spec/full_general_corpus'/source['source_relpath']
        self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), source['chapter_sha256'])
        lines = path.read_text().splitlines()
        fact = next(f for f in factor['facts'] if f['id']=='explain_autohint_fact_runtime_contract')
        ranges = re.findall(r'L(\d+)-L(\d+)', fact['source_anchor'])
        self.assertTrue(ranges)
        excerpt = '\n'.join('\n'.join(lines[int(a)-1:int(b)]) for a,b in ranges)
        for evidence in ('内核', '自动调用', 'session', 'cache_id', 'HASH'):
            self.assertIn(evidence, excerpt)
        self.assertEqual(fact['type'], 'open_question')
        self.assertEqual(fact['status'], 'needs_verification')
        self.assertEqual(factor['manifest_refs'], [])

    def test_user_call_is_not_relabelled_as_one_deterministic_target_error(self):
        factor = yaml.safe_load((ROOT/'specs/utility/explain_autohint/explain_autohint.factor.yaml').read_text())
        fact = next(f for f in factor['facts'] if f['id']=='explain_autohint_fact_body_10')
        self.assertIn('无任', fact['statement'])
        self.assertIn('或可能', fact['statement'])
        self.assertEqual(fact['source_anchor'], 'L10-L11')
