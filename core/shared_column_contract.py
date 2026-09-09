"""Internal, uncached DDL evidence for finite INSERT/UPDATE consumers.

No public YAML schema, SQL rewriting, runtime proof or general SQL parser.
Only fully consumed ordinary DDL establishes absence of defaults/nullability.
"""
import hashlib
import re

from .finite_sql_contract import (
    IDENT, NAME, ReviewNeeded, Contradiction, ddl_tables, expression_type,
    split_list, take_group, top_mask, type_family, unwrap,
)


LITERAL = r"(?:[+-]?\d+|'(?:[^']|'')*'|TRUE|FALSE)"
EXACT_DECIMAL_LITERAL = r'[+-]?[0-9]+(?:\.[0-9]+)?'
QUERY_KEYWORDS = {'WHERE', 'JOIN', 'LIMIT', 'OFFSET', 'GROUP', 'ORDER', 'HAVING',
                  'UNION', 'INTERSECT', 'EXCEPT', 'MINUS', 'WITH', 'FOR', 'FETCH',
                  'AS', 'CONNECT', 'START'}


def check_direct_projection_types(items, declared_types, columns, source_types):
    """Reject contradictions in finite unqualified column projections.

    Returns positions actually checked, not a whole-query proof. Expressions,
    functions, literals and qualified/quoted identifiers need separate identity
    contracts. In particular no SUM return type or implicit cast is inferred.
    Input source types are the caller's contract, not database catalog evidence.
    """
    aliases = {'INT': 'INTEGER', 'INT4': 'INTEGER', 'INT2': 'SMALLINT',
               'INT8': 'BIGINT', 'DECIMAL': 'NUMERIC', 'BOOL': 'BOOLEAN'}

    def canonical(value):
        value = ' '.join(str(value).upper().split())
        return aliases.get(value, value)

    source = {str(name).lower(): typ for name, typ in zip(columns, source_types)}
    checked = []
    for index, (item, declared) in enumerate(zip(items, declared_types)):
        match = re.fullmatch(rf'({IDENT})(?:\s+AS\s+{IDENT})?', str(item).strip(), re.I)
        if not match or match[1].upper() in (
            'NULL', 'TRUE', 'FALSE', 'DEFAULT', 'CURRENT_DATE', 'CURRENT_TIME',
            'CURRENT_TIMESTAMP', 'LOCALTIME', 'LOCALTIMESTAMP', 'CURRENT_USER',
            'SESSION_USER', 'USER', 'CURRENT_ROLE', 'CURRENT_CATALOG', 'CURRENT_SCHEMA',
        ):
            continue
        name = match[1].lower()
        if name not in source:
            raise Contradiction('projection_missing_column', name)
        if canonical(source[name]) != canonical(declared):
            raise Contradiction('projection_type_mismatch',
                                f'column {index+1} {name}: source={source[name]}, declared={declared}')
        checked.append(index)
    return checked


def finite_values_null_positions(items, width):
    """Untyped NULL input evidence from every full VALUES row, not a cast.

    This proves only the input token's identity. Target nullability, generated
    columns and execution are separate checks; SELECT/set inference is absent.
    """
    if not isinstance(items, list) or not items or not all(isinstance(s, str) for s in items):
        raise ReviewNeeded('null_input_unknown', 'NULL requires nonempty finite VALUES rows')
    positions = set(range(width))
    for item in items:
        row = split_list(unwrap(item))
        if len(row) != width:
            raise ReviewNeeded('null_input_unknown', 'VALUES row width differs from output contract')
        positions.intersection_update(i for i, expr in enumerate(row) if expr.upper() == 'NULL')
    return positions


