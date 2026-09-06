"""Independent finite DELETE columns; never an execution/row-count Oracle."""
import re

from .finite_sql_contract import (
    IDENT, NAME, Contradiction, ReviewNeeded, column_name, ddl_tables,
    expression_type, finite_ctes, get_table, get_write_table, split_clause, split_list,
    take_group, top_mask,
)
from .shared_column_contract import QUERY_KEYWORDS, attach_shared_contracts, finite_derived_target


CLAUSES = 'USING|WHERE|ORDER|LIMIT|RETURNING|PARTITION|SUBPARTITION|FROM'
RESERVED = QUERY_KEYWORDS | set(CLAUSES.split('|')) | {'ONLY', 'DELETE', 'SELECT', 'AS'}
LITERAL = r"(?:[+-]?\d+(?:\.\d+)?|'(?:[^']|'')*'|TRUE|FALSE)"
LIMITS = [
    'Checks only listed finite target/predicate/order/limit/returning shapes, not full SQL correctness.',
    'Single direct-column ordering and positive int32 LIMIT are checker bounds, not product limits or deleted-row Oracles.',
    'Single ordinary USING checks relation/target-column scope, not joins, match counts or visibility.',
    'No row-count, inheritance set, permissions, triggers, visibility, or database execution proof.',
    'Existing CTE evidence retains its original scope; ordinary SELECT predicates/cardinality are not verified.',
    'DELETE without WHERE may delete every row; a shape check is not execution authorization.',
]


def finite_using_source(using, tables, target, target_name, qualifier):
    """Consume the whole single-source clause; do not borrow UPDATE self-FROM rules."""
    match = re.fullmatch(rf'USING\s+({NAME})(?:\s+(?:AS\s+)?({IDENT}))?', using, re.I)
    if not match or (match[2] or '').upper() in RESERVED:
        raise ReviewNeeded('using_unknown', 'Needs one ordinary USING relation with a finite alias')
    source = get_table(tables, match[1])
    if (not source.get('_column_contract') or not source['ddl']
            or '_view_base' in source or '_view_base' in target):
        raise ReviewNeeded('using_unknown', 'USING proof currently requires two ordinary base relations')
    source_name = match[1].lower()
    target_name = target_name.lower()
    same_basename = source_name.split('.')[-1] == target_name.split('.')[-1]
    if source is target or (same_basename and ('.' not in source_name or '.' not in target_name)):
        raise ReviewNeeded('using_unknown', 'Repeated or namespace-ambiguous target needs a separate environment contract')
    binding = (match[2] or source_name.split('.')[-1]).lower()
    if binding == qualifier or binding.upper() in RESERVED:
        raise ReviewNeeded('using_unknown', 'USING alias conflicts with target or a clause keyword')
    return source


