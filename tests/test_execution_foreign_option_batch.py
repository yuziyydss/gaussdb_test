"""Four independent documented options, not one concatenated scenario."""
import json
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.prepare_execution_batch import build_batch

ROOT = Path(__file__).resolve().parents[1]


class ForeignOptionBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def test_each_candidate_binds_once_with_its_own_initial_state(self):
        batch = build_batch(self.r, self.g, profile='foreign_options')
        self.assertEqual(batch['summary']['candidates'], 4)
        self.assertEqual(batch['summary']['scenario_sequences'], 4)
        self.assertEqual(batch['summary']['unbound_candidate_ids'], [])
        seen = set()
        for unit in batch['units']:
            self.assertEqual(len(unit['steps']), 1)
            cid = unit['steps'][0]['case_id']
            self.assertNotIn(cid, seen); seen.add(cid)
            self.assertEqual(unit['static_blockers'], ['physical_mode_unresolved'])
            self.assertEqual(unit['preparation_status'], 'blocked')
            self.assertEqual(len(unit['oracle_calibration_pending']), 1)
            self.assertEqual(unit['source_scenario']['status'], 'planned')
            present = unit['steps'][0]['source_step']['candidate']['params']['operation'] in ('aft_log_set', 'aft_log_drop')
            self.assertEqual(len(unit['setup_sqls']), 4 if present else 3)
            self.assertEqual(len(unit['ownership_plan'].get('setup_mutations', [])), int(present))
            self.assertFalse(unit['ownership_plan']['runtime_ownership_proven'])
            self.assertFalse(unit['database_executed'])
        self.assertEqual(batch['summary']['runtime_verified'], 0)

    def test_generated_records_unchanged_and_no_fabricated_catalog_or_sqlstate(self):
        batch = build_batch(self.r, self.g, profile='foreign_options')
        published = json.loads((ROOT/'generated/factor_packages/generation_report.json').read_text())
        cases = {c['case_id']: c for m in published['manifests'].values() for c in m['cases']}
        for candidate in batch['candidates']:
            self.assertEqual(candidate, cases[candidate['case_id']])
            self.assertEqual(candidate['expected_scope'], 'syntax_only')
        for unit in batch['units']:
            oracle = unit['steps'][0]['oracles'][0]
            self.assertEqual(oracle['kind'], 'manual_assertion')
            self.assertNotIn('sql', oracle)
            self.assertNotIn('sqlstates', oracle)
