"""Source-scoped STORED generation from actual inputs, not a SQL evaluator."""
import re

from .finite_sql_contract import (
    IDENT, NAME, ReviewNeeded, get_write_table, split_clause, split_list, take_group,
    top_mask, unwrap,
)


def integer_value(literal):
    if not re.fullmatch(r'[+-]?[0-9]+', literal):
        raise ReviewNeeded('generated_integer_input_unknown', 'Expected a finite integer literal')
    digits = literal.lstrip('+-').lstrip('0') or '0'
    if len(digits) > 10:
        raise ReviewNeeded('generated_integer_range_unknown', 'Input exceeds finite INT range')
    value = int(('-' if literal.startswith('-') else '')+digits)
    if not -(2**31) <= value <= 2**31-1:
        raise ReviewNeeded('generated_integer_range_unknown', 'Input exceeds finite INT range')
    return value


def stored_sum_columns(table, source_scope='m_compat'):
    """Complete declaration identity, independent of input row provenance."""
    if '_view_base' in table:
        return None
    ddl = table['ddl'].strip().removesuffix(';').strip()
    head = re.match(rf'^CREATE\s+TABLE\s+({NAME})\s*(\()', ddl, re.I)
    if not head:
        return None
    body, suffix = take_group(ddl[head.end()-1:])
    declarations = split_list(body)
    if suffix or len(declarations) != 3:
        return None
    plain = [re.fullmatch(rf'({IDENT})\s+(?:INT|INTEGER)', d, re.I)
             for d in declarations[:2]]
    generated_prefix = r'GENERATED\s+ALWAYS\s+' if source_scope == 'general' else r'(?:GENERATED\s+ALWAYS\s+)?'
    # General CREATE TABLE L751: omission is STORED. M L451-452 instead
    # depends on m_format_dev_version (s2 defaults to VIRTUAL), so do not
    # infer the M storage kind from source_scope alone.
    storage = r'(?:\s+STORED)?' if source_scope == 'general' else r'\s+STORED'
    generated = re.fullmatch(
        rf'({IDENT})\s+(?:INT|INTEGER)\s+{generated_prefix}AS\s*'
        rf'\(\s*({IDENT})\s*\+\s*({IDENT})\s*\){storage}', declarations[2], re.I)
    if not all(plain) or not generated:
        return None
    base = [m[1].lower() for m in plain]
    name = generated[1].lower()
    if (len(set(base+[name])) != 3 or set(base) != {generated[2].lower(), generated[3].lower()}
            or list(table['columns']) != base+[name]):
        return None
    return base+[name]


def sum_inputs(rows, base):
    values = []
    for row in rows:
        value = sum(row[column] for column in base)
        if not -(2**31) <= value <= 2**31-1:
            raise ReviewNeeded('generated_integer_range_unknown', 'Generated sum exceeds finite INT range')
        values.append(value)
    return values


def literal_inputs(statement, columns, generated=False):
    """An already matched INSERT VALUES supplies every ordinary input column."""
    base = columns[:-1] if generated else columns
    explicit = [c.lower() for c in split_list(unwrap(statement[2]))] if statement[2] else None
    inputs, row_width = [], None
    for row in split_list(statement[3]):
        values = split_list(unwrap(row))
        names = explicit if explicit is not None else columns[:len(values)]
        if (len(values) != len(names) or len(names) != len(set(names))
                or not set(base) <= set(names) <= set(columns)
                or (row_width is not None and len(values) != row_width)):
            raise ReviewNeeded('generated_integer_input_unknown', 'Input column list or arity is unproved')
        row_width = len(values)
        incoming = dict(zip(names, values))
        if generated and columns[-1] in incoming and incoming[columns[-1]].upper() != 'DEFAULT':
            return None  # Preserve the existing targeted generated-column negative.
        inputs.append({column:integer_value(incoming[column]) for column in base})
    return inputs


def values_statement(sql, source_scope='m_compat'):
    prefix = r'INSERT\s+INTO' if source_scope == 'general' else r'INSERT(?:\s+INTO)?'
    return re.fullmatch(
        rf'{prefix}\s+({NAME})\b\s*(\([^()]*\))?\s*VALUES?\b\s*(\(.+\))',
        sql, re.I | re.S)


def inspect_stored_integer_insert(sql, setup_sqls, tables, source_scope):
    """M CREATE TABLE L441-458/L472-474; M INSERT L15-16/L76-80.
    General CREATE TABLE L746-762 and INSERT L16-17 independently establish
    this finite contract, with required GENERATED ALWAYS and INSERT INTO.

    Prove one fresh three-column table: two naked INT inputs and a final
    STORED INT sum (explicit in M; explicit or omitted in general).
    DEFAULT requests generation;
    it is never converted into ordinary NULL. No extra setup, row lookup,
    aliases, conflict branch, CTE, unknown M storage default or runtime Oracle.
    Return None outside this domain so the existing conservative checker runs.
    """
    if source_scope not in {'m_compat', 'general'}:
        return None
    sql = sql.strip().removesuffix(';').strip()
    if ';' in top_mask(sql) or '--' in sql or '/*' in sql or '"' in sql:
        return None
    statement = values_statement(sql, source_scope)
    if not statement:
        return None
    _, tail = split_clause(statement[3], 'ON|RETURNING|AS|SELECT|WHERE')
    if tail:
        return None
    table = get_write_table(tables, statement[1])
    ddl = table['ddl'].strip().removesuffix(';').strip()
    actual_setup = [s.strip().removesuffix(';').strip() for s in setup_sqls if s.strip()]
    if actual_setup != [ddl]:
        return None
    columns = stored_sum_columns(table, source_scope)
    if not columns:
        return None
    inputs = literal_inputs(statement, columns, generated=True)
    if inputs is None:
        return None
    generated_values = sum_inputs(inputs, columns[:-1])
    return dict(checks=['target_columns','input_arity','finite_expression_types',
                        'stored_generated_integer_sum','generated_default_or_omission'],
                generated_values=generated_values, runtime_proven=False)


