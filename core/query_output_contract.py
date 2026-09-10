"""Conditional documented query signatures, never runtime function resolution."""
import re

from .finite_sql_contract import (
    IDENT, NAME, Contradiction, ReviewNeeded, ddl_tables, get_table,
    split_clause, split_list, top_mask,
)


def finite_query_source_columns(query, setup, *, allow_unchecked_predicate=False,
                                allow_approximate_declarations=False):
    """Bind a plain SELECT's source to its surviving ordinary CREATE columns.

    This is declaration evidence, not execution/row/value/function resolution.
    Deliberately no views, joins, CTEs, nested sources or session-name guessing.
    Existing DDL invalidation handles DROP/ALTER and opaque lifecycle steps.
    """
    from .shared_column_contract import ordinary_columns
    query = query.strip().removesuffix(';').strip()
    if (not query.upper().startswith('SELECT ') or '--' in query or '/*' in query
            or ';' in top_mask(query)):
        raise ReviewNeeded('query_source_unknown', 'Expected one plain SELECT')
    items, from_clause = split_clause(query[7:], 'FROM')
    name = from_clause[5:].strip() if from_clause else ''
    predicate = ''
    if allow_unchecked_predicate:
        name, predicate = split_clause(name, 'WHERE')
        if predicate and not predicate[5:].strip():
            raise ReviewNeeded('query_source_unknown', 'Empty WHERE cannot establish a query')
    if not re.fullmatch(NAME, name):
        raise ReviewNeeded('query_source_unknown', 'Only one direct table source is currently proved')
    if any(re.match(r'^\s*(?:SET|RESET)\b', sql, re.I) for sql in setup):
        raise ReviewNeeded('query_source_unknown', 'Session resolution changes are not interpreted')
    try:
        table = get_table(ddl_tables(setup), name)
    except ReviewNeeded as exc:
        raise ReviewNeeded('query_source_unknown', exc.detail) from exc
    columns = ordinary_columns(table['ddl'],allow_approximate_declarations=allow_approximate_declarations)
    if not columns:
        raise ReviewNeeded('query_source_definition_unknown', 'No complete ordinary column declarations')
    return {'items': split_list(items), 'source_table': name.lower(), 'columns': columns,
            'unverified_predicate': predicate}


def check_rendered_insert_query(sql, setup, *, profile_query, output_types,
                                source_tables, source_columns, contract):
    """Prove only direct query output/profile identity, never target acceptance.

    WHERE is carried as unverified predicate/cardinality evidence. This does not
    establish conversion, precision safety, view writeability, generated values
    or any database behavior. Other source forms need another explicit contract.
    """
    from .shared_column_contract import check_direct_projection_types
    if contract != 'fixture_direct_columns':
        raise ReviewNeeded('query_contract_unknown', str(contract))
    statement = sql.strip().removesuffix(';').strip()
    if (not re.match(r'^INSERT\b', statement, re.I) or '--' in statement
            or '/*' in statement or ';' in top_mask(statement)):
        raise ReviewNeeded('query_source_unknown', 'Expected one INSERT SELECT statement')
    _, query = split_clause(statement, 'SELECT')
    query, tail = split_clause(query, 'ON|RETURNING')
    actual = finite_query_source_columns(query, setup, allow_unchecked_predicate=True)
    profile = finite_query_source_columns(profile_query, setup, allow_unchecked_predicate=True)
    if (actual['source_table'] != profile['source_table']
            or [actual['source_table']] != [str(n).lower() for n in source_tables]):
        raise Contradiction('query_source_identity_mismatch', actual['source_table'])
    columns = actual['columns']
    names = list(columns)
    types = [columns[n]['type'] for n in names]
    if len(actual['items']) != len(output_types):
        raise Contradiction('query_output_arity', 'Actual projection width differs from output_types')
    checked = check_direct_projection_types(actual['items'], output_types, names, types)
    if len(checked) != len(actual['items']):
        raise ReviewNeeded('query_projection_unknown', 'Only direct user-column projections are proved')
    canonical = lambda value: ' '.join(str(value).upper().split())
    if list(map(canonical, actual['items'])) != list(map(canonical, profile['items'])):
        raise Contradiction('query_projection_mismatch', 'Actual SELECT differs from selected query profile')
    referenced = {re.match(IDENT, item)[0].lower() for item in actual['items']}
    if referenced != {str(n).lower() for n in source_columns}:
        raise Contradiction('query_source_columns_mismatch', 'Declared dependencies differ from projected columns')
    return {'checked_output_positions': checked, 'source_table': actual['source_table'],
            'unverified_predicate': actual['unverified_predicate'], 'unverified_suffix': tail,
            'target_acceptance_proven': False, 'runtime_proven': False}