def inspect_delete(sql, setup_sqls):
    result = {'status': 'needs_review', 'scope': 'finite_delete_shape_only',
              'checks': [], 'issues': [], 'limits': LIMITS}
    try:
        sql = sql.strip().removesuffix(';').strip()
        if ';' in top_mask(sql) or '--' in sql or '/*' in sql or '"' in sql:
            raise ReviewNeeded('syntax_unknown', 'Multiple statements/comments/quoted identifiers unsupported')
        tables = attach_shared_contracts(ddl_tables(setup_sqls), setup_sqls)
        body, tables, cte_checks = finite_ctes(sql, tables, setup_sqls)
        prefix = re.match(r'^DELETE\s+(?:FROM\s+)?(?:(ONLY)\s+)?', body, re.I)
        if not prefix:
            raise ReviewNeeded('statement_not_supported', 'Expected finite single-target DELETE')
        only = bool(prefix[1])
        target_sql = body[prefix.end():].strip()
        derived = target_sql.startswith('(')
        if derived:
            query, tail = take_group(target_sql)
            table = finite_derived_target(query, tables)
            default_alias = None
        else:
            target = re.match(rf'^({NAME})\b', target_sql)
            if not target:
                raise ReviewNeeded('target_unknown', 'Expected one direct table or derived target')
            table = get_write_table(tables, target[1])
            default_alias = target[1].split('.')[-1].lower()
            tail = target_sql[target.end():].strip()
        if not table.get('_column_contract'):
            raise ReviewNeeded('fixture_unknown', 'No complete ordinary target-column evidence')
        star = tail.startswith('*')
        if star:
            tail = tail[1:].strip()
        if (only or star) and '_view_base' in table:
            raise ReviewNeeded('target_unknown', 'ONLY/star on view or derived target is outside finite scope')
        alias_text, clauses = split_clause(tail, CLAUSES)
        alias = re.fullmatch(rf'(?:AS\s+)?({IDENT})', alias_text, re.I) if alias_text else None
        if alias_text and (not alias or alias[1].upper() in RESERVED):
            raise ReviewNeeded('target_unknown', 'Incomplete alias, multiple targets, or unknown target tail')
        qualifier = alias[1].lower() if alias else default_alias
        using, rest = split_clause(clauses, 'WHERE|ORDER|LIMIT|RETURNING')
        source = finite_using_source(using, tables, table, target[1] if not derived else '', qualifier) if using else None
        condition, rest = split_clause(rest, 'ORDER|LIMIT|RETURNING')
        ordering, rest = split_clause(rest, 'LIMIT|RETURNING')
        limiting, returning = split_clause(rest, 'RETURNING')
        checks = [*cte_checks, 'delete_single_target_columns']
        if source is not None:
            checks.append('delete_using_single_ordinary_source')

        def target_column(expression):
            if source is not None and '.' not in expression and expression.lower() in source['columns']:
                raise ReviewNeeded('using_scope_unknown', 'Unqualified target/source column resolution is not proved: '+expression)
            return column_name(expression, table['columns'], qualifier)

        if only or star:
            checks.append('delete_target_modifiers_syntax_only')
        if condition:
            match = re.fullmatch(rf'WHERE\s+({NAME})\s*=\s*({LITERAL})', condition, re.I | re.S)
            if not match:
                raise ReviewNeeded('predicate_or_clause_unknown', 'Needs absent WHERE or direct column/literal equality in clause order')
            column = target_column(match[1])
            if expression_type(match[2], {}) != table['columns'][column]:
                raise ReviewNeeded('conversion_unknown', 'DELETE equality types are not identical')
            checks.append('delete_finite_equality_predicate')
        else:
            checks.append('delete_no_predicate')
        if ordering:
            match = re.fullmatch(rf'ORDER\s+BY\s+({NAME})(?:\s+(?:ASC|DESC))?', ordering, re.I)
            if not match:
                raise ReviewNeeded('order_unknown', 'Needs one direct target column with optional ASC/DESC')
            target_column(match[1])
            checks.append('delete_order_target_column')
        if limiting:
            match = re.fullmatch(r'LIMIT\s+([0-9]{1,10})', limiting, re.I)
            if not match or not 1 <= int(match[1]) <= 2147483647:
                raise ReviewNeeded('limit_unknown', 'Outside finite positive int32 literal LIMIT checker domain')
            checks.append('delete_limit_literal_shape')
        if returning:
            output = returning[len('RETURNING'):].strip()
            expressions = list(table['columns']) if output == '*' else split_list(output)
            labels = set()
            for expression in expressions:
                match = re.fullmatch(rf'({NAME})(?:\s+AS\s+({IDENT}))?', expression, re.I)
                if not match:
                    raise ReviewNeeded('returning_unknown', 'RETURNING needs direct target columns')
                column = target_column(match[1])
                label = (match[2] or column).lower()
                if label in labels or label.upper() in RESERVED:
                    raise ReviewNeeded('returning_unknown', 'Ambiguous or non-finite RETURNING label')
                labels.add(label)
            checks.append('delete_returning_columns')
        if derived:
            checks.append('single_base_direct_derived_target_columns')
        elif '_view_base' in table:
            checks.append('single_base_direct_view_columns')
        result.update(status='checked', checks=checks)
    except ReviewNeeded as exc:
        result['status'] = 'rejected' if isinstance(exc, Contradiction) else 'needs_review'
        result['issues'].append({'code': exc.code, 'detail': exc.detail})
    return result
