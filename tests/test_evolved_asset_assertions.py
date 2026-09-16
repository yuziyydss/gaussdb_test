import copy
import unittest
from tests.evolved_asset_assertions import assert_evolved_asset


class EvolvedAssetAssertionsTests(unittest.TestCase):
    def test_additive_facts_do_not_disable_dimension_and_rule_checks(self):
        old = {'kind': 'factor', 'facts': [{'id': 'f', 'statement': 'original'}],
               'scenario_refs': ['s'], 'dimensions': {'v': {'values': ['1']}}, 'rules': ['r']}
        new = copy.deepcopy(old)
        new['facts'].append({'id': 'new', 'statement': 'new fact'})
        new['scenario_refs'].append('new_scenario')
        assert_evolved_asset(self, new, old)
        for field, value in (('dimensions', {}), ('rules', []), ('facts', [])):
            bad = copy.deepcopy(new); bad[field] = value
            with self.assertRaises(AssertionError):
                assert_evolved_asset(self, bad, old)

    def test_source_coverage_and_existing_consumers_cannot_be_erased(self):
        old = {'kind': 'source_ledger', 'source_line_count': 2,
               'units': [{'id': 'u', 'line_start': 1, 'line_end': 2,
                          'status': 'mapped', 'fact_refs': ['f']}]}
        assert_evolved_asset(self, old, old)
        for change in ({'line_end': 1}, {'fact_refs': []},
                       {'fact_refs': ['unrelated']}, {'line_start': 3}):
            bad = copy.deepcopy(old); bad['units'][0].update(change)
            with self.assertRaises(AssertionError):
                assert_evolved_asset(self, bad, old)

    def test_fixture_sql_and_target_oracle_stay_exact(self):
        for old in ({'kind': 'fixture', 'execution': {'setup_sqls': ['CREATE TABLE t(id INT)']}},
                    {'kind': 'scenario', 'oracles': [{'kind': 'target_error', 'sqlstates': ['23505']}]}):
            bad = {'kind': old['kind']}
            with self.assertRaises(AssertionError):
                assert_evolved_asset(self, bad, old)
