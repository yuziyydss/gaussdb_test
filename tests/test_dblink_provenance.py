"""DBLink source contradictions need both sides, not an inferred cleanup rule."""
from pathlib import Path
import re
import unittest
import yaml

ROOT = Path(__file__).resolve().parents[1]


class DBLinkProvenanceTests(unittest.TestCase):
    def cited_text(self, factor_id, fact_suffix):
        package = ROOT / 'specs/ddl' / factor_id
        factor = yaml.safe_load((package / (factor_id + '.factor.yaml')).read_text())
        self.assertFalse(factor['manifest_refs'])
        self.assertFalse(factor['fixture_refs'])
        fact = next(f for f in factor['facts'] if f['id'] == factor_id + '_fact_' + fact_suffix)
        self.assertEqual(fact['type'], 'open_question')
        self.assertEqual(fact['status'], 'needs_verification')
        lines = (ROOT / 'work/doc2spec/full_general_corpus/general/ddl' / (factor_id + '.txt')).read_text().splitlines()
        return '\n'.join('\n'.join(lines[int(a)-1:int(b)])
                         for a, b in re.findall(r'L(\d+)-L(\d+)', fact['source_anchor']))

    def test_private_cleanup_conflict_cites_creation_and_drop_example(self):
        for fid, suffix in [('create_database_link', 'private_cleanup'),
                            ('drop_database_link', 'cleanup_conflict')]:
            with self.subTest(factor=fid):
                text = self.cited_text(fid, suffix)
                self.assertIn('CREATE DATABASE LINK private_dblink', text)
                self.assertIn('DROP PUBLIC DATABASE LINK private_dblink', text)
                self.assertIn('PRIVATE' if fid.startswith('drop') else '私有', text)

    def test_using_separator_conflict_cites_both_forms(self):
        text = self.cited_text('create_database_link', 'using_separator')
        self.assertIn("option 'value' [...])", text)
        self.assertIn("option 'value' [, ... ]", text)
