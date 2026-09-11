"""Finite ASTORE two-level / USTORE one-level LOCAL checks; not runtime proof."""
import re

from .finite_sql_contract import IDENT, split_list, take_group, top_mask


def _require(condition, detail):
    if not condition:
        raise ValueError('index_partition_contract: '+detail)


def _statement(sql):
    text = sql.strip().removesuffix(';').strip()
    _require('--' not in text and '/*' not in text and ';' not in top_mask(text),
             'one uncommented statement required')
    return text


def _match(pattern, text):
    match = re.fullmatch(pattern, text, re.I | re.ASCII)
    _require(match is not None, 'outside reviewed finite shape: '+text[:120])
    return match


def _bound_list(body, *, children, names, word=None):
    """Parse explicit single-INTEGER upper bounds, retaining declared order."""
    result = []
    word = word or ('PARTITION' if children else 'SUBPARTITION')
    for item in split_list(body):
        head = re.match(rf'{word}\s+({IDENT})\s+VALUES\s+LESS\s+THAN\s*\(\s*([+-]?[0-9]+)\s*\)\s*',
                        item, re.I | re.ASCII)
        _require(head is not None, 'explicit finite INTEGER bound required')
        name, upper = head[1].lower(), int(head[2])
        _require(name not in names, 'duplicate table partition name')
        _require(-(2**31) <= upper < 2**31, 'bound outside INTEGER domain')
        _require(not result or upper > result[-1]['upper'], 'bounds must increase within each level')
        names.add(name)
        node = {'name': name, 'upper': upper}
        tail = item[head.end():]
        if children:
            nested, tail = take_group(tail)
            node['subpartitions'] = _bound_list(nested, children=False, names=names)
        _require(not tail, 'unconsumed table partition clause')
        result.append(node)
    _require(bool(result), 'empty partition layout')
    return result


def check_ustore_local_index(sql, setup, teardown, *, target, properties, gates):
    """One INTEGER RANGE key, explicit USTORE, plain UBTree LOCAL, fresh table.

    General CREATE TABLE PARTITION L94, L102-106, L366-377 and CREATE INDEX
    L224-227, L417-437. No ACTIVE_PAGES value/range or statistics effect inferred.
    Tracking gates are requirements only, not evidence of actual server values.
    """
    _require(properties.get('index_partition_contract') == 'ustore_range_local'
             and properties.get('storage_engine') == 'USTORE'
             and properties.get('partitioned') is True
             and properties.get('subpartitioned') is False,
             'explicit one-level USTORE profile required')
    for key, expected in [('actor_authority', ['create_any_index']),
                          ('case_namespace', ['isolated_user_schema']),
                          ('table_creation_authority', ['create_any_table']),
                          ('track_counts', ['on']), ('track_activities', ['on'])]:
        _require(gates.get(key) == expected, 'missing fixture/tracking gate: '+key)
    _require(re.fullmatch(r'g_[a-z0-9_]{1,50}', target) is not None,
             'fresh unqualified test table required')
    _require(len(setup) == len(teardown) == 1, 'one fresh table and exact cleanup required')
    table = re.escape(target)
    head = re.match(rf'CREATE\s+TABLE\s+{table}\s*\(\s*id\s+(?:INTEGER|INT)\s*\)\s*'
                    r'WITH\s*\(\s*storage_type\s*=\s*ustore\s*\)\s*'
                    r'PARTITION\s+BY\s+RANGE\s*\(\s*id\s*\)\s*',
                    _statement(setup[0]), re.I | re.ASCII)
    _require(head is not None, 'actual USTORE one-INTEGER RANGE table required')
    definitions, tail = take_group(_statement(setup[0])[head.end():])
    _require(not tail, 'unconsumed USTORE fixture suffix')
    layout = _bound_list(definitions, children=False, names=set(), word='PARTITION')
    _require(properties.get('partition_keys') == ['id'] and layout == properties.get('partition_layout'),
             'declared key/layout differs from actual DDL')
    _match(rf'DROP\s+TABLE\s+{table}\s+RESTRICT', _statement(teardown[0]))
    index = _match(rf'CREATE\s+INDEX\s+({IDENT})\s+ON\s+{table}\s+USING\s+ubtree'
                   r'\s*\(\s*id\s*\)\s+LOCAL', _statement(sql))[1].lower()
    _require(index != target, 'index and table share relation namespace')
    return {'scope': 'finite_ustore_range_local', 'source_table': target,
            'storage_engine': 'USTORE', 'method': 'ubtree', 'partition_keys': ['id'],
            'table_layout': layout, 'automatic_partitions': True, 'runtime_proven': False,
            'cleanup_ownership_proven': False, 'statistics_proven': False}


