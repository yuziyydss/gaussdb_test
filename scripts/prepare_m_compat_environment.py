#!/usr/bin/env python3
"""Generate M bootstrap instructions/files only; no database dependency."""
import argparse
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from core.m_compat_environment import MEnvironment


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--database', default='m_factor_test')
    parser.add_argument('--management-database', default='postgres')
    parser.add_argument('--namespace', default='m_factor_run')
    parser.add_argument('--output-dir', type=Path, default=ROOT/'generated/m_compat_environment')
    args = parser.parse_args()
    env = MEnvironment(args.management_database, args.database, args.namespace)
    plan = env.plan()
    sources = [
        ('work/doc2spec/full_general_corpus/general/ddl/create_database.txt',
         '1.13.9.16', 'CREATEDB/autocommit; DBCOMPATIBILITY M; template restrictions; reconnect'),
        ('work/m_compat_batch_02/corpus/m_compat/ddl/create_database.txt',
         '2.4.2.8.7', 'M CREATE DATABASE means schema, not physical database'),
        ('work/m_compat_batch_02/corpus/m_compat/utility/use.txt',
         '2.4.2.18.2', 'USE can fail silently; verify database()'),
        ('work/pdf_tiered_2026_09_07/batch_32/corpus/general/utility/section_5_3.txt',
         '5.3', 'gsql ON_ERROR_STOP'),
    ]
    plan['source_evidence'] = [dict(path=path, section=section, meaning=meaning,
        sha256=hashlib.sha256((ROOT/path).read_bytes()).hexdigest()) for path,section,meaning in sources]
    plan['parent_pdf_sha256'] = hashlib.sha256((ROOT/'gaussdb-rf-cent.pdf').read_bytes()).hexdigest()
    files = env.files()
    plan['files_sha256'] = {name:hashlib.sha256(sql.encode()).hexdigest() for name,sql in files.items()}
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for name, sql in files.items():
        (args.output_dir/name).write_text(sql, encoding='utf-8')
    (args.output_dir/'plan.json').write_text(json.dumps(plan,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'output':str(args.output_dir),'files':len(files),'database_executed':False}))


if __name__ == '__main__':
    main()
