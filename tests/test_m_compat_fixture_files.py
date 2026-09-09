import hashlib
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import Mock
from core.factor_package_model import FactorFixtureDef
from core.factor_package_generator import FactorPackageSQLGenerator
from core.generator import GeneratedCase
from core.executor import Executor,ExecConfig
from scripts.generate_factor_package_sql import render_sql_snapshot


PAYLOAD=b'1\t10\n2\t20\n3\t30\n'
TARGET='/tmp/m_factor_assets/load_data/two_int.tsv'


def asset(**changes):
    return dict(dict(id='two_int',source_path='assets/two_int.tsv',sha256=hashlib.sha256(PAYLOAD).hexdigest(),
        target_path=TARGET,format='integer_tsv',column_count=2,row_count=3,
        deployment='manual_copy_and_verify',cleanup='remove_only_owned_deployed_file_after_hash_check',fact_refs=[]),**changes)


class MFixtureFileTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup)
        self.root=Path(self.tmp.name);self.path=self.root/'specs/utility/example/fixtures/source.fixture.yaml'
        self.path.parent.mkdir(parents=True);self.local=self.path.parent/'assets/two_int.tsv'
        self.local.parent.mkdir();self.local.write_bytes(PAYLOAD)

    def fixture(self,**changes):
        return FactorFixtureDef.model_validate(dict(schema_version=1,kind='fixture',id='fx',name='fx',status='needs_review',description='file contract',
            provides=dict(tables=[],files=[asset(**changes)]),seed=dict(required=False,rows=[]),
            execution=dict(status='ready',mode='explicit',setup_sqls=['CREATE TABLE t (id INTEGER, qty INTEGER);'],teardown_sqls=['DROP TABLE t;'],note='offline only')))

    def compile(self,fx=None,sql=None):
        fx=fx or self.fixture()
        r=SimpleNamespace(specs_dir=self.root/'specs',source_paths={'fx':self.path},get_fixture=lambda key:fx,
            fixture_topological_order=lambda refs:refs)
        return FactorPackageSQLGenerator(r)._compile_fixture_files(['fx'],sql or f"LOAD DATA INFILE '{TARGET}' INTO TABLE t;",[])

    def test_concrete_file_bytes_and_deployment_are_distinct(self):
        files=self.compile();self.assertEqual(len(files),1)
        self.assertEqual(files[0]['sha256'],hashlib.sha256(PAYLOAD).hexdigest())
        self.assertFalse(files[0]['deployed']);self.assertTrue(files[0]['deployment_required'])
        self.assertEqual(files[0]['repository_source_path'],'specs/utility/example/fixtures/assets/two_int.tsv')

    def test_missing_and_changed_file_fail_closed(self):
        self.local.unlink()
        with self.assertRaisesRegex(ValueError,'file asset'):self.compile()
        self.local.write_bytes(b'9\t90\n')
        with self.assertRaisesRegex(ValueError,'SHA256'):self.compile()

    def test_shape_and_integer_range_are_checked_after_hash(self):
        for data in (b'1\n2\n3\n',b'1\t10\n',b'2147483648\t10\n2\t20\n3\t30\n',b'NULL\t10\n2\t20\n3\t30\n'):
            self.local.write_bytes(data)
            with self.assertRaises(ValueError):self.compile(self.fixture(sha256=hashlib.sha256(data).hexdigest()))

    def test_paths_and_symlinks_cannot_escape_fixture(self):
        for changes in (dict(source_path='../secret.tsv'),dict(target_path='/etc/passwd'),dict(target_path='/tmp/m_factor_assets/../secret'),dict(target_path="/tmp/m_factor_assets/a';DROP.tsv")):
            with self.assertRaises(ValueError):self.fixture(**changes)
        self.local.unlink();outside=self.root/'outside.tsv';outside.write_bytes(PAYLOAD);self.local.symlink_to(outside)
        with self.assertRaisesRegex(ValueError,'outside fixture'):self.compile()

    def test_unconsumed_and_conflicting_target_assets_are_rejected(self):
        with self.assertRaisesRegex(ValueError,'not referenced'):self.compile(sql='SELECT id FROM t;')
        fx=self.fixture();second=fx.provides.files[0].model_copy(update={'id':'other'})
        fx.provides.files.append(second)
        with self.assertRaisesRegex(ValueError,'duplicate'):self.compile(fx)

    def test_serialization_only_changes_cases_with_assets(self):
        plain=GeneratedCase('x','x','pairwise',{},'SELECT id FROM t;')
        self.assertNotIn('file_assets',plain.to_dict())
        case=GeneratedCase('x','x','pairwise',{},f"LOAD DATA INFILE '{TARGET}' INTO TABLE t;",file_assets=self.compile())
        self.assertEqual(case.to_dict()['file_assets'],case.file_assets)
        self.assertIn('-- file_assets:',render_sql_snapshot('file',[case]))
        self.assertNotIn('-- file_assets:',render_sql_snapshot('plain',[plain]))

    def test_legacy_execution_blocks_files_before_any_connection(self):
        case=GeneratedCase('x','x','pairwise',{},f"LOAD DATA INFILE '{TARGET}' INTO TABLE t;",file_assets=self.compile())
        executor=Executor(ExecConfig(enabled=True));executor.connect=Mock(side_effect=AssertionError('no database'))
        executor.create_sandbox=Mock(side_effect=AssertionError('no sandbox'));executor._conn=Mock()
        self.assertEqual(executor.execute_one(case).verdict,'skip')
        self.assertEqual(executor.execute_batch([case])[0].verdict,'skip')
        executor._conn.cursor.assert_not_called();executor.connect.assert_not_called();executor.create_sandbox.assert_not_called()


if __name__=='__main__':unittest.main()
