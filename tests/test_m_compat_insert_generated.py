"""Four generated input states retain real column/type and error identity."""
import copy
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.finite_sql_contract import inspect_write
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]


class MInsertGeneratedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generate(self, suffix):
        mid = 'manifest_m_insert_' + suffix
        self.assertTrue(mid in self.registry.manifests, 'Missing manifest: ' + mid)
        return FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[mid])[0]

    def test_null_is_a_distinct_literal_negative_not_integer_or_default(self):
        cases = self.generate('generated_null_negative')
        self.assertEqual(len(cases), 1)
        case = cases[0]
        self.assertIn('(7,9,NULL)', case.sql)
        self.assertEqual(case.expected, 'error')
        self.assertFalse(case.expected_sqlstates)
        self.assertEqual(case.expected_error_category, 'generated_write')
        check = inspect_write(case.sql, case.setup_sqls)
        self.assertEqual(check['issues'][0]['code'], 'generated_column_write')
        profile = self.registry.resolve_dimension_values('m_insert')['source_profile'][case.params['source_profile']]
        self.assertEqual(profile.attributes['source_profile.properties.output_types'][-1], 'NULL')

    def test_omission_values_and_query_keep_three_real_available_columns(self):
        for suffix in ('generated_omitted_values', 'generated_omitted_query'):
            with self.subTest(suffix=suffix):
                cases = self.generate(suffix)
                self.assertEqual(len(cases), 1)
                case = cases[0]
                self.assertEqual(case.expected, 'success')
                self.assertIn('g INT GENERATED ALWAYS AS', '\n'.join(case.setup_sqls))
                resolved = self.registry.resolve_dimension_values('m_insert')
                target = resolved['target_profile'][case.params['target_profile']]
                source = resolved['source_profile'][case.params['source_profile']]
                self.assertEqual(target.attributes['target_profile.properties.available_column_count'], 3)
                self.assertEqual(source.attributes['source_profile.properties.output_column_count'], 2)
                checked = inspect_write(case.sql, case.setup_sqls, conflict_source_scope='m_compat')
                self.assertEqual(checked['status'], 'checked', checked)
                self.assertIn('stored_generated_integer_sum', checked['checks'])
                self.assertEqual(case.expected_scope, 'syntax_only')

    def test_null_input_proof_does_not_relax_global_type_compatibility(self):
        self.assertFalse(FactorPackageSQLGenerator._types_compatible('INTEGER','NULL'))
        self.assertFalse(FactorPackageSQLGenerator._set_types_equal('INTEGER','NULL'))
        resolved = copy.deepcopy(self.registry.resolve_dimension_values('m_insert'))
        source = resolved['source_profile']['m_insert_source_profile_values']
        source.attributes['source_profile.properties.output_types'] = ['INTEGER','NULL']
        source.attributes['source_profile.properties.items'] = ['(7,NULL)']
        combo = {'target_profile':'m_insert_target_profile_table',
                 'source_profile':'m_insert_source_profile_values'}
        FactorPackageSQLGenerator._validate_insert_input_contract(combo, resolved)
        for forged in (['(7,9)'], ["(7,'NULL')"], ['(7,NULL)','(8,9)'],
                       ['(7,NULL,9)'], ['7,NULL'], ['(7,CAST(NULL AS INTEGER))'], []):
            with self.subTest(forged=forged):
                source.attributes['source_profile.properties.items'] = forged
                with self.assertRaises(GenerationValidationError):
                    FactorPackageSQLGenerator._validate_insert_input_contract(combo, resolved)

    def test_unknown_query_output_cannot_claim_literal_null_evidence(self):
        resolved = copy.deepcopy(self.registry.resolve_dimension_values('m_insert'))
        source = resolved['source_profile']['m_insert_source_profile_query']
        source.attributes['source_profile.properties.output_types'] = ['INTEGER','NULL']
        source.attributes['source_profile.properties.items'] = []
        combo = {'target_profile':'m_insert_target_profile_table',
                 'source_profile':'m_insert_source_profile_query'}
        with self.assertRaises(GenerationValidationError):
            FactorPackageSQLGenerator._validate_insert_input_contract(combo, resolved)

    def test_finite_audit_preserves_unexecuted_scenarios(self):
        self.generate('generated_null_negative')
        audit = FactorCoverageAuditor(self.registry).audit('m_insert')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['manifests']['unresolved_error_oracles'])


if __name__ == '__main__':
    unittest.main()
