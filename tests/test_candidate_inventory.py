"""Retained historical SQL must not inflate the active candidate inventory."""
import hashlib
import json
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace as NS
import unittest

from scripts.audit_candidate_inventory import audit_inventory, digest
from scripts.generate_factor_package_sql import render_sql_snapshot


class CandidateInventoryTests(unittest.TestCase):
    def setUp(self):
        self.temp = TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.active = dict(factor_id='insert', case_id='active_case', sql='INSERT INTO t VALUES (1);',
                           params={}, expected='success', expected_error_category='', expected_sqlstates=[],
                           expected_error_regex='', expected_oracle_status='confirmed', expected_scope='syntax',
                           environment_requirements=[], setup_sqls=[], teardown_sqls=[])
        self.old = {**self.active, 'case_id': 'old_case', 'expected': 'error',
                    'expected_oracle_status': 'needs_verification', 'context': 'preserve non-rendered field'}
        self.old_path = 'generated/factor_packages/insert/old.sql'
        archive = 'archive/spec_reviews/old.yaml'
        for path, text in (('generated/factor_packages/insert/active.sql', render_sql_snapshot('active', [NS(**self.active)])),
                           (self.old_path, render_sql_snapshot('old', [NS(**self.old)])), (archive, 'historical manifest')):
            file = self.root/path
            file.parent.mkdir(parents=True, exist_ok=True)
            file.write_text(text)
        self.variant = dict(historical_snapshot_path=self.old_path, original_manifest_path=archive,
                            original_case=self.old, execution_allowed=False, status='needs_verification')
        self.scenario = NS(factor_ref='insert', status='planned', fact_refs=['question'], variants=[self.variant])
        self.question = NS(id='question', type='open_question', status='needs_verification')
        self.registry = NS(manifests={'active': NS(factor_ref='insert')},
                           factors={'insert': NS(manifest_refs=['active'], scenario_refs=['review'], facts=[self.question])},
                           scenarios={'review': self.scenario})
        self.report = {'manifests': {'active': {'cases': [self.active]}}}
        self.ledger = {'old': dict(factor_ref='insert', scenario_ref='review', case_ids=['old_case'],
            original_case_sha256={'old_case': hashlib.sha256(json.dumps(self.old, ensure_ascii=False,
                                   sort_keys=True, separators=(',', ':')).encode()).hexdigest()},
            snapshot_sha256=digest(self.root/self.old_path), archived_manifest_sha256=digest(self.root/archive))}

    def audit(self, ledger=None):
        return audit_inventory(self.registry, self.report, self.ledger if ledger is None else ledger, root=self.root)

    def test_active_and_history_have_separate_denominators(self):
        result = self.audit()
        self.assertEqual(result['active_case_count'], 1)
        self.assertEqual(result['active_manifest_count'], 1)
        self.assertEqual(result['historical_review_case_count'], 1)
        self.assertEqual(result['physical_sql_file_count'], 2)
        self.assertFalse(result['database_executed'])

    def test_unclassified_old_file_is_not_silently_counted(self):
        with self.assertRaisesRegex(ValueError, 'unclassified'):
            self.audit({})

    def test_no_double_classification(self):
        self.ledger['active'] = self.ledger['old']
        with self.assertRaisesRegex(ValueError, 'still active'):
            self.audit()

    def test_non_rendered_historical_fields_are_preserved(self):
        self.old['context'] = 'changed without changing SQL text'
        with self.assertRaisesRegex(ValueError, 'full case fields'):
            self.audit()

    def test_historical_sql_tampering_is_rejected(self):
        (self.root/self.old_path).write_text('different')
        with self.assertRaisesRegex(ValueError, 'snapshot identity'):
            self.audit()

    def test_original_manifest_tampering_is_rejected(self):
        (self.root/self.variant['original_manifest_path']).write_text('different')
        with self.assertRaisesRegex(ValueError, 'Archived manifest identity'):
            self.audit()

    def test_review_is_not_a_ready_scenario(self):
        self.scenario.status = 'ready'
        with self.assertRaisesRegex(ValueError, 'planned scenario'):
            self.audit()

    def test_missing_question_cannot_authorize_retirement(self):
        self.question.status = 'confirmed'
        with self.assertRaisesRegex(ValueError, 'source question'):
            self.audit()

    def test_review_must_not_be_executable(self):
        self.variant['execution_allowed'] = True
        with self.assertRaisesRegex(ValueError, 'non-executable'):
            self.audit()

    def test_report_must_match_active_registry(self):
        self.report['manifests']['old'] = {'cases': [self.old]}
        with self.assertRaisesRegex(ValueError, 'registry/report'):
            self.audit()

    def test_active_sql_must_match_report(self):
        self.active['sql'] = 'INSERT INTO t VALUES (2);'
        with self.assertRaisesRegex(ValueError, 'Active snapshot/report'):
            self.audit()


if __name__ == '__main__':
    unittest.main()