def inspect_stored_seeded_write(sql, setup_sqls, tables, source_scope):
    """Finite exact seed histories only, not a general fixture executor.

    M INSERT/UPDATE and CREATE TABLE permit DEFAULT generation. Here SELECT
    projects two integer seed columns, or UPDATE requests only recomputation.
    One base-column integer equality must match actual seed inputs. No joins,
    aliases, casts, base-column assignments, unknown history or runtime claims.
    """
    # General sources independently permit the same finite computation:
    # CREATE TABLE L746-762, INSERT L16-17, UPDATE L14-15. Entry grammar is
    # still mode-specific, including every seed statement below.
    if source_scope not in {'m_compat', 'general'}:
        return None
    sql = sql.strip().removesuffix(';').strip()
    if ';' in top_mask(sql) or '--' in sql or '/*' in sql or '"' in sql:
        return None
    prefix = r'INSERT\s+INTO' if source_scope == 'general' else r'INSERT(?:\s+INTO)?'
    query = re.fullmatch(
        rf'{prefix}\s+({NAME})\b\s*(\([^()]*\))?\s*SELECT\s+'
        rf'({IDENT})\s*,\s*({IDENT})\s+FROM\s+({NAME})\s+WHERE\s+({IDENT})\s*=\s*([+-]?[0-9]+)', sql, re.I)
    update = re.fullmatch(
        rf'UPDATE\s+({NAME})\s+SET\s+({IDENT})\s*=\s*DEFAULT\s+WHERE\s+({IDENT})\s*=\s*([+-]?[0-9]+)', sql, re.I)
    if not query and not update:
        return None
    table = get_write_table(tables, (query or update)[1])
    columns = stored_sum_columns(table, source_scope)
    if not columns:
        return None
    setup = [s.strip().removesuffix(';').strip() for s in setup_sqls if s.strip()]
    target_ddl = table['ddl'].strip().removesuffix(';').strip()
    if query:
        source = get_write_table(tables, query[5])
        source_ddl = source['ddl'].strip().removesuffix(';').strip()
        if len(setup) != 3 or setup[0] != source_ddl or setup[2] != target_ddl or query[1].lower() == query[5].lower():
            return None
        head = re.match(rf'^CREATE\s+TABLE\s+{NAME}\s*(\()', source_ddl, re.I)
        if not head or '_view_base' in source:
            return None
        body, suffix = take_group(source_ddl[head.end()-1:])
        plain = [re.fullmatch(rf'({IDENT})\s+(?:INT|INTEGER)(?:\s+DEFAULT\s+([+-]?[0-9]+))?',d,re.I)
                 for d in split_list(body)]
        if suffix or len(plain) != 2 or not all(plain):
            return None
        source_columns = [m[1].lower() for m in plain]
        if len(set(source_columns)) != 2 or list(source['columns']) != source_columns:
            return None
        for column in plain:
            if column[2] is not None:
                integer_value(column[2])  # Declared defaults are validated, not substituted.
        seed = values_statement(setup[1], source_scope)
        if not seed or seed[1].lower() != query[5].lower():
            return None
        inputs = literal_inputs(seed, source_columns)
        target_columns = [n.lower() for n in split_list(unwrap(query[2]))] if query[2] else columns[:-1]
        projection = [query[3].lower(),query[4].lower()]
        if (len(target_columns) != 2 or set(target_columns) != set(columns[:-1])
                or not set(projection) <= set(source_columns) or query[6].lower() not in source_columns):
            return None
        filter_value = integer_value(query[7])
        selected = [dict(zip(target_columns,(row[n] for n in projection)))
                    for row in inputs if row[query[6].lower()] == filter_value]
        check = 'fixture_seeded_projection'
    else:
        if len(setup) != 2 or setup[0] != target_ddl or update[2].lower() != columns[-1] or update[3].lower() not in columns[:-1]:
            return None
        seed = values_statement(setup[1], source_scope)
        if not seed or seed[1].lower() != update[1].lower():
            return None
        inputs = literal_inputs(seed, columns, generated=True)
        if inputs is None:
            return None
        sum_inputs(inputs,columns[:-1])  # Every initial generated seed row must fit too.
        filter_value = integer_value(update[4])
        selected = [row for row in inputs if row[update[3].lower()] == filter_value]
        check = 'fixture_seeded_generated_update'
    if not selected:
        return None  # Do not credit a vacuous non-exercising case as this contract.
    values = sum_inputs(selected,columns[:-1])
    return dict(checks=['target_columns','input_arity','finite_expression_types',
                        'stored_generated_integer_sum','generated_default_or_omission',check],
                generated_values=values, runtime_proven=False)
