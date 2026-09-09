"""Static M environment preparation; never connects to or creates a database.

Environment setup is a batch-level connection plan, not a per-case SQL fixture.
The emitted gsql files are opt-in, stop on errors, and never drop a database.
"""
from dataclasses import dataclass
import re


MODE_SQL = (
    "SELECT current_database(), datcompatibility FROM pg_catalog.pg_database "
    "WHERE datname = current_database()"
)
BOOTSTRAP_PATH = "generated/m_compat_environment/plan.json"


def requires_m(case):
    return any(r.get('key') == 'compatibility_mode' and
               r.get('allowed_values') == ['M']
               for r in getattr(case, 'environment_requirements', []))


def guard(expression, label):
    # Scalar expression fails closed on NULL as well as false. gsql must stop
    # on the resulting error; it must not continue into CREATE/USE/test SQL.
    return f"SELECT 1 / CASE WHEN {expression} THEN 1 ELSE 0 END AS {label};"


@dataclass(frozen=True)
class MEnvironment:
    management_database: str = 'postgres'
    database: str = 'm_factor_test'
    namespace: str = 'm_factor_run'

    def __post_init__(self):
        for value in (self.management_database, self.database, self.namespace):
            if not re.fullmatch(r'[a-z][a-z0-9_]{0,62}', value):
                raise ValueError('Use simple lowercase identifiers, at most 63 characters')
        # Explicit test prefixes also exclude SQL keywords and system objects.
        if not self.database.startswith('m_factor_') or not self.namespace.startswith('m_factor_'):
            raise ValueError('Database and namespace must use the m_factor_ test prefix')
        if len({self.management_database, self.database, self.namespace}) != 3:
            raise ValueError('Management database, physical M database and schema must differ')

    def files(self):
        stop = '\\set ON_ERROR_STOP on\n\\set AUTOCOMMIT on\n'
        actual_mode = '(SELECT datcompatibility FROM pg_catalog.pg_database WHERE datname = current_database())'
        create = stop + '\n'.join([
            '-- Optional NEW database route: run on the non-M management connection.',
            '-- Requires CREATEDB; outside any transaction; existing database is an error.',
            guard(f"current_database() = '{self.management_database}' AND {actual_mode} <> 'M'", 'management_verified'),
            f"CREATE DATABASE {self.database} DBCOMPATIBILITY = 'M';",
            '',
        ])
        connect = stop + '\n'.join([
            '-- Required for both NEW and explicitly approved REUSE routes.',
            '-- The next line is a gsql client command, NOT server SQL.',
            f'\\connect {self.database}',
            guard(f"current_database() = '{self.database}' AND {actual_mode} = 'M'", 'm_database_verified'),
            MODE_SQL + ';',
            '',
        ])
        namespace = stop + '\n'.join([
            '-- Run on the verified M connection. Existing schema is an error.',
            guard(f"current_database() = '{self.database}' AND {actual_mode} = 'M'", 'm_database_verified'),
            f'CREATE SCHEMA {self.namespace};',
            f'USE {self.namespace};',
            guard(f"database() = '{self.namespace}'", 'namespace_verified'),
            '',
        ])
        return {'00_create_database.gsql': create, '01_connect_verify.gsql': connect,
                '02_namespace.gsql': namespace}

    def plan(self):
        return {
            'kind': 'm_environment_preparation', 'static_only': True,
            'database_executed': False, 'test_runner_calibrated': False,
            'management_database': self.management_database,
            'physical_database': self.database, 'namespace': self.namespace,
            'new_route': ['00_create_database.gsql', '01_connect_verify.gsql', '02_namespace.gsql'],
            'reuse_route': ['01_connect_verify.gsql', '02_namespace.gsql'],
            'connection_contract': {
                'create_database_autocommit': True, 'reconnect_required': True,
                'namespace_and_case_same_connection': True,
                'transaction_fixture_same_connection': True,
                'case_execution': 'isolated serial lifecycle; not a concatenated SQL smoke script',
            },
            'failure_policy': {
                'environment_failure': 'stop before fixtures; never count as target negative pass',
                'setup_failure': 'stop target; retain partial object inventory for reviewed cleanup',
                'cleanup': 'only objects proven created by this run; never blind DROP OWNED/CASCADE',
                'physical_database_drop': 'not generated; requires separate explicit approval',
            },
            'limitations': ['Privileges and M feature availability require actual environment validation',
                           'M DDL, transaction isolation and target Oracles remain unexecuted',
                           'Legacy executor is blocked for M: its general sandbox cleanup is not M-calibrated'],
        }
