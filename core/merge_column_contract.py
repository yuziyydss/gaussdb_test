"""General MERGE: finite columns/actions, never row execution.

Source: full_general_corpus/general/dml/merge_into.txt L56-89, and PDF
1.6.1/1.6.2 boolean/comparison operators. Direct VIEW sources reuse ordered
DDL lineage; direct subqueries share projection columns, not target identity.
Explicit single-integer RANGE selectors permit non-key UPDATE (general
MERGE L16,32-34,48-52; CREATE TABLE PARTITION L485-507,526-539).
Partition INSERT accepts only direct keys from a complete literal seed image
whose every key falls in the selected range: a sufficient condition, never a
JOIN/WHERE evaluator or necessary-error criterion. Writable views, other
partition INSERT routing, CTEs and complex expressions
stay review. A single source-side integer > literal in
ON or an action WHERE supplies type/column evidence, not matching/action rows.
"""
import hashlib
import re

from .finite_sql_contract import (
    IDENT, NAME, SET_INPUT_LITERAL, Contradiction, ReviewNeeded, check_types,
    column_name, get_write_table, split_clause, split_list, take_group, top_mask,
    finite_range_partition_selector, finite_range_partition_definition, partition_integer, range_partition_for,
)
from .shared_column_contract import (
    QUERY_KEYWORDS, check_omitted_columns, validate_literal, integer_literal_in_range,
    finite_query_source, ordinary_columns, closed_literal_source_rows,
)


def review(detail):
    raise ReviewNeeded('merge_shape_unknown', detail)


def source_integer_filter(predicate, source, alias):
    """Shared finite predicate identity, not truth, coercion or row inference."""
    match = re.fullmatch(rf'({IDENT}\.{IDENT})\s*>\s*([+-]?[0-9]+)', predicate, re.I)
    if not match:
        review('MERGE filter needs one qualified source integer > literal')
    if match[1].lower().split('.')[-1] not in source['columns']:
        # An absent user-column declaration does not disprove system-column
        # existence. Do not manufacture a missing-column target Oracle.
        review('MERGE filter column has no declared ordinary-column identity')
    filtered = column_name(match[1], source['columns'], alias)
    contract = source['_column_contract'][filtered]
    if contract['family'] != 'integer':
        review('MERGE filter requires an actual signed integer source column')
    if len(match[2]) > 32 or not integer_literal_in_range(contract, match[2]):
        review('MERGE filter literal conversion/range is not proved')
    # Nullable operands remain legal typed expressions. No TRUE/FALSE/NULL
    # result, null elimination, matching, or affected-row count is inferred.


def target_names(raw, table):
    names = split_list(raw)
    if not names or not all(re.fullmatch(IDENT, name) for name in names):
        review('MERGE target list needs bare ordinary column names')
    names = [column_name(name, table['columns']) for name in names]
    if len(names) != len(set(names)):
        review('Repeated assignment/insert columns need separate semantics')
    return names


def partition_target(table, selector):
    """Fully parse the RANGE suffix before reusing ordinary column declarations.

    Original DDL hashes/identity survive. This selector helper alone proves
    neither seed routing nor row movement nor a reusable ordinary-table identity.
    """
    prefix, _ = split_clause(table['ddl'].strip().removesuffix(';'), 'PARTITION')
    columns = ordinary_columns(prefix)
    if not columns:
        review('Partition column declarations require a full finite contract')
    # DDL/type evidence precedes missing-name/out-of-range contradictions:
    # an invalid setup cannot establish the intended target error.
    key, bounds = finite_range_partition_definition(table)
    if key not in columns or any(upper is not None and not integer_literal_in_range(columns[key], str(upper))
                                 for _, upper in bounds):
        review('Partition bounds must fit the actual integer key domain')
    for_selector = re.match(r'^PARTITION\s+FOR\s*', selector, re.I)
    if for_selector:
        value, _ = take_group(selector[for_selector.end():])
        if not integer_literal_in_range(columns[key], str(partition_integer(value))):
            review('Partition FOR value must fit the actual integer key domain')
    remaining, contract = finite_range_partition_selector(selector, table)
    if contract is None:
        review('MERGE partition selector is not finite')
    ddl_hash = hashlib.sha256(table['ddl'].encode()).hexdigest()
    for col in columns.values():
        col['ddl_sha256'] = ddl_hash
    return {**table, '_column_contract': columns, '_merge_partition': contract}, remaining


