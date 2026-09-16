"""Validate small local fixture inputs without deploying, deleting or executing."""
import hashlib
import re
from pathlib import Path


def inspect_fixture_files(fixture, fixture_path, specs_dir):
    base=Path(fixture_path).parent.resolve()
    root=Path(specs_dir).parent.resolve()
    result=[];ids=set();targets=set()
    for asset in fixture.provides.files:
        if asset.id in ids or asset.target_path in targets:
            raise ValueError('duplicate file asset identity or target')
        ids.add(asset.id);targets.add(asset.target_path)
        path=(base/asset.source_path).resolve()
        if not path.is_relative_to(base/'assets') or not path.is_relative_to(root):
            raise ValueError('file asset resolves outside fixture assets')
        if not path.is_file():raise ValueError(f'file asset missing: {asset.source_path}')
        if path.stat().st_size>1024*1024:raise ValueError('file asset exceeds finite 1 MiB input limit')
        data=path.read_bytes()
        if hashlib.sha256(data).hexdigest()!=asset.sha256:
            raise ValueError(f'file asset SHA256 mismatch: {asset.id}')
        try:text=data.decode('utf-8')
        except UnicodeDecodeError as exc:raise ValueError('file asset is not UTF-8') from exc
        if not text.endswith('\n') or '\r' in text:raise ValueError('file asset requires LF-terminated rows')
        rows=text.splitlines()
        if len(rows)!=asset.row_count:raise ValueError('file asset row_count mismatch')
        for row in rows:
            columns=row.split(',' if asset.format == 'integer_csv' else '\t')
            if len(columns)!=asset.column_count:raise ValueError('file asset column_count mismatch')
            if any(not re.fullmatch(r'-?[0-9]+',c) or not -2147483648<=int(c)<=2147483647 for c in columns):
                raise ValueError('file asset requires finite unquoted INTEGER TSV/CSV values')
        result.append(dict(asset.model_dump(),fixture_id=fixture.id,
            repository_source_path=path.relative_to(root).as_posix(),
            deployed=False,deployment_required=True))
    return result
