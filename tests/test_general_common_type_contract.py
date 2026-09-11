"""PDF 1.9.4/1.9.5: finite common types, not a general cast interpreter."""
import unittest
import copy
from pathlib import Path

from core.finite_sql_contract import Contradiction, ReviewNeeded

SETUP = ['CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);']


class CommonTypeGeneratorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()

    def test_selected_contract_cannot_lie_about_actual_case_output(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.factor_package_model import EnvironmentRequirementDef
        from core.spec_generator import GenerationValidationError
        matrix=self.r.matrices['matrix_select_query_profiles']
        profile=next(p for p in matrix.profiles if p.id=='select_basic_star')
        old=profile.model_copy(deep=True)
        manifest=copy.deepcopy(self.r.manifests['manifest_select_core_positive'])
        manifest.bindings={'query_profile':['select_basic_star']}
        manifest.environment_requirements=[EnvironmentRequirementDef(key='compatibility_mode',allowed_values=['PG'],fact_refs=['select_fact_permissions'])]
        try:
            profile.render='SELECT CASE WHEN TRUE THEN col_1 ELSE col_2 END AS result FROM t_select_source'
            profile.properties.update(common_type_contract='pg_scalar_union_case_v1',output_types=['TEXT'])
            with self.assertRaisesRegex(GenerationValidationError,'common_type_output_mismatch'):
                FactorPackageSQLGenerator(self.r).generate_with_report(manifest)
        finally:
            matrix.profiles[matrix.profiles.index(profile)]=old

    def test_real_new_candidates_share_a_fixture_and_keep_pending_oracles(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        g=FactorPackageSQLGenerator(self.r)
        for f,count in [('select',7),('insert',2)]:
            cases,report=g.generate_with_report(self.r.manifests[f'manifest_{f}_common_type_pg'])
            self.assertEqual(len(cases),count)
            self.assertTrue(report.pairwise_complete)
            self.assertEqual(len({c.case_id for c in cases}),count)
            for c in cases:
                self.assertIn('CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);',c.setup_sqls)
                self.assertEqual(c.expected,'success');self.assertEqual(c.expected_scope,'syntax_only')
                self.assertFalse(any(s.startswith('DROP ') for s in c.setup_sqls))
                if f=='insert':
                    self.assertEqual(c.teardown_sqls,['DROP TABLE g_common_target;','DROP TABLE g_common_source;'])
        for sid in ('scenario_select_common_union_unknown','scenario_insert_common_case_integer'):
            s=self.r.scenarios[sid]
            self.assertEqual(s.status,'planned')
            self.assertTrue(any(o['kind']=='manual_assertion' for o in s.oracles))

    def test_real_manifest_mode_and_actual_ddl_cannot_be_forged(self):
        from unittest.mock import patch
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        for mode in ('M','A','C'):
            m=copy.deepcopy(self.r.manifests['manifest_select_common_type_pg'])
            next(g for g in m.environment_requirements if g.key=='compatibility_mode').allowed_values=[mode]
            with self.subTest(mode=mode), self.assertRaisesRegex(GenerationValidationError,'physical PG'):
                FactorPackageSQLGenerator(self.r).generate_with_report(m)
        g=FactorPackageSQLGenerator(self.r);original=g._compile_fixture_lifecycle
        def changed(refs):
            setup,down=original(refs)
            return [s.replace('qty INTEGER','qty TEXT') for s in setup],down
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'common_type_category'):
                g.generate_with_report(self.r.manifests['manifest_select_common_type_pg'])

    def test_curated_increment_rebuild_and_body_hashes(self):
        import hashlib
        from scripts.build_common_type_batch import ROOT,SOURCES,planned_files
        self.assertEqual(planned_files(),{})
        for base,rel,sha,_ in SOURCES.values():
            self.assertEqual(hashlib.sha256((ROOT/base/rel).read_bytes()).hexdigest(),sha)
        self.assertIn('select',self.r.factor_dependency_graph()['insert'])
        self.assertEqual(self.r.fixture_topological_order(['fixture_insert_common_type']),
                         ['fixture_select_common_type','fixture_insert_common_type'])


class CommonTypeTests(unittest.TestCase):
    def infer(self, sql, mode='PG', setup=None):
        from core.common_type_contract import infer_query_types
        return infer_query_types(sql, SETUP if setup is None else setup, mode=mode)

    def test_same_type_and_null_resolve_per_column(self):
        self.assertEqual(self.infer('SELECT id, note FROM g_common_source UNION SELECT qty, NULL FROM g_common_source'), ['INTEGER', 'TEXT'])
        self.assertEqual(self.infer('SELECT NULL UNION SELECT NULL'), ['TEXT'])
        self.assertEqual(self.infer("SELECT 'a' UNION SELECT 'b'"), ['TEXT'])
        self.assertEqual(self.infer('SELECT id FROM g_common_source UNION ALL SELECT NULL'), ['INTEGER'])

    def test_case_types_include_unselected_branch(self):
        self.assertEqual(self.infer('SELECT CASE WHEN flag THEN id ELSE qty END AS result FROM g_common_source'), ['INTEGER'])
        self.assertEqual(self.infer('SELECT CASE WHEN TRUE THEN NULL ELSE NULL END'), ['TEXT'])
        with self.assertRaisesRegex(Contradiction, 'common_type_category'):
            self.infer('SELECT CASE WHEN TRUE THEN id ELSE note END FROM g_common_source')

    def test_union_arity_and_left_association_are_not_ignored(self):
        with self.assertRaisesRegex(Contradiction, 'common_type_arity'):
            self.infer('SELECT 1, TRUE UNION SELECT 2')
        with self.assertRaisesRegex(Contradiction, 'common_type_category'):
            self.infer('SELECT NULL UNION SELECT NULL UNION SELECT 1')

    def test_unknown_string_is_not_a_typed_text_or_proved_integer(self):
        for token in ("'1'", "'bad'"):
            with self.subTest(token=token), self.assertRaisesRegex(ReviewNeeded, 'unknown_input_conversion'):
                self.infer(f'SELECT {token} UNION SELECT 1')

    def test_mode_casts_precision_and_nonfinite_forms_remain_review(self):
        for mode in ('A', 'C', 'M', None):
            with self.subTest(mode=mode), self.assertRaises(ReviewNeeded): self.infer('SELECT 1 UNION SELECT 2',mode)
        for sql in ('SELECT 1.2 UNION SELECT 1', 'SELECT CAST(1 AS BIGINT) UNION SELECT 2',
                    'SELECT 2147483648 UNION SELECT 2', 'SELECT 1 INTERSECT SELECT 2',
                    'SELECT CASE WHEN id THEN id ELSE qty END FROM g_common_source',
                    'SELECT 1; SELECT 2', 'SELECT 1 /* comment */ UNION SELECT 2'):
            with self.subTest(sql=sql), self.assertRaises(ReviewNeeded): self.infer(sql)
        with self.assertRaises(ReviewNeeded):
            self.infer('SELECT id UNION SELECT qty',setup=[])

    def test_actual_source_ddl_and_missing_columns_are_checked(self):
        with self.assertRaisesRegex(Contradiction, 'common_type_missing_column'):
            self.infer('SELECT missing FROM g_common_source UNION SELECT qty FROM g_common_source')
        with self.assertRaises(ReviewNeeded):
            self.infer('SELECT id FROM g_common_source UNION SELECT qty FROM g_common_source',
                       setup=SETUP+['DROP TABLE g_common_source;'])
        with self.assertRaises(ReviewNeeded):
            self.infer('SELECT id FROM g_common_source UNION SELECT qty FROM g_common_source',
                       setup=['CREATE TABLE g_common_source (id INTEGER, qty BIGINT);'])

    def test_storage_uses_exact_target_type_not_a_mode_free_cast_table(self):
        from core.common_type_contract import check_common_type_query
        sql='INSERT INTO g_common_source (id) SELECT CASE WHEN TRUE THEN 1 ELSE 2 END'
        result=check_common_type_query(sql,SETUP,mode='PG',output_types=['INTEGER'])
        self.assertTrue(result['exact_assignment_types'])
        self.assertFalse(result['runtime_proven'])
        with self.assertRaisesRegex(ReviewNeeded, 'assignment_conversion_unknown'):
            check_common_type_query(sql.replace('(id)', '(note)'),SETUP,mode='PG',output_types=['INTEGER'])
        with self.assertRaisesRegex(Contradiction, 'common_type_output_mismatch'):
            check_common_type_query('SELECT 1 UNION SELECT 2',SETUP,mode='PG',output_types=['TEXT'])


if __name__ == '__main__': unittest.main()