def check_rendered_insert_target(sql, setup, *, profile_target, available_types,
                                  available_count, target_types, target_count,
                                  explicit_columns, contract, is_view=False,
                                  generated=False, generated_columns=None):
    """Identity/types of a finite implicit INSERT target, not casts.

    Uses surviving actual CREATE DDL, not provides/profile declarations. Input
    values, conversion safety, predicates, triggers and runtime stay separate.
    Views/generated targets require separate positive declaration providers.
    Aliases and explicit target lists are not proved; behavior stays separate.
    """
    from .finite_sql_contract import get_table
    if contract not in ('fixture_ordinary_columns', 'fixture_direct_view_columns', 'fixture_generated_columns'):
        raise ReviewNeeded('target_contract_unknown', str(contract))
    view_contract = contract == 'fixture_direct_view_columns'
    generated_contract = contract == 'fixture_generated_columns'
    if is_view is not view_contract or generated is not generated_contract:
        raise Contradiction('target_kind_mismatch', 'Profile kind differs from the selected target contract')
    statement = sql.strip().removesuffix(';').strip()
    if '--' in statement or '/*' in statement or ';' in top_mask(statement):
        raise ReviewNeeded('target_source_unknown', 'Expected one uncommented INSERT')
    match = re.match(rf'^INSERT\s+(?:INTO\s+)?({NAME})\b', statement, re.I)
    if not match or not re.fullmatch(NAME, profile_target):
        raise ReviewNeeded('target_source_unknown', 'Only direct target names are proved')
    if match[1].lower() != profile_target.lower():
        raise Contradiction('target_identity_mismatch', match[1])
    if explicit_columns or not re.match(r'^(?:VALUES?|SET|SELECT)\b', statement[match.end():].strip(), re.I):
        raise ReviewNeeded('target_columns_unknown', 'Explicit columns/aliases need an ordered target contract')
    if any(re.match(r'^\s*(?:SET|RESET)\b', s, re.I) for s in setup):
        raise ReviewNeeded('target_source_unknown', 'Session name resolution is not interpreted')
    try:
        tables = ddl_tables(setup)
        if view_contract:
            tables = attach_shared_contracts(tables, setup)
        table = get_table(tables, match[1])
    except ReviewNeeded as exc:
        raise ReviewNeeded('target_source_unknown', exc.detail) from exc
    if view_contract and '_view_base' not in table:
        raise Contradiction('target_kind_mismatch', 'Actual target is not a proven direct view')
    columns = table.get('_column_contract') if view_contract else ordinary_columns(table['ddl'])
    if generated_contract:
        columns = finite_generated_target_columns(table)
        actual_generated = {n for n, col in columns.items() if col['generated']}
        if actual_generated != {str(n).lower() for n in (generated_columns or [])}:
            raise Contradiction('target_generated_columns_mismatch', 'Profile points at different generated columns')
    if not columns:
        raise ReviewNeeded('target_definition_unknown', 'Complete ordinary target DDL is required')
    names = list(columns)
    actual_types = [columns[n]['type'] for n in names]
    if (available_count != len(names) or target_count != len(names)
            or len(available_types) != len(names) or len(target_types) != len(names)):
        raise Contradiction('target_arity_mismatch', 'Profile width differs from actual target declarations')
    try:
        for declared in (available_types, target_types):
            checked = check_direct_projection_types(names, declared, names, actual_types)
            if len(checked) != len(names):
                raise ReviewNeeded('target_columns_unknown', 'Not all column identities are proved')
    except Contradiction as exc:
        raise Contradiction('target_type_mismatch', exc.detail) from exc
    return {'target_name': match[1].lower(), 'column_order': names,
            'declaration_types': actual_types, 'column_origins': {n: columns[n]['origin'] for n in names},
            'view_lineage': view_contract, 'generated_columns': [n for n in names if columns[n].get('generated')],
            'generation_semantics_proven': False, 'input_conversion_proven': False, 'runtime_proven': False}


