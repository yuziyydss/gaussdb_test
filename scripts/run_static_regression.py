#!/usr/bin/env python3
"""Run local unittest with endpoint input identity and an actual process receipt.

This is a static-test runner, not a database sandbox or an execution Oracle.
Keep the workspace frozen during a run. Endpoints cannot detect change/revert.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time


ROOT = Path(__file__).resolve().parents[1]
INPUT_DIRS = ('core', 'api', 'scripts', 'tests', 'web', 'specs', 'factors',
              'grammars', 'manifests', 'matrices', 'environments', 'fixtures',
              'work/doc2spec', 'intranet_corpus', 'generated/factor_packages', 'archive/spec_reviews',
              'docs/compat_facts', 'work/pdf_foundations_2026_09_07/corpus',
              'work/m_compat_batch_01/corpus', 'work/m_compat_batch_02/corpus',
              'work/m_compat_batch_03/corpus', 'work/m_compat_batch_04/corpus',
              'work/m_compat_batch_04_charset/corpus', 'work/m_compat_batch_04_dependencies/corpus',
              'work/m_compat_batch_05/corpus', 'work/m_compat_batch_06/corpus')
INPUT_FILES = ('main.py', 'requirements.txt', 'pyproject.toml', 'pytest.ini',
               'setup.cfg', 'gaussdb-rf-cent.pdf', 'generated/audit/pdf_catalog_coverage.json',
               'work/pdf_tiered_2026_09_07/batch_19/corpus/m_compat/utility/section_2_6.txt')
INPUT_SUFFIXES = {'.py', '.yaml', '.yml', '.json', '.txt', '.html', '.css', '.js', '.sql'}
LIMITS = [
    'Only the listed input paths/extensions, spec fixture assets and Python version are fingerprinted; installed libraries and secrets are not.',
    'Equal endpoints do not prove that files never changed and were restored during the run.',
    'GAUSSDB_ENABLED=false is a requested configuration, not network isolation; review test code for fake connections.',
    'A passing unittest receipt does not prove database execution, full SQL coverage, or package readiness.',
    'Skipped or expected-failure tests are retained as incomplete, not all-passed evidence.',
]


def digest(path):
    result = hashlib.sha256()
    with path.open('rb') as source:
        for chunk in iter(lambda: source.read(1024*1024), b''):
            result.update(chunk)
    return result.hexdigest()


def snapshot(root):
    paths = set()
    for name in INPUT_DIRS:
        directory = root/name
        if directory.is_symlink():
            raise ValueError('Input directory symlinks need separate identity review')
        for path in directory.rglob('*'):
            if '__pycache__' in path.parts:
                continue
            if path.is_symlink():
                raise ValueError('Input symlinks need separate identity review')
            fixture_asset = name == 'specs' and 'assets' in path.relative_to(directory).parts
            if path.is_file() and (path.suffix in INPUT_SUFFIXES or fixture_asset):
                paths.add(path)
    for name in INPUT_FILES:
        path = root/name
        if path.is_symlink():
            raise ValueError('Input symlinks need separate identity review')
        if path.is_file():
            paths.add(path)
    return {str(p.relative_to(root)): digest(p) for p in sorted(paths)}


def test_command(root, modules):
    for module in modules:
        if (not re.fullmatch(r'tests\.test_[A-Za-z0-9_]+', module)
                or not (root/(module.replace('.', '/')+'.py')).is_file()):
            raise ValueError('Only existing tests.test_* modules may be selected')
    args = list(modules) if modules else ['discover', '-s', 'tests']
    return [sys.executable, '-m', 'unittest', *args, '-v']


def now():
    return datetime.now(timezone.utc).isoformat()


def save(path, data):
    with path.open('x', encoding='utf-8') as target:
        json.dump(data, target, ensure_ascii=False, indent=2)
        target.write('\n')


def run(root, output, modules=(), *, timeout_seconds=1800):
    if type(timeout_seconds) is not int or not 1 <= timeout_seconds <= 86400:
        raise ValueError('timeout_seconds must be an integer from 1 to 86400')
    root, output = root.resolve(), output.resolve()
    if not output.is_relative_to(root/'work') or output == root/'work' or output.exists():
        raise ValueError('Use a new, non-existing run directory under project work/')
    # Receipts must not be captured as their own changing inputs.
    if output.is_relative_to(root/'work/doc2spec'):
        raise ValueError('Output must be outside source input directories')
    command = test_command(root, modules)
    output.mkdir(parents=True, exist_ok=False)
    started, tick = now(), time.monotonic()
    before, after, exit_code, error = {}, {}, None, None
    log_path = output/'tests.log'
    try:
        before = snapshot(root)
        save(output/'start.json', {
            'started_at': started, 'command': command, 'before_inputs': before,
            'timeout_seconds': timeout_seconds,
            'python_version': sys.version, 'environment_overrides': {'GAUSSDB_ENABLED': 'false'},
            'input_dirs': list(INPUT_DIRS), 'input_files': list(INPUT_FILES),
            'input_suffixes': sorted(INPUT_SUFFIXES), 'limits': LIMITS,
        })
        with log_path.open('xb') as log:
            process = subprocess.run(command, cwd=root,
                env={**os.environ, 'GAUSSDB_ENABLED': 'false', 'PYTHONUNBUFFERED': '1'},
                stdout=log, stderr=subprocess.STDOUT, timeout=timeout_seconds, check=False)
            exit_code = process.returncode
    except (OSError, ValueError, subprocess.SubprocessError, KeyboardInterrupt) as exc:
        error = type(exc).__name__
    try:
        after = snapshot(root)
    except (OSError, ValueError) as exc:
        error = type(exc).__name__
    log_text = log_path.read_text(encoding='utf-8', errors='replace') if log_path.exists() else ''
    summary = re.search(r'Ran (\d+) tests? in ([\d.]+)s\s+((?:OK|FAILED)(?:\s*\([^\n]*\))?)\s*$', log_text)
    count = int(summary[1]) if summary else None
    changed = sorted(name for name in before.keys() | after.keys() if before.get(name) != after.get(name))
    if error:
        status = 'error'
    elif exit_code != 0:
        status = 'failed'
    elif changed:
        status = 'inputs_changed'
    elif not summary or not count or summary[3] != 'OK':
        status = 'incomplete'
    else:
        status = 'passed'
    result = {
        'status': status, 'scope': 'static_unit_tests', 'database_verified': False,
        'database_execution_requested': False, 'started_at': started, 'ended_at': now(),
        'wall_seconds': round(time.monotonic()-tick, 3), 'command': command,
        'timeout_seconds': timeout_seconds,
        'exit_code': exit_code, 'error_type': error, 'tests_run': count,
        'unittest_summary': summary[3] if summary else None,
        'before_inputs': before, 'after_inputs': after, 'changed_inputs': changed,
        'log_sha256': digest(log_path) if log_path.exists() else None,
        'start_record_sha256': digest(output/'start.json') if (output/'start.json').exists() else None,
        'limits': LIMITS,
    }
    save(output/'receipt.json', result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, required=True)
    parser.add_argument('--module', action='append', default=[])
    parser.add_argument('--timeout-seconds', type=int, default=1800,
                        help='Bounded child-process budget, 1–86400 seconds (default: 1800)')
    args = parser.parse_args()
    try:
        result = run(ROOT, args.output_dir, args.module, timeout_seconds=args.timeout_seconds)
    except ValueError as exc:
        parser.error(str(exc))
    print(json.dumps({k: result[k] for k in ('status', 'exit_code', 'tests_run', 'wall_seconds')}))
    return int(result['status'] != 'passed')


if __name__ == '__main__':
    raise SystemExit(main())