def inputs(names, values, target, source, alias):
    if len(names) != len(values):
        raise Contradiction('arity', f'{len(names)} MERGE columns vs {len(values)} expressions')
    for name, value in zip(names, values):
        if re.fullmatch(SET_INPUT_LITERAL, value, re.I):
            # Shared helpers validate DEFAULT/NULL, integer/decimal bounds;
            # ordinary text literal width is checked separately below.
            if value.upper() not in ('NULL', 'DEFAULT'):
                contract = target['_column_contract'][name]
                if contract['family'] == 'text':
                    validate_literal(contract, value)
            continue
        ref = re.fullmatch(rf'{re.escape(alias)}\.({IDENT})', value, re.I)
        if not ref:
            review('MERGE RHS needs a literal, DEFAULT or a qualified source column')
        origin = column_name(value, source['columns'], alias)
        a, b = source['_column_contract'][origin], target['_column_contract'][name]
        # Family equality alone cannot prove VARCHAR widths or integer ranges.
        if any(a.get(k) != b.get(k) for k in ('type', 'length', 'precision', 'scale')):
            review('MERGE source/target physical column domains differ')
        if a['nullable'] and not b['nullable']:
            review('Nullable source may require a target NOT NULL predicate proof')
    check_types(names, values, target['columns'], source['columns'], alias,
                default_table=target, value_table=target)


def update_action(body, target, source, alias, join_key):
    match = re.match(r'^UPDATE\s+SET\s+', body, re.I)
    if not match:
        review('MATCHED action must be a finite UPDATE SET')
    body = body[match.end():]
    if re.search(r'\bWHERE\b', top_mask(body), re.I):
        review('Branch WHERE needs a predicate contract')
    assigned = set()
    for assignment in split_list(body):
        equals = [m.start() for m in re.finditer('=', top_mask(assignment))]
        if len(equals) != 1:
            review('MERGE assignment operator is not finite')
        lhs, rhs = (s.strip() for s in (assignment[:equals[0]], assignment[equals[0]+1:]))
        if lhs.startswith('('):
            raw, rest = take_group(lhs)
            if rest:
                review('Trailing target tuple syntax')
            names = target_names(raw, target)
            if not rhs.startswith('('):
                review('Tuple assignment requires a tuple of finite expressions')
            raw, rest = take_group(rhs)
            if rest:
                review('Trailing source tuple syntax')
            values = split_list(raw)
        else:
            names, values = target_names(lhs, target), [rhs]
        if assigned.intersection(names):
            review('Repeated MERGE target assignment')
        assigned.update(names)
        if join_key in names:
            raise Contradiction('merge_join_key_update_not_supported',
                                'General MERGE L63-64 forbids updating ON condition columns')
        if target.get('_merge_partition') and target['_merge_partition'][0] in names:
            raise ReviewNeeded('partition_movement', 'MERGE partition-key updates need row movement/routing evidence')
        inputs(names, values, target, source, alias)


def seeded_partition_inputs(names, values, target, source, alias, setup):
    """All source keys in-range suffice for any unmatched/filtered subset.

    Failure of this sufficient condition stays review: an out-of-range seed
    might not reach INSERT, so it is not automatically a target error Oracle.
    """
    key,bounds,selected = target['_merge_partition']
    if len(names) != len(values) or key not in names:
        raise ReviewNeeded('partition_routing_unknown', 'A complete explicit incoming partition key is required')
    value = values[names.index(key)]
    ref = re.fullmatch(rf'{re.escape(alias)}\.({IDENT})', value, re.I)
    if not ref or '_view_base' in source:
        raise ReviewNeeded('partition_routing_unknown', 'Only a direct ordinary-source key has this seed proof')
    origin = column_name(value,source['columns'],alias)
    column = source['_column_contract'][origin]
    base = source.get('_query_base',source)
    try:
        image = closed_literal_source_rows(base,setup,source_scope='general')
        if column['origin'][0] != image['table']:
            raise ReviewNeeded('source_rows_unknown','Projection origin differs from actual fresh source')
        for row in image['rows']:
            literal = row[column['origin'][1]]
            actual = range_partition_for(bounds,partition_integer(literal))
            if actual != selected:
                raise ReviewNeeded('source_rows_unknown','Not every source key belongs to the selected partition')
    except ReviewNeeded as error:
        raise ReviewNeeded('partition_routing_unknown',error.detail) from error
    target['_closed_seed_partition_checked'] = True


