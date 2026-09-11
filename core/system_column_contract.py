"""Finite documented ROWID identity prerequisites, not runtime catalog proof."""
import re


def _require(pattern, sql):
    if not isinstance(sql,str) or re.fullmatch(r'\s*'+pattern+r'\s*;?\s*',sql,re.I) is None:
        raise ValueError('system_column_contract: SQL outside reviewed finite shape')


def check_rowid_source(setup, teardown, gates, table):
    """One fresh ordinary table, only id INTEGER and hasrowid=on in A mode.

    Implicit system columns are not put in user-column provides with guessed
    types. Automatically created sequence/index identities require runtime proof.
    """
    return _check_rowid_table(setup, teardown, gates, table, initial='on',
                             authority=('executor_authority','create_any_table_and_sequence'))


def _check_rowid_table(setup, teardown, gates, table, *, initial, authority):
    if (gates.get('compatibility_mode') != ['A']
            or gates.get('case_namespace') != ['fresh_user_schema']
            or gates.get(authority[0]) != [authority[1]]):
        raise ValueError('system_column_contract: exact mode, namespace and authority gates required')
    if not isinstance(table,str) or re.fullmatch(r'g_a3_[a-z0-9_]+',table) is None:
        raise ValueError('system_column_contract: fresh unqualified target name required')
    if len(setup)!=1 or len(teardown)!=1:
        raise ValueError('system_column_contract: exact single-table lifecycle required')
    _require(r'CREATE\s+TABLE\s+'+re.escape(table)+
             r'\s*\(\s*id\s+INTEGER\s*\)\s+WITH\s*\(\s*hasrowid\s*=\s*'+initial+r'\s*\)',setup[0])
    _require(r'DROP\s+TABLE\s+'+re.escape(table)+r'\s+RESTRICT',teardown[0])
    return {'scope':'finite_hasrowid_storage_identity', 'table':table,
            'system_column_names':['rowid','rowno'], 'system_column_types':None,
            'catalog_identity_proven':False, 'physical_mode_proven':False,
            'requires_owned_dependency_inventory':True, 'cleanup_ownership_proven':False}


def check_sequence_system_target(sql, setup, teardown, gates, table, column):
    evidence=check_rowid_source(setup,teardown,gates,table)
    if column not in ('rowid','rowno'):
        raise ValueError('system_column_contract: only documented system targets')
    _require(r'CREATE\s+SEQUENCE\s+seq_[a-z0-9_]+\s+OWNED\s+BY\s+'
             +re.escape(table)+r'\.'+column,sql)
    return {**evidence,'target_column':column,'target_error_proven':False}


def check_alter_rowid_target(sql, setup, teardown, gates, table):
    """Empty ordinary table off→on; excludes compressed data and other actions."""
    evidence=_check_rowid_table(setup,teardown,gates,table,initial='off',
                                authority=('table_authority','fixture_table_creator'))
    _require(r'ALTER\s+TABLE\s+'+re.escape(table)+r'\s+SET\s+WITH\s+ROWID',sql)
    return {**evidence, 'planned_transition':{'hasrowid_before':False,'hasrowid_after':True},
            'transition_executed':False}
