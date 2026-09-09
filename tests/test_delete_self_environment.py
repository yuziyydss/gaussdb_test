"""Declared B self-USING proof stays separate from measured mode and behavior."""
import copy,json,unittest
from pathlib import Path
from core.finite_delete_contract import inspect_delete
from scripts.audit_delete_contracts import audit_report

SETUP=['CREATE TABLE t (id INTEGER, note VARCHAR(64));',"INSERT INTO t VALUES (1,'one');"]
SQL='DELETE FROM t USING t AS src;'
GATE=[{'key':'compatibility_mode','allowed_values':['B'],'fact_refs':['delete_fact_single_using_b_environment']}]

class DeleteSelfEnvironmentTests(unittest.TestCase):
    def test_default_call_does_not_guess_b(self):
        self.assertEqual(inspect_delete(SQL,SETUP)['status'],'needs_review')

    def test_exact_declared_b_supports_only_bounded_self_using_shape(self):
        for sql in (SQL,'DELETE t USING t src;'):
            result=inspect_delete(sql,SETUP,environment_requirements=GATE)
            self.assertEqual(result['status'],'checked',result)
            self.assertIn('delete_self_using_declared_b',result['checks'])
            self.assertTrue(any('declared' in x for x in result['limits']))

    def test_missing_wrong_broad_duplicate_gates_are_not_proof(self):
        for gates in ([],[dict(key='compatibility_mode',allowed_values=[])],
                      [dict(key='compatibility_mode',allowed_values=['A'])],
                      [dict(key='compatibility_mode',allowed_values=['M'])],
                      [dict(key='compatibility_mode',allowed_values=['B','A'])],GATE+GATE,
                      {'compatibility_mode':'B'},['B'],GATE+['B'],[dict(key='compatibility_mode',allowed_values='B')]):
            result=inspect_delete(SQL,SETUP,environment_requirements=gates)
            self.assertEqual(result['status'],'needs_review',gates)

    def test_wider_self_shapes_and_mutated_fixture_remain_unreviewed(self):
        for sql in ('DELETE FROM ONLY t USING t AS src;','DELETE FROM t * USING t AS src;',
                    'DELETE FROM t AS d USING t AS src;','DELETE FROM t USING t;',
                    'DELETE FROM t USING t AS t;','DELETE FROM t USING t AS src WHERE t.id=1;',
                    'DELETE FROM t USING t AS src RETURNING t.id;',
                    'DELETE FROM t USING t AS src ORDER BY t.id;',
                    'DELETE FROM t USING t AS src LIMIT 1;',
                    'WITH c AS (SELECT id FROM t) DELETE FROM t USING t AS src;'):
            self.assertEqual(inspect_delete(sql,SETUP,environment_requirements=GATE)['status'],'needs_review',sql)
        for extra in ('DROP TABLE t;','ALTER TABLE t ADD x INTEGER;'):
            self.assertEqual(inspect_delete(SQL,SETUP+[extra],environment_requirements=GATE)['status'],'needs_review')
        self.assertEqual(inspect_delete('DELETE FROM ns.t USING t AS src;',
            ['CREATE TABLE ns.t (id INTEGER);'],environment_requirements=GATE)['status'],'needs_review')
        self.assertEqual(inspect_delete('DELETE FROM v USING v AS src;',
            SETUP+['CREATE VIEW v AS SELECT id,note FROM t;'],environment_requirements=GATE)['status'],'needs_review')

    def test_actual_audit_consumes_gates_without_upgrading_lifecycle_or_oracle(self):
        root=Path(__file__).resolve().parents[1]
        r=json.loads((root/'generated/factor_packages/generation_report.json').read_text())
        mid='manifest_delete_self_using_b_fresh';selected={'manifests':{mid:r['manifests'][mid]}}
        before=copy.deepcopy(selected);result=audit_report(selected)
        self.assertEqual(selected,before)
        self.assertEqual(result['summary']['delete_contract'],{'checked':2})
        self.assertFalse(result['database_executed'])
        for case in result['cases']:
            self.assertFalse(case['target_error_verified'])
            self.assertEqual(case['lifecycle']['status'],'needs_review')
        for case in selected['manifests'][mid]['cases']:
            case['environment_requirements']=[]
        self.assertEqual(audit_report(selected)['summary']['delete_contract'],{'needs_review':2})