def insert_action(body, target, source, alias, setup=()):
    match = re.match(r'^INSERT\b\s*', body, re.I)
    if not match:
        review('NOT MATCHED action must be a finite INSERT')
    body = body[match.end():]
    if re.fullmatch(r'DEFAULT\s+VALUES', body, re.I):
        if target.get('_merge_partition'):
            raise ReviewNeeded('partition_routing_unknown','DEFAULT partition keys need a separate routing proof')
        names = list(target['columns'])
        inputs(names, ['DEFAULT']*len(names), target, source, alias)
        return
    names = list(target['columns'])
    if body.startswith('('):
        raw, body = take_group(body)
        names = target_names(raw, target)
    match = re.match(r'^VALUES\b\s*', body, re.I)
    if not match or not body[match.end():].startswith('('):
        review('MERGE INSERT needs one finite VALUES tuple')
    raw, rest = take_group(body[match.end():])
    if rest.startswith(','):
        # A dangling comma or arbitrary trailing token is not evidence of a
        # second VALUES row and must not masquerade as its target Oracle.
        tail = rest
        while tail.startswith(','):
            tail = tail[1:].strip()
            if not tail.startswith('('):
                review('Incomplete additional VALUES group')
            extra, tail = take_group(tail)
            if not extra.strip():
                review('Empty additional VALUES group')
        if tail:
            review('Unparsed text after additional VALUES group')
        raise Contradiction('merge_multiple_values_not_supported',
                            'General MERGE L77-78 forbids multiple INSERT VALUES groups')
    if rest:
        review('MERGE INSERT trailing predicates/syntax need a separate contract')
    values = split_list(raw)
    if target.get('_merge_partition'):
        seeded_partition_inputs(names,values,target,source,alias,setup)
    inputs(names, values, target, source, alias)
    if check_omitted_columns(target, names):
        target['_omissions_checked'] = True