def check_rendered_insert_primary_key(sql, setup, *, profile_target, key_columns):
    """Positive inline-PK evidence for a direct PG ON CONFLICT target only.

    Not an index/constraint catalog: named/table constraints, partial/expression
    indexes, schema resolution changes and altered DDL remain unproved. No
    unique evidence is inferred from a profile label, NOT NULL or a key name.
    """
    from .finite_sql_contract import get_table
    if (not isinstance(key_columns, list) or len(key_columns) != 1
            or not all(isinstance(k, str) and re.fullmatch(IDENT, k) for k in key_columns)):
        raise ReviewNeeded('primary_key_contract_unknown', 'One explicit unquoted key is required')
    expected = [k.lower() for k in key_columns]
    profile = re.fullmatch(rf'({NAME})\s*(?:\([^)]*\))?', profile_target.strip(), re.I)
    statement = sql.strip().removesuffix(';').strip()
    masked = top_mask(statement)
    head = re.match(rf'^INSERT\s+INTO\s+({NAME})\s*\(', statement, re.I)
    if not profile or not head or '--' in statement or '/*' in statement or ';' in masked:
        raise ReviewNeeded('primary_key_target_unknown', 'Expected one direct INSERT with explicit columns')
    if profile[1].lower() != head[1].lower():
        raise Contradiction('primary_key_target_mismatch', head[1])
    if any(re.match(r'^\s*(?:SET|RESET)\b', s, re.I) for s in setup):
        raise ReviewNeeded('primary_key_source_unknown', 'Session name resolution is not interpreted')
    table = get_table(ddl_tables(setup), head[1])
    columns = ordinary_columns(table['ddl'])
    if not columns:
        raise ReviewNeeded('primary_key_definition_unknown', 'Complete ordinary CREATE TABLE is required')
    ddl_head = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+{NAME}\s*(\()', table['ddl'], re.I)
    body, _ = take_group(table['ddl'][ddl_head.end()-1:])
    actual = []
    for declaration in split_list(body):
        if re.search(r'\bPRIMARY\s+KEY\b', top_mask(declaration), re.I):
            actual.append(re.match(IDENT, declaration)[0].lower())
    if actual != expected:
        raise Contradiction('primary_key_mismatch', f'Actual inline primary key {actual}, required {expected}')
    conflict = re.search(r'\bON\s+CONFLICT\b', masked, re.I)
    if not conflict:
        raise ReviewNeeded('primary_key_consumer_unknown', 'Only ON CONFLICT is a consumer')
    tail = statement[conflict.end():].strip()
    if tail.startswith('('):
        target, action = take_group(tail)
        names = split_list(target)
        if (not all(re.fullmatch(IDENT, n) for n in names)
                or [n.lower() for n in names] != actual):
            raise Contradiction('primary_key_conflict_target_mismatch', target)
        if not re.match(r'^DO\s+(?:UPDATE\s+SET\b|NOTHING\b)', action, re.I):
            raise ReviewNeeded('primary_key_consumer_unknown', 'Predicate/arbitrary conflict action is unproved')
    elif not re.fullmatch(r'DO\s+NOTHING', tail, re.I):
        raise ReviewNeeded('primary_key_consumer_unknown', 'Only DO NOTHING may omit the finite target')
    return {'table': head[1].lower(), 'primary_key': actual,
            'ddl_sha256': hashlib.sha256(table['ddl'].encode()).hexdigest(), 'runtime_proven': False}


def check_rendered_replace_unique_keys(sql, setup, *, profile_target, required_keys, expected_conflicts):
    """One-row M REPLACE with two plain INT inline keys and two actual seeds.

    A closed fixture is intentional: no DEFAULT/NULL, other DDL/DML, delayed,
    composite or expression constraints. This does not extend ordinary_columns
    or prove database behavior. Profile claims must match fully consumed SQL.
    """
    if (len(setup) != 2 or not isinstance(required_keys, dict) or len(required_keys) != 2
            or sorted(required_keys.values()) != ['PRIMARY KEY', 'UNIQUE']
            or type(expected_conflicts) is not int or not 0 <= expected_conflicts <= 2):
        raise ReviewNeeded('unique_key_scope_unknown', 'Expected two inline keys, CREATE and seed INSERT')
    statements = [s.strip().removesuffix(';').strip() for s in [*setup, sql]]
    if any('--' in s or '/*' in s or ';' in top_mask(s) for s in statements):
        raise ReviewNeeded('unique_key_source_unknown', 'Commented/multiple/opaque statements are unproved')
    ddl = re.fullmatch(rf'CREATE\s+TABLE\s+({NAME})\s*\((.*)\)', statements[0], re.I | re.S)
    if not ddl:
        raise ReviewNeeded('unique_key_ddl_unknown', 'Fresh ordinary CREATE TABLE is required')
    columns, actual_keys = [], {}
    for declaration in split_list(ddl[2]):
        col = re.fullmatch(rf'({IDENT})\s+(?:INT|INTEGER)(?:\s+(PRIMARY\s+KEY|UNIQUE))?', declaration, re.I)
        if not col or col[1].lower() in columns:
            raise ReviewNeeded('unique_key_ddl_unknown', declaration)
        name = col[1].lower()
        columns.append(name)
        if col[2]:
            actual_keys[name] = ' '.join(col[2].upper().split())
    if len(columns) != 2:
        raise ReviewNeeded('unique_key_ddl_unknown', 'Only two complete ordinary INT declarations are proved')
    if actual_keys != {k.lower(): v for k, v in required_keys.items()}:
        raise Contradiction('unique_key_mismatch', f'Actual {actual_keys}, required {required_keys}')
    if actual_keys.get(columns[0]) != 'PRIMARY KEY':
        raise ReviewNeeded('unique_key_order_unknown', 'Finite result order uses the first, primary-key column')
    target = re.fullmatch(rf'({NAME})\s*\(([^()]*)\)', profile_target, re.I)
    if not target or target[1].lower() != ddl[1].lower() or [c.lower() for c in split_list(target[2])] != columns:
        raise Contradiction('unique_key_target_mismatch', profile_target)

    def rows(statement, prefix):
        match = re.fullmatch(rf'{prefix}\s+({NAME})\s*\(([^()]*)\)\s+VALUES\s+(.+)', statement, re.I | re.S)
        if not match:
            raise ReviewNeeded('unique_key_input_unknown', 'Explicit columns and finite VALUES are required')
        if match[1].lower() != ddl[1].lower() or [c.lower() for c in split_list(match[2])] != columns:
            raise Contradiction('unique_key_target_mismatch', match[1])
        values = []
        for row in split_list(match[3]):
            expressions = split_list(unwrap(row))
            if len(expressions) != 2 or any(not re.fullmatch(r'[+-]?[0-9]+', e) for e in expressions):
                raise ReviewNeeded('unique_key_input_unknown', 'Only two non-NULL INT literals are proved')
            if any(len(e.lstrip('+-').lstrip('0')) > 10 for e in expressions):
                raise ReviewNeeded('unique_key_input_unknown', 'Literal exceeds the finite INT range')
            values.append([int(e) for e in expressions])
            if any(not -(2**31) <= v <= 2**31-1 for v in values[-1]):
                raise ReviewNeeded('unique_key_input_unknown', 'Literal exceeds the finite INT range')
        return values

    seeds = rows(statements[1], r'INSERT\s+INTO')
    incoming = rows(statements[2], r'REPLACE(?:\s+INTO)?')
    if len(seeds) != 2 or len(incoming) != 1:
        raise ReviewNeeded('unique_key_input_unknown', 'Only two seeds and one incoming row are proved')
    if any(len({row[index] for row in seeds}) != 2 for index in (0, 1)):
        raise Contradiction('seed_unique_violation', 'Seed INSERT already conflicts with a declared key')
    conflicts = [row for row in seeds if any(row[i] == incoming[0][i] for i in (0, 1))]
    if len(conflicts) != expected_conflicts:
        raise Contradiction('conflict_rows_mismatch', f'Actual {len(conflicts)}, required {expected_conflicts}')
    return {'column_order': columns, 'keys': actual_keys, 'conflicting_rows': len(conflicts),
            'expected_rows': sorted([row for row in seeds if row not in conflicts] + incoming),
            'ddl_sha256': hashlib.sha256(statements[0].encode()).hexdigest(), 'runtime_proven': False}


def generated_write_columns(table):
    """Positive column-identity evidence only, not a generation evaluator.

    M CREATE TABLE permits [GENERATED ALWAYS] AS (...) [STORED|VIRTUAL].
    An omitted storage keyword is intentionally not resolved: M s2 changes
    its default. Read the actual surviving CREATE, not a fixture label, a
    column named 'generated', or keywords inside a DEFAULT string literal.
    Views/derived targets still require their existing identity contract.
    """
    ddl = table['ddl'].strip().removesuffix(';').strip()
    match = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+{NAME}\s*(\()', ddl, re.I)
    if not match or '"' in ddl:
        return set()
    body, _ = take_group(ddl[match.end()-1:])
    generated = set()
    for declaration in split_list(body):
        column = re.match(
            rf'^({IDENT})\s+{NAME}(?:\s+PRECISION|\s+VARYING)?'
            r'(?:\s*\([^)]*\))?\s+(?:GENERATED\s+ALWAYS\s+)?AS\s*(\()',
            declaration, re.I)
        if not column or column[1].lower() not in table['columns']:
            continue
        expression, suffix = take_group(declaration[column.end()-1:])
        if not expression.strip() or not re.fullmatch(r'(?:STORED|VIRTUAL)?', suffix, re.I):
            raise ReviewNeeded('generated_definition_unknown', declaration)
        generated.add(column[1].lower())
    return generated


def finite_generated_target_columns(table):
    """Positive simple declarations only; never create an ordinary contract.

    Actual consumer: naked INT id/qty and explicitly declared generated g.
    Bare builtin types below retain spelling; typmods, ordinary DEFAULT and
    constraints are deliberately unproved here. Existing generated identity
    parser checks AS grouping/storage spelling, not expression legality/result.
    No NULL/default absence, generation evaluation or storage-default inference.
    """
    ddl = table['ddl'].strip().removesuffix(';').strip()
    head = re.match(rf'^CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+({NAME})\s*(\()', ddl, re.I)
    if not head or '"' in ddl:
        raise ReviewNeeded('target_definition_unknown', 'Expected a finite unquoted CREATE TABLE')
    body, tail = take_group(ddl[head.end()-1:])
    if tail:
        raise ReviewNeeded('target_definition_unknown', 'Table suffix has no declaration contract')
    generated = generated_write_columns(table)
    if not generated:
        raise Contradiction('target_kind_mismatch', 'Actual target has no proved generated column')
    columns = {}
    for declaration in split_list(body):
        column = re.fullmatch(rf'({IDENT})\s+(INTEGER|INT|SMALLINT|BIGINT|BOOLEAN|BOOL|TEXT)'
                              r'(?:\s+(.*))?', declaration, re.I | re.S)
        if not column or column[1].lower() in columns:
            raise ReviewNeeded('target_definition_unknown', 'Unproved/duplicate column declaration')
        name, typ, suffix = column.groups()
        name = name.lower()
        if name not in generated and (suffix or '').strip():
            raise ReviewNeeded('target_definition_unknown', 'Ordinary column clauses need a separate contract')
        columns[name] = {'type': typ.upper(), 'origin': (head[1].lower(), name),
                         'generated': name in generated}
    if set(columns) != set(table['columns']):
        raise ReviewNeeded('target_definition_unknown', 'Column identity differs from the fixture parser')
    return columns


def check_generated_inputs(table, names, expressions):
    """Check input intent before generic types can erase generated identity."""
    generated = generated_write_columns(table)
    inputs = [(name, expr) for name, expr in zip(names, expressions) if name in generated]
    for name, expr in inputs:
        if expr.strip().upper() != 'DEFAULT':
            raise Contradiction('generated_column_write',
                                f'{name}: generated column cannot receive an explicit value (including NULL)')
    if inputs:
        raise ReviewNeeded('generated_default_unknown',
                           'DEFAULT requests generation, not an ordinary NULL/default literal; '
                           'generation expression/result contract is not evaluated')


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
            rf'({IDENT})\s+(INTEGER|INT[248]?|SMALLINT|BIGINT|TEXT|VARCHAR|CHARACTER\s+VARYING|BOOLEAN|BOOL|NUMERIC|DECIMAL)'
            r'(\s*\(\s*[0-9]+\s*(?:,\s*[0-9]+\s*)?\))?(?=\s|$)(.*)', declaration, re.I | re.S)
        if not column or column[1].lower() in columns:
            return None
        name, typ, length, rest = column.groups()
        family = type_family(typ)
        decimal_params = {}
        if family == 'numeric':
            # Bare/one-parameter NUMERIC and DECIMAL have context-dependent
            # defaults (PDF 1.3.1); only explicit valid (p,s) is evidence here.
            params = re.findall(r'[0-9]+', length or '')
            params = [p.lstrip('0') or '0' for p in params]
            if len(params) != 2 or any(len(p) > 4 for p in params):
                return None
            precision, scale = map(int, params)
            if not 1 <= precision <= 1000 or not 0 <= scale <= precision:
                return None
            decimal_params = {'precision': precision, 'scale': scale}
            length = None
        elif length and (family != 'text' or typ.upper() == 'TEXT' or ',' in length):
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
                 else 'constant' if (re.fullmatch(LITERAL, default, re.I)
                                     or (decimal_params and re.fullmatch(EXACT_DECIMAL_LITERAL, default)))
                 else 'dynamic' if re.fullmatch(rf'{NAME}\s*\(.*\)', default, re.S)
                 else 'unparsed')
        columns[name.lower()] = {
            'family': family, 'type': typ.upper(),
            'length': int(re.sub(r'\D', '', length)) if length else None,
            'nullable': nullable, 'default_state': state, 'default_sql': default,
            'origin': (match[1].lower(), name.lower()),
            'ddl_sha256': hashlib.sha256(ddl.encode()).hexdigest(),
            **decimal_params,
        }
    return columns or None


