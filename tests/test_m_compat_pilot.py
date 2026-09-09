"""M pilot contracts: static evidence only, never a database success claim."""
import copy
import hashlib
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
PILOT = ('m_create_table', 'm_create_view', 'm_insert', 'm_update', 'm_delete', 'm_select')


class MCompatPilotTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def select_contract(self, **changes):
        factor = self.registry.factors['m_select']
        resolved = copy.deepcopy(self.registry.resolve_dimension_values(factor.id))
        combo = {key: value.default_value_id for key, value in factor.dimensions.items()}
        combo.update(changes)
        return factor, combo, resolved

    def test_absent_lock_is_semantic_property_not_general_value_id(self):
        factor, combo, resolved = self.select_contract(select_modifier='m_select_select_modifier_distinctrow')
        self.generator._validate_structural_contract(factor, combo, resolved)

    def test_real_lock_still_rejects_distinct(self):
        factor, combo, resolved = self.select_contract(select_modifier='m_select_select_modifier_distinct')
        resolved['lock_clause'][combo['lock_clause']].attributes['lock_clause.properties.active'] = True
        with self.assertRaisesRegex(GenerationValidationError, '锁定子句'):
            self.generator._validate_structural_contract(factor, combo, resolved)

    def test_set_output_contract_rejects_wrong_arity(self):
        factor, combo, resolved = self.select_contract(set_operator='m_select_set_operator_union', right_target_list='m_select_right_target_list_two')
        with self.assertRaisesRegex(GenerationValidationError, '输出列数不一致'):
            self.generator._validate_structural_contract(factor, combo, resolved)

    def test_all_manifests_generate_nonempty_unique_deterministic_cases(self):
        global_ids = set()
        for fid in PILOT:
            factor = self.registry.factors[fid]
            sqls = set()
            for mid in factor.manifest_refs:
                with self.subTest(manifest=mid):
                    manifest = self.registry.manifests[mid]
                    cases, report = self.generator.generate_with_report(manifest)
                    again, _ = self.generator.generate_with_report(manifest)
                    self.assertTrue(cases)
                    self.assertTrue(report.pairwise_complete)
                    self.assertEqual([(c.case_id,c.sql) for c in cases], [(c.case_id,c.sql) for c in again])
                    for dim, values in manifest.bindings.items():
                        self.assertEqual(set(values), {c.params[dim] for c in cases}, (mid,dim))
                    varied = {dim for dim,values in manifest.bindings.items() if len(values)>1}
                    for case in cases:
                        self.assertTrue(varied.issubset(case.consumed_dimension_ids), (mid,case.sql,varied,case.consumed_dimension_ids))
                        self.assertNotIn(case.case_id, global_ids)
                        self.assertNotIn(case.sql, sqls)
                        global_ids.add(case.case_id)
                        sqls.add(case.sql)
                        self.assertNotIn('{', case.sql)
                        self.assertNotIn('...', case.sql)
                        self.assertTrue(case.setup_sqls)
                        self.assertTrue(case.teardown_sqls)
                        self.assertEqual(case.environment_requirements[0]['allowed_values'], ['M'])
                        if case.expected == 'error':
                            self.assertEqual(case.expected_oracle_status, 'needs_verification')
                            self.assertFalse(case.expected_sqlstates)

    def test_cross_fixture_topology_does_not_duplicate_source_table(self):
        manifest = self.registry.manifests['manifest_m_insert_view']
        refs = self.generator._ordered_fixture_refs(manifest.fixture_refs)
        self.assertLess(refs.index('fixture_m_create_table_source'), refs.index('fixture_m_create_view_direct'))
        setup, teardown = self.generator._compile_fixture_lifecycle(refs)
        self.assertEqual(sum(sql.startswith('CREATE TABLE m_b01_source ') for sql in setup), 1)
        self.assertLess(next(i for i,s in enumerate(teardown) if s.startswith('DROP VIEW')),
                        next(i for i,s in enumerate(teardown) if s.startswith('DROP TABLE')))
        self.assertFalse(any(s.strip() == 'SELECT 1;' for s in setup))

    def test_source_identity_and_honest_unmapped_ledger(self):
        for fid in PILOT:
            with self.subTest(factor=fid):
                factor = self.registry.factors[fid]
                self.assertEqual(factor.status, 'needs_review')
                src = factor.source
                self.assertTrue(src.catalog_chapter_ref.source_relpath.startswith('m_compat/'))
                path = ROOT/'work/m_compat_batch_01/corpus'/src.catalog_chapter_ref.source_relpath
                self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), src.artifact_sha256)
                ledger = self.registry.source_ledgers[factor.source_ledger_ref]
                self.assertTrue(any(u.status == 'unmapped' for u in ledger.units))
                lines = [n for u in ledger.units for n in range(u.line_start,u.line_end+1)]
                lines += [entry.line for entry in ledger.ignored_lines]
                self.assertEqual(sorted(lines), list(range(1,len(path.read_text().splitlines())+1)))
                self.assertNotEqual(src.artifact_sha256, self.registry.factors[fid[2:]].source.artifact_sha256)

    def test_m_spellings_are_not_general_mode_substitutions(self):
        sqls = {}
        for fid in PILOT:
            sqls[fid] = [c.sql for mid in self.registry.factors[fid].manifest_refs
                         for c in self.generator.generate_cases_for_manifest(self.registry.manifests[mid])]
        self.assertTrue(any('INSERT m_b01_source SET ' in s for s in sqls['m_insert']))
        self.assertTrue(any(' VALUE ' in s for s in sqls['m_insert']))
        self.assertTrue(any('DISTINCTROW' in s for s in sqls['m_select']))
        self.assertTrue(any('LIMIT 1,2' in s for s in sqls['m_select']))
        self.assertTrue(any('VIRTUAL' in s for s in sqls['m_create_table']))
        for s in sqls['m_create_view']:
            self.assertNotIn('WITH READ ONLY', s)
            self.assertNotIn(' TEMP ', s)
        for fid in ('m_update','m_delete'):
            self.assertFalse(any(' ONLY ' in s or ' RETURNING ' in s for s in sqls[fid]))


if __name__ == '__main__':
    unittest.main()