def check_merge(sql, tables, *, source_scope, setup_sqls=()):
    if source_scope != 'general':
        review('General MERGE rules have not been proved for this mode/source')
    if any(token in sql for token in ('$', '`', '\\')):
        review('Unsupported MERGE quoting/escape syntax')
    match = re.match(rf'^MERGE\s+INTO\s+({NAME})\s+', sql, re.I)
    if not match:
        review('MERGE requires two named ordinary tables and distinct explicit aliases')
    target = get_write_table(tables, match[1])
    rest = sql[match.end():]
    if re.match(r'^PARTITION\b', rest, re.I):
        target, rest = partition_target(target, rest)
    target_match = re.match(rf'^(?:AS\s+)?({IDENT})\s+USING\s+', rest, re.I)
    if not target_match:
        review('MERGE requires two named ordinary tables and distinct explicit aliases')
    target_alias = target_match[1].lower()
    rest = rest[target_match.end():]
    query_source = rest.startswith('(')
    if query_source:
        query, rest = take_group(rest)
        source_match = re.match(rf'^(?:AS\s+)?({IDENT})\s+ON\b\s*', rest, re.I)
        if not source_match:
            review('MERGE query source requires an explicit alias and ON')
        source = finite_query_source(query, tables)
        source_alias = source_match[1].lower()
    else:
        source_match = re.match(rf'^({NAME})\s+(?:AS\s+)?({IDENT})\s+ON\b\s*', rest, re.I)
        if not source_match:
            review('MERGE requires two named ordinary tables and distinct explicit aliases')
        source = get_write_table(tables, source_match[1])
        source_alias = source_match[2].lower()
    rest = rest[source_match.end():]
    reserved = QUERY_KEYWORDS | {'ON', 'USING', 'WHEN', 'MATCHED', 'THEN', 'UPDATE', 'INSERT', 'SET'}
    if target_alias == source_alias or any(a.upper() in reserved for a in (target_alias, source_alias)):
        review('MERGE aliases are ambiguous or reserved')
    if not target.get('_column_contract') or '_view_base' in target:
        review('MERGE needs actual ordinary table DDL, not view/derived/partition metadata')
    if not source.get('_column_contract'):
        review('MERGE needs actual ordinary table DDL, not view/derived/partition metadata')
    view_source = '_view_base' in source
    if view_source:
        # Only attach_shared_contracts' ordered, direct named VIEW proof is a
        # read-source identity. A derived target or writable VIEW is not one.
        base = source['_view_base']
        if (source.get('_derived_target') or not base.get('_column_contract')
                or '_view_base' in base
                or source.get('_view_ddl_sha256') != hashlib.sha256(source['ddl'].encode()).hexdigest()):
            review('MERGE VIEW source lacks a closed, ordered direct-projection proof')
    if not rest.startswith('('):
        review('MERGE ON needs one parenthesized finite equality')
    condition, body = take_group(rest)
    equality = re.fullmatch(rf'({IDENT}\.{IDENT})\s*=\s*({IDENT}\.{IDENT})'
                            rf'(?:\s+AND\s+({IDENT}\.{IDENT}\s*>\s*[+-]?[0-9]+))?', condition, re.I)
    if not equality:
        review('MERGE ON expression/predicate needs a separate contract')
    left, right = equality[1].lower(), equality[2].lower()
    if left.startswith(source_alias+'.') and right.startswith(target_alias+'.'):
        left, right = right, left
    key = column_name(left, target['columns'], target_alias)
    other = column_name(right, source['columns'], source_alias)
    if target['columns'][key] != source['columns'][other]:
        review('MERGE ON comparison conversion is not proved')
    if equality[3]:
        # Restrict the extra predicate to the source. Permitting target-side
        # predicates would require protecting every target ON column against
        # UPDATE, not just the equality key (MERGE L63-64).
        source_integer_filter(equality[3], source, source_alias)
    if not body:
        raise Contradiction('merge_action_required', 'General MERGE L79-81 requires at least one action')
    mask = top_mask(body)
    if re.search(r'\b(?:CASE|END)\b', mask, re.I):
        review('CASE nesting cannot be confused with MERGE WHEN actions')
    actions = list(re.finditer(r'\bWHEN\s+(NOT\s+)?MATCHED\s+THEN\b', mask, re.I))
    if not actions or body[:actions[0].start()].strip():
        review('Unparsed MERGE action prefix')
    kinds = [bool(m[1]) for m in actions]
    if len(set(kinds)) != len(kinds):
        raise Contradiction('duplicate_merge_when_clause',
                            'General MERGE L79-81 permits at most one action of each kind')
    action_filter_present = False
    for i, action in enumerate(actions):
        end = actions[i+1].start() if i+1 < len(actions) else len(body)
        branch = body[action.end():end].strip()
        branch, where = split_clause(branch, 'WHERE')
        if where:
            source_integer_filter(where[len('WHERE'):].strip(), source, source_alias)
            action_filter_present = True
        if kinds[i]:
            insert_action(branch, target, source, source_alias,setup_sqls)
        else:
            update_action(branch, target, source, source_alias, key)
    identity = ('merge_direct_query_source_columns' if query_source else
                'merge_direct_view_source_columns' if view_source else
                'merge_ordinary_source_columns' if target.get('_merge_partition') else 'merge_ordinary_source_target_columns')
    checks = [identity, 'merge_simple_on_columns',
              'merge_action_cardinality_and_join_key', 'merge_input_arity_and_domains']
    if target.get('_merge_partition'):
        checks.append('merge_range_partition_target_columns')
        if not all(kinds):
            checks.append('merge_partition_key_unchanged')
        if target.get('_closed_seed_partition_checked'):
            checks.append('merge_closed_seed_partition_sufficiency')
    if equality[3]:
        checks.append('merge_source_integer_on_filter')
    if action_filter_present:
        checks.append('merge_source_integer_action_filter')
    for flag, label in (('_defaults_checked', 'shared_ordinary_defaults'),
                        ('_omissions_checked', 'shared_omitted_base_columns'),
                        ('_explicit_nulls_checked', 'shared_explicit_nullability'),
                        ('_integer_literals_checked', 'shared_integer_literal_ranges'),
                        ('_decimal_literals_checked', 'shared_exact_decimal_literals')):
        if target.get(flag):
            checks.append(label)
    return checks
