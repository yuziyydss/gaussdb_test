"""Mode-specific finite common-type evidence from PDF 1.9.4/1.9.5.

Only simple UNION [ALL], one-WHEN CASE, direct columns and small literals.
No generic cast table, typmod conversion, preferred-type guessing or M reuse.
"""
import re

from .finite_sql_contract import IDENT, NAME, Contradiction, ReviewNeeded, split_clause, split_list, top_mask
from .query_output_contract import finite_query_source_columns

FLAGS = re.I | re.A | re.S
ALIASES = {'INT':'INTEGER', 'INT4':'INTEGER', 'INT2':'SMALLINT', 'INT8':'BIGINT', 'BOOL':'BOOLEAN'}
CATEGORIES = {'SMALLINT':'number', 'INTEGER':'number', 'BIGINT':'number', 'TEXT':'string', 'BOOLEAN':'boolean'}
PG_CONTRACT = 'pg_scalar_union_case_v1'
A_CONTRACT = 'a_integer_union_case_v1'
CONTRACT_MODES = {PG_CONTRACT: 'PG', A_CONTRACT: 'A'}
# Table 1-309, explicitly A compatibility; only reviewed int2/int4/int8 cells.
A_INTEGER_RESULTS = {
    ('SMALLINT', 'SMALLINT'): 'SMALLINT', ('SMALLINT', 'INTEGER'): 'INTEGER',
    ('SMALLINT', 'BIGINT'): 'BIGINT', ('INTEGER', 'SMALLINT'): 'INTEGER',
    ('INTEGER', 'INTEGER'): 'INTEGER', ('INTEGER', 'BIGINT'): 'BIGINT',
    ('BIGINT', 'SMALLINT'): 'BIGINT', ('BIGINT', 'INTEGER'): 'BIGINT',
    ('BIGINT', 'BIGINT'): 'BIGINT',
}


def _type(value):
    if not isinstance(value,str) or not value.isascii():
        raise ReviewNeeded('common_type_declaration_unknown', str(value))
    typ=ALIASES.get(value.upper(),value.upper())
    if typ not in CATEGORIES:
        raise ReviewNeeded('common_type_declaration_unknown',value)
    return typ


def _atom(text, columns):
    text=text.strip()
    if text.upper()=='NULL': return (None,'null')
    if re.fullmatch(r"'(?:[^']|'')*'",text): return (None,'string')
    if text.upper() in ('TRUE','FALSE'): return ('BOOLEAN',None)
    if re.fullmatch(r'[+-]?[0-9]+',text):
        if len(text)>12 or not -(2**31)<=int(text)<2**31:
            raise ReviewNeeded('common_type_literal_unknown',text)
        return ('INTEGER',None)
    if re.fullmatch(IDENT,text,re.A):
        column=columns.get(text.lower())
        if column is None: raise Contradiction('common_type_missing_column',text)
        return (_type(column['type']),None)
    raise ReviewNeeded('common_type_expression_unknown',text)


def _common(inputs):
    types={typ for typ,_ in inputs if typ is not None}
    if not types: return ('TEXT',None)
    if len({CATEGORIES[t] for t in types})>1:
        raise Contradiction('common_type_category','Known inputs belong to different categories')
    if len(types)>1:
        raise ReviewNeeded('common_type_preference_unknown','Mixed exact types require separate conversion evidence')
    chosen=next(iter(types))
    if chosen!='TEXT' and any(kind=='string' for _,kind in inputs):
        raise ReviewNeeded('unknown_input_conversion','Unknown text content has not been converted to '+chosen)
    return (chosen,None)


def _a_integer_common(inputs):
    pair = tuple(typ for typ, _ in inputs)
    if pair not in A_INTEGER_RESULTS:
        raise ReviewNeeded('a_integer_input_unknown', 'Only two known int2/int4/int8 inputs are reviewed')
    return (A_INTEGER_RESULTS[pair], None)


