"""General-chapter LOAD DATA: bounded B-mode candidate, never a deployed file."""
import hashlib
from pathlib import Path
import unittest
from unittest.mock import Mock

from core.factor_package_model import FactorPackageRegistry, FixtureInputFileDef
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.executor import Executor, ExecConfig

ROOT = Path(__file__).resolve().parents[1]
PAYLOAD = b'1\t10\n2\t20\n3\t30\n'
TARGET = '/tmp/factor_assets/general/load_data/two_int.tsv'


class SharedFixturePathTests(unittest.TestCase):
    def test_explicit_general_namespace_keeps_old_m_and_rejects_escape(self):
        data = dict(id='two_int',source_path='assets/two_int.tsv',
                    sha256=hashlib.sha256(PAYLOAD).hexdigest(),target_path=TARGET,
                    format='integer_tsv',column_count=2,row_count=3,
                    deployment='manual_copy_and_verify',
                    cleanup='remove_only_owned_deployed_file_after_hash_check')
        self.assertEqual(FixtureInputFileDef(**data).target_path,TARGET)
        old = '/tmp/m_factor_assets/load_data/two_int.tsv'
        self.assertEqual(FixtureInputFileDef(**dict(data,target_path=old)).target_path,old)
        for path in ('/tmp/two_int.tsv','/etc/passwd','/tmp/factor_assets/../secret',
                     '/tmp/factor_assets//x','/tmp/factor_assets/./x'):
            with self.subTest(path=path), self.assertRaises(ValueError):
                FixtureInputFileDef(**dict(data,target_path=path))


class GeneralLoadDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def generated(self):
        return self.generator.generate_with_report(
            self.registry.manifests['manifest_load_data_two_int'])

    def test_two_exact_candidates_use_real_bytes_and_b_mode_authority(self):
        cases, report = self.generated()
        prefix = ("LOAD DATA INFILE '"+TARGET+"' INTO TABLE g_load_data_two_int "
                  "FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'")
        self.assertEqual({c.sql for c in cases},{prefix+';',prefix+' (id,qty);'})
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        for case in cases:
            self.assertEqual(case.setup_sqls,['CREATE TABLE g_load_data_two_int (id INTEGER,qty INTEGER);'])
            self.assertEqual(case.teardown_sqls,['DROP TABLE g_load_data_two_int;'])
            self.assertEqual(len(case.file_assets),1)
            asset = case.file_assets[0]
            self.assertEqual((ROOT/asset['repository_source_path']).read_bytes(),PAYLOAD)
            self.assertEqual(asset['sha256'],hashlib.sha256(PAYLOAD).hexdigest())
            self.assertEqual((asset['row_count'],asset['column_count']),(3,2))
            self.assertFalse(asset['deployed'])
            self.assertTrue(asset['deployment_required'])
            gates = {e['key']:e for e in case.environment_requirements}
            for key, value in [('compatibility_mode','B'),('b_format_version','5.7'),
                               ('b_format_dev_version','s2'),('actor_authority','sysadmin'),
                               ('enable_copy_server_files','on')]:
                self.assertEqual(gates[key]['allowed_values'],[value])
            self.assertEqual(gates['actor_authority']['fact_refs'],['copy::copy_fact_body_10'])
            self.assertEqual(case.expected_scope,'syntax_only')
            self.assertNotIn('LOCAL',case.sql)

    def test_undeployed_file_is_blocked_before_any_database_connection(self):
        cases, _ = self.generated()
        executor = Executor(ExecConfig(enabled=True))
        executor.connect = Mock(side_effect=AssertionError('no database'))
        executor.create_sandbox = Mock(side_effect=AssertionError('no database'))
        executor._conn = Mock()
        self.assertEqual(executor.execute_batch(cases)[0].verdict,'skip')
        executor.connect.assert_not_called()
        executor.create_sandbox.assert_not_called()
        executor._conn.cursor.assert_not_called()

    def test_remaining_runtime_questions_and_copy_dependency_are_not_hidden(self):
        self.generated()
        factor = self.registry.factors['load_data']
        self.assertEqual({f.id for f in factor.facts if f.type=='open_question'}, set())
        graph = self.registry.factor_dependency_graph()
        self.assertIn('copy',graph['load_data'])
        audit = FactorCoverageAuditor(self.registry).audit('load_data')
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['facts']['wrong_consumer_type'],[])
        syntax = self.registry.syntaxes['syntax_load_data']
        self.assertNotIn('load_data_fact_grammar_line_32',syntax.source_fact_refs)
        self.assertNotIn('load_data_fact_grammar_line_49',syntax.source_fact_refs)
        matrix = self.registry.matrices['matrix_load_data_coverage']
        self.assertEqual({f.id for f in matrix.documented_features if f.status=='needs_profile'}, set())


if __name__ == '__main__':
    unittest.main()