def _fresh_plain_column_fixture(setup, target, label):
    """Shared closed fixture evidence, not a catalog or general DDL evaluator."""
    from .finite_sql_contract import inspect_write
    if not setup:
        raise ReviewNeeded(label+'_fixture_unknown','Fresh CREATE TABLE is required')
    ddl=setup[0].strip().removesuffix(';').strip()
    actual=re.match(rf'^CREATE\s+TABLE\s+({NAME})\s*\(',ddl,re.I)
    if not actual or actual[1].lower()!=target or '--' in ddl or '/*' in ddl or ';' in top_mask(ddl):
        raise ReviewNeeded(label+'_fixture_unknown','First setup must create exactly the selected ordinary table')
    columns=ordinary_columns(ddl)
    if not columns or any(not c['nullable'] or c['default_state']!='absent' for c in columns.values()):
        raise ReviewNeeded(label+'_definition_unknown','Defaults, constraints or unparsed definitions need another contract')
    for index,seed in enumerate(setup[1:],1):
        insert=re.match(rf'^\s*INSERT\s+(?:INTO\s+)?({NAME})\b',seed,re.I)
        if not insert or insert[1].lower()!=target or inspect_write(seed,setup[:index])['status']!='checked':
            raise ReviewNeeded(label+'_setup_unknown','Only finite seed INSERTs into this table are supported')
    return columns


