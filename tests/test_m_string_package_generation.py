"""Formal manifests must consume storage evidence, not just label profiles."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from core.finite_sql_contract import inspect_write
from scripts.prepare_execution_batch import build_batch
from scripts.build_m_compat_pilot import insert, update
from tests.evolved_asset_assertions import assert_evolved_asset

ROOT = Path(__file__).resolve().parents[1]


class MStringPackageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def test_formal_manifests_have_real_storage_checks_and_seed(self):
        for factor in ('m_insert', 'm_update'):
            manifest = self.registry.manifests['manifest_'+factor+'_string_utf8']
            cases, report = self.generator.generate_with_report(manifest)
            self.assertTrue(cases)
            self.assertTrue(report.pairwise_complete)
            for case in cases:
                result = inspect_write(case.sql, case.setup_sqls, conflict_source_scope='m_compat',
                                       environment_requirements=case.environment_requirements)
                self.assertEqual(result['status'], 'checked', result)
                self.assertIn('shared_m_utf8_string_storage', result['checks'])
                self.assertEqual(case.expected, 'success')
                self.assertTrue(case.teardown_sqls)
                if factor == 'm_update':
                    self.assertTrue(any(s.startswith('INSERT ') for s in case.setup_sqls))
            sqls = '\n'.join(c.sql for c in cases)
            for token in ("''", "'a'", "'ab'", "'中'", "'中文'", "'😀好'", 'DEFAULT'):
                self.assertIn(token, sqls)

    def test_missing_mode_or_encoding_cannot_silently_generate_positive(self):
        for factor in ('m_insert', 'm_update'):
            for key in ('compatibility_mode', 'client_encoding', 'character_set_database'):
                manifest = copy.deepcopy(self.registry.manifests['manifest_'+factor+'_string_utf8'])
                manifest.environment_requirements = [g for g in manifest.environment_requirements if g.key != key]
                with self.assertRaisesRegex(GenerationValidationError, 'required_write_contract'):
                    self.generator.generate_with_report(manifest)

    def test_sources_and_planned_oracles_are_present_without_verified_claim(self):
        for fid in ('m_insert', 'm_update'):
            factor = self.registry.factors[fid]
            ledger = self.registry.source_ledgers[factor.source_ledger_ref]
            self.assertTrue(any(s.id == fid+'_string_types_source' for s in ledger.supplemental_sources))
            self.assertTrue(any(s.id == fid+'_string_charset_source' for s in ledger.supplemental_sources))
            scenarios = [self.registry.scenarios[s] for s in factor.scenario_refs if '_string_' in s]
            self.assertTrue(scenarios)
            self.assertTrue(all(s.status == 'planned' for s in scenarios))
            self.assertTrue(all(s.oracles for s in scenarios))

    def test_offline_batch_binds_all_generated_candidates_without_execution(self):
        batch = build_batch(self.registry, self.generator, profile='m_string_storage')
        self.assertEqual(batch['summary']['candidates'], 17)
        self.assertEqual(batch['summary']['bound_candidate_ids'], 17)
        self.assertEqual(batch['summary']['unbound_candidate_ids'], [])
        self.assertEqual(batch['summary']['runtime_verified'], 0)
        self.assertFalse(batch['database_executed'])
        self.assertFalse(batch['execution_authorized'])
        for unit in batch['units']:
            self.assertEqual(unit['static_blockers'], [], unit)
            self.assertTrue(all('sql' not in step['source_step'] for step in unit['steps']))

    def test_oversized_seed_or_default_cannot_pass_via_declared_column_type(self):
        for factor in ('m_insert', 'm_update'):
            fixture_id = 'fixture_'+factor+'_string_utf8'
            for mutation in ('default', 'seed') if factor == 'm_update' else ('default',):
                fixture = self.registry.fixtures[fixture_id].model_copy(deep=True)
                if mutation == 'default':
                    fixture.execution.setup_sqls[0] = fixture.execution.setup_sqls[0].replace("'默认'", "'默认值'")
                else:
                    fixture.execution.setup_sqls[1] = fixture.execution.setup_sqls[1].replace("'旧'", "'中文好'")
                with self.subTest(factor=factor, mutation=mutation), patch.dict(self.registry.fixtures, {fixture_id: fixture}):
                    with self.assertRaises(GenerationValidationError):
                        self.generator.generate_with_report(self.registry.manifests['manifest_'+factor+'_string_utf8'])

    def test_changed_literal_and_unknown_contract_are_not_label_only_checks(self):
        matrix_id = 'matrix_m_insert_source_profile'
        matrix = self.registry.matrices[matrix_id].model_copy(deep=True)
        profile = next(p for p in matrix.profiles if p.id == 'm_insert_source_profile_string_han_edge')
        profile.properties['items'] = ["(7,'中文好')"]
        with patch.dict(self.registry.matrices, {matrix_id: matrix}):
            with self.assertRaises(GenerationValidationError):
                self.generator.generate_with_report(self.registry.manifests['manifest_m_insert_string_utf8'])
        matrix_id = 'matrix_m_insert_target_profile'
        matrix = self.registry.matrices[matrix_id].model_copy(deep=True)
        profile = next(p for p in matrix.profiles if p.id == 'm_insert_target_profile_string_utf8')
        profile.properties['required_write_contract'] = 'unrecognized_storage'
        with patch.dict(self.registry.matrices, {matrix_id: matrix}):
            with self.assertRaisesRegex(GenerationValidationError, 'unsupported contract'):
                self.generator.generate_with_report(self.registry.manifests['manifest_m_insert_string_utf8'])
