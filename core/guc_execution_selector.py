"""Select concrete GUC values for resolved environment gates.

The selector remains offline.  It chooses a value, builds the five-step
session-overlay plan, and never claims authorization or runtime evidence.
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, model_validator

from core.guc_capability import GucCapabilityPlanDef, GucCapabilityPlanStepDef
from core.guc_environment import GucEnvironmentPlanner, GucEnvironmentRegistry
from core.guc_requirement_resolver import GucRequirementResolverResultDef


class GucExecutionSelectionError(ValueError):
    pass


class StrictGucExecutionSelectionModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucExecutionSelectionItemDef(StrictGucExecutionSelectionModel):
    requirement_key: str
    parameter_name: str
    selected_value: str
    plan: GucCapabilityPlanDef

    @model_validator(mode="after")
    def ensure_selection_shape(self) -> "GucExecutionSelectionItemDef":
        if self.requirement_key != f"guc_{self.parameter_name}":
            raise ValueError("GUC execution selection key must derive from parameter name")
        if not self.selected_value:
            raise ValueError("GUC execution selected value cannot be empty")
        return self


class GucExecutionSelectionSummaryDef(StrictGucExecutionSelectionModel):
    selection_count: int


class GucExecutionSelectionResultDef(StrictGucExecutionSelectionModel):
    kind: Literal["guc_execution_selection"] = "guc_execution_selection"
    schema_version: Literal[1] = 1
    selections: List[GucExecutionSelectionItemDef]
    summary: GucExecutionSelectionSummaryDef
    runtime_authorized: bool = False
    database_executed: bool = False
    runtime_verified: bool = False
    limits: List[str] = Field(default_factory=lambda: [
        "This selector only chooses a static GUC value and builds a plan.",
        "It does not connect to a database or execute SQL.",
        "Runtime execution still requires explicit authorization and a receipt.",
        "The selected plan must capture, apply, verify, restore, and verify restore.",
    ])

    @model_validator(mode="after")
    def ensure_selection_result_shape(self) -> "GucExecutionSelectionResultDef":
        if self.runtime_authorized or self.database_executed or self.runtime_verified:
            raise ValueError("GUC execution selection cannot claim runtime evidence")
        keys = [item.requirement_key for item in self.selections]
        if len(set(keys)) != len(keys):
            raise ValueError("GUC execution selection keys cannot repeat")
        if self.summary.selection_count != len(self.selections):
            raise ValueError("GUC execution selection summary is inconsistent")
        return self


def _quote_sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def _plain_value(sql_literal: str) -> str:
    if len(sql_literal) >= 2 and sql_literal[0] == sql_literal[-1] == "'":
        return sql_literal[1:-1].replace("''", "'")
    return sql_literal


def select_guc_execution_values(
    resolved: GucRequirementResolverResultDef,
    root: Path,
    *,
    selections: Optional[Dict[str, str]] = None,
) -> GucExecutionSelectionResultDef:
    selections = selections or {}
    supported_by_key = {
        item.requirement_key: item for item in resolved.supported
    }
    unknown_keys = sorted(set(selections) - set(supported_by_key))
    if unknown_keys:
        raise GucExecutionSelectionError(
            "unknown GUC selection keys: " + ", ".join(unknown_keys)
        )

    registry = GucEnvironmentRegistry(
        root, inventory_path=root / "environments/guc_parameters_v2.yaml"
    )
    registry.load_all()
    planner = GucEnvironmentPlanner(registry)
    parameters_by_name = {
        parameter.name: parameter for parameter in registry.parameters.values()
    }

    selected_items: List[GucExecutionSelectionItemDef] = []
    for requirement_key, resolved_item in sorted(supported_by_key.items()):
        allowed_values = resolved_item.allowed_values
        selected_value = selections.get(requirement_key, allowed_values[0])
        if selected_value not in allowed_values:
            raise GucExecutionSelectionError(
                f"GUC selection {requirement_key}={selected_value!r} is not in allowed values "
                f"{allowed_values!r}"
            )
        parameter = parameters_by_name.get(resolved_item.parameter_name)
        if parameter is None:
            raise GucExecutionSelectionError(
                f"GUC execution selection parameter not found: {resolved_item.parameter_name}"
            )
        target_literal = _quote_sql_literal(selected_value)
        original_literal = parameter.default_value
        plan = planner.plan(parameter.id, target_literal, original_literal)
        selected_items.append(GucExecutionSelectionItemDef(
            requirement_key=requirement_key,
            parameter_name=resolved_item.parameter_name,
            selected_value=selected_value,
            plan=GucCapabilityPlanDef(
                target_value=plan.target_value,
                original_value=plan.original_value,
                steps=[
                    GucCapabilityPlanStepDef(action=step.action, sql=step.sql)
                    for step in plan.steps
                ],
            ),
        ))

    return GucExecutionSelectionResultDef(
        selections=selected_items,
        summary=GucExecutionSelectionSummaryDef(
            selection_count=len(selected_items)
        ),
    )
