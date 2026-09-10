"""Finite RANGE key/selector shape; deliberately not tuple routing or runtime."""
import re
from .finite_sql_contract import (
    IDENT, NAME, ReviewNeeded, Contradiction, ddl_tables, get_table,
    take_group, split_list, top_mask,
)


def _integer(value):
    if not isinstance(value,str) or not re.fullmatch(r'[+-]?[0-9]{1,10}',value.strip()):
        raise ReviewNeeded('partition_value_unknown','Only finite INTEGER literals are checked')
    number=int(value)
    if not -(2**31)<=number<2**31:
        raise ReviewNeeded('partition_value_unknown','INTEGER range not established')
    return number


def check_rendered_partition_selector(sql,setup,*,profile_target,keys,values):
    """Compare actual SQL, declared profile and actual DDL for 1–2 INT keys.

    Bound tuple width/types are checked but tuple ordering/routing, seed state,
    global indexes, permissions and execution remain unproved. Nothing here
    changes the older single-key INSERT/MERGE routing contract.
    """
    if (not isinstance(keys,list) or not 1<=len(keys)<=2 or
            any(not isinstance(k,str) or not re.fullmatch(IDENT,k) for k in keys) or
            len({k.lower() for k in keys})!=len(keys) or not isinstance(values,list)):
        raise ReviewNeeded('partition_profile_unknown','Expected one or two distinct bare key names and value list')
    statement=sql.strip().removesuffix(';').strip()
    if '--' in statement or '/*' in statement or ';' in top_mask(statement):
        raise ReviewNeeded('partition_sql_unknown','Expected one uncommented statement')
    match=re.fullmatch(rf'ALTER\s+TABLE\s+({NAME})\s+TRUNCATE\s+PARTITION\s+FOR\s*\(([^()]*)\)',
                       statement,re.I|re.ASCII)
    if not match or not re.fullmatch(NAME,profile_target):
        raise ReviewNeeded('partition_sql_unknown','Only a direct table and FOR value list are checked')
    if match[1].lower()!=profile_target.lower():
        raise Contradiction('partition_target_mismatch',match[1])
    selected=[_integer(v) for v in split_list(match[2])]
    declared=[_integer(v) for v in values]
    if selected!=declared:
        raise Contradiction('partition_values_mismatch','Rendered selector differs from profile values')
    # Only explicit fresh fixture DDL/seed history; no session or opaque effects.
    integer_or_null=r'(?:[+-]?[0-9]{1,10}|NULL)'
    row=rf'\(\s*{integer_or_null}(?:\s*,\s*{integer_or_null})*\s*\)'
    seed=rf'INSERT\s+INTO\s+{re.escape(profile_target)}(?:\s*\(\s*{IDENT}(?:\s*,\s*{IDENT})*\s*\))?\s+VALUES\s*{row}(?:\s*,\s*{row})*'
    for item in setup:
        text=item.strip().removesuffix(';').strip()
        finite_setup=(re.fullmatch(rf'CREATE\s+SCHEMA\s+{NAME}',text,re.I|re.ASCII) or
            re.match(rf'CREATE\s+TABLE\s+{re.escape(profile_target)}\s*\(',text,re.I|re.ASCII) or
            re.fullmatch(seed,text,re.I|re.ASCII))
        if '--' in text or '/*' in text or ';' in top_mask(text) or not finite_setup:
            raise ReviewNeeded('partition_fixture_unknown','Only fresh schema/table and direct INSERT setup is admitted')
    table=get_table(ddl_tables(setup),profile_target)
    ddl=table['ddl'].strip().removesuffix(';').strip()
    head=re.match(rf'CREATE\s+TABLE\s+{NAME}\s*(\()',ddl,re.I|re.ASCII)
    if not head:
        raise ReviewNeeded('partition_ddl_unknown','Expected ordinary permanent table')
    body,suffix=take_group(ddl[head.end()-1:]);columns={}
    for item in split_list(body):
        column=re.fullmatch(rf'({IDENT})\s+(INTEGER|INT|INT4)',item,re.I|re.ASCII)
        if not column or column[1].lower() in columns:
            raise ReviewNeeded('partition_column_unknown','Only unadorned distinct INTEGER columns are checked')
        columns[column[1].lower()]='INTEGER'
    header=re.match(rf'PARTITION\s+BY\s+RANGE\s*\(([^()]*)\)\s*',suffix,re.I|re.ASCII)
    if not header:
        raise ReviewNeeded('partition_ddl_unknown','Expected VALUES LESS THAN RANGE header')
    actual_keys=[k.lower() for k in split_list(header[1])]
    if actual_keys!=[k.lower() for k in keys] or any(k not in columns for k in actual_keys):
        raise Contradiction('partition_keys_mismatch','Actual key order/names differ from profile or columns')
    if len(selected)!=len(actual_keys):
        raise Contradiction('partition_key_arity','Selector width differs from actual key count')
    definitions,tail=take_group(suffix[header.end():])
    if tail:
        raise ReviewNeeded('partition_ddl_unknown','Unconsumed RANGE suffix')
    names=set();max_seen=False
    for item in split_list(definitions):
        bound=re.fullmatch(rf'PARTITION\s+({IDENT})\s+VALUES\s+LESS\s+THAN\s*\(([^()]*)\)',item,re.I|re.ASCII)
        if not bound or bound[1].lower() in names or max_seen:
            raise ReviewNeeded('partition_bound_unknown','Unsupported/duplicate partition or bound after MAXVALUE')
        names.add(bound[1].lower());parts=split_list(bound[2])
        if len(parts)!=len(actual_keys):
            raise Contradiction('partition_bound_arity','Bound width differs from key count')
        is_max=[v.upper()=='MAXVALUE' for v in parts]
        if any(is_max):
            if not all(is_max):
                raise ReviewNeeded('partition_bound_unknown','Mixed MAXVALUE tuples need separate review')
            max_seen=True
        else:
            for value in parts:_integer(value)
    return dict(partition_keys=actual_keys,key_types=[columns[k] for k in actual_keys],
                selector_values=selected,source_table=profile_target.lower(),
                routing_proven=False,bounds_order_proven=False,runtime_proven=False)