def check_rendered_sum_source(query, setup, *, items, output_types, available_columns,
                              available_types, source_tables, mode, identity):
    """Compatibility entry point: never accepts a non-SUM function identity."""
    if identity != 'm_builtin_sum':
        raise ReviewNeeded('function_identity_unknown', str(identity))
    return check_rendered_aggregate_source(query, setup, items=items, output_types=output_types,
        available_columns=available_columns, available_types=available_types,
        source_tables=source_tables, mode=mode, identity=identity)


def check_rendered_aggregate_source(query, setup, *, items, output_types, available_columns,
                                    available_types, source_tables, mode, identity):
    """Bind a selected documented aggregate to the actual direct query and DDL."""
    from .shared_column_contract import check_direct_projection_types
    evidence = finite_query_source_columns(query, setup,allow_approximate_declarations=(
        mode=='M' and identity in ('m_builtin_sum','m_builtin_min','m_builtin_max','m_builtin_avg')))
    if evidence['source_table'] not in [str(name).lower() for name in source_tables]:
        raise Contradiction('query_source_identity_mismatch', evidence['source_table'])
    actual = evidence['columns']
    names = list(actual)
    types = [actual[name]['type'] for name in names]
    try:
        checked = check_direct_projection_types(available_columns, available_types, names, types)
    except Contradiction as exc:
        raise Contradiction('query_source_type_mismatch', exc.detail) from exc
    if len(checked) != len(available_columns):
        raise ReviewNeeded('query_source_unknown', 'Not all declared source columns have identity evidence')
    # Preserve token boundaries: SUM(ALL qty) must not equal SUM(allqty).
    canonical = lambda value: tuple(t.upper() for t in re.findall(
        rf'{IDENT}|[^\s]', str(value), flags=re.ASCII))
    if list(map(canonical, evidence['items'])) != list(map(canonical, items)):
        raise Contradiction('query_projection_mismatch', 'Rendered projection differs from the selected profile')
    check_documented_aggregate_types(evidence['items'], output_types, names, types, mode=mode, identity=identity)
    return evidence


def check_documented_aggregate_types(items, declared_types, columns, source_types, *, mode, identity):
    """Finite M SUM/MIN/MAX/AVG/COUNT signatures; identity is a runtime precondition.

    M PDF 2.5.11 MAX L574-591 / MIN L635-652 separates table fields from
    expressions. Here only bare INT and FLOAT/DOUBLE fields are supported:
    INT keeps INT; FLOAT returns DOUBLE. AVG L72-87 instead maps bare
    INT/DECIMAL to DECIMAL and FLOAT/DOUBLE to DOUBLE. No typmods, collection/collation,
    casts, constants, windows, nullability, or runtime result evaluation.
    COUNT L338-388 returns BIGINT for a single bare INT field or the separate
    COUNT(*) row-count form, not multiargument DISTINCT or arbitrary expressions.
    """
    from .shared_column_contract import NON_COLUMN_EXPRESSIONS
    if identity == 'm_builtin_sum':
        return check_documented_sum_types(items, declared_types, columns, source_types,mode=mode,identity=identity)
    if mode != 'M':
        raise ReviewNeeded('function_mode_unknown', 'These signatures are documented only for M')
    function = {'m_builtin_min': 'MIN', 'm_builtin_max': 'MAX', 'm_builtin_avg': 'AVG',
                'm_builtin_count': 'COUNT'}.get(identity)
    if function is None:
        raise ReviewNeeded('function_identity_unknown', str(identity))
    if len(items) != len(declared_types):
        raise Contradiction('function_contract_arity', 'Function projections and output types must have equal widths')
    if len(columns) != len(source_types):
        raise Contradiction('function_source_arity', 'Source columns and types must have equal widths')
    source = {str(n).lower(): str(t).strip() for n,t in zip(columns,source_types)}
    aliases = {'INTEGER':'INT','INT4':'INT'}
    if function == 'AVG':
        aliases['NUMERIC'] = 'DECIMAL'
    checked=[]
    for index,(item,declared) in enumerate(zip(items,declared_types)):
        if function == 'COUNT' and re.fullmatch(
                rf'COUNT\s*\(\s*\*\s*\)(?:\s+AS\s+{IDENT})?',str(item).strip(),re.I|re.ASCII):
            output=str(declared).strip()
            if not output.isascii():
                raise ReviewNeeded('function_output_type_unknown',output)
            if output.upper() != 'BIGINT':
                raise Contradiction('function_output_type_mismatch',
                                    f'column {index+1} COUNT(*): expected BIGINT, declared {declared}')
            checked.append(index)
            continue
        match=re.fullmatch(rf'{function}\s*\(\s*(?:(?:ALL|DISTINCT)\s+)?({IDENT})\s*\)'
                           rf'(?:\s+AS\s+{IDENT})?',str(item).strip(),re.I|re.ASCII)
        if not match or match[1].upper() in NON_COLUMN_EXPRESSIONS:
            raise ReviewNeeded('function_expression_unknown',str(item))
        name=match[1].lower()
        if name not in source:
            raise Contradiction('function_missing_column',name)
        raw_type=source[name]
        if not raw_type.isascii():
            raise ReviewNeeded('function_argument_type_unknown',raw_type)
        typ=aliases.get(raw_type.upper(),raw_type.upper())
        returns = ({'INT':'DECIMAL','DECIMAL':'DECIMAL','FLOAT':'DOUBLE','DOUBLE':'DOUBLE'}
                   if function == 'AVG' else {'INT':'BIGINT'} if function == 'COUNT'
                   else {'INT':'INT','FLOAT':'DOUBLE','DOUBLE':'DOUBLE'})
        expected=returns.get(typ)
        if expected is None:
            raise ReviewNeeded('function_argument_type_unknown',raw_type)
        output=str(declared).strip()
        if not output.isascii():
            raise ReviewNeeded('function_output_type_unknown',output)
        if aliases.get(output.upper(),output.upper()) != expected:
            raise Contradiction('function_output_type_mismatch',
                                f'column {index+1} {function}({name}): expected {expected}, declared {declared}')
        checked.append(index)
    return checked


