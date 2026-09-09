"""Conservative checks of rendered finite writes against actual fixture DDL.

This is not a GaussDB parser or an execution oracle. `checked` proves only the
listed write-shape checks. Unsupported syntax/conversions remain needs_review.
No database calls, implicit-cast assumptions or specification status changes.
"""
from __future__ import annotations

import re

IDENT = r'[A-Za-z_][A-Za-z0-9_]*'
NAME = rf'{IDENT}(?:\.{IDENT})?'


class ReviewNeeded(ValueError):
    def __init__(self, code, detail):
        self.code, self.detail = code, detail


class Contradiction(ReviewNeeded):
    pass


def top_mask(text):
    """Preserve positions while masking quoted strings and nested expressions."""
    out, depth, quote, i = [], 0, None, 0
    while i < len(text):
        c = text[i]
        if quote:
            out.append(' ')
            if c == quote:
                if i + 1 < len(text) and text[i + 1] == quote:
                    out.append(' ')
                    i += 1
                else:
                    quote = None
        elif c in "'\"":
            quote = c
            out.append(' ')
        elif c == '(':
            depth += 1
            out.append(' ')
        elif c == ')':
            depth -= 1
            if depth < 0:
                raise ReviewNeeded('syntax_unknown', 'Unbalanced parentheses')
            out.append(' ')
        else:
            out.append(c if depth == 0 else ' ')
        i += 1
    if quote or depth:
        raise ReviewNeeded('syntax_unknown', 'Unbalanced expression')
    return ''.join(out)


def split_list(text):
    indices = [m.start() for m in re.finditer(',', top_mask(text))]
    bounds = [-1, *indices, len(text)]
    return [text[a + 1:b].strip() for a, b in zip(bounds, bounds[1:])]


def split_clause(text, keywords):
    found = re.search(r'\b(?:' + keywords + r')\b', top_mask(text), re.I)
    return (text[:found.start()].strip(), text[found.start():].strip()) if found else (text.strip(), '')


def unwrap(text):
    text = text.strip()
    if not (text.startswith('(') and text.endswith(')')):
        raise ReviewNeeded('syntax_unknown', 'Expected finite parenthesized list')
    top_mask(text[1:-1])
    return text[1:-1]


def type_family(typ):
    typ = typ.upper().split('(')[0].strip()
    if typ in ('INT', 'INTEGER', 'SMALLINT', 'BIGINT', 'INT2', 'INT4', 'INT8'):
        return 'integer'
    if typ in ('TEXT', 'VARCHAR', 'CHAR', 'CHARACTER VARYING'):
        return 'text'
    if typ in ('BOOLEAN', 'BOOL'):
        return 'boolean'
    if typ in ('NUMERIC', 'DECIMAL', 'REAL', 'FLOAT', 'DOUBLE PRECISION'):
        return 'numeric'
    return typ


