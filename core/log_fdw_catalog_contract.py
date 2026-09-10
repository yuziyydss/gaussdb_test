"""Finite log_fdw catalog DDL identity, not FDW data or execution validation."""
import re


def _match(pattern, sql):
    match = re.fullmatch(r'\s*'+pattern+r'\s*;?\s*', sql, re.I)
    if match is None:
        raise ValueError('log_fdw_catalog: SQL outside reviewed finite DDL shape')
    return match


def check_log_fdw_catalog(action, sql, setup, teardown, gates):
    """Require the real server, fresh schema and (for DROP) foreign table.

    This is deliberately not a validator for arbitrary wrappers, log options,
    server files, or dependent views. It does not approve running the DDL.
    """
    if gates.get('documented_fdw_available') != ['log_fdw_catalog'] or gates.get('database_scope') != ['non_pdb']:
        raise ValueError('log_fdw_catalog: wrapper and non-PDB gates required')
    expected_setup = {'create': 2, 'drop': 3}.get(action)
    if expected_setup is None or len(setup) != expected_setup:
        raise ValueError('log_fdw_catalog: exact server/schema/table lifecycle required')
    # Only fresh, explicitly test-prefixed schemas/servers; no system names,
    # IF NOT EXISTS, endpoint/credential options, or multiple statements.
    name = r'g_a3_[a-z0-9_]+'
    server = _match(r'CREATE\s+SERVER\s+('+name+r')\s+FOREIGN\s+DATA\s+WRAPPER\s+log_fdw', setup[0])[1].lower()
    schema = _match(r'CREATE\s+SCHEMA\s+('+name+r')', setup[1])[1].lower()
    create_pattern = (r'CREATE\s+FOREIGN\s+TABLE\s+('+re.escape(schema)+r'\.[a-z_][a-z0-9_]*)'
        r'\s*\(\s*col1\s+TEXT\s*\)\s+SERVER\s+'+re.escape(server)+
        r"\s+OPTIONS\s*\(\s*logtype\s+'(?-i:gs_log)'\s*\)")
    table = _match(create_pattern, sql if action == 'create' else setup[2])[1].lower()
    drop_pattern = r'DROP\s+FOREIGN\s+TABLE\s+'+re.escape(table)+r'\s+RESTRICT'
    if action == 'drop':
        _match(drop_pattern, sql)
    cleanup_patterns = ([] if action == 'drop' else [drop_pattern]) + [
        r'DROP\s+SCHEMA\s+'+re.escape(schema)+r'\s+RESTRICT',
        r'DROP\s+SERVER\s+'+re.escape(server)+r'\s+RESTRICT',
    ]
    if len(teardown) != len(cleanup_patterns):
        raise ValueError('log_fdw_catalog: exact ownership-scoped cleanup sequence required')
    for pattern, statement in zip(cleanup_patterns, teardown):
        _match(pattern, statement)
    return {'status': 'checked', 'scope': 'finite_catalog_ddl_only',
            'server': server, 'schema': schema, 'table': table,
            'runtime_proven': False, 'data_access_proven': False, 'cleanup_ownership_proven': False}


def check_log_fdw_enable_rls_negative(sql, setup, teardown, gates, target):
    """Validate a real foreign target for the documented ENABLE prohibition.

    This proves neither runtime rejection nor support for any other ALTER action.
    Reuse CREATE's retained-table cleanup shape, not DROP's removed-table shape.
    """
    if len(setup) != 3 or gates.get('table_authority') != ['fixture_table_creator']:
        raise ValueError('log_fdw_catalog: actual foreign setup and ALTER authority required')
    evidence = check_log_fdw_catalog('create', setup[2], setup[:2], teardown, gates)
    if target.lower() != evidence['table']:
        raise ValueError('log_fdw_catalog: target profile disagrees with actual foreign table')
    _match(r'ALTER\s+TABLE\s+'+re.escape(evidence['table'])+r'\s+ENABLE\s+ROW\s+LEVEL\s+SECURITY', sql)
    return {**evidence, 'scope': 'finite_foreign_enable_rls_negative_shape',
            'target_error_proven': False}
