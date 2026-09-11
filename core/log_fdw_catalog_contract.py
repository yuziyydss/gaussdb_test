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
    create_pattern = (r'CREATE\s+FOREIGN\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?('+re.escape(schema)+r'\.[a-z_][a-z0-9_]*)'
        r'\s*\(\s*col1\s+TEXT\s*\)\s+SERVER\s+'+re.escape(server)+
        r"\s+OPTIONS\s*\(\s*logtype\s+'(?-i:gs_log)'\s*\)")
    table = _match(create_pattern, sql if action == 'create' else setup[2])[1].lower()
    drop_pattern = r'DROP\s+FOREIGN\s+TABLE\s+(?:IF\s+EXISTS\s+)?'+re.escape(table)+r'(?:\s+RESTRICT)?'
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


def check_log_fdw_option_seed(sql, table):
    """Only the documented ADD latest_files '2' setup statement, no state proof."""
    _match(r'ALTER\s+FOREIGN\s+TABLE\s+'+re.escape(table)+
           r"\s+OPTIONS\s*\(\s*ADD\s+latest_files\s+'2'\s*\)", sql)


def check_log_fdw_option_change(sql, setup, teardown, gates, operation):
    """Documented latest_files representatives with actual absent/present state."""
    clauses = {'implicit': "latest_files '2'", 'add': "ADD latest_files '2'",
               'set': "SET latest_files '5'", 'drop': 'DROP latest_files'}
    if operation not in clauses:
        raise ValueError('log_fdw_catalog: finite option operation required')
    present = operation in ('set', 'drop')
    if len(setup) != (4 if present else 3):
        raise ValueError('log_fdw_catalog: exact initial option state required')
    evidence = check_log_fdw_catalog('create', setup[2], setup[:2], teardown, gates)
    prefix = r'ALTER\s+FOREIGN\s+TABLE\s+'+re.escape(evidence['table'])+r'\s+OPTIONS\s*\(\s*'
    def clause_pattern(clause):
        # SQL words insensitive, documented option values remain literal.
        return r'\s+'.join(re.escape(part) for part in clause.split())
    _match(prefix+clause_pattern(clauses[operation])+r'\s*\)', sql)
    if present:
        check_log_fdw_option_seed(setup[3], evidence['table'])
    return {**evidence, 'scope': 'finite_latest_files_option_state',
            'initial_option_present': present, 'operation': operation,
            'validator_behavior_proven': False, 'physical_mode_proven': False}
