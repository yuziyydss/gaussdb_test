"""Load the authoritative no-manifest disposition snapshot."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Dict, Optional

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PATH = ROOT / "docs" / "NO_MANIFEST_REMAINING_20260920.json"

CATEGORY_LABELS = {
    "remote_identity_and_secret": "远端身份与秘密",
    "documented_unsupported": "文档不支持",
    "dual_session_runtime_binding": "双会话运行时绑定",
    "internal_callback_and_unknown_domain": "内部实现与未知编码域",
    "kernel_task_context": "内核任务上下文",
    "authoritative_om_upgrade": "权威OM升级上下文",
}


def load_no_manifest_dispositions(path: Path = DEFAULT_PATH) -> Optional[Dict[str, dict]]:
    """Return factor_ref -> disposition, or None when the snapshot is absent."""
    if not path.exists():
        return None
    payload = json.loads(path.read_text(encoding="utf-8"))
    entries = payload.get("dispositions")
    if not isinstance(entries, list):
        raise ValueError(f"{path}: dispositions must be a list")
    result: Dict[str, dict] = {}
    for entry in entries:
        factor_ref = entry.get("factor_ref") if isinstance(entry, dict) else None
        if not factor_ref or factor_ref in result:
            raise ValueError(f"{path}: invalid or duplicate factor_ref")
        result[factor_ref] = entry
    return result


def category_label(category: str) -> str:
    return CATEGORY_LABELS.get(category, category)
