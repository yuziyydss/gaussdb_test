"""Explicit A table 1-309 subset must not widen the PG contract."""
import copy
from pathlib import Path
import unittest

SETUP = ['CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);']
CONTRACT = 'a_integer_union_case_v1'


class AIntegerConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()

    def test_explicit_a_identity_works_in_actual_generator_without_pg_borrowing(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.factor_package_model import EnvironmentRequirementDef
        r = self.registry
        matrix = r.matrices['matrix_select_query_profiles']
        profile = next(p for p in matrix.profiles if p.id == 'select_basic_star')
        old = profile.model_copy(deep=True)
        manifest = copy.deepcopy(r.manifests['manifest_select_core_positive'])
        manifest.bindings = {'query_profile': ['select_basic_star']}
        manifest.environment_requirements = [EnvironmentRequirementDef(key='compatibility_mode',allowed_values=['A'],
            fact_refs=['create_database::create_database_fact_compatibility_environment'])]
        try:
            # Same known INTEGER pair is within the explicit A table, not a PG fallback.
            profile.render = 'SELECT col_1 FROM t_select_source UNION SELECT col_2 FROM t_select_source'
            profile.properties.update(common_type_contract=CONTRACT, output_types=['INTEGER'])
            cases,_ = FactorPackageSQLGenerator(r).generate_with_report(manifest)
            self.assertEqual(len(cases),1)
            self.assertIn(' UNION ',cases[0].sql)
        finally:
            matrix.profiles[matrix.profiles.index(profile)] = old

    def test_real_candidates_fixtures_mode_and_pending_oracle(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        g = FactorPackageSQLGenerator(self.registry)
        for factor, count in [('select',4),('insert',2)]:
            cases, report = g.generate_with_report(self.registry.manifests[f'manifest_{factor}_common_type_a_integer'])
            self.assertEqual(len(cases),count)
            self.assertEqual(len({c.case_id for c in cases}),count)
            self.assertTrue(report.pairwise_complete)
            for c in cases:
                self.assertEqual(c.expected,'success');self.assertEqual(c.expected_scope,'syntax_only')
                self.assertEqual([r['allowed_values'] for r in c.environment_requirements if r['key']=='compatibility_mode'],[['A']])
                self.assertEqual(c.setup_sqls[0],SETUP[0])
                self.assertFalse(any(s.startswith('DROP ') for s in c.setup_sqls))
                if factor=='insert':
                    self.assertEqual(c.teardown_sqls,['DROP TABLE a_common_target;','DROP TABLE a_common_source;'])
        self.assertEqual(self.registry.fixture_topological_order(['fixture_insert_common_type_a_integer']),
                         ['fixture_select_common_type_a_integer','fixture_insert_common_type_a_integer'])
        scenario = self.registry.scenarios['scenario_insert_common_a_integer']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(scenario.oracles[0]['expected'],[[1],[2]])
        self.assertTrue(any(o['kind']=='manual_assertion' for o in scenario.oracles))

    def test_actual_a_manifest_wrong_mode_and_target_ddl_rejected(self):
        from unittest.mock import patch
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        g = FactorPackageSQLGenerator(self.registry)
        base = self.registry.manifests['manifest_insert_common_type_a_integer']
        for mode in ('PG','M','C'):
            m=copy.deepcopy(base);m.environment_requirements[0].allowed_values=[mode]
            with self.subTest(mode=mode),self.assertRaisesRegex(GenerationValidationError,'physical A'):
                g.generate_with_report(m)
        original = g._compile_fixture_lifecycle
        def wrong(refs):
            setup,down=original(refs)
            return [s.replace('result BIGINT','result INTEGER') for s in setup],down
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=wrong):
            with self.assertRaisesRegex(GenerationValidationError,'assignment_conversion_unknown'):
                g.generate_with_report(base)

    def test_curated_source_anchor_and_nine_cells_not_whole_chapter(self):
        import hashlib
        from scripts.build_a_integer_common_type import ROOT,SOURCES,planned_files,ENV,RULE
        self.assertEqual(planned_files(),{})
        base,rel,sha,_ = SOURCES['common']
        text = (ROOT/base/rel).read_text()
        self.assertEqual(hashlib.sha256((ROOT/base/rel).read_bytes()).hexdigest(),sha)
        self.assertIn('A兼容模式',text.splitlines()[27].replace(' ',''))
        ledger = self.registry.source_ledgers[self.registry.factors['select'].source_ledger_ref]
        source = next(s for s in ledger.supplemental_sources if s.id=='select_type_a_integer_source')
        self.assertEqual(source.source_anchor,'L28-L52')
        self.assertEqual(source.catalog_chapter_ref.chapter_sha256,sha)
        unit = next(u for u in ledger.units if u.id=='select_src_028')
        self.assertIn(source.id,unit.supplemental_source_refs)
        self.assertTrue({ENV,RULE}.issubset(unit.fact_refs))


class AIntegerTypeTests(unittest.TestCase):
    def infer(self, sql, mode='A', setup=SETUP):
        from core.common_type_contract import infer_query_types
        return infer_query_types(sql,setup,mode=mode,contract=CONTRACT)

    def test_nine_ordered_pairs_for_union_and_case(self):
        # Independent literal transcription of the nine reviewed PDF cells.
        expected = [['SMALLINT','INTEGER','BIGINT'],['INTEGER','INTEGER','BIGINT'],['BIGINT','BIGINT','BIGINT']]
        columns = ['lo','mid','hi']
        for i,left in enumerate(columns):
            for j,right in enumerate(columns):
                with self.subTest(left=left,right=right):
                    self.assertEqual(self.infer(f'SELECT {left} FROM a_common_source UNION SELECT {right} FROM a_common_source'),[expected[i][j]])
                    self.assertEqual(self.infer(f'SELECT CASE WHEN TRUE THEN {left} ELSE {right} END FROM a_common_source'),[expected[i][j]])

    def test_other_modes_and_pg_default_do_not_use_a_table(self):
        from core.common_type_contract import infer_query_types
        from core.finite_sql_contract import ReviewNeeded
        sql = 'SELECT lo FROM a_common_source UNION SELECT hi FROM a_common_source'
        for mode in ('PG','M','C',None):
            with self.subTest(mode=mode), self.assertRaises(ReviewNeeded): self.infer(sql,mode)
        with self.assertRaises(ReviewNeeded): infer_query_types(sql,SETUP,mode='PG')
        with self.assertRaises(ReviewNeeded): infer_query_types(sql,SETUP,mode='A')

    def test_unknowns_float_typmod_and_functions_remain_review(self):
        from core.finite_sql_contract import ReviewNeeded
        for expression in ('NULL', "'1'", 'TRUE', '1.5', "CAST('1' AS BIGINT)", 'decode(1,1,lo,hi)'):
            with self.subTest(expression=expression), self.assertRaises(ReviewNeeded):
                self.infer(f'SELECT lo FROM a_common_source UNION SELECT {expression} FROM a_common_source')
        with self.assertRaises(ReviewNeeded):
            self.infer('SELECT lo FROM a_common_source UNION SELECT hi FROM a_common_source',
                       setup=['CREATE TABLE a_common_source (lo SMALLINT, hi NUMERIC(10,2));'])

    def test_output_and_storage_identity_not_value_fit(self):
        from core.common_type_contract import check_common_type_query
        from core.finite_sql_contract import Contradiction, ReviewNeeded
        sql = 'INSERT INTO target (result) SELECT CASE WHEN TRUE THEN lo ELSE hi END FROM a_common_source'
        kwargs = dict(mode='A',contract=CONTRACT,output_types=['BIGINT'])
        result = check_common_type_query(sql,SETUP+['CREATE TABLE target (result BIGINT);'],**kwargs)
        self.assertFalse(result['runtime_proven'])
        with self.assertRaisesRegex(ReviewNeeded,'assignment_conversion_unknown'):
            check_common_type_query(sql,SETUP+['CREATE TABLE target (result INTEGER);'],**kwargs)
        with self.assertRaisesRegex(Contradiction,'common_type_output_mismatch'):
            check_common_type_query(sql,SETUP+['CREATE TABLE target (result BIGINT);'],mode='A',contract=CONTRACT,output_types=['INTEGER'])

    def test_actual_ddl_arity_and_all_branches(self):
        from core.finite_sql_contract import Contradiction, ReviewNeeded
        sql = 'SELECT CASE WHEN TRUE THEN lo ELSE hi END FROM a_common_source'
        with self.assertRaises(ReviewNeeded): self.infer(sql,setup=SETUP+['DROP TABLE a_common_source;'])
        with self.assertRaises(ReviewNeeded): self.infer(sql,setup=['CREATE TABLE a_common_source (lo SMALLINT, hi TEXT);'])
        with self.assertRaises(Contradiction): self.infer('SELECT lo,hi FROM a_common_source UNION SELECT mid FROM a_common_source')


if __name__ == '__main__': unittest.main()