def check_documented_sum_types(items, declared_types, columns, source_types, *, mode, identity):
    """Check only the explicitly selected M builtin SUM contract.

    Local PDF 2.5.11 L952-965: INT/DECIMAL -> DECIMAL; FLOAT/DOUBLE -> DOUBLE.
    `identity` is a documented precondition, NOT evidence of resolved OID. The
    caller must keep runtime resolution as an unverified environment gate.
    No qualification, casts, windows, typmods, nullability or result evaluation.
    Other function identities and modes must never inherit this rule.
    """
    from .shared_column_contract import NON_COLUMN_EXPRESSIONS
    if mode != 'M':
        raise ReviewNeeded('function_mode_unknown', 'This signature is documented only for M')
    if identity != 'm_builtin_sum':
        raise ReviewNeeded('function_identity_unknown', str(identity))
    if len(items) != len(declared_types):
        raise Contradiction('function_contract_arity', 'Function projections and output types must have equal widths')
    if len(columns) != len(source_types):
        raise Contradiction('function_source_arity', 'Source columns and types must have equal widths')
    aliases = {'INTEGER': 'INT', 'INT4': 'INT', 'NUMERIC': 'DECIMAL'}
    source = {str(name).lower(): str(typ).strip()
              for name, typ in zip(columns, source_types)}
    checked = []
    for index, (item, declared) in enumerate(zip(items, declared_types)):
        match = re.fullmatch(
            rf'SUM\s*\(\s*(?:(?:ALL|DISTINCT)\s+)?({IDENT})\s*\)'
            rf'(?:\s+AS\s+{IDENT})?', str(item).strip(), re.I | re.ASCII)
        if not match or match[1].upper() in NON_COLUMN_EXPRESSIONS:
            raise ReviewNeeded('function_expression_unknown', str(item))
        name = match[1].lower()
        if name not in source:
            raise Contradiction('function_missing_column', name)
        # Do not let Python Unicode upper() turn a different type spelling
        # into reviewed INT/DECIMAL evidence (for example, dotless i).
        if not source[name].isascii():
            raise ReviewNeeded('function_argument_type_unknown', source[name])
        arg_type = aliases.get(source[name].upper(), source[name].upper())
        expected = {'INT': 'DECIMAL', 'DECIMAL': 'DECIMAL',
                    'FLOAT': 'DOUBLE', 'DOUBLE': 'DOUBLE'}.get(arg_type)
        if expected is None:
            raise ReviewNeeded('function_argument_type_unknown', source[name])
        output = str(declared).strip()
        if not output.isascii():
            raise ReviewNeeded('function_output_type_unknown', output)
        actual = output.upper()
        if aliases.get(actual, actual) != expected:
            raise Contradiction('function_output_type_mismatch',
                                f'column {index+1} SUM({name}): expected {expected}, declared {declared}')
        checked.append(index)
    return checked
