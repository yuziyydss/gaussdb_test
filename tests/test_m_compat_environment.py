import unittest
from types import SimpleNamespace
from unittest.mock import Mock

from core.executor import Executor, ExecConfig
from core.m_compat_environment import MEnvironment, requires_m
from scripts.generate_factor_package_sql import render_sql_snapshot


class MEnvironmentTests(unittest.TestCase):
    def test_separate_database_reconnect_and_namespace(self):
        files = MEnvironment().files()
        self.assertIn("DBCOMPATIBILITY = 'M'", files['00_create_database.gsql'])
        self.assertIn("<> 'M'", files['00_create_database.gsql'])
        self.assertIn('\\connect m_factor_test', files['01_connect_verify.gsql'])
        self.assertIn('datcompatibility', files['01_connect_verify.gsql'])
        self.assertIn("database() = 'm_factor_run'", files['02_namespace.gsql'])
        for sql in files.values():
            self.assertTrue(sql.startswith('\\set ON_ERROR_STOP on'))
            self.assertIn('\\set AUTOCOMMIT on', sql)
            self.assertNotIn('DROP ', sql)
            self.assertNotIn('IF NOT EXISTS', sql)
        self.assertNotIn('00_create_database.gsql', MEnvironment().plan()['reuse_route'])

    def test_identifiers_fail_closed(self):
        for bad in ('public', 'template0', 'm_factor_a;DROP TABLE x', 'm_factor_"', 'm_factor_'+'x'*63):
            with self.subTest(value=bad), self.assertRaises(ValueError):
                MEnvironment(database=bad)
        with self.assertRaises(ValueError):
            MEnvironment(database='m_factor_same',namespace='m_factor_same')

    def test_legacy_executor_never_writes_or_connects_for_m_even_negative(self):
        case = SimpleNamespace(case_id='m_case', sql='DROP DATABASE m_owned_schema;', expected='error',
            environment_requirements=[dict(key='compatibility_mode',allowed_values=['M'])])
        executor = Executor(ExecConfig(enabled=True, environment_capabilities={'compatibility_mode':'M'}))
        executor.connect = Mock(side_effect=AssertionError('must not connect'))
        executor.create_sandbox = Mock(side_effect=AssertionError('must not write'))
        executor._conn = Mock()
        self.assertEqual(executor.execute_one(case).verdict, 'skip')
        self.assertEqual(executor.execute_batch([case])[0].verdict, 'skip')
        executor._conn.cursor.assert_not_called()

    def test_general_snapshot_is_unchanged(self):
        self.assertEqual(render_sql_snapshot('empty', []), '-- generated_from: empty\n-- static_only: true\n-- case_count: 0\n')
        self.assertFalse(requires_m(SimpleNamespace(environment_requirements=[])))


if __name__ == '__main__':
    unittest.main()