def _expression(text, columns, resolve):
    text=re.sub(rf'\s+AS\s+{IDENT}$','',text.strip(),flags=FLAGS)
    case=re.fullmatch(r'CASE\s+WHEN\s+(.+?)\s+THEN\s+(.+?)\s+ELSE\s+(.+?)\s+END',text,FLAGS)
    if case:
        if _atom(case[1],columns)[0]!='BOOLEAN':
            raise ReviewNeeded('common_type_predicate_unknown',case[1])
        # ELSE first, as documented; never skip an unreachable THEN branch.
        return resolve([_atom(case[3],columns),_atom(case[2],columns)])
    return _atom(text,columns)


def _branch(query, setup, resolve):
    if not re.match(r'^SELECT\s+',query,FLAGS):
        raise ReviewNeeded('common_type_query_unknown',query)
    projection,tail=split_clause(query[7:],'FROM')
    columns={}
    if tail:
        actual=finite_query_source_columns(query,setup)
        columns=actual['columns']
    return [_expression(item,columns,resolve) for item in split_list(projection)]


def infer_query_types(sql, setup, *, mode, contract=PG_CONTRACT):
    if contract not in CONTRACT_MODES or mode != CONTRACT_MODES[contract]:
        raise ReviewNeeded('common_type_mode_unknown','Contract identity requires its explicit physical mode')
    resolve = _a_integer_common if contract == A_CONTRACT else _common
    sql=sql.strip().removesuffix(';').strip()
    if not sql.isascii() or '--' in sql or '/*' in sql or ';' in top_mask(sql):
        raise ReviewNeeded('common_type_query_unknown','Expected a single finite uncommented query')
    left,tail=split_clause(sql,'UNION')
    result=_branch(left,setup,resolve)
    branch_count=1
    while tail:
        branch_count+=1
        if branch_count>4: raise ReviewNeeded('common_type_depth_unknown','At most four left-associated branches')
        remainder=re.sub(r'^UNION\s+(?:ALL\s+)?','',tail,flags=FLAGS)
        right,tail=split_clause(remainder,'UNION')
        types=_branch(right,setup,resolve)
        if len(result)!=len(types):
            raise Contradiction('common_type_arity','UNION branches must have the same output width')
        result=[resolve([a,b]) for a,b in zip(result,types)]
    if any(typ is None for typ,_ in result):
        raise ReviewNeeded('common_type_output_unknown','Bare unknown output without CASE/UNION is not this contract')
    if contract == A_CONTRACT and any(typ not in ('SMALLINT','INTEGER','BIGINT') for typ,_ in result):
        raise ReviewNeeded('a_integer_input_unknown','Only known integer outputs are reviewed')
    return [typ for typ,_ in result]


def check_common_type_query(sql, setup, *, mode, output_types, contract=PG_CONTRACT):
    statement=sql.strip().removesuffix(';').strip()
    insert=re.fullmatch(rf'INSERT\s+INTO\s+({NAME})\s*\(([^()]+)\)\s+(SELECT\s+.+)',statement,FLAGS)
    query=insert[3] if insert else statement
    actual=infer_query_types(query,setup,mode=mode,contract=contract)
    if not isinstance(output_types,list) or actual!=[_type(t) for t in output_types]:
        raise Contradiction('common_type_output_mismatch','Declared output types differ from rendered SQL/actual source')
    if insert:
        source=finite_query_source_columns('SELECT * FROM '+insert[1],setup)
        names=[n.strip().lower() for n in split_list(insert[2])]
        if len(names)!=len(set(names)) or len(names)!=len(actual):
            raise Contradiction('common_type_arity','INSERT targets must be unique and match output width')
        for name,typ in zip(names,actual):
            if name not in source['columns']:
                raise Contradiction('common_type_missing_column',name)
            if _type(source['columns'][name]['type'])!=typ:
                raise ReviewNeeded('assignment_conversion_unknown','Only exact source/target types have been reviewed')
    return {'output_types':actual,'exact_assignment_types':bool(insert),'runtime_proven':False,
            'limits':['No predicate/result evaluation, row count, nullability or constraints are proved.',
                      'No typmod, generic implicit casts, other modes or unreviewed mixed-type interpretation.']}
