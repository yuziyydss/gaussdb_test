"""NULL-only field is not an empty table and is not a zero row count."""
from tests.evolved_asset_assertions import assert_evolved_asset
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import select

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_m_select_count_all_null';TABLE='m_select_count_ns.source_table'


class CountNullBoundaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def manifest(self):
        self.assertTrue(MID in self.r.manifests,MID);return self.r.manifests[MID]

    def test_four_existing_projections_get_a_real_two_null_row_fixture(self):
        g=FactorPackageSQLGenerator(self.r);cases,report=g.generate_with_report(self.manifest())
        self.assertTrue(report.pairwise_complete);self.assertEqual(len(cases),4)
        self.assertEqual({c.sql for c in cases},{f'SELECT COUNT({v}) AS result FROM {TABLE};'
            for v in ('qty','ALL qty','DISTINCT qty','*')})
        for c in cases:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA m_select_count_ns;',
                f'CREATE TABLE {TABLE} (id INTEGER, qty INTEGER);',
                f'INSERT INTO {TABLE} (id,qty) VALUES (2,NULL),(2,NULL);'])
            self.assertEqual(c.teardown_sqls,[f'DROP TABLE {TABLE} RESTRICT;','DROP SCHEMA m_select_count_ns;'])
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
        fx=self.r.fixtures['fixture_m_select_count_all_null_source']
        self.assertEqual(fx.name,fx.id)
        self.assertEqual(fx.seed.rows,[{'id':2,'qty':None},{'id':2,'qty':None}]);self.assertTrue(fx.seed.required)
        self.assertEqual(fx.requires_fixture_refs,[])

    def test_same_sql_is_distinct_fixture_coverage_not_distinct_sql(self):
        g=FactorPackageSQLGenerator(self.r);fresh,_=g.generate_with_report(self.manifest())
        old=[]
        for mid in ('manifest_m_select_count_nullable','manifest_m_select_count_star'):
            old.extend(g.generate_with_report(self.r.manifests[mid])[0])
        self.assertTrue({c.sql for c in fresh}<={c.sql for c in old})
        self.assertFalse({c.case_id for c in fresh}&{c.case_id for c in old})
        for c in fresh:
            previous=next(p for p in old if p.sql==c.sql)
            self.assertEqual(c.environment_requirements,previous.environment_requirements)
            self.assertNotEqual(c.setup_sqls,previous.setup_sqls)

    def test_zero_field_counts_and_two_rows_have_planned_step_oracles(self):
        self.manifest();s=self.r.scenarios['scenario_m_select_count_all_null']
        self.assertEqual(s.status,'planned');self.assertEqual(len(s.steps),4)
        self.assertEqual([o['expected'] for o in s.oracles if o['kind']=='result_set'],[[[0]],[[0]],[[0]],[[2]]])
        meta=[o for o in s.oracles if o['kind']=='manual_assertion']
        self.assertEqual(len(meta),4);self.assertTrue(all('BIGINT' in o['expected'] for o in meta))
        self.assertEqual({o['step_id'] for o in meta},{x['id'] for x in s.steps})
        for k in ('database_authorization','target_oracle_calibration','per_step_oracle','ownership_scoped_cleanup'):
            self.assertIn(k,s.execution_requirements)

    def test_auditor_keeps_text_overlap_but_only_rejects_same_actual_inputs(self):
        self.manifest();audit=FactorCoverageAuditor(self.r).audit('m_select')
        self.assertEqual(len(audit['manifests']['duplicate_sql']),4)
        self.assertEqual(audit['manifests']['duplicate_inputs'],[])
        repeated=copy.deepcopy(self.manifest())
        repeated.fixture_refs=['fixture_m_select_count_source']
        with patch.dict(self.r.manifests,{MID:repeated}):
            bad=FactorCoverageAuditor(self.r).audit('m_select')
        self.assertEqual(len(bad['manifests']['duplicate_inputs']),4)
        self.assertFalse(bad['conclusions']['generation_model_complete'])


if __name__=='__main__':unittest.main()
