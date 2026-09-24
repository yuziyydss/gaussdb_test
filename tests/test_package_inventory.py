import unittest
from types import SimpleNamespace as NS

from core.package_inventory import package_inventory


class PackageInventoryTests(unittest.TestCase):
    def registry(self):
        def factor(mids):
            return NS(manifest_refs=mids, scenario_refs=[], fixture_refs=[], facts=[])
        return NS(factors={'plain': factor(['p']), 'm_plain': factor(['m']),
                           'pending': factor([]), 'm_pending': factor([])},
                  manifests={'p': NS(factor_ref='plain'), 'm': NS(factor_ref='m_plain')})

    def test_partial_selection_does_not_shrink_registry_denominator(self):
        result = package_inventory(self.registry(), ['p'])
        self.assertEqual(result['registered_package_count'], 4)
        self.assertEqual(result['with_manifest_count'], 2)
        self.assertEqual(result['selected_package_count'], 1)
        self.assertEqual(result['without_manifest_count'], 2)
        self.assertEqual(result['not_selected_with_manifest_refs'], ['m_plain'])
        self.assertEqual(result['by_package_namespace']['M']['registered'], 2)
        self.assertFalse(result['runtime_evidence_connected'])

    def test_empty_and_invalid_selection_are_distinct(self):
        self.assertEqual(package_inventory(self.registry(), [])['selected_package_count'], 0)
        with self.assertRaises(ValueError):
            package_inventory(self.registry(), ['missing'])

    def test_missing_manifest_package_retains_evidence_not_unsupported_label(self):
        r = self.registry()
        r.factors['pending'].facts = [NS(id='question', type='open_question',
                                          status='needs_verification', statement='Requires reviewed assets')]
        r.factors['pending'].scenario_refs = ['scenario_pending']
        row = next(x for x in package_inventory(r, ['p'])['without_manifest'] if x['factor_ref']=='pending')
        self.assertEqual(row['scenario_refs'], ['scenario_pending'])
        self.assertEqual(row['review_fact_refs'], ['pending::question'])
        self.assertEqual(row['status'], 'no_manifest_not_a_support_verdict')

    def test_dispositions_annotate_and_reject_drift(self):
        r = self.registry()
        dispositions = {
            'pending': {
                'blocking_category': 'runtime_contract',
                'blocking_reason': 'Assets are not ready.',
                'next_action': 'Implement the runtime contract.',
            },
            'm_pending': {
                'blocking_category': 'documented_unsupported',
                'blocking_reason': 'The current form is unsupported.',
                'next_action': 'Revisit only after documented product change.',
            },
        }
        rows = {x['factor_ref']: x for x in package_inventory(r, ['p'], dispositions)['without_manifest']}
        self.assertEqual(rows['pending']['blocking_category'], 'runtime_contract')
        self.assertEqual(rows['pending']['next_action'], 'Implement the runtime contract.')
        self.assertEqual(rows['m_pending']['blocking_reason'], 'The current form is unsupported.')
        with self.assertRaisesRegex(ValueError, 'No-manifest disposition set mismatch'):
            package_inventory(r, ['p'], {'pending': dispositions['pending']})
        incomplete = {
            'pending': {'blocking_category': 'runtime_contract'},
            'm_pending': dispositions['m_pending'],
        }
        with self.assertRaisesRegex(ValueError, 'missing fields'):
            package_inventory(r, ['p'], incomplete)
