"""Core expression candidate chain remains static, traceable and read-only."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

from core.core_expression_candidate_chain import (
    build_core_expression_candidate_chain,
    verify_core_expression_candidate_chain,
)

ROOT = Path(__file__).resolve().parents[1]
ENV_PATH = ROOT / 'environments/core_expression_candidate_chain_v1.yaml'
OUTPUT_PATH = ROOT / 'generated/core_expression_candidate_chain_v1/candidates.json'


class CoreExpressionCandidateChainTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.chain = build_core_expression_candidate_chain(ROOT)
        cls.environment = yaml.safe_load(ENV_PATH.read_text(encoding='utf-8'))

    def test_all_wave_facts_are_bound_to_candidates(self):
        self.assertEqual(self.chain.summary.source_fact_count, 246)
        self.assertEqual(self.chain.summary.referenced_fact_count, 246)
        self.assertEqual(self.chain.summary.uncovered_fact_count, 0)
        self.assertEqual(self.chain.uncovered_fact_ids, [])

    def test_candidate_scale_and_static_boundary(self):
        self.assertEqual(self.chain.summary.candidate_count, 171)
        self.assertEqual(self.chain.summary.fixture_count, 3)
        self.assertEqual(self.chain.summary.candidate_fact_reference_count, 293)
        self.assertTrue(self.chain.summary.all_candidates_read_only)
        self.assertTrue(self.chain.summary.static_chain_complete)
        self.assertFalse(self.chain.summary.runtime_executed)
        self.assertFalse(self.chain.summary.runtime_verified)

    def test_candidates_are_unique_and_hash_bound_to_facts(self):
        fact_ids = {
            item['id']
            for path in (
                ROOT / 'docs/compat_facts/core_type_expression_domain_v1.yaml',
                ROOT / 'docs/compat_facts/core_function_operator_domain_v1.yaml',
                ROOT / 'docs/compat_facts/core_function_operator_wave2a_v1.yaml',
            )
            for item in yaml.safe_load(path.read_text(encoding='utf-8'))['facts']
        }
        candidate_ids = [item.id for item in self.chain.candidates]
        sql_statements = [item.sql for item in self.chain.candidates]
        self.assertEqual(len(candidate_ids), len(set(candidate_ids)))
        self.assertEqual(len(sql_statements), len(set(sql_statements)))
        for candidate in self.chain.candidates:
            with self.subTest(candidate=candidate.id):
                self.assertTrue(candidate.fact_refs)
                self.assertTrue(set(candidate.fact_refs).issubset(fact_ids))
                self.assertTrue(candidate.oracle_status, 'needs_verification')
                self.assertEqual(candidate.execution_status, 'not_executed')

    def test_candidate_sql_is_single_read_only_statement(self):
        for candidate in self.chain.candidates:
            with self.subTest(candidate=candidate.id):
                self.assertTrue(candidate.sql.endswith(';'))
                self.assertEqual(candidate.sql.count(';'), 1)
                self.assertTrue(candidate.sql.strip().upper().startswith(('SELECT ', 'WITH ')))
                upper_sql = candidate.sql.upper()
                for forbidden in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
                    self.assertNotIn(forbidden, upper_sql)

    def test_fixtures_are_explicit_and_candidates_resolve(self):
        fixtures = {item.id: item for item in self.chain.fixtures}
        self.assertEqual(set(fixtures), {'no_fixture', 'core_expr_fixture', 'rownum_fixture'})
        self.assertEqual(fixtures['no_fixture'].setup_sql, [])
        self.assertTrue(fixtures['core_expr_fixture'].setup_sql)
        self.assertTrue(fixtures['rownum_fixture'].setup_sql)
        for fixture in fixtures.values():
            self.assertEqual(
                len(fixture.setup_sql),
                len(fixture.teardown_sql),
            )
        for candidate in self.chain.candidates:
            self.assertIn(candidate.fixture_ref, fixtures)

    def test_written_chain_is_current_and_verifiable(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        result = verify_core_expression_candidate_chain(ROOT)
        self.assertEqual(result.summary.source_fact_count, 246)
        self.assertEqual(result.summary.candidate_count, 171)
        self.assertTrue(result.summary.static_chain_complete)

    def test_written_chain_detects_drift(self):
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['candidate_count'] += 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            with self.assertRaisesRegex(ValueError, 'stale|invalid'):
                verify_core_expression_candidate_chain(ROOT)
        finally:
            OUTPUT_PATH.write_text(original, encoding='utf-8')


if __name__ == '__main__':
    unittest.main()
