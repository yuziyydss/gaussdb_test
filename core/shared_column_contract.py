"""Internal, uncached DDL evidence for finite INSERT/UPDATE consumers.

No public YAML schema, SQL rewriting, runtime proof or general SQL parser.
Only fully consumed ordinary DDL establishes absence of defaults/nullability.
"""
import hashlib
import re

from .finite_sql_contract import (
    IDENT, NAME, ReviewNeeded, Contradiction, ddl_tables, expression_type,
    split_list, take_group, top_mask, type_family,
)


LITERAL = r"(?:[+-]?\d+|'(?:[^']|'')*'|TRUE|FALSE)"
QUERY_KEYWORDS = {'WHERE', 'JOIN', 'LIMIT', 'OFFSET', 'GROUP', 'ORDER', 'HAVING',
                  'UNION', 'INTERSECT', 'EXCEPT', 'MINUS', 'WITH', 'FOR', 'FETCH',
                  'AS', 'CONNECT', 'START'}


def ordinary_columns(ddl):
    statement = ddl.strip().removesuffix(';').strip()
    match = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+({NAME})\s*(\()', statement, re.I)
    if not match:
        return None
    body, remainder = take_group(statement[match.end()-1:])
    if remainder or '"' in statement:
        return None
    columns = {}
    for declaration in split_list(body):
        column = re.fullmatch(
            rf'({IDENT})\s+(INTEGER|INT[248]?|SMALLINT|BIGINT|TEXT|VARCHAR|CHARACTER\s+VARYING|BOOLEAN|BOOL)'
            r'(\s*\(\s*\d+\s*\))?(?=\s|$)(.*)', declaration, re.I | re.S)
        if not column or column[1].lower() in columns:
            return None
        name, typ, length, rest = column.groups()
        family = type_family(typ)
        if length and (family != 'text' or typ.upper() == 'TEXT'):
            return None
        nullable, null_seen, default = True, False, None
        while rest.strip():
            rest = rest.strip()
            null = re.match(r'^(NOT\s+NULL|NULL|PRIMARY\s+KEY)\b', rest, re.I)
            if null:
                if null_seen:
                    return None
                nullable, null_seen = null[1].upper() == 'NULL', True
                rest = rest[null.end():]
                continue
            if default is not None or not re.match(r'^DEFAULT\s+', rest, re.I):
                return None
            rest = re.sub(r'^DEFAULT\s+', '', rest, flags=re.I)
            suffix = re.search(r'\b(?:NOT\s+NULL|PRIMARY\s+KEY)\b', top_mask(rest), re.I)
            default = rest[:suffix.start()].strip() if suffix else rest.strip()
            rest = rest[suffix.start():] if suffix else ''
            if not default:
                return None
        state = ('absent' if default is None else 'null' if default.upper() == 'NULL'
                 else 'constant' if re.fullmatch(LITERAL, default, re.I)
                 else 'dynamic' if re.fullmatch(rf'{NAME}\s*\(.*\)', default, re.S)
                 else 'unparsed')
        columns[name.lower()] = {
            'family': family, 'type': typ.upper(),
            'length': int(re.sub(r'\D', '', length)) if length else None,
            'nullable': nullable, 'default_state': state, 'default_sql': default,
            'origin': (match[1].lower(), name.lower()),
            'ddl_sha256': hashlib.sha256(ddl.encode()).hexdigest(),
        }
    return columns or None


def unrelated_plain_table_ddl(sql, base_name, view_name):
    """Safe only for a closed direct-view dependency graph checked by caller.

    Different spelling is not identity proof when either name lacks a schema.
    Unknown DDL, constraints, expressions and multi-object drops stay opaque.
    """
    statement = sql.strip().removesuffix(';').strip()
    drop = re.fullmatch(rf'DROP\s+TABLE\s+(?:IF\s+EXISTS\s+)?({NAME})(?:\s+(?:CASCADE|RESTRICT))?',
                        statement, re.I)
    create = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+({NAME})\s*\(', statement, re.I)
    if drop:
        name = drop[1].lower()
    elif create:
        columns = ordinary_columns(statement)
        if not columns or any(c['default_state'] not in ('absent', 'null', 'constant') for c in columns.values()):
            return False
        name = create[1].lower()
    else:
        return False
    for dependency in (base_name.lower(), view_name.lower()):
        if name == dependency:
            return False
        if ('.' not in name or '.' not in dependency) and name.split('.')[-1] == dependency.split('.')[-1]:
            return False
    return True


def direct_projection_columns(projection, base, alias, labels=None):
    """Shared direct-column lineage for named views and derived targets."""
    if alias.upper() in QUERY_KEYWORDS:
        return None
    expressions = list(base['columns']) if projection.strip() == '*' else split_list(projection)
    projected, origins = {}, []
    for expr in expressions:
        match = re.fullmatch(rf'({NAME})(?:\s+AS\s+({IDENT}))?', expr, re.I)
        if not match:
            return None
        parts = match[1].lower().split('.')
        origin = parts[-1]
        label = (match[2] or origin).lower()
        if (len(parts) == 2 and parts[0] != alias) or origin not in base['columns'] or label in projected:
            return None
        projected[label] = base['_column_contract'][origin]
        origins.append(origin)
    if not projected or len(origins) != len(set(origins)):
        return None
    if labels is not None:
        if (len(labels) != len(projected) or len(set(labels)) != len(labels)
                or not all(re.fullmatch(IDENT, s) for s in labels)):
            return None
        projected = dict(zip(labels, projected.values()))
    return projected


def finite_derived_target(query, tables):
    """Inspect actual target SELECT, without creating or rewriting any SQL."""
    match = re.fullmatch(rf'SELECT\s+(.+?)\s+FROM\s+({NAME})(?:\s+(?:AS\s+)?({IDENT}))?',
                         query.strip(), re.I | re.S)
    if not match:
        raise ReviewNeeded('target_unknown', 'Derived target is not a finite direct projection')
    base = tables.get(match[2].lower())
    if not base or not base.get('_column_contract') or '_view_base' in base:
        raise ReviewNeeded('fixture_unknown', 'Derived target needs a complete ordinary base table')
    alias = (match[3] or match[2].split('.')[-1]).lower()
    projected = direct_projection_columns(match[1], base, alias)
    if not projected:
        raise ReviewNeeded('target_unknown', 'Derived output is not unambiguous direct user columns')
    return {'columns': {n: c['family'] for n, c in projected.items()},
            'ddl': query, '_column_contract': projected, '_view_base': base,
            '_derived_target': True,
            '_target_query_sha256': hashlib.sha256(query.encode()).hexdigest()}


def attach_shared_contracts(tables, setup):
    """Re-derive from ordered setup on every call; no stale cross-case cache."""
    # Rules/triggers or namespace settings require a separate writeability contract.
    if any(re.match(r'^\s*(?:CREATE\s+(?:OR\s+REPLACE\s+)?(?:TRIGGER|RULE)|SET\b|RESET\b)', s, re.I)
           for s in setup):
        return tables
    for table in tables.values():
        if table and table['columns']:
            table['_column_contract'] = ordinary_columns(table['ddl'])
    for index, sql in enumerate(setup):
        statement = sql.strip().removesuffix(';').strip()
        view = re.fullmatch(rf'CREATE\s+VIEW\s+({NAME})\s*(\([^)]*\))?\s+AS\s+SELECT\s+(.+?)\s+FROM\s+({NAME})'
                            rf'(?:\s+(?:AS\s+)?({IDENT}))?', statement, re.I | re.S)
        if not view or view[1].lower() in tables:
            continue
        if (view[5] or '').upper() in QUERY_KEYWORDS:
            continue
        before = ddl_tables(setup[:index])
        base_name = view[4].lower()
        base = tables.get(base_name)
        if (not base or not base.get('_column_contract') or not before.get(base_name)
                or before[base_name]['ddl'] != base['ddl']):
            continue
        # A complete ordinary base and direct user-column projection have no
        # hidden table/type/default dependencies. Only this narrow graph may
        # survive unrelated plain-table DDL, including its CASCADE. Own-object
        # drop/recreate and uncertain namespace/opaque changes always revoke.
        closed = all(c['default_state'] in ('absent', 'null', 'constant')
                     for c in base['_column_contract'].values())
        if any(re.match(r'^\s*(?:CREATE|ALTER|DROP|DO|CALL|EXECUTE|COMMIT|END|ROLLBACK|ABORT|DISCARD|PREPARE)\b', s, re.I)
               and not (closed and unrelated_plain_table_ddl(s, base_name, view[1]))
               for s in setup[index+1:]):
            continue
        # Repeated CREATE VIEW without DROP is not evidence of successful setup.
        if any(re.match(rf'^\s*CREATE\s+(?:OR\s+REPLACE\s+)?VIEW\s+{re.escape(view[1])}\b', s, re.I)
               for s in setup[:index]):
            continue
        alias = (view[5] or base_name.split('.')[-1]).lower()
        labels = [s.lower() for s in split_list(view[2][1:-1])] if view[2] else None
        projected = direct_projection_columns(view[3], base, alias, labels)
        if projected:
            tables[view[1].lower()] = {
                'columns': {n: c['family'] for n, c in projected.items()},
                'ddl': sql, '_column_contract': projected, '_view_base': base,
                '_view_ddl_sha256': hashlib.sha256(sql.encode()).hexdigest(),
            }
    return tables


def default_literal(table, name):
    contract = table.get('_column_contract')
    if '_view_base' in table:
        raise ReviewNeeded('default_unknown', 'View/derived DEFAULT application semantics are not established; '
                           'base-column lineage does not prove inheritance: '+name)
    if not contract:
        raise ReviewNeeded('default_unknown', 'No complete base-column default evidence: '+name)
    column = contract[name]
    state = column['default_state']
    if state not in ('absent', 'null', 'constant'):
        raise ReviewNeeded('default_unknown', f'{name}: {state} default')
    value = 'NULL' if state in ('absent', 'null') else column['default_sql']
    validate_literal(column, value)
    return value


def validate_literal(column, value):
    if value.upper() == 'NULL':
        if not column['nullable']:
            raise Contradiction('null_not_allowed', f"{column['origin']}: NULL violates declared NOT NULL")
        return
    if expression_type(value, {}) != column['family']:
        raise ReviewNeeded('conversion_unknown', f"{column['origin']}: default conversion not proved")
    if column['family'] == 'integer':
        bits = 16 if column['type'] in ('SMALLINT', 'INT2') else 64 if column['type'] in ('BIGINT', 'INT8') else 32
        if len(value) > 32 or not -(2**(bits-1)) <= int(value) < 2**(bits-1):
            raise ReviewNeeded('default_range_unknown', str(column['origin']))
    if column['family'] == 'text':
        decoded = value[1:-1].replace("''", "'")
        limit = column['length']
        if not decoded.isascii() or (limit is not None and (limit < 1 or len(decoded) > limit)):
            raise ReviewNeeded('default_length_unknown', str(column['origin']))


def check_omitted_columns(table, names):
    contract = table.get('_column_contract')
    if not contract:
        # Existing shape-only checks stay shape-only, never claim default proof.
        return False
    base = table.get('_view_base', table)
    used = {contract[n]['origin'][1] for n in names}
    for name in base['_column_contract']:
        if name not in used:
            default_literal(base, name)
    return True
