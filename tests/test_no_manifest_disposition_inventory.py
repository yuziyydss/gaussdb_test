"""The real no-manifest disposition snapshot must match the live registry."""
import json
from pathlib import Path
import unittest

from core.package_inventory import package_inventory
from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / 'docs' / 'NO_MANIFEST_REMAINING_20260920.json'


class NoManifestDispositionInventoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        payload = json.loads(PATH.read_text(encoding='utf-8'))
        cls.payload = payload
        cls.dispositions = {
            entry['factor_ref']: entry for entry in payload['dispositions']
        }

    def test_snapshot_counts_match_registry(self):
        inventory = package_inventory(self.registry, [], self.dispositions)
        self.assertEqual(inventory['registered_package_count'], self.payload['registered_package_count'])
        self.assertEqual(inventory['with_manifest_count'], self.payload['with_manifest_count'])
        self.assertEqual(inventory['without_manifest_count'], self.payload['without_manifest_count'])

    def test_every_remaining_package_has_structured_disposition(self):
        rows = package_inventory(self.registry, [], self.dispositions)['without_manifest']
        self.assertEqual(len(rows), self.payload["without_manifest_count"])
        for row in rows:
            with self.subTest(factor=row['factor_ref']):
                self.assertIn(row['blocking_category'], {
                    'remote_identity_and_secret',
                    'documented_unsupported',
                    'dual_session_runtime_binding',
                    'internal_callback_and_unknown_domain',
                    'kernel_task_context',
                    'authoritative_om_upgrade',
                })
                self.assertTrue(row['blocking_reason'])
                self.assertTrue(row['next_action'])
                self.assertEqual(row['status'], 'no_manifest_not_a_support_verdict')


if __name__ == '__main__':
    unittest.main()