def check_rendered_column_add(sql, setup, *, profile_target, added_column,
                              compatibility_modes, position_compatibility_mode='B'):
    """One nullable INTEGER ADD FIRST/AFTER; only statically derive column order."""
    if position_compatibility_mode not in ('B','M') or compatibility_modes != [position_compatibility_mode]:
        raise ReviewNeeded('column_add_mode','Position requires the exact reviewed B/M chapter mode')
    if (not isinstance(profile_target,str) or not re.fullmatch(NAME,profile_target)
            or not isinstance(added_column,str) or not re.fullmatch(IDENT,added_column)):
        raise ReviewNeeded('column_add_contract_unknown','Explicit ordinary table and added column required')
    statement=sql.strip().removesuffix(';').strip()
    if '--' in statement or '/*' in statement or ';' in top_mask(statement):
        raise ReviewNeeded('column_add_syntax_unknown','Expected one uncommented ADD statement')
    match=re.fullmatch(rf'ALTER\s+TABLE\s+({NAME})\s+ADD\s+(?:COLUMN\s+)?({IDENT})\s+INTEGER\s+'
                       rf'(FIRST|AFTER\s+({IDENT}))',statement,re.I)
    if not match:
        raise ReviewNeeded('column_add_syntax_unknown','Only ordinary nullable INTEGER ADD FIRST/AFTER is reviewed')
    target,new=profile_target.lower(),added_column.lower()
    if (match[1].lower(),match[2].lower()) != (target,new):
        raise Contradiction('column_add_identity_mismatch','Rendered target or added name differs from profile')
    columns=_fresh_plain_column_fixture(setup,target,'column_add')
    if new in columns:
        raise Contradiction('column_add_destination_exists',new)
    before=list(columns);after=before.copy()
    if match[4]:
        anchor=match[4].lower()
        if anchor not in columns:
            raise Contradiction('column_add_anchor_missing',anchor)
        after.insert(before.index(anchor)+1,new)
    else:
        after.insert(0,new)
    return dict(before_columns=before,after_columns=after,added_nullable=True,added_default_state='absent')


