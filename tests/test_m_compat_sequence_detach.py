"""Detach starts from an owned sequence, not an already-independent sequence."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

MID='manifest_m_alter_sequence_detach_owned'
FID='fixture_m_alter_sequence_owned_source'
SEQ='m_b03_existing_seq'
OWNER='m_b03_sequence_owner'


class SequenceDetachTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_target_has_real_owned_unadvanced_precondition(self):
        self.assertTrue(MID in self.r.manifests,MID)
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1);self.assertTrue(report.pairwise_complete)
        c=cases[0]
        self.assertEqual(c.sql,f'ALTER SEQUENCE {SEQ} OWNED BY NONE;')
        self.assertEqual(c.setup_sqls,[f'CREATE TABLE {OWNER} (id INT);',
            f'CREATE SEQUENCE {SEQ} MINVALUE 1 MAXVALUE 100 START 5 CACHE 1 OWNED BY {OWNER}.id;'])
        self.assertEqual(c.teardown_sqls,[f'DROP SEQUENCE IF EXISTS {SEQ};',f'DROP TABLE IF EXISTS {OWNER};'])
        self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_scoped_selection_does_not_expand_old_finite_domain(self):
        self.assertTrue(MID in self.r.manifests,MID)
        f=self.r.factors['m_alter_sequence'];m=self.r.manifests[MID]
        case=self.g.generate_cases_for_manifest(m)[0]
        solver=self.g._build_solver(f,m,self.r.resolve_dimension_values(f.id))
        self.assertTrue(solver.is_valid(case.params)[0])
        for key,value in [('change','max'),('owned','unchanged'),('if_exists','yes')]:
            bad=copy.deepcopy(case.params);bad[key]='m_alter_sequence_'+key+'_'+value
            self.assertFalse(solver.is_valid(bad)[0],bad)
        old=self.r.manifests['manifest_m_alter_sequence_finite']
        self.assertNotIn('m_alter_sequence_change_unchanged',old.bindings['change'])
        self.assertTrue(all(c.params['change']!='m_alter_sequence_change_unchanged'
                            for c in self.g.generate_cases_for_manifest(old)))

    def test_planned_result_uses_initial_nextval_after_owner_drop(self):
        s=self.r.scenarios['scenario_m_alter_sequence_association']
        self.assertEqual(s.fixture_refs,[FID])
        self.assertEqual(s.status,'planned')
        self.assertEqual([x['sql'] for x in s.steps],[f'ALTER SEQUENCE {SEQ} OWNED BY NONE;',
            f'DROP TABLE {OWNER};',f"SELECT nextval('{SEQ}');"])
        self.assertEqual(s.oracles,[dict(kind='result_set',step_id='after_owner_drop',expected=[[5]])])
        self.assertIn('m_create_sequence::m_create_sequence_fact_owned',s.fact_refs)
        self.assertTrue(any(f.type=='open_question' and '相等' in f.statement
                            for f in self.r.factors['m_alter_sequence'].facts))

    def test_permissions_have_real_typed_cross_chapter_sources(self):
        self.assertTrue(MID in self.r.manifests,MID)
        gates={x.key:x for x in self.r.manifests[MID].environment_requirements}
        expected={'sequence_creation_authority':('create_any_sequence','m_create_sequence::m_create_sequence_fact_authority'),
            'table_creation_authority':('create_any_table','m_create_table::m_create_table_fact_authority'),
            'object_authority':('case_object_owner','m_alter_sequence_fact_authority')}
        for key,(allowed,ref) in expected.items():
            self.assertEqual(gates[key].allowed_values,[allowed]);self.assertIn(ref,gates[key].fact_refs)
            package,fact=ref.split('::') if '::' in ref else ('m_alter_sequence',ref)
            self.assertEqual(next(f.type for f in self.r.factors[package].facts if f.id==fact),'environment')
        self.assertEqual(gates['compatibility_mode'].allowed_values,['M'])
        self.assertEqual(gates['namespace'].allowed_values,['isolated_user_schema'])


if __name__=='__main__':unittest.main()
