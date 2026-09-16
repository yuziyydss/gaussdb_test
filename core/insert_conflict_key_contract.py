"""Finite PG ON CONFLICT same-key assignment; no arbitrary key mutation proof.

PDF INSERT L80-83 permits tuple assignments/WHERE; L335-367 scopes ON CONFLICT
separately from DUPLICATE KEY's key-update restriction at L332. Planned rows
are derived from literal fixture/input values, not observed database results.
"""
import re


NAME = r'[a-z_][a-z0-9_]*(?:\.[a-z_][a-z0-9_]*)?'
ROW = r"\(\s*(-?[0-9]+)\s*,\s*'((?:''|[^'])*)'\s*\)"


def _row(match):
    key, note = int(match[1]), match[2].replace("''", "'")
    if (not -2147483648 <= key <= 2147483647 or len(note) > 64
            or not note.isascii() or any(ord(c) < 32 or c == '\\' for c in note)):
        raise ValueError('conflict_key: finite INTEGER / ASCII VARCHAR(64) inputs required')
    return key, note


def check_same_key_tuple(sql, setup, teardown, gates):
    required = {'compatibility_mode':['PG'],
                'actor_authority':['fixture_creator_insert_select_update'],
                'case_namespace':['isolated_user_schema']}
    if any(gates.get(k) != v for k,v in required.items()):
        raise ValueError('conflict_key: explicit PG/actor/isolation gates required')
    if len(setup) != 2 or len(teardown) != 1:
        raise ValueError('conflict_key: fresh DDL plus one literal seed only')
    ddl = re.fullmatch(rf'\s*CREATE\s+TABLE\s+({NAME})\s*\(\s*id\s+INTEGER\s+PRIMARY\s+KEY\s*,\s*note\s+VARCHAR\s*\(64\)\s*\)\s*;?\s*',setup[0],re.I|re.A)
    if not ddl:
        raise ValueError('conflict_key: actual two-column inline primary key required')
    table = ddl[1].lower(); name = re.escape(table)
    if not re.fullmatch(rf'\s*DROP\s+TABLE\s+{name}\s*;?\s*',teardown[0],re.I|re.A):
        raise ValueError('conflict_key: exact fresh-table cleanup required')
    seed = re.fullmatch(rf'\s*INSERT\s+INTO\s+{name}\s*\(\s*id\s*,\s*note\s*\)\s+VALUES\s+(.+?)\s*;?\s*',setup[1],re.I|re.A|re.S)
    if not seed:
        raise ValueError('conflict_key: literal seed target required')
    rows = {}; pos = 0; text = seed[1]
    while pos < len(text):
        match = re.compile(ROW, re.A).match(text,pos)
        if not match:
            raise ValueError('conflict_key: finite literal seed required')
        key,note = _row(match)
        if key in rows:
            raise ValueError('conflict_key: duplicate seed primary key')
        rows[key] = note; pos = match.end()
        if not text[pos:].strip():break
        separator = re.match(r'\s*,\s*',text[pos:])
        if not separator or pos+separator.end() == len(text):
            raise ValueError('conflict_key: invalid seed tail')
        pos += separator.end()
    statement = re.fullmatch(
        rf'\s*INSERT\s+INTO\s+{name}\s*\(\s*id\s*,\s*note\s*\)\s+VALUES\s+{ROW}'
        rf'\s+ON\s+CONFLICT\s*\(\s*id\s*\)\s+DO\s+UPDATE\s+SET\s*'
        rf'\(\s*id\s*,\s*note\s*\)\s*=\s*\(\s*EXCLUDED\.id\s*,\s*EXCLUDED\.note\s*\)'
        rf'\s+WHERE\s+{name}\.id\s*>\s*0\s*;?\s*',sql,re.I|re.A|re.S)
    if not statement:
        raise ValueError('conflict_key: single-row same-key tuple and target-key WHERE required')
    key,note = _row(statement)
    if key not in rows:
        branch = 'insert_new_key'; rows[key] = note
    elif key > 0:
        branch = 'update_same_key'; rows[key] = note
    else:
        branch = 'where_filtered'
    return {'contract':'same_inline_integer_key_tuple_v1', 'table':table,
            'branch':branch, 'key_value_changed':False,
            'planned_rows':[[k,v] for k,v in sorted(rows.items())],
            'oracle_sql':f'SELECT id, note FROM {table} ORDER BY id;',
            'scope':'one_inline_integer_key_literal_input_same_column_assignment',
            'runtime_proven':False, 'arbitrary_key_change_proven':False}