def check_rendered_column_rename(sql, setup, *, profile_target, source_column,
                                 target_column, compatibility_modes, change_compatibility_mode='B'):
    """Prove only a same-definition rename on one fresh, plain fixture table.

    RENAME and source-scoped B/M CHANGE share the old/new identity check. Type/default/null or
    position changes, dependencies and opaque setup remain outside this model;
    returned column order is not an executed result or a general DDL simulator.
    """
    if change_compatibility_mode not in ('B','M'):
        raise ReviewNeeded('column_rename_source_unknown','Only reviewed B/M CHANGE chapter scopes are supported')
    if (not isinstance(profile_target,str) or not re.fullmatch(NAME,profile_target)
            or not all(isinstance(n,str) and re.fullmatch(IDENT,n) for n in (source_column,target_column))):
        raise ReviewNeeded('column_rename_contract_unknown','Explicit ordinary table/column identities required')
    target,old,new=profile_target.lower(),source_column.lower(),target_column.lower()
    statement=sql.strip().removesuffix(';').strip()
    if '--' in statement or '/*' in statement or ';' in top_mask(statement):
        raise ReviewNeeded('column_rename_syntax_unknown','Expected exactly one uncommented ALTER TABLE')
    prefix=rf'ALTER\s+TABLE\s+({NAME})\s+'
    rename=re.fullmatch(prefix+rf'RENAME\s+(?:COLUMN\s+)?({IDENT})\s+TO\s+({IDENT})',statement,re.I)
    change=re.fullmatch(prefix+rf'CHANGE\s+(?:COLUMN\s+)?({IDENT})\s+({IDENT})\s+'
                        r'((?:VARCHAR\s*\(\s*[0-9]+\s*\)|INTEGER|INT|SMALLINT|BIGINT|TEXT|BOOLEAN))',statement,re.I)
    match=rename or change
    if not match:
        raise ReviewNeeded('column_rename_syntax_unknown','Only ordinary RENAME or same-definition CHANGE is supported')
    if rename and change_compatibility_mode == 'M':
        raise ReviewNeeded('column_rename_syntax_unknown','Reviewed M contract covers CHANGE, not general RENAME COLUMN')
    if tuple(x.lower() for x in match.groups()[:3]) != (target,old,new):
        raise Contradiction('column_rename_identity_mismatch','Rendered target or rename mapping differs from profile')
    if change and compatibility_modes != [change_compatibility_mode]:
        raise ReviewNeeded('column_rename_mode',f'Actual CHANGE requires exactly {change_compatibility_mode} for its source chapter')
    columns=_fresh_plain_column_fixture(setup,target,'column_rename')
    if old not in columns:
        raise Contradiction('column_rename_source_missing',old)
    if new in columns:
        raise Contradiction('column_rename_destination_exists',new)
    if change:
        changed=ordinary_columns(f'CREATE TABLE shape ({new} {change[4]})')[new]
        if any(changed[k]!=columns[old][k] for k in ('type','length','nullable','default_state')):
            raise ReviewNeeded('column_rename_definition_changed','CHANGE changes more than the column name')
    before=list(columns)
    return dict(before_columns=before,after_columns=[new if n==old else n for n in before],definition_changed=False)


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
    if column['family'] == 'numeric' and value.upper() != 'NULL':
        table['_decimal_literals_checked'] = True
    return value