def ddl_tables(setup):
    tables = {}
    for sql in setup:
        sql = sql.strip()
        statement = sql.removesuffix(';').strip()
        try:
            masked = top_mask(statement)
        except ReviewNeeded as exc:
            raise ReviewNeeded('fixture_unknown', 'Malformed/opaque setup cannot prove table shape') from exc
        if ';' in masked or '--' in sql or '/*' in sql:
            raise ReviewNeeded('fixture_unknown', 'Multi-statement/commented setup needs explicit DDL review')
        drop = re.fullmatch(rf'DROP\s+TABLE\s+(?:IF\s+EXISTS\s+)?({NAME}(?:\s*,\s*{NAME})*)(?:\s+(?:CASCADE|RESTRICT))?',
                            statement, re.I)
        if drop:
            for name in split_list(drop[1]):
                tables.pop(name.lower(), None)
            continue
        if re.match(r'^ALTER\s+TABLE\b', statement, re.I):
            altered = re.match(rf'^ALTER\s+TABLE\s+(?:IF\s+EXISTS\s+)?(?:ONLY\s+)?({NAME})\b', statement, re.I)
            if not altered or re.search(r'\bRENAME\b|\bSET\s+SCHEMA\b', masked, re.I):
                # Do not guess renamed namespaces or their effects on other names.
                tables = dict.fromkeys(tables)
            else:
                tables[altered[1].lower()] = None
            continue
        if re.match(r'^(?:ROLLBACK|ABORT|COMMIT|END|DISCARD|DO|CALL|EXECUTE|PREPARE\s+TRANSACTION)\b|'
                    r'^(?:DROP\s+(?:TABLE|SCHEMA|OWNED)|ALTER\s+SCHEMA)\b', statement, re.I):
            # Resets and opaque programs can invalidate prior CREATE evidence.
            tables = dict.fromkeys(tables)
            continue
        match = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+({NAME})\s*\(', sql, re.I)
        if not match:
            continue
        start = match.end() - 1
        # Find the matching close; top_mask rejects malformed/quoted fragments.
        end = None
        for i in range(start + 1, len(sql)):
            if sql[i] != ')':
                continue
            try:
                top_mask(sql[start:i + 1])
                end = i
                break
            except ReviewNeeded:
                continue
        if end is None:
            continue
        columns = {}
        for part in split_list(sql[start + 1:end]):
            if re.match(r'^(?:CONSTRAINT|PRIMARY|UNIQUE|CHECK|FOREIGN)\b', part, re.I):
                continue
            col = re.match(rf'^({IDENT})\s+([A-Za-z]+(?:\s+PRECISION|\s+VARYING)?)(?:\([^)]*\))?(?=\s|$)', part, re.I)
            if not col or col[1].lower() in columns:
                columns = None
                break
            columns[col[1].lower()] = type_family(col[2])
        name = match[1].lower()
        entry = {'columns': columns, 'ddl': sql}
        if name in tables:
            # Even identical CREATEs without an intervening DROP are ambiguous
            # execution evidence, not a second successful creation.
            tables[name] = None
        else:
            tables[name] = entry
    return tables


def finite_inline_nonnull_columns(setup):
    """Return positive inline non-null evidence, never proof of nullability.

    Unknown/invalidated tables and non-inline constraints are not inferred.
    This checks existing fixture metadata; it is not a default-value evaluator.
    """
    try:
        tables = ddl_tables(setup)
    except ReviewNeeded:
        return {}
    evidence = {}
    for name, table in tables.items():
        if not table or not table['columns']:
            continue
        ddl = table['ddl']
        body, _ = take_group(ddl[ddl.index('('):])
        nonnull = set()
        for part in split_list(body):
            column = re.match(rf'^({IDENT})\b', part)
            if not column or column[1].lower() not in table['columns']:
                continue
            if re.search(r'\bNOT\s+NULL\b|\bPRIMARY\s+KEY\b', top_mask(part), re.I):
                nonnull.add(column[1].lower())
        evidence[name] = nonnull
    return evidence


def get_table(tables, name):
    table = tables.get(name.lower())
    if not table or not table['columns']:
        raise ReviewNeeded('fixture_unknown', f'No unambiguous finite CREATE TABLE for {name}')
    return table


def get_write_table(tables, name):
    table = get_table(tables, name)
    if not table['ddl']:
        raise ReviewNeeded('target_unknown', 'CTE output is not a writable fixture')
    return table


def column_name(expr, columns, alias=None):
    if not re.fullmatch(NAME, expr.strip()):
        raise ReviewNeeded('column_unknown', expr)
    parts = expr.lower().strip().split('.')
    if len(parts) == 2 and parts[0] != alias:
        raise ReviewNeeded('qualifier_unknown', expr)
    name = parts[-1]
    if name not in columns:
        raise Contradiction('missing_column', expr)
    return name


def expression_type(expr, columns, alias=None):
    expr = expr.strip()
    if re.fullmatch(r'[+-]?\d+', expr):
        return 'integer'
    if re.fullmatch(r'[+-]?\d+\.\d+', expr):
        return 'numeric'
    if re.fullmatch(r"'(?:[^']|'')*'", expr):
        return 'text'
    if expr.upper() in ('TRUE', 'FALSE'):
        return 'boolean'
    if expr.upper() in ('DEFAULT', 'NULL'):
        raise ReviewNeeded('default_unknown' if expr.upper() == 'DEFAULT' else 'nullability_unknown', expr)
    if re.fullmatch(NAME, expr):
        return columns[column_name(expr, columns, alias)]
    arithmetic = re.fullmatch(rf'({NAME})\s*[+-]\s*\d+', expr)
    if arithmetic:
        family = columns[column_name(arithmetic[1], columns, alias)]
        if family in ('integer', 'numeric'):
            return family
    raise ReviewNeeded('expression_unknown', expr)


def check_types(names, expressions, target, source=None, alias=None, default_table=None, value_table=None):
    if len(names) != len(expressions):
        raise Contradiction('arity', f'{len(names)} target columns vs {len(expressions)} expressions')
    if default_table is not None or value_table is not None:
        from .shared_column_contract import check_generated_inputs
        check_generated_inputs(default_table if default_table is not None else value_table,
                               names, expressions)
    for name, expr in zip(names, expressions):
        is_default = expr.strip().upper() == 'DEFAULT'
        if is_default and default_table is not None:
            from .shared_column_contract import default_literal
            expr = default_literal(default_table, name)
            default_table['_defaults_checked'] = True
            if expr == 'NULL':
                continue  # The shared resolver already checked nullability.
        if not is_default and expr.strip().upper() == 'NULL':
            from .shared_column_contract import check_explicit_null
            check_explicit_null(value_table, name)
            continue
        actual = expression_type(expr, target if source is None else source, alias)
        if target[name] != actual and not (target[name] == 'numeric' and actual == 'integer'):
            raise ReviewNeeded('conversion_unknown', f'{name}: {actual} -> {target[name]}')
        if value_table is not None and not is_default:
            from .shared_column_contract import check_assignment_integer_literal, check_assignment_decimal_literal
            check_assignment_integer_literal(value_table, name, expr)
            check_assignment_decimal_literal(value_table, name, expr)


def check_partition_assignment(table, name, expr, alias):
    ddl = table['ddl']
    key = re.search(rf'\b(SUBPARTITION|PARTITION)\s+BY\s+RANGE\s*\(\s*{re.escape(name)}\s*\)', ddl, re.I)
    any_keys = re.findall(r'\b(?:SUBPARTITION|PARTITION)\s+BY\s+(?:RANGE|LIST|HASH|KEY)(?:\s+COLUMNS)?\s*\(([^)]+)\)', ddl, re.I)
    if re.search(r'\bPARTITION\s+BY\b', ddl, re.I) and not any_keys:
        raise ReviewNeeded('partition_contract_unknown', 'Unsupported partition key declaration')
    if not any(name in [x.strip().lower() for x in keys.split(',')] for keys in any_keys):
        return
    if expr.strip().lower() in (name, f'{alias}.{name}' if alias else name):
        return
    if key and not re.search(r'\b(?:INTERVAL|AUTOMATIC|MAXVALUE|TEMPLATE)\b', ddl, re.I) and re.fullmatch(r'[+-]?\d+', expr.strip()):
        prefix = r'(?<!SUB)PARTITION' if key[1].upper() == 'PARTITION' else 'SUBPARTITION'
        boundaries = re.findall(rf'\b{prefix}\s+{IDENT}\s+VALUES\s+LESS\s+THAN\s*\(([^)]+)\)', ddl, re.I)
        if boundaries and all(re.fullmatch(r'\s*[+-]?\d+\s*', b) for b in boundaries):
            if int(expr) >= max(int(b) for b in boundaries):
                raise Contradiction('partition_out_of_range', f'{name}={expr} exceeds all finite {key[1]} upper bounds')
    raise ReviewNeeded('partition_movement', f'{name}: key change requires partition routing/ROW MOVEMENT review')


def partition_integer(text):
    """Bound conversion work; larger/typed expressions remain outside this proof."""
    text = text.strip()
    if len(text) > 32 or not re.fullmatch(r'[+-]?\d+', text):
        raise ReviewNeeded('partition_routing_unknown', 'Partition key is not a finite integer literal')
    return int(text)


def range_partition_for(bounds, value):
    for name, upper in bounds:
        if upper is None or value < upper:
            return name
    raise Contradiction('partition_out_of_range', f'{value} has no declared RANGE partition')


def finite_insert_partition(columns, table):
    """Consume one explicit selector and prove only a complete integer RANGE DDL."""
    prefix = re.match(r'^PARTITION\s*(FOR\b)?\s*', columns, re.I)
    if not prefix:
        return columns, None
    selector, columns = take_group(columns[prefix.end():].strip())
    ddl = table['ddl'].strip().removesuffix(';').strip()
    if ';' in top_mask(ddl) or '--' in ddl or '/*' in ddl or '"' in ddl:
        raise ReviewNeeded('partition_contract_unknown', 'Non-finite partition DDL')
    _, suffix = split_clause(ddl, 'PARTITION')
    grammar = re.match(rf'^PARTITION\s+BY\s+RANGE\s*\(\s*({IDENT})\s*\)\s*', suffix, re.I)
    if not grammar or table['columns'].get(grammar[1].lower()) != 'integer':
        raise ReviewNeeded('partition_contract_unknown', 'Only a single integer RANGE key is checked')
    definitions, remainder = take_group(suffix[grammar.end():].strip())
    if remainder:
        raise ReviewNeeded('partition_contract_unknown', 'Unconsumed partition DDL suffix')
    bounds, seen = [], set()
    for definition in split_list(definitions):
        part = re.fullmatch(rf'PARTITION\s+({IDENT})\s+VALUES\s+LESS\s+THAN\s*\(\s*([+-]?\d+|MAXVALUE)\s*\)',
                            definition, re.I)
        if not part:
            raise ReviewNeeded('partition_contract_unknown', 'Unsupported RANGE partition definition')
        name = part[1].lower()
        upper = None if part[2].upper() == 'MAXVALUE' else partition_integer(part[2])
        if name in seen or (bounds and (bounds[-1][1] is None or
                                       (upper is not None and upper <= bounds[-1][1]))):
            raise ReviewNeeded('partition_contract_unknown', 'Duplicate names or non-increasing RANGE bounds')
        seen.add(name)
        bounds.append((name, upper))
    if prefix[1]:
        selected = range_partition_for(bounds, partition_integer(selector))
    else:
        if not re.fullmatch(IDENT, selector.strip()):
            raise ReviewNeeded('partition_routing_unknown', 'Partition unions/expressions are not checked')
        selected = selector.strip().lower()
        if selected not in seen:
            raise Contradiction('missing_partition', selected)
    # INSERT's bare alias with a partition is not made legal by this checker.
    if columns and not columns.startswith('(') and not re.match(r'^AS\s+', columns, re.I):
        raise ReviewNeeded('syntax_unknown', 'Explicit partition requires AS for target alias')
    return columns, (grammar[1].lower(), bounds, selected)


def check_insert_partition_row(contract, names, expressions):
    key, bounds, selected = contract
    if key not in names:
        raise ReviewNeeded('partition_routing_unknown', 'Omitted partition key requires a default contract')
    value = partition_integer(expressions[names.index(key)])
    actual = range_partition_for(bounds, value)
    if actual != selected:
        raise Contradiction('partition_mismatch', f'{key}={value} routes to {actual}, not {selected}')


def finite_projection(query, tables):
    """Projection/type evidence only; predicates/cardinality are NOT verified."""
    if not query.upper().startswith('SELECT '):
        raise ReviewNeeded('query_unknown', query)
    projection, from_sql = split_clause(query[7:], 'FROM')
    source = {}
    if from_sql:
        source_text, _ = split_clause(from_sql[5:], 'WHERE|ORDER|LIMIT')
        if not re.fullmatch(NAME, source_text):
            raise ReviewNeeded('query_unknown', from_sql)
        try:
            source = get_table(tables, source_text)['columns']
        except ReviewNeeded as exc:
            raise ReviewNeeded('query_unknown', exc.detail) from exc
    if projection == '*' and not source:
        raise ReviewNeeded('query_unknown', 'Star expansion has no finite source')
    return (list(source) if projection == '*' else split_list(projection)), source


def take_group(text):
    """Consume one balanced parenthesized prefix, preserving the remaining SQL."""
    if not text.startswith('('):
        raise ReviewNeeded('syntax_unknown', 'Expected parenthesized prefix')
    for i, char in enumerate(text):
        if char != ')':
            continue
        try:
            top_mask(text[:i + 1])
        except ReviewNeeded:
            continue
        return text[1:i], text[i + 1:].strip()
    raise ReviewNeeded('syntax_unknown', 'Unclosed parenthesized prefix')


def finite_values_cte_types(query, explicit):
    """Only homogeneous literal rows with explicit full output names are proof."""
    if not explicit:
        raise ReviewNeeded('cte_unknown', 'VALUES CTE output names must be explicit')
    types = None
    for row in split_list(query[6:].strip()):
        expressions = split_list(unwrap(row))
        if types is not None and len(expressions) != len(types):
            raise Contradiction('arity', 'VALUES CTE rows have different widths')
        row_types = []
        for expr in expressions:
            if expr.upper() == 'DEFAULT':
                raise Contradiction('default_in_values_cte', 'DEFAULT is only allowed in top-level INSERT VALUES')
            if not re.fullmatch(r"(?:[+-]?\d+(?:\.\d+)?|'(?:[^']|'')*'|TRUE|FALSE)", expr, re.I):
                raise ReviewNeeded('query_unknown', 'VALUES CTE contains non-literal or unresolved input')
            row_types.append(expression_type(expr, {}))
        if types is not None and types != row_types:
            raise ReviewNeeded('conversion_unknown', 'VALUES CTE common type coercion is not proved')
        types = row_types
    return types


def bounded_recursive_cte_types(query, explicit, name):
    """One VALUES seed and a bounded positive int32 counter, never execution.

    Other columns must retain their identity. No joins, casts, additional CTEs,
    nested branches, dynamic bounds or enumeration of the recurrence.
    """
    if not explicit or len(set(x.lower() for x in explicit)) != len(explicit):
        raise ReviewNeeded('cte_unknown', 'Bounded recursion needs unique explicit output names')
    anchor, recursive = split_clause(query, 'UNION')
    if not re.match(r'^VALUES\b', anchor, re.I):
        raise ReviewNeeded('cte_unknown', 'Recursive anchor is not a literal VALUES row')
    raw, remaining = take_group(anchor[6:].strip())
    if remaining:
        raise ReviewNeeded('cte_unknown', 'Recursive anchor must be a single row')
    seed = split_list(raw)
    types = finite_values_cte_types(anchor, explicit)
    if len(types) != len(explicit):
        raise ReviewNeeded('cte_unknown', 'Recursive output rename width unresolved')
    columns = dict(zip((x.lower() for x in explicit), types))
    recurrence = re.fullmatch(rf'UNION\s+ALL\s+SELECT\s+(.+?)\s+FROM\s+({IDENT})\s+'
                             rf'WHERE\s+({IDENT})\s*(<=|<)\s*([+-]?\d+)', recursive, re.I | re.S)
    if not recurrence or recurrence[2].lower() != name:
        raise ReviewNeeded('cte_unknown', 'Recursive branch is not a finite self-counter')
    expressions = split_list(recurrence[1])
    if len(expressions) != len(types):
        raise Contradiction('arity', 'Recursive branch and anchor have different widths')
    key = column_name(recurrence[3], columns)
    index = list(columns).index(key)
    increment = re.fullmatch(rf'{re.escape(key)}\s*\+\s*(\d+)', expressions[index], re.I)
    if columns[key] != 'integer' or not increment:
        raise ReviewNeeded('cte_unknown', 'Recursive counter is not a direct increasing integer')
    for label, expr, family in zip(columns, expressions, types):
        if expression_type(expr, columns) != family:
            raise ReviewNeeded('conversion_unknown', 'Recursive output type differs from anchor')
        if label != key and expr.lower() != label:
            raise ReviewNeeded('cte_unknown', 'Non-counter recursive columns must retain identity')

    def int32(value):
        if len(value) > 12 or not -(2**31) <= int(value) < 2**31:
            raise ReviewNeeded('recursive_bound_unknown', 'Literal exceeds finite int32 contract')
        return int(value)

    for value, family in zip(seed, types):
        if family == 'integer':
            int32(value)
    start, step, bound = int32(seed[index]), int32(increment[1]), int32(recurrence[5])
    if step <= 0:
        raise ReviewNeeded('recursive_bound_unknown', 'Recursive step must be positive')
    last_input = bound - (1 if recurrence[4] == '<' else 0)
    increments = max(0, (last_input - start) // step + 1)
    int32(str(start + increments * step))  # Also check the last produced row.
    return types


def finite_delete_cte_checks(query, table):
    """Direct ordinary DELETE CTE only; no row count or execution permission."""
    body, _ = split_clause(query, 'RETURNING')
    match = re.fullmatch(rf'DELETE\s+FROM\s+({NAME})(?:\s+WHERE\s+(.+))?', body, re.I | re.S)
    if not match:
        raise ReviewNeeded('cte_unknown', 'DELETE CTE target or clauses are outside finite scope')
    if match[2] is None:
        return ['delete_base_target', 'delete_no_predicate']
    condition = re.fullmatch(rf'({IDENT})\s*=\s*(.+)', match[2], re.S)
    literal = r"(?:[+-]?\d+(?:\.\d+)?|'(?:[^']|'')*'|TRUE|FALSE)"
    if not condition or not re.fullmatch(literal, condition[2], re.I):
        raise ReviewNeeded('predicate_unknown', 'DELETE CTE needs a direct column/literal equality')
    column = column_name(condition[1], table['columns'])
    if expression_type(condition[2], {}) != table['columns'][column]:
        raise ReviewNeeded('conversion_unknown', 'DELETE equality operand types are not identical')
    return ['delete_base_target', 'delete_finite_equality_predicate']


def finite_dml_cte_output(query, tables, setup_sqls):
    """Check real non-WITH DML against original setup, then its RETURNING.

    Re-entry into inspect_write is bounded: this entry requires a direct
    INSERT/UPDATE prefix, and never supplies a synthetic fixture or query.
    """
    target = re.match(rf'^(?:INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+({NAME})\b', query, re.I)
    if not target or setup_sqls is None:
        raise ReviewNeeded('cte_unknown', 'DML CTE needs a finite direct write and original setup')
    table = get_write_table(tables, target[1])
    if not table.get('_column_contract') or '_view_base' in table:
        raise ReviewNeeded('cte_unknown', 'DML CTE target needs complete ordinary base columns')
    if re.match(r'^DELETE\b', query, re.I):
        # table already derives from the same original, ordered setup; this is
        # a separate narrow predicate check, not general DELETE support.
        inner_checks = finite_delete_cte_checks(query, table)
    else:
        inner = inspect_write(query, setup_sqls)
        if inner['status'] != 'checked':
            issue = inner['issues'][0]
            error = Contradiction if inner['status'] == 'rejected' else ReviewNeeded
            raise error(issue['code'], 'DML CTE inner write: '+issue['detail'])
        inner_checks = inner['checks']
    _, returning = split_clause(query, 'RETURNING')
    if not returning:
        raise ReviewNeeded('cte_unknown', 'DML CTE has no explicit RETURNING output')
    output = returning[len('RETURNING'):].strip()
    expressions = list(table['columns']) if output == '*' else split_list(output)
    names, types = [], []
    for expr in expressions:
        match = re.fullmatch(rf'({IDENT})(?:\s+AS\s+({IDENT}))?', expr, re.I)
        if not match:
            raise ReviewNeeded('cte_unknown', 'RETURNING is not a finite direct-column projection')
        column = column_name(match[1], table['columns'])
        label = (match[2] or column).lower()
        if label in names:
            raise ReviewNeeded('cte_unknown', 'Ambiguous RETURNING output labels')
        names.append(label)
        types.append(table['columns'][column])
    return names, types, ['finite_dml_cte_write_and_returning_columns',
                          *('dml_cte:'+check for check in inner_checks)]


def finite_ctes(sql, tables, setup_sqls=None):
    """Finite output bindings; their output never becomes a writable fixture."""
    if not re.match(r'^WITH\s', sql, re.I):
        return sql, tables, []
    body = sql[4:].strip()
    recursive = bool(re.match(r'^RECURSIVE\b', body, re.I))
    if recursive:
        body = body[9:].strip()
    tables = dict(tables)
    seen = set()
    extra_checks = []
    while True:
        match = re.match(rf'^({IDENT})\b', body)
        if not match:
            raise ReviewNeeded('cte_unknown', 'No finite CTE name')
        name = match[1].lower()
        if name in seen or name in tables:
            raise ReviewNeeded('cte_unknown', 'Duplicate/shadowed CTE name')
        seen.add(name)
        body = body[match.end():].strip()
        explicit = None
        if body.startswith('('):
            raw, body = take_group(body)
            explicit = split_list(raw)
            if not all(re.fullmatch(IDENT, x) for x in explicit):
                raise ReviewNeeded('cte_unknown', 'Non-finite CTE column list')
        as_clause = re.match(r'^AS\s+(?:(?:NOT\s+)?MATERIALIZED\s+)?', body, re.I)
        if not as_clause:
            raise ReviewNeeded('cte_unknown', 'Missing CTE AS')
        query, body = take_group(body[as_clause.end():].strip())
        query = query.strip()
        if recursive:
            if body.startswith(','):
                raise ReviewNeeded('cte_unknown', 'Multiple recursive CTEs need a dependency contract')
            types = bounded_recursive_cte_types(query, explicit, name)
            names = [None] * len(types)
        elif re.match(r'^(?:INSERT|UPDATE|DELETE)\b', query, re.I):
            if len(seen) != 1 or body.startswith(','):
                raise ReviewNeeded('cte_unknown', 'DML CTE dependencies need a separate contract')
            names, types, extra_checks = finite_dml_cte_output(query, tables, setup_sqls)
        elif re.match(r'^VALUES\b', query, re.I):
            types = finite_values_cte_types(query, explicit)
            names = [None] * len(types)  # Replaced by checked explicit names below.
        else:
            expressions, source = finite_projection(query, tables)
            names, types = [], []
            for expr in expressions:
                renamed = re.fullmatch(rf'(.+?)\s+AS\s+({IDENT})', expr, re.I)
                value = renamed[1] if renamed else expr
                label = renamed[2] if renamed else expr
                if not re.fullmatch(IDENT, label):
                    raise ReviewNeeded('cte_unknown', 'Output label is not explicit')
                names.append(label.lower())
                types.append(expression_type(value, source))
        if explicit is not None:
            # Partial column renaming needs the full dialect contract.
            if len(explicit) != len(names):
                raise ReviewNeeded('cte_unknown', 'CTE output rename width unresolved')
            names = [x.lower() for x in explicit]
        if len(set(names)) != len(names):
            raise ReviewNeeded('cte_unknown', 'Ambiguous CTE output labels')
        tables[name] = {'columns': dict(zip(names, types)), 'ddl': ''}
        if not body.startswith(','):
            checks = ['finite_cte_output_columns']
            if recursive:
                checks.append('bounded_recursive_cte_columns')
            return body, tables, checks + extra_checks
        body = body[1:].strip()


def finite_from_source(tail, tables, target_bindings):
    """Resolve one known FROM relation without merging ambiguous column scopes."""
    from_text, _ = split_clause(tail[4:].lstrip(), 'WHERE|RETURNING|ORDER|LIMIT')
    match = re.fullmatch(rf'({NAME})(?:\s+(?:AS\s+)?({IDENT}))?', from_text, re.I)
    if not match or (match[2] or '').upper() == 'AS':
        raise ReviewNeeded('query_unknown', 'Non-finite UPDATE FROM source')
    source = get_table(tables, match[1])
    binding = (match[2] or match[1].split('.')[-1]).lower()
    if not match[2] and any(source is t for t in target_bindings.values()):
        raise Contradiction('self_from_requires_alias', 'Documented self-FROM requires an explicit FROM alias')
    if binding in target_bindings:
        raise ReviewNeeded('query_unknown', 'FROM alias conflicts with target')
    return source


def check_target_rhs_from(rhs, columns, alias, source):
    if re.fullmatch(r"(?:[+-]?\d+(?:\.\d+)?|'(?:[^']|'')*'|TRUE|FALSE)", rhs, re.I):
        return
    target_ref = re.fullmatch(rf'({NAME})(?:\s*[+-]\s*\d+)?', rhs)
    if not target_ref:
        raise ReviewNeeded('query_unknown', 'Only finite target-side RHS with FROM is checked')
    parts = target_ref[1].lower().split('.')
    if ((len(parts) == 1 and parts[0] in source['columns']) or
            (len(parts) == 2 and parts[0] != alias)):
        raise ReviewNeeded('query_unknown', 'FROM RHS source/ambiguous column resolution is not proved')
    column_name(target_ref[1], columns, alias)


def check_assignments(body, table, alias, tables, allow_defaults=False):
    body, tail = split_clause(body, 'FROM|WHERE|RETURNING|ORDER|LIMIT')
    from_source = bool(re.match(r'^FROM\b', tail, re.I))
    if from_source:
        target_bindings = ({alias: table} if alias else
                           {name.split('.')[-1]: table for name, item in tables.items() if item is table})
        from_table = finite_from_source(tail, tables, target_bindings)
    columns = table['columns']
    for assignment in split_list(body):
        equals = top_mask(assignment).find('=')
        if equals < 0:
            raise ReviewNeeded('assignment_unknown', assignment)
        lhs, rhs = assignment[:equals].strip(), assignment[equals + 1:].strip()
        if from_source and not (allow_defaults and rhs.upper() == 'DEFAULT'):
            check_target_rhs_from(rhs, columns, alias, from_table)
        if lhs.startswith('('):
            names = [column_name(x, columns, alias) for x in split_list(unwrap(lhs))]
            inner = unwrap(rhs)
            expressions = split_list(inner)
        else:
            names, expressions = [column_name(lhs, columns, alias)], [rhs]
            inner = unwrap(rhs) if rhs.startswith('(') and rhs.endswith(')') else rhs
        subquery = inner.upper().startswith('SELECT ')
        if subquery:
            expressions, source = finite_projection(inner, tables)
            check_types(names, expressions, columns, source=source, value_table=table)
        else:
            check_types(names, expressions, columns, alias=alias,
                        default_table=table if allow_defaults else None, value_table=table)
        for name, expr in zip(names, expressions):
            # A same-named query column is not proof of an identity assignment.
            check_partition_assignment(table, name, '<subquery>' if subquery else expr, alias)
    return ['assignment_columns', 'assignment_arity', 'finite_expression_types', 'partition_key_assignment']


def check_multi_update(targets, body, tables):
    from .shared_column_contract import QUERY_KEYWORDS, finite_derived_target
    aliases = {}
    base_names = []
    for target in split_list(targets):
        if target.startswith('('):
            query, tail = take_group(target)
            match = re.fullmatch(rf'(?:AS\s+)?({IDENT})', tail, re.I)
            table = finite_derived_target(query, tables)
            alias = match[1].lower() if match else None
        else:
            match = re.fullmatch(rf'(?:ONLY\s+)?({NAME})(?:\s*\*)?\s+(?:AS\s+)?({IDENT})', target, re.I)
            alias = match[2].lower() if match else None
            table = get_write_table(tables, match[1]) if match else None
        if not alias or alias.upper() in QUERY_KEYWORDS or alias in aliases:
            raise ReviewNeeded('target_unknown', 'Multi-target UPDATE needs distinct explicit aliases')
        base = table.get('_view_base', table)
        identity = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+({NAME})\s*\(', base['ddl'].strip(), re.I)
        if not identity:
            raise ReviewNeeded('target_unknown', 'Multi-target base identity is not proved')
        name = identity[1].lower()
        if any(name == existing or (('.' not in name or '.' not in existing)
               and name.split('.')[-1] == existing.split('.')[-1]) for existing in base_names):
            raise ReviewNeeded('target_unknown', 'Repeated/ambiguous base relation needs a self-target contract')
        base_names.append(name)
        aliases[alias] = table
    assignments, tail = split_clause(body, 'FROM|WHERE|RETURNING|ORDER|LIMIT')
    if re.match(r'^FROM\b', tail, re.I):
        finite_from_source(tail, tables, aliases)
    for assignment in split_list(assignments):
        match = re.fullmatch(rf'({IDENT})\.({IDENT})\s*=\s*(.+)', assignment, re.S)
        if not match or match[1].lower() not in aliases:
            raise ReviewNeeded('target_unknown', 'Unresolved multi-target assignment')
        if not re.fullmatch(r"(?:[+-]?\d+(?:\.\d+)?|'(?:[^']|'')*'|TRUE|FALSE)", match[3], re.I):
            raise ReviewNeeded('query_unknown', 'Cross-target RHS/order semantics not checked')
        check_assignments(assignment, aliases[match[1].lower()], match[1].lower(), tables)
    return ['qualified_multi_target_columns', 'literal_assignment_types', 'partition_key_assignment',
            'finite_multi_target_relations']


def check_insert_all(sql, tables):
    branches, query = split_clause(sql, 'SELECT')
    expressions, source = finite_projection(query, tables)
    projected = {}
    for expr in expressions:
        if not re.fullmatch(IDENT, expr) or expr.lower() in projected:
            raise ReviewNeeded('query_unknown', 'INSERT ALL needs distinct finite output labels')
        projected[expr.lower()] = expression_type(expr, source)
    prefix = re.match(r'^INSERT\s+(?:(ALL|FIRST)\s+)?', branches, re.I)
    body = branches[prefix.end():].strip()
    count = 0
    while body:
        if body.upper().startswith('WHEN '):
            condition, then = split_clause(body[5:], 'THEN')
            if not condition or not then:
                raise ReviewNeeded('branch_unknown', 'Incomplete WHEN/THEN')
            body = then[4:].strip()
        elif not count and (prefix[1] or '').upper() != 'ALL':
            raise ReviewNeeded('branch_unknown', 'Unconditional INSERT requires ALL')
        target = re.match(rf'^INTO\s+({NAME})\s*', body, re.I)
        if not target:
            raise ReviewNeeded('branch_unknown', 'Non-finite INSERT ALL branch')
        table = get_write_table(tables, target[1])
        body = body[target.end():].strip()
        raw_columns, body = take_group(body)
        names = [column_name(x, table['columns']) for x in split_list(raw_columns)]
        if len(names) != len(set(names)):
            raise Contradiction('duplicate_column', str(names))
        values = re.match(r'^VALUES\s*', body, re.I)
        if not values:
            raise ReviewNeeded('branch_unknown', 'INSERT ALL branch without finite VALUES')
        raw_values, body = take_group(body[values.end():].strip())
        check_types(names, split_list(raw_values), table['columns'], source=projected, value_table=table)
        count += 1
    if not count:
        raise ReviewNeeded('branch_unknown', 'No INSERT ALL branches')
    return ['all_branch_target_columns', 'all_branch_input_arity', 'finite_query_output_types']


def inspect_write(sql, setup_sqls):
    result = {'status': 'needs_review', 'scope': 'finite_write_shape_only', 'checks': [], 'issues': []}
    try:
        sql = sql.strip().removesuffix(';').strip()
        if ';' in top_mask(sql) or '--' in sql or '/*' in sql or '"' in sql:
            raise ReviewNeeded('syntax_unknown', 'Multiple statements/comments/quoted identifiers unsupported')
        from .shared_column_contract import (
            QUERY_KEYWORDS, attach_shared_contracts, check_omitted_columns, finite_derived_target,
        )
        tables = attach_shared_contracts(ddl_tables(setup_sqls), setup_sqls)
        sql, tables, cte_checks = finite_ctes(sql, tables, setup_sqls)
        derived = re.match(r'^(UPDATE|INSERT\s+INTO)\s*(?=\()', sql, re.I)
        derived_table = None
        if derived:
            target_query, target_tail = take_group(sql[derived.end():])
            derived_table = finite_derived_target(target_query, tables)
        update = re.match(rf'^UPDATE\s+(?:ONLY\s+)?({NAME})\b', sql, re.I)
        insertion = re.match(rf'^(INSERT\s+INTO|REPLACE(?:\s+INTO)?)\s+({NAME})\b', sql, re.I)
        if update or (derived and derived[1].upper() == 'UPDATE'):
            target, body = split_clause(target_tail if derived else sql[update.end():].strip(), 'SET')
            if not body.upper().startswith('SET '):
                raise ReviewNeeded('syntax_unknown', 'No top-level SET')
            if len(split_list(target)) > 1:
                if derived:
                    raise ReviewNeeded('target_unknown', 'Multi-target derived UPDATE needs a separate contract')
                result['checks'] = check_multi_update(update[1] + ' ' + target, body[4:], tables)
                result['status'] = 'checked'
                result['checks'] = cte_checks + result['checks']
                if any(t and t.get('_integer_literals_checked') for t in tables.values()):
                    result['checks'].append('shared_integer_literal_ranges')
                if any(t and t.get('_decimal_literals_checked') for t in tables.values()):
                    result['checks'].append('shared_exact_decimal_literals')
                if any(t and t.get('_explicit_nulls_checked') for t in tables.values()):
                    result['checks'].append('shared_explicit_nullability')
                return result
            if not derived and target.startswith('*'):
                target = target[1:].strip()
            if not derived:
                target = re.sub(r'\b(?:SUBPARTITION|PARTITION)\s*(?:FOR\s*)?\([^)]*\)', '', target, flags=re.I).strip()
            alias = re.fullmatch(rf'(?:AS\s+)?({IDENT})', target, re.I) if target else None
            if target and not alias:
                raise ReviewNeeded('target_unknown', target)
            if alias and alias[1].upper() in QUERY_KEYWORDS:
                raise ReviewNeeded('target_unknown', 'Incomplete alias or clause: '+target)
            if derived and split_clause(body[4:], 'FROM|WHERE|RETURNING|ORDER|LIMIT')[1].upper().startswith('FROM'):
                raise ReviewNeeded('query_unknown', 'Derived UPDATE FROM needs a separate source/target contract')
            update_table = derived_table if derived else get_write_table(tables, update[1])
            result['checks'] = check_assignments(body[4:], update_table, alias[1].lower() if alias else None, tables, allow_defaults=True)
        elif insertion or derived:
            table = derived_table if derived else get_write_table(tables, insertion[2])
            is_insert = bool(derived) or insertion[1].upper().startswith('INSERT')
            if not is_insert and '_view_base' in table:
                raise ReviewNeeded('target_unknown', 'REPLACE view semantics are not proved')
            body = target_tail if derived else sql[insertion.end():].strip()
            if body.upper().startswith('SET '):
                if is_insert:
                    raise ReviewNeeded('syntax_unknown', 'INSERT SET not handled')
                result['checks'] = check_assignments(body[4:], table, None, tables)
            else:
                columns, body = split_clause(body, 'VALUES|VALUE|SELECT|DEFAULT')
                route = None
                if is_insert and not derived:
                    columns, route = finite_insert_partition(columns, table)
                alias = re.match(rf'^(?:AS\s+)?({IDENT})(?=\s|\(|$)', columns, re.I) if columns and not columns.startswith('(') else None
                if alias and alias[1].upper() in ('PARTITION', 'SUBPARTITION'):
                    raise ReviewNeeded('partition_routing_unknown', 'Explicit INSERT partition routing not checked')
                if alias and alias[1].upper() in QUERY_KEYWORDS:
                    raise ReviewNeeded('target_unknown', 'Incomplete alias or clause: '+columns)
                if alias:
                    bare_alias = not re.match(r'^AS\b', columns, re.I)
                    columns = columns[alias.end():].strip()
                    selector = re.match(r'^PARTITION\b\s*(?:FOR\b\s*)?\(', columns, re.I)
                    if (is_insert and not derived and bare_alias and selector and
                            re.search(r'\bPARTITION\s+BY\b', top_mask(table['ddl']), re.I)):
                        take_group(columns[selector.end() - 1:])  # Do not classify malformed selectors.
                        raise Contradiction('partition_alias_form_not_supported',
                                            'Documented bare INSERT alias cannot accompany explicit partition selection')
                names = [column_name(x, table['columns'], alias[1].lower() if alias else None) for x in split_list(unwrap(columns))] if columns else list(table['columns'])
                if len(names) != len(set(names)):
                    raise Contradiction('duplicate_column', str(names))
                values = re.match(r'^VALUES?\s*(?=\()', body, re.I)
                if values:
                    rows, tail = split_clause(body[values.end():], 'ON|RETURNING')
                    row_width = None
                    for row in split_list(rows):
                        expressions = split_list(unwrap(row))
                        if row_width is not None and len(expressions) != row_width:
                            raise Contradiction('arity', 'VALUES rows have different widths')
                        row_width = len(expressions)
                        row_names = names
                        if not columns and len(expressions) < len(names):
                            if not is_insert or not table.get('_column_contract'):
                                raise ReviewNeeded('implicit_defaults_unknown', 'Omitted target defaults not checked')
                            row_names = names[:len(expressions)]
                        check_types(row_names, expressions, table['columns'],
                                    default_table=table if is_insert else None, value_table=table)
                        if is_insert and check_omitted_columns(table, row_names):
                            table['_omissions_checked'] = True
                        if route:
                            check_insert_partition_row(route, row_names, expressions)
                elif body.upper().startswith('SELECT '):
                    if route:
                        raise ReviewNeeded('partition_routing_unknown', 'SELECT row partition keys are not evaluated')
                    query, _ = split_clause(body, 'ON|RETURNING')
                    expressions, source = finite_projection(query, tables)
                    query_names = names
                    if is_insert and not columns and len(expressions) < len(names):
                        if not table.get('_column_contract'):
                            raise ReviewNeeded('implicit_defaults_unknown', 'Omitted target defaults not checked')
                        query_names = names[:len(expressions)]
                    check_types(query_names, expressions, table['columns'], source=source, value_table=table)
                    if is_insert and check_omitted_columns(table, query_names):
                        table['_omissions_checked'] = True
                elif is_insert and re.fullmatch(r'DEFAULT\s+VALUES', split_clause(body, 'RETURNING')[0], re.I):
                    # PDF INSERT permits the optional target list with DEFAULT
                    # VALUES. Names were checked above; omitted base columns
                    # still require defaults, not an implicit exemption.
                    check_types(names, ['DEFAULT'] * len(names), table['columns'], default_table=table)
                    check_omitted_columns(table, names)
                else:
                    raise ReviewNeeded('input_unknown', body)
                result['checks'] = ['target_columns', 'input_arity', 'finite_expression_types']
                if route:
                    result['checks'].append('finite_explicit_partition_routing')
        elif re.match(r'^INSERT\s+(?:ALL|FIRST|WHEN)\b', sql, re.I):
            result['checks'] = check_insert_all(sql, tables)
        else:
            raise ReviewNeeded('statement_not_supported', 'Only finite UPDATE/INSERT/REPLACE handled')
        result['status'] = 'checked'
        result['checks'] = cte_checks + result['checks']
        checked_tables = list(tables.values()) + ([derived_table] if derived_table else [])
        if any(t and t.get('_integer_literals_checked') for t in checked_tables):
            result['checks'].append('shared_integer_literal_ranges')
        if any(t and t.get('_decimal_literals_checked') for t in checked_tables):
            result['checks'].append('shared_exact_decimal_literals')
        if any(t and t.get('_defaults_checked') for t in checked_tables):
            result['checks'].append('shared_constant_or_null_defaults')
        if any(t and t.get('_omissions_checked') for t in checked_tables):
            result['checks'].append('insert_omitted_base_columns')
        if any(t and t.get('_explicit_nulls_checked') for t in checked_tables):
            result['checks'].append('shared_explicit_nullability')
        target_name = update[1] if update else insertion[2] if insertion else None
        if target_name and tables.get(target_name.lower(), {}).get('_view_base'):
            result['checks'].append('single_base_direct_view_columns')
        if derived:
            result['checks'].append('single_base_direct_derived_target_columns')
    except ReviewNeeded as exc:
        result['status'] = 'rejected' if isinstance(exc, Contradiction) else 'needs_review'
        result['issues'].append({'code': exc.code, 'detail': exc.detail})
    return result


def inspect_lifecycle(setup, teardown):
    """Static risk flags, not authorization to execute on a shared connection."""
    statements = [s.strip().rstrip(';').upper() for s in setup]
    cleanup = [s.strip().rstrip(';').upper() for s in teardown]
    try:
        single_statements = all(';' not in top_mask(s.strip().rstrip(';')) for s in [*setup, *teardown])
    except ReviewNeeded:
        single_statements = False
    scoped = (bool(statements) and statements[0] == 'BEGIN'
              and single_statements
              and not any(re.match(r'^(?:BEGIN|START\s+TRANSACTION|COMMIT|END|ROLLBACK|ABORT|PREPARE\s+TRANSACTION)\b', s) for s in statements[1:])
              and bool(cleanup) and cleanup[-1] == 'ROLLBACK'
              and all(re.fullmatch(rf'DROP TABLE (?:IF EXISTS )?{NAME}', s) for s in cleanup[:-1]))
    risky = [s for s in [*setup, *teardown]
             if re.search(r'\bDROP\s+(?:OWNED|ROLE|USER|SCHEMA)\b|\bCASCADE\b', s, re.I)]
    return {'status': 'transaction_scoped' if scoped and not risky else 'needs_review',
            'risk_sqls': risky, 'requires': ['dedicated_connection', 'no_outer_transaction',
            'rollback_on_setup_failure', 'documented_transaction_support'],
            'database_executed': False}
