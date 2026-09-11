"""Finite B AUTO_INCREMENT initial/target evidence, not ordinary DEFAULT proof."""
import re


def insert_audit_context(params, environment_requirements, teardown_sqls):
    """Opt in from a declared finite profile, not from a B-looking table name.

    Preserve the requirement list until validation so duplicate keys cannot be
    silently lost in a dict. This describes intended conditions, not DB proof.
    """
    if params.get('target_profile') not in {'insert_target_autoincrement_fresh','insert_target_autoincrement_omitted'}:
        return None
    return {'environment_requirements':environment_requirements, 'teardown_sqls':teardown_sqls}


def check_insert_audit_context(sql, setup, context, source_scope, table):
    """Untrusted report fields must be rechecked against actual fresh DDL."""
    if (source_scope != 'general' or not isinstance(context, dict)
            or set(context) != {'environment_requirements','teardown_sqls'}):
        raise ValueError('auto_increment_contract: explicit general-source audit context required')
    requirements = context['environment_requirements']
    if (not isinstance(requirements, list) or not all(isinstance(r,dict)
            and isinstance(r.get('key'),str) and isinstance(r.get('allowed_values'),list)
            for r in requirements)):
        raise ValueError('auto_increment_contract: malformed environment requirements')
    gates = {r['key']:r['allowed_values'] for r in requirements}
    if len(gates) != len(requirements):
        raise ValueError('auto_increment_contract: duplicate environment requirements')
    teardown = context['teardown_sqls']
    if not isinstance(teardown,list) or not all(isinstance(s,str) for s in teardown):
        raise ValueError('auto_increment_contract: explicit teardown list required')
    return check_autoincrement_insert(sql,setup,teardown,gates,table)


def _match(pattern, sql):
    match = re.fullmatch(r'\s*'+pattern+r'\s*;?\s*', sql, re.I | re.ASCII)
    if match is None:
        raise ValueError('auto_increment_contract: outside reviewed finite SQL shape')
    return match


def check_fresh_autoincrement_source(setup, teardown, gates, table):
    """Shared actual DDL identity; no history, ordinary default or M borrowing."""
    if (gates.get('compatibility_mode') != ['B']
            or gates.get('case_namespace') != ['fresh_user_schema']
            or gates.get('table_authority') != ['fixture_table_creator']):
        raise ValueError('auto_increment_contract: exact B/fresh/owner gates required')
    if not re.fullmatch(r'g_b_[a-z0-9_]{1,45}', table):
        raise ValueError('auto_increment_contract: fresh unqualified target required')
    if len(setup) != 1 or len(teardown) != 1:
        raise ValueError('auto_increment_contract: prior writes/counter state unreviewed')
    name = re.escape(table)
    _match(r'CREATE\s+TABLE\s+'+name+r'\s*\(\s*id\s+INTEGER\s+PRIMARY\s+KEY\s+'
           r'AUTO_INCREMENT\s*,\s*note\s+INTEGER\s*\)\s+AUTO_INCREMENT\s*=\s*1', setup[0])
    _match(r'DROP\s+TABLE\s+'+name+r'\s+RESTRICT', teardown[0])
    return {'scope':'finite_b_fresh_auto_increment', 'table':table, 'column':'id',
            'declared_initial':1,
            'counter_value_proven':False, 'runtime_proven':False,
            'cleanup_ownership_proven':False, 'requires_owned_dependency_inventory':True}


def check_autoincrement_transition(sql, setup, teardown, gates, table):
    """ALTER TABLE L290-293: nonnegative 0 or 10, not a measured counter."""
    evidence = check_fresh_autoincrement_source(setup, teardown, gates, table)
    requested = int(_match(r'ALTER\s+TABLE\s+'+re.escape(table)+r'\s+AUTO_INCREMENT\s*=\s*(0|10)', sql)[1])
    return {**evidence, 'requested_value':requested,
            'requested_value_exceeds_initial':requested > 1}


def check_autoincrement_insert(sql, setup, teardown, gates, table):
    """CREATE TABLE L820-851 allocation inputs, not ordinary DEFAULT resolution.

    Only a fresh single-row input and exact column mapping; no inferred next
    value, RETURNING, history, explicit counter advancement or sequence SQL.
    """
    evidence = check_fresh_autoincrement_source(setup, teardown, gates, table)
    statement = sql.strip().removesuffix(';').strip()
    if ';' in statement:
        raise ValueError('auto_increment_contract: exactly one INSERT statement required')
    body = _match(r'INSERT\s+INTO\s+'+re.escape(table)+r'\s*(.+)', statement)[1].strip()
    omitted = re.fullmatch(r'\(\s*note\s*\)\s+VALUES\s*\(\s*1\s*\)', body, re.I | re.ASCII)
    if omitted:
        trigger = 'omitted'
    else:
        trigger = _match(r'\(\s*id\s*,\s*note\s*\)\s+VALUES\s*\(\s*(NULL|0|DEFAULT)\s*,\s*1\s*\)', body)[1].upper()
    return {**evidence, 'allocation_trigger':trigger,
            'target_columns':['note'] if omitted else ['id', 'note'],
            'scope':'finite_b_fresh_auto_increment_insert'}