def check_explicit_null(table, name):
    """Explicit NULL uses ordinary nullability, never a default substitution.

    M CREATE TABLE SELECT 2.4.2.8.19 L283-286 and L296-297 distinguish
    nullability from omission/defaults. The caller checks generated identity
    first. Views/derived targets and absent ordinary DDL evidence remain unknown.
    This is an assignment constraint, not a runtime result or a new SQL type.
    """
    contract = table.get('_column_contract') if table else None
    if not contract or name not in contract or '_view_base' in table:
        raise ReviewNeeded('nullability_unknown','No ordinary target nullability evidence')
    validate_literal(contract[name], 'NULL')
    table['_explicit_nulls_checked'] = True


def integer_literal_in_range(column, value):
    """Signed ranges from PDF 1.3.1; callers establish integer literal syntax.

    Normalize leading zeros before bounded conversion, so long inputs cannot
    exceed Python's integer-string limit. No assignment/coercion behavior proof.
    """
    bits = {'SMALLINT': 16, 'INT2': 16, 'INTEGER': 32, 'INT': 32,
            'INT4': 32, 'BIGINT': 64, 'INT8': 64}.get(column['type'])
    digits = value.lstrip('+-').lstrip('0') or '0'
    if bits is None or len(digits) > 20:
        return False
    number = int(('-' if value.startswith('-') else '') + digits)
    return -(2**(bits-1)) <= number < 2**(bits-1)


