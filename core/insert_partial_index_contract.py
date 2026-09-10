"""Finite expression/partial-index arbitration, not SQL/runtime validation.

General INSERT L335-369 and CREATE INDEX L26-29, L126-129, L384-390,
L649-658. Exact integer +1 / second-column >0 identity only. No predicate
implication, function resolution, PK substitution, or database access.
"""
import re

from .finite_sql_contract import ReviewNeeded, split_list


def _match(pattern, sql):
    match = re.fullmatch(r'\s*'+pattern+r'\s*;?\s*', sql, re.I)
    if match is None:
        raise ReviewNeeded('partial_index_shape_unknown',
                           'Actual SQL is outside the reviewed partial-index contract')
    return match


def _integer(token):
    if not re.fullmatch(r'[+-]?[0-9]{1,10}', token):
        raise ReviewNeeded('partial_index_input_unknown', 'Only finite INTEGER literals are reviewed')
    value = int(token)
    if not -(2**31) <= value <= 2**31-1:
        raise ReviewNeeded('partial_index_range_unknown', 'Actual input exceeds INTEGER range')
    return value


def _row(text):
    row = _match(r'\(\s*([+-]?[0-9]+)\s*,\s*([+-]?[0-9]+)\s*\)', text)
    return (_integer(row[1]), _integer(row[2]))


def _key(row):
    key = row[0] + 1
    if not -(2**31) <= key <= 2**31-1:
        raise ReviewNeeded('partial_index_range_unknown', 'Index expression exceeds INTEGER range')
    return key


def check_partial_index_insert(sql, setup, teardown):
    """Check actual fresh DDL/seed and one DO NOTHING input, under PG gates.

    The caller must separately require PG, built-in integer operator binding,
    an isolated writable schema and ownership-scoped execution. Returned row
    outcomes are model expectations, never runtime Oracle results. The finite
    identifier domain avoids accepting arbitrary reserved or quoted names.
    """
    if len(setup) != 3 or len(teardown) != 1:
        raise ReviewNeeded('partial_index_lifecycle_unknown', 'Require fresh table, unique index, seed, exact DROP')
    name = r'g_[a-z][a-z0-9_]{0,48}'
    ddl = _match(r'CREATE\s+TABLE\s+('+name+r')\s*\(\s*'
                 r'(id|k|key_col)\s+(?:INT|INTEGER)\s+NOT\s+NULL\s*,\s*'
                 r'(flag|s|predicate_col)\s+(?:INT|INTEGER)\s+NOT\s+NULL\s*\)\s*'
                 r'WITH\s*\(\s*storage_type\s*=\s*ASTORE\s*\)', setup[0])
    table, key_column, predicate_column = (v.lower() for v in ddl.groups())
    table_re, key_re, predicate_re = map(re.escape, (table, key_column, predicate_column))
    expression = rf'\(\s*{key_re}\s*\+\s*1\s*\)'
    target = rf'\(\s*{expression}\s*\)\s+WHERE\s+{predicate_re}\s*>\s*0'
    index = _match(r'CREATE\s+UNIQUE\s+INDEX\s+('+name+r')\s+ON\s+'
                   +table_re+r'\s+USING\s+btree\s*'+target, setup[1])[1].lower()
    if index == table:
        raise ReviewNeeded('partial_index_name_collision', 'Table and index must have distinct names')
    columns = rf'\(\s*{key_re}\s*,\s*{predicate_re}\s*\)'
    insertion = rf'INSERT\s+INTO\s+{table_re}\s*{columns}\s+VALUES\s*'
    seed_text = _match(insertion+r'(\(.+\))', setup[2])[1]
    row_texts = split_list(seed_text)
    if not 1 <= len(row_texts) <= 32:
        raise ReviewNeeded('partial_index_seed_unknown', 'Require 1-32 actual finite seed rows')
    seeds = [_row(text) for text in row_texts]
    active_keys = set()
    for row in seeds:
        key = _key(row)
        if row[1] > 0:
            if key in active_keys:
                raise ReviewNeeded('partial_index_seed_conflict', 'Seed violates the actual partial unique index')
            active_keys.add(key)
    incoming_text = _match(insertion+r'(\([^()]+\))\s+ON\s+CONFLICT\s*'
                           +target+r'\s+DO\s+NOTHING', sql)[1]
    incoming = _row(incoming_text)
    incoming_key = _key(incoming)
    _match(r'DROP\s+TABLE\s+'+table_re+r'\s+RESTRICT', teardown[0])
    member = incoming[1] > 0
    conflict = member and incoming_key in active_keys
    return {
        'status': 'checked', 'scope': 'finite_exact_partial_index_model',
        'table': table, 'index': index, 'key_column': key_column,
        'predicate_column': predicate_column, 'expression': key_column+' + 1',
        'predicate': predicate_column+' > 0', 'seed_rows': [list(row) for row in seeds],
        'incoming_row': list(incoming), 'predicate_member': member,
        'conflict_in_finite_model': conflict, 'expected_affected_rows': 0 if conflict else 1,
        'required_compatibility_mode': 'PG', 'required_operator_binding': 'builtin_integer_plus_and_gt',
        'runtime_proven': False, 'operator_identity_proven': False,
        'cleanup_ownership_proven': False,
    }
