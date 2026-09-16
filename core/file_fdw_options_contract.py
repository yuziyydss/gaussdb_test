"""Finite general file_fdw input contract, not a remote validator or file reader.

CREATE FOREIGN TABLE L52-87 delegates these options to COPY; reviewed COPY
L231-247, L346-388, L428-487 and L499-527. Binary/fixed remain unreviewed.
"""
import re


def parse_options(text):
    result = {}
    token = re.compile(r"\s*([a-z_][a-z0-9_]*)\s+'((?:[^']|'')*)'\s*(,|$)", re.I | re.A)
    pos = 0
    while pos < len(text):
        match = token.match(text, pos)
        if not match:
            raise ValueError('file_fdw: malformed option list')
        key, value, comma = match.groups(); key = key.lower()
        if key in result:
            raise ValueError('file_fdw: duplicate option '+key)
        result[key] = value.replace("''", "'")
        pos = match.end()
        if comma and not text[pos:].strip():
            raise ValueError('file_fdw: trailing comma')
    if not result:
        raise ValueError('file_fdw: empty options')
    return result


def check_options(wrapper, text):
    if wrapper != 'file_fdw':
        raise ValueError('file_fdw: wrapper mismatch')
    options = parse_options(text)
    allowed = {'filename','format','header','delimiter','quote','escape','null','encoding'}
    if set(options)-allowed:
        raise ValueError('file_fdw: unknown or wrong-scope option')
    path = options.get('filename', '')
    if not re.fullmatch(r'/tmp/factor_assets/[a-zA-Z0-9_./-]+', path) or '..' in path.split('/'):
        raise ValueError('file_fdw: scoped absolute filename required')
    fmt = options.get('format', '').lower()
    if fmt not in ('text','csv','binary','fixed'):
        raise ValueError('file_fdw: explicit format required')
    if fmt in ('binary','fixed') and set(options)&{'delimiter','null'}:
        raise ValueError('file_fdw: incompatible format and delimiter/null')
    if 'header' in options and fmt not in ('csv','fixed'):
        raise ValueError('file_fdw: HEADER requires CSV/FIXED')
    if {'quote','escape'} & set(options) and fmt != 'csv':
        raise ValueError('file_fdw: QUOTE/ESCAPE require CSV')
    if fmt in ('binary','fixed'):
        raise ValueError('file_fdw: binary bytes / fixed formatter unreviewed')
    if 'header' in options and options['header'].lower() not in ('true','false'):
        raise ValueError('file_fdw: finite boolean spelling required')
    delimiter = options.get('delimiter', ',' if fmt=='csv' else '\t')
    if not delimiter or len(delimiter.encode())>10 or any(c in delimiter for c in '\0\r\n'):
        raise ValueError('file_fdw: invalid delimiter')
    if fmt=='text' and any(c in delimiter for c in '\\.abcdefghijklmnopqrstuvwxyz0123456789'):
        raise ValueError('file_fdw: text delimiter character restriction')
    for key in ('quote','escape'):
        if fmt!='csv': break
        value = options.get(key, '"')
        if len(value.encode())!=1 or any(c in value for c in '\0\r\n') or value in delimiter or delimiter in value:
            raise ValueError('file_fdw: invalid or colliding '+key)
    null = options.get('null', '' if fmt=='csv' else '\\N')
    if len(null)>100 or any(c in null for c in '\0\r\n'):
        raise ValueError('file_fdw: invalid NULL marker')
    if null and (null in delimiter or delimiter in null or
                 (fmt=='csv' and any(null in options.get(k,'"') or options.get(k,'"') in null for k in ('quote','escape')))):
        raise ValueError('file_fdw: overlapping NULL marker')
    return dict(options, format=fmt)


def parse_create(sql):
    match = re.fullmatch(
        r'\s*CREATE\s+FOREIGN\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?'
        r'(g_cft_file_ns\.rows)\s*\(\s*id\s+INTEGER\s*,\s*qty\s+INTEGER\s*\)'
        r'\s+SERVER\s+(g_cft_file_server)\s+OPTIONS\s*\((.*)\)\s*;?\s*', sql, re.I|re.A|re.S)
    if not match:
        raise ValueError('file_fdw: finite two-integer target shape required')
    return match[1].lower(), match[2].lower(), check_options('file_fdw', match[3])


def check_file_fdw(sql, setup, teardown, gates, assets, selected_format):
    required = {'documented_fdw_available':['file_fdw'], 'database_scope':['non_pdb'],
                'compatibility_mode':['PG'], 'server_file_access':['deployed_hash_verified_and_allowlisted']}
    if any(gates.get(k)!=v for k,v in required.items()):
        raise ValueError('file_fdw: explicit wrapper/mode/file gates required')
    table, server, options = parse_create(sql)
    if options['format'] != selected_format:
        raise ValueError('file_fdw: selected format differs from rendered OPTIONS')
    def normalized(statements):
        return [re.sub(r'\s+', ' ', s.strip().rstrip(';')).lower() for s in statements]
    if normalized(setup) != [f'create server {server} foreign data wrapper file_fdw', 'create schema g_cft_file_ns']:
        raise ValueError('file_fdw: real fresh server/schema setup required')
    if normalized(teardown) != [f'drop foreign table {table} restrict', 'drop schema g_cft_file_ns restrict', f'drop server {server} restrict']:
        raise ValueError('file_fdw: reverse ownership-scoped cleanup required')
    fmt = options['format']; asset_format = 'integer_csv' if fmt=='csv' else 'integer_tsv'
    if (len(assets)!=1 or assets[0]['target_path']!=options['filename']
            or assets[0]['format']!=asset_format or assets[0]['column_count']!=2
            or assets[0].get('deployed') is not False):
        raise ValueError('file_fdw: exact undeployed input asset required')
    # Local asset parser proves only unquoted two-column integer rows, no header.
    expected = {'header':'false','delimiter':',' if fmt=='csv' else '\t',
                'quote':'"','escape':'"','null':'' if fmt=='csv' else '\\N','encoding':'UTF8'}
    if any(options[k].lower()!=v.lower() for k,v in expected.items() if k in options):
        raise ValueError('file_fdw: options differ from finite file layout')
    return {'status':'checked', 'scope':'finite_file_options_and_local_bytes',
            'format':fmt, 'runtime_proven':False, 'deployed':False,
            'validator_proven':False, 'cleanup_ownership_proven':False}