def check_assignment_integer_literal(table, name, value):
    """Add proof only for a literal and complete ordinary target-column DDL."""
    column = (table.get('_column_contract') or {}).get(name)
    value = value.strip()
    if not column or column['family'] != 'integer' or not re.fullmatch(r'[+-]?[0-9]+', value):
        return
    if not integer_literal_in_range(column, value):
        raise ReviewNeeded('assignment_range_unknown',
                           f"{column['origin']}: literal outside declared signed {column['type']} range; "
                           'assignment behavior requires environment review')
    table['_integer_literals_checked'] = True


def validate_exact_decimal_literal(column, value):
    """Prove only exact (p,s) representation; never emulate database rounding.

    PDF 1.3.1 defines p/s and documents environment-sensitive overflow/rounding.
    String normalization avoids binary floats and unbounded integer conversion.
    """
    if not re.fullmatch(EXACT_DECIMAL_LITERAL, value):
        raise ReviewNeeded('decimal_literal_unknown', str(column['origin']))
    integer, _, fraction = value.lstrip('+-').partition('.')
    if len(fraction.rstrip('0')) > column['scale']:
        raise ReviewNeeded('decimal_rounding_unknown',
                           f"{column['origin']}: literal needs scale reduction; rounding not evaluated")
    if len(integer.lstrip('0')) > column['precision'] - column['scale']:
        raise ReviewNeeded('decimal_range_unknown',
                           f"{column['origin']}: literal exceeds declared integer digits; "
                           'assignment behavior requires environment review')


def check_assignment_decimal_literal(table, name, value):
    column = (table.get('_column_contract') or {}).get(name)
    value = value.strip()
    if not column or 'precision' not in column or not re.fullmatch(EXACT_DECIMAL_LITERAL, value):
        return
    validate_exact_decimal_literal(column, value)
    table['_decimal_literals_checked'] = True


def validate_literal(column, value):
    if value.upper() == 'NULL':
        if not column['nullable']:
            raise Contradiction('null_not_allowed', f"{column['origin']}: NULL violates declared NOT NULL")
        return
    actual = expression_type(value, {})
    if actual != column['family'] and not (column['family'] == 'numeric' and actual == 'integer'):
        raise ReviewNeeded('conversion_unknown', f"{column['origin']}: default conversion not proved")
    if column['family'] == 'numeric':
        validate_exact_decimal_literal(column, value)
    if column['family'] == 'integer':
        if len(value) > 32 or not integer_literal_in_range(column, value):
            raise ReviewNeeded('default_range_unknown', str(column['origin']))
    if column['family'] == 'text':
        decoded = value[1:-1].replace("''", "'")
        limit = column['length']
        if not decoded.isascii() or (limit is not None and (limit < 1 or len(decoded) > limit)):
            raise ReviewNeeded('default_length_unknown', str(column['origin']))


def check_omitted_columns(table, names):
    if generated_write_columns(table).difference(names):
        raise ReviewNeeded('generated_default_unknown',
                           'Omitted generated columns need a generation expression/result contract')
    contract = table.get('_column_contract')
    if not contract:
        # Existing shape-only checks stay shape-only, never claim default proof.
        return False
    # Omission of an exposed view/derived column must use the same target
    # evidence as explicit DEFAULT. Resolving against its base first would
    # bypass default_literal's deliberate no-inheritance guard.
    if '_view_base' in table:
        for name in contract:
            if name not in names:
                default_literal(table, name)
    base = table.get('_view_base', table)
    used = {contract[n]['origin'][1] for n in names}
    for name in base['_column_contract']:
        if name not in used:
            default_literal(base, name)
    return True
