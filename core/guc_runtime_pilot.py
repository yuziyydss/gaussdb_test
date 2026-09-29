"""GUC V2 runtime pilot built from the deterministic overlay plan export.

The default artifact is a dry-run plan.  Real execution requires explicit
authorization, a database transport, and a separate receipt; this module never
fabricates runtime evidence.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import List

from core.guc_plan_export import GucOverlayPlanExportRegistry
from core.runtime_validation_pilot import (
    RuntimeCleanupDef,
    RuntimeOracleDef,
    RuntimePilotPlanDef,
    RuntimeStepDef,
    RuntimeUnitDef,
    plan_sha256,
)


class GucV2RuntimePilotError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(
            "GUC V2 runtime pilot 加载失败:\n" + "\n".join(f"- {item}" for item in errors)
        )


def _plain_value(sql_literal: str) -> str:
    if len(sql_literal) >= 2 and sql_literal[0] == sql_literal[-1] == "'":
        return sql_literal[1:-1].replace("''", "'")
    return sql_literal


def _unit_id(parameter_name: str) -> str:
    return "guc_v2_overlay_" + parameter_name.replace(".", "_")


def _overlay_unit(overlay) -> RuntimeUnitDef:
    original = _plain_value(overlay.original_value)
    target = _plain_value(overlay.target_value)
    steps = [
        RuntimeStepDef(
            phase="capture_original",
            sql=overlay.steps[0].sql,
            expected_rows=[[original]],
        ),
        RuntimeStepDef(phase="apply", sql=overlay.steps[1].sql),
        RuntimeStepDef(
            phase="verify_target",
            sql=overlay.steps[2].sql,
            expected_rows=[[target]],
        ),
        RuntimeStepDef(phase="restore", sql=overlay.steps[3].sql),
        RuntimeStepDef(
            phase="verify_restore",
            sql=overlay.steps[4].sql,
            expected_rows=[[original]],
        ),
    ]
    return RuntimeUnitDef(
        id=_unit_id(overlay.parameter_name),
        kind="guc_overlay",
        interface_refs=[overlay.parameter_id],
        status="ready_for_authorized_execution",
        oracle=RuntimeOracleDef(
            kind="metadata",
            expected=f"{overlay.parameter_name}={target}; restore={original}",
            status="needs_verification",
        ),
        execution_plan=steps,
        cleanup=RuntimeCleanupDef(restore_original_guc=True),
    )


def build_guc_v2_runtime_dry_run(root: Path) -> RuntimePilotPlanDef:
    export = GucOverlayPlanExportRegistry(root).load()
    if export.environment_schema_version != 2 or export.environment_id != "guc_environment_v2":
        raise GucV2RuntimePilotError([
            "GUC V2 runtime pilot must bind to guc_environment_v2"
        ])
    units = [_overlay_unit(item) for item in export.plans]
    return RuntimePilotPlanDef(
        schema_version=1,
        kind="runtime_validation_pilot",
        profile="runtime_guc_v2_pilot_v1",
        status="ready_for_authorized_execution",
        units=units,
        execution_requirements=[
            "explicit_runtime_authorization",
            "single_connection",
            "no_global_guc_changes",
            "restore_original_guc_values",
            "per_step_success_receipt",
            "row_oracle_for_current_setting",
        ],
        limits=[
            "This dry run does not open a database connection or execute SQL.",
            "A planned step is not runtime evidence.",
            "GUC overlays are session-local only and must restore the captured original value.",
            "Restore must use the captured original value, not RESET.",
            "Output oracles depend on current_setting rows and are not claimed without captured evidence.",
        ],
    )


class GucV2RuntimePilotRegistry:
    """Build, persist, and reload the GUC V2 runtime pilot plan."""

    def __init__(self, root: Path):
        self.root = Path(root)

    def build(self) -> RuntimePilotPlanDef:
        return build_guc_v2_runtime_dry_run(self.root)

    def write(self, output: Path) -> Path:
        plan = self.build()
        payload = plan.model_dump(mode="json")
        payload["plan_sha256"] = plan_sha256(plan)
        output = Path(output)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return output

    def load(self, path: Path) -> RuntimePilotPlanDef:
        path = Path(path)
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucV2RuntimePilotError([f"{path}: {exc}"]) from exc
        recorded_hash = payload.pop("plan_sha256", "")
        try:
            plan = RuntimePilotPlanDef(**payload)
        except Exception as exc:
            raise GucV2RuntimePilotError([f"{path}: {exc}"]) from exc
        actual_hash = plan_sha256(plan)
        if recorded_hash != actual_hash:
            raise GucV2RuntimePilotError([
                f"plan hash drift: expected {recorded_hash}, got {actual_hash}"
            ])
        return plan