def check_index_partition(sql, setup, teardown, *, target, properties, gates):
    """Check actual DDL against the profile, then actual LOCAL index positions.

    Only two distinct one-column INTEGER range keys, explicit ASTORE, a fresh
    table, and a plain nonunique/nonconcurrent BTREE index are admitted. Omitted
    index partitions are automatic; explicit partitions must match both levels.
    FOR, defaults, routing, data, catalog state and cleanup ownership are unproved.
    """
    _require(properties.get('index_partition_contract') == 'range_range_positional',
             'explicit finite partition contract required')
    _require(properties.get('storage_engine') == 'ASTORE'
             and properties.get('partitioned') is True and properties.get('subpartitioned') is True,
             'ASTORE subpartition profile required')
    for key, expected in [('actor_authority', ['create_any_index']),
                          ('case_namespace', ['isolated_user_schema']),
                          ('table_creation_authority', ['create_any_table'])]:
        _require(gates.get(key) == expected, 'missing isolated fixture/authority gate: '+key)
    _require(re.fullmatch(r'g_[a-z0-9_]+', target) is not None, 'fresh unqualified test table required')
    _require(len(setup) == 1 and len(teardown) == 1, 'one fresh table and exact owned cleanup required')
    ddl = _statement(setup[0])
    head = re.match(rf'CREATE\s+TABLE\s+({IDENT})\s*(\()', ddl, re.I | re.ASCII)
    _require(head is not None and head[1].lower() == target, 'actual fixture target mismatch')
    columns_body, tail = take_group(ddl[head.end()-1:])
    columns = []
    for item in split_list(columns_body):
        column = _match(rf'({IDENT})\s+(INTEGER|INT)', item)[1].lower()
        _require(column not in columns, 'duplicate fixture column')
        columns.append(column)
    header = re.match(rf'WITH\s*\(\s*storage_type\s*=\s*astore\s*\)\s*'
                      rf'PARTITION\s+BY\s+RANGE\s*\(\s*({IDENT})\s*\)\s*'
                      rf'SUBPARTITION\s+BY\s+RANGE\s*\(\s*({IDENT})\s*\)\s*', tail, re.I | re.ASCII)
    _require(header is not None, 'actual ASTORE RANGE/RANGE header required')
    keys = [header[1].lower(), header[2].lower()]
    _require(len(set(keys)) == 2 and all(key in columns for key in keys), 'range keys must be distinct actual columns')
    _require(keys == properties.get('partition_keys'), 'declared and actual partition keys differ')
    definitions, tail = take_group(tail[header.end():])
    _require(not tail, 'unconsumed fixture DDL suffix')
    layout = _bound_list(definitions, children=True, names=set())
    _require(layout == properties.get('partition_layout'), 'declared and actual partition layout differ')
    _match(rf'DROP\s+TABLE\s+{re.escape(target)}', _statement(teardown[0]))

    index = _match(rf'CREATE\s+INDEX\s+({IDENT})\s+ON\s+{re.escape(target)}\s+USING\s+btree'
                   rf'\s*\(([^()]*)\)\s+LOCAL\s*(.*)', _statement(sql))
    index_keys = [key.lower() for key in split_list(index[2])]
    _require(len(index_keys) == len(set(index_keys)) and all(key in columns for key in index_keys),
             'index keys must be distinct actual bare columns')
    mapping = []
    if index[3]:
        definitions, tail = take_group(index[3])
        _require(not tail, 'unconsumed LOCAL suffix')
        parts = split_list(definitions)
        _require(len(parts) == len(layout), 'LOCAL parent count differs from table')
        names = set()
        for item, table_part in zip(parts, layout):
            parent = re.match(rf'PARTITION\s+({IDENT})\s*(\()', item, re.I | re.ASCII)
            _require(parent is not None, 'explicit LOCAL parent with children required, no FOR')
            parent_name = parent[1].lower()
            _require(parent_name not in names, 'duplicate index partition name')
            names.add(parent_name)
            nested, tail = take_group(item[parent.end()-1:])
            _require(not tail, 'unconsumed index parent clause')
            children = split_list(nested)
            _require(len(children) == len(table_part['subpartitions']), 'LOCAL child count differs from table')
            mapped_children = []
            for child, table_child in zip(children, table_part['subpartitions']):
                name = _match(rf'SUBPARTITION\s+({IDENT})', child)[1].lower()
                _require(name not in names, 'duplicate index subpartition name')
                names.add(name)
                mapped_children.append({'index': name, 'table': table_child['name']})
            mapping.append({'index': parent_name, 'table': table_part['name'], 'children': mapped_children})
    return {'scope': 'finite_range_range_local', 'source_table': target, 'partition_keys': keys,
            'table_layout': layout, 'automatic_partitions': not bool(index[3]), 'positional_mapping': mapping,
            'runtime_proven': False, 'cleanup_ownership_proven': False, 'data_routing_proven': False}
