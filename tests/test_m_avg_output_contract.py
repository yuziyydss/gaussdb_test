"""M AVG consumes existing real sources without inventing a general interpreter."""
from tests.evolved_asset_assertions import assert_evolved_asset
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
import yaml
from core.finite_sql_contract import ReviewNeeded, Contradiction
from core.query_output_contract import check_documented_aggregate_types, check_documented_sum_types
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import select

ROOT = Path(__file__).resolve().parents[1]


class AvgTypeTests(unittest.TestCase):
    def check(self, typ='INTEGER', output='DECIMAL', item='AVG(qty)', mode='M', identity='m_builtin_avg'):
        return check_documented_aggregate_types([item], [output], ['qty'], [typ], mode=mode, identity=identity)

    def test_exact_and_approximate_return_families_are_distinct(self):
        for typ in ('INT', 'INTEGER', 'INT4', 'DECIMAL', 'NUMERIC'):
            self.assertEqual(self.check(typ), [0])
        for typ in ('FLOAT', 'DOUBLE'):
            self.assertEqual(self.check(typ, 'DOUBLE'), [0])
        for typ, output in (('INT', 'INTEGER'), ('FLOAT', 'DECIMAL'), ('DOUBLE', 'FLOAT')):
            with self.subTest(typ=typ), self.assertRaisesRegex(Contradiction, 'function_output_type_mismatch'):
                self.check(typ, output)

    def test_only_finite_bare_field_identity_is_supported(self):
        for changes in ({'mode':'general'}, {'identity':'user_function'}, {'item':'SUM(qty)'},
                        {'item':'AVG(1)'}, {'item':'AVG(qty+1)'}, {'item':'AVG(qty) OVER ()'},
                        {'item':'app.AVG(qty)'}, {'item':'AVG(current_date)'}, {'item':'AVG(NULL)'},
                        {'item':'AVG(qty) AS reſult'}, {'typ':'ınt'}, {'output':'DECıMAL'},
                        {'typ':'BIGINT'}, {'typ':'DECIMAL(8,2)'}, {'typ':'TEXT'}):
            with self.subTest(changes=changes), self.assertRaises(ReviewNeeded): self.check(**changes)
        for modifier in ('', 'ALL ', 'DISTINCT '):
            self.assertEqual(self.check(item=f'avg( {modifier}qty ) AS result'), [0])
        with self.assertRaisesRegex(Contradiction, 'function_missing_column'): self.check(item='AVG(missing)')

    def test_legacy_sum_and_min_decimal_scope_are_not_broadened(self):
        with self.assertRaisesRegex(ReviewNeeded, 'function_identity_unknown'):
            check_documented_sum_types(['AVG(qty)'], ['DECIMAL'], ['qty'], ['INT'], mode='M', identity='m_builtin_avg')
        with self.assertRaisesRegex(ReviewNeeded, 'function_argument_type_unknown'):
            check_documented_aggregate_types(['MIN(qty)'], ['DECIMAL'], ['qty'], ['DECIMAL'], mode='M', identity='m_builtin_min')


class AvgConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()

    def manifest(self, suffix):
        mid = 'manifest_m_select_avg_' + suffix
        self.assertTrue(mid in self.r.manifests, mid)
        return self.r.manifests[mid]

    def test_four_queries_use_three_existing_fixtures_and_exact_gates(self):
        all_sql = set()
        for suffix, table, cols in (('builtin','m_b01_source',('id','qty')),
                ('float','m_select_approximate_ns.float_source',('qty',)),
                ('double','m_select_approximate_ns.double_source',('qty',))):
            cs, report = FactorPackageSQLGenerator(self.r).generate_with_report(self.manifest(suffix))
            self.assertEqual({c.sql for c in cs}, {f'SELECT AVG({col}) AS result FROM {table};' for col in cols})
            self.assertTrue(report.pairwise_complete)
            for c in cs:
                gates = {g['key']:g['allowed_values'] for g in c.environment_requirements}
                self.assertEqual(gates['compatibility_mode'], ['M'])
                self.assertEqual(gates['function_resolution'], ['m_builtin_avg'])
                self.assertEqual(c.expected_scope, 'syntax_only')
                all_sql.add(c.sql)
        self.assertEqual(len(all_sql), 4)

    def test_wrong_mode_function_or_actual_source_type_cannot_be_overridden(self):
        for key, values in (('compatibility_mode',['general']), ('function_resolution',['m_builtin_sum']),
                            ('function_resolution',['m_builtin_avg','unknown'])):
            m = copy.deepcopy(self.manifest('float'))
            next(g for g in m.environment_requirements if g.key == key).allowed_values = values
            with self.subTest(key=key, values=values), self.assertRaisesRegex(GenerationValidationError, 'function_resolution'):
                FactorPackageSQLGenerator(self.r).generate_with_report(m)
        m = self.manifest('float'); g = FactorPackageSQLGenerator(self.r)
        original = g._compile_fixture_lifecycle
        def changed(refs):
            setup, down = original(refs)
            return [s.replace('(qty FLOAT)', '(qty DOUBLE)') for s in setup], down
        with patch.object(g, '_compile_fixture_lifecycle', side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError, 'source_type_mismatch'): g.generate_with_report(m)

    def test_new_scenarios_remain_planned_with_separate_output_type_oracle(self):
        self.manifest('builtin')
        for suffix, values in (('builtin', [[[2]],[[20]]]), ('float', [[[2.0]]]), ('double', [[[2.0]]])):
            s = self.r.scenarios['scenario_m_select_avg_' + suffix]
            self.assertEqual(s.status, 'planned')
            self.assertEqual([o['expected'] for o in s.oracles if o['kind']=='result_set'], values)
            self.assertTrue(any(o['kind']=='manual_assertion' for o in s.oracles))
            self.assertIn('target_oracle_calibration', s.execution_requirements)
            self.assertIn('per_step_oracle', s.execution_requirements)

