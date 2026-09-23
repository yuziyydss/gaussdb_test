"""CREATE OPERATOR CLASS uses one transactional FUNCTION 1 representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_create_operator_class_fresh_function'
NS='g_create_opclass_ns'
NAME=f'{NS}.g_create_opclass'


class CreateOperatorClassFreshFunctionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_non_default_btree_function_candidate(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
            f'CREATE OPERATOR CLASS {NAME} FOR TYPE INTEGER USING btree '
            f'AS FUNCTION 1 {NS}.compare_integer(INTEGER, INTEGER);')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_transactional_function_fixture_and_cleanup(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls,[
            'BEGIN;',
            f'CREATE SCHEMA {NS};',
            f'CREATE FUNCTION {NS}.compare_integer(INTEGER, INTEGER) RETURNS INTEGER '
            "LANGUAGE SQL IMMUTABLE AS 'SELECT CASE WHEN $1 = $2 THEN 0 "
            "WHEN $1 < $2 THEN -1 ELSE 1 END;';",
        ])
        self.assertEqual(case.teardown_sqls,['ROLLBACK;'])
        self.assertFalse(any('DROP OPERATOR' in x or 'CASCADE' in x or 'DROP OWNED' in x
                              for x in case.setup_sqls+case.teardown_sqls))
        fixture=self.r.fixtures['fixture_create_operator_class_fresh_function']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('事务内','非默认','索引比较契约','ROLLBACK','禁止COMMIT'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gates_feature_and_audit_do_not_claim_index_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['internal_operator_class_test']['allowed_values'],['true'])
        self.assertIn('create_operator_class_fact_internal',
                      gates['internal_operator_class_test']['fact_refs'])
        self.assertEqual(gates['operator_class_create_privilege']['allowed_values'],['sysadmin'])
        self.assertIn('create_operator_class_fact_privilege',
                      gates['operator_class_create_privilege']['fact_refs'])
        self.assertEqual(gates['create_function_authority']['allowed_values'],['true'])
        self.assertIn('create_function::create_function_fact_create_any',
                      gates['create_function_authority']['fact_refs'])
        features={f.id:f for f in self.r.matrices['matrix_create_operator_class_coverage'].documented_features}
        feature=features['create_operator_class_feature_function_items']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','representative'))
        self.assertEqual(feature.value_refs,[
            'create_operator_class_class_name_fresh',
            'create_operator_class_default_modifier_nondefault',
            'create_operator_class_data_type_integer',
            'create_operator_class_method_btree_fresh',
            'create_operator_class_family_implicit',
            'create_operator_class_members_fresh_function',
        ])
        audit=FactorCoverageAuditor(self.r).audit('create_operator_class')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])


if __name__=='__main__':unittest.main()
