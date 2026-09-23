"""Load the authoritative remaining generation-model gap snapshot."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Dict, Optional

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PATH = ROOT / "docs" / "GENERATION_MODEL_REMAINING_20260920.json"

CATEGORY_LABELS = {
    "documented_support_conflict": "文档支持矛盾",
    "resource_pool_support_conflict": "资源池支持冲突",
    "complex_structural_and_runtime_profiles": "复杂结构与运行时Profile",
    "external_key_manager_capability": "外部密钥管理器能力",
    "file_fdw_binary_fixed_contract": "file_fdw BINARY/FIXED合同",
    "tde_and_index_domain_contracts": "TDE与索引域合同",
    "model_architecture_contract": "模型架构合同",
    "operator_class_index_contract": "操作符类索引合同",
    "cursor_and_target_profiles": "游标与目标Profile",
    "cursor_assignment_and_target_profiles": "游标赋值与目标Profile",
}


def load_generation_gap_dispositions(path: Path = DEFAULT_PATH) -> Optional[Dict[str, dict]]:
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
        required = {"blocking_category", "blocking_reason", "next_action"}
        absent = sorted(required - set(entry))
        if absent:
            raise ValueError(f"{path}: {factor_ref} missing fields {absent}")
        result[factor_ref] = entry
    return result


def category_label(category: str) -> str:
    return CATEGORY_LABELS.get(category, category)
