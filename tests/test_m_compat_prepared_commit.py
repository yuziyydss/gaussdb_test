"""Preparing COMMIT must not commit; an actual owned transaction supplies state."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_03 import prepare
from scripts.build_m_compat_batch_02 import transaction

MID='manifest_m_prepare_commit'
SQL="PREPARE m_prepare_stmt FROM 'COMMIT';"


class PreparedCommitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.r.load_all()

    def test_commit_body_is_a_real_cross_chapter_consumer(self):
        profiles={p['id']:p for p in prepare().files['matrices/body.matrix.yaml']['profiles']}
        self.assertTrue('m_prepare_body_commit' in profiles)
        self.assertEqual(profiles['m_prepare_body_commit']['render'],"'COMMIT'")
        self.assertIn('m_commit::m_commit_fact_syntax',profiles['m_prepare_body_commit']['fact_refs'])
        self.assertIn('m_commit_fact_syntax',transaction('COMMIT').exports)

    def test_owns_real_transaction_and_does_not_execute_before_target(self):
        self.assertTrue(MID in self.r.manifests,MID)
        cases,report=FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1);self.assertTrue(report.pairwise_complete)
        c=cases[0]
        self.assertEqual(c.sql,SQL)
        self.assertEqual(c.setup_sqls,['CREATE TABLE m_commit_data (id INT);',
            'INSERT INTO m_commit_data VALUES (0);','BEGIN;','INSERT INTO m_commit_data VALUES (1);',
            'SELECT COUNT(*) FROM m_commit_data;'])
        self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;','ROLLBACK;','DROP TABLE m_commit_data;'])
        self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
        gates={g['key']:g for g in c.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['M'])
        self.assertEqual(gates['transaction_authority']['allowed_values'],['transaction_creator'])
        self.assertIn('m_commit::m_commit_fact_authority',gates['transaction_authority']['fact_refs'])

    def test_fixture_dependency_and_mode_require_same_owned_session(self):
        fid='fixture_m_prepare_commit'
        self.assertTrue(fid in self.r.fixtures,fid)
        self.assertEqual(self.r.fixtures[fid].requires_fixture_refs,['fixture_m_commit_transaction'])
        self.assertIn('m_commit',self.r.factor_dependency_graph()['m_prepare'])
        gates={g.key:g for g in self.r.manifests[MID].environment_requirements}
        self.assertEqual(gates['session_lifecycle'].allowed_values,['isolated_connection'])

    def test_stage_results_distinguish_prepare_from_execute_without_claiming_execution(self):
        sid='scenario_m_prepare_commit_phase'
        self.assertTrue(sid in self.r.scenarios,sid)
        s=self.r.scenarios[sid]
        self.assertEqual(s.status,'planned')
        self.assertEqual([x['sql'] for x in s.steps],[SQL,'ROLLBACK;',
            'SELECT id FROM m_commit_data ORDER BY id;','BEGIN;',
            'INSERT INTO m_commit_data VALUES (1);','EXECUTE m_prepare_stmt;','ROLLBACK;',
            'SELECT id FROM m_commit_data ORDER BY id;'])
        oracles={o['step_id']:o['expected'] for o in s.oracles}
        self.assertEqual(oracles,{'after_prepare_rollback':[[0]],'after_execute_rollback':[[0],[1]]})
        features=prepare().files['matrices/body.matrix.yaml']['documented_features']
        commit=next(f for f in features if f['id']=='m_prepare_feature_body_commit')
        self.assertEqual(commit['coverage_mode'],'representative')
        self.assertEqual(sum(f['status']=='needs_profile' for f in features),7)


if __name__=='__main__': unittest.main()
