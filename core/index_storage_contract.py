"""Finite rendered index storage evidence, not a full SQL or runtime oracle."""
import re
from .finite_sql_contract import IDENT, NAME, Contradiction, ReviewNeeded, ddl_tables, get_table, split_list, take_group


def _fillfactor_option(fragment):
    fragment = fragment.strip()
    if not fragment:
        return None
    match = re.fullmatch(r'WITH\s*\(\s*fillfactor\s*=\s*([+-]?\d+)\s*\)', fragment, re.I)
    if not match:
        raise ReviewNeeded('index_storage_unknown', fragment)
    return int(match[1])


def _finite_index_parts(sql):
    """One bounded ordinary-index shape shared by storage and key checks."""
    statement = sql.strip().removesuffix(';').strip()
    prefix = re.match(rf'^CREATE\s+(?:UNIQUE\s+)?INDEX\s+{NAME}\s+'
                      rf'(?:USING\s+(?:BTREE|UBTREE)\s+)?ON\s+(?P<table>{NAME})\s*(\()',
                      statement, re.I)
    if not prefix:
        raise ReviewNeeded('index_storage_unknown', 'Unsupported index production')
    keys, tail = take_group(statement[prefix.end()-1:])
    actual_storage = ''
    with_prefix = re.match(r'^WITH\s*(\()', tail, re.I)
    if with_prefix:
        body, tail = take_group(tail[with_prefix.end()-1:])
        actual_storage = 'WITH ('+body+')'
    # Consume full finite tail. Keywords inside COMMENT strings are data.
    if not re.fullmatch(r"(?:COMMENT\s+'(?:''|[^'])*'\s*)?"
                        r'(?:(?:ALGORITHM\s*=\s*DEFAULT|LOCK\s+DEFAULT)\s*)?', tail, re.I):
        raise ReviewNeeded('index_storage_unknown', tail)
    return {'table': prefix['table'].lower(), 'keys': split_list(keys), 'storage': actual_storage}


def check_rendered_index_fillfactor(sql, profile_storage):
    """Compare actual/profile integer FILLFACTOR, then check documented 10..100.

    Current consumer is the explicit M ordinary-index finite grammar. Quoted
    identifiers, partitions, extra storage options and non-default tails need
    separate evidence. The caller must check the M source/environment gate and
    bind a negative result to the documented target rule, not any error label.
    No table/engine, key type, uniqueness, lock or runtime behavior is proved.
    """
    actual_storage = _finite_index_parts(sql)['storage']
    declared = _fillfactor_option(profile_storage)
    actual = _fillfactor_option(actual_storage)
    if actual != declared:
        raise Contradiction('index_storage_mismatch',
                            f'profile FILLFACTOR={declared}, rendered FILLFACTOR={actual}')
    return {'fillfactor': actual, 'range_valid': actual is None or 10 <= actual <= 100,
            'default_value_proven': False, 'key_contract_proven': False,
            'engine_proven': False, 'runtime_proven': False}


def check_rendered_index_keys(sql, setup, *, items, key_count, source_tables, source_columns):
    """Bind finite direct keys to a surviving ordinary table, never its engine.

    Ordering syntax is consumed but not compared with ordering profile values.
    Only ordinary (not partitioned) table DDL establishes the 32-key bound here.
    Expression/prefix keys, generated columns, views and unparsed DDL need
    their own contracts; no success/error label can substitute for evidence.
    """
    from .shared_column_contract import ordinary_columns
    parts = _finite_index_parts(sql)
    actual = []
    for item in parts['keys']:
        match = re.fullmatch(rf'({IDENT})(?:\s+(?:ASC|DESC))?(?:\s+NULLS\s+(?:FIRST|LAST))?',item,re.I)
        if not match or match[1].upper() in ('NULL','TRUE','FALSE','DEFAULT'):
            raise ReviewNeeded('index_key_expression_unknown',item)
        actual.append(match[1].lower())
    if not isinstance(items,list) or not items or any(not re.fullmatch(IDENT,str(item)) for item in items):
        raise ReviewNeeded('index_key_expression_unknown','Only direct profile key names are proved')
    if actual != [str(item).lower() for item in items]:
        raise Contradiction('index_key_items_mismatch','Rendered keys differ from selected items/order')
    if type(key_count) is not int or key_count != len(actual):
        raise Contradiction('index_key_count_mismatch','Declared key count differs from actual keys')
    if [parts['table']] != [str(name).lower() for name in source_tables]:
        raise Contradiction('index_source_identity_mismatch',parts['table'])
    if any(re.match(r'^\s*(?:SET|RESET)\b',s,re.I) for s in setup):
        raise ReviewNeeded('index_source_unknown','Session resolution is not interpreted')
    try:
        table = get_table(ddl_tables(setup),parts['table'])
        columns = ordinary_columns(table['ddl'])
        if not columns:
            raise ReviewNeeded('index_source_unknown','No complete ordinary table declarations')
    except ReviewNeeded as exc:
        raise ReviewNeeded('index_source_unknown',exc.detail) from exc
    missing = set(actual)-set(columns)
    if missing:
        raise Contradiction('index_key_missing_column',str(sorted(missing)))
    if set(actual) != {str(name).lower() for name in source_columns}:
        raise Contradiction('index_key_columns_mismatch','Dependency labels differ from actual keys')
    if len(actual) > 32:
        raise Contradiction('index_key_limit','Ordinary index has more than 32 keys')
    return {'table':parts['table'],'keys':actual,
            'column_origins':{name:columns[name]['origin'] for name in actual},
            'declaration_types':[columns[name]['type'] for name in actual],
            'ordering_proven':False,'method_type_compatibility_proven':False,
            'engine_proven':False,'runtime_proven':False}
