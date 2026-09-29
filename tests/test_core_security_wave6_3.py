"""Security Functions Wave 6-3 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_security_wave6_3_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_security_wave6_3_v1/manifest.json'


class CoreSecurityWave63Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_security_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_security_wave6_3_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 522)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 535)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 13)
        self.assertIn('1.6.20 安全函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 31)
        self.assertEqual(self.manifest['summary']['open_question_count'], 2)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_facts_bound_to_scope'])

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertEqual(fact['status'], 'confirmed')
                self.assertIn(fact['type'], {'syntax', 'constraint', 'environment', 'behavior_oracle'})
                self.assertEqual(fact['source_refs'], ['w6_3_1_6_20'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_security_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'security_wave6_3_encrypt_aes128',
            'security_wave6_3_encrypt',
            'security_wave6_3_encrypt_bytea',
            'security_wave6_3_key_policy',
            'security_wave6_3_decrypt_aes128',
            'security_wave6_3_decrypt',
            'security_wave6_3_decrypt_bytea',
            'security_wave6_3_aes_encrypt',
            'security_wave6_3_aes_encrypt_boundary',
            'security_wave6_3_aes_decrypt',
            'security_wave6_3_aes_decrypt_boundary',
            'security_wave6_3_digest',
            'security_wave6_3_password_deadline',
            'security_wave6_3_password_notifytime',
            'security_wave6_3_password_lifetime',
            'security_wave6_3_login_audit_messages',
            'security_wave6_3_login_audit_messages_pid',
            'security_wave6_3_query_audit',
            'security_wave6_3_query_unified_audit',
            'security_wave6_3_delete_audit',
            'security_wave6_3_masking_functions',
            'security_wave6_3_masking_semantics',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.20')
        self.assertEqual(source['physical_page_start'], 522)
        self.assertEqual(source['physical_page_end'], 535)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_security_wave6_3.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
