"""Resolve Factor Package GUC environment gates against GUC V2 capabilities.

The resolver is offline and structural.  It proves that a ``guc_*`` gate can be
bound to a reviewed GUC V2 capability; it does not execute SQL or authorize a
database run.
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict, List, Literal

from pydantic import BaseModel, ConfigDict, Field, model_validator

from core.guc_capability import GucCapabilityPlanDef, GucCapabilityRegistry
from core.guc_requirement_adapter import GucRequirementAdapterRegistry


class StrictGucRequirementResolverModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucResolvedRequirementDef(StrictGucRequirementResolverModel):
    requirement_key: str
    parameter_name: str
    allowed_values: List[str]
    fact_refs: List[str]
    plan: GucCapabilityPlanDef

    @model_validator(mode="after")
    def ensure_resolved_shape(self) -> "GucResolvedRequirementDef":
        if self.requirement_key != f"guc_{self.parameter_name}":
            raise ValueError("GUC resolved requirement key must derive from parameter name")
        if not self.allowed_values or not self.fact_refs:
            raise ValueError("GUC resolved requirement must have values and facts")
        return self


class GucInvalidRequirementDef(StrictGucRequirementResolverModel):
    requirement_key: str
    requested_values: List[str]
    supported_values: List[str]


class GucRequirementResolverSummaryDef(StrictGucRequirementResolverModel):
    requested_count: int
    supported_count: int
    unsupported_count: int
    invalid_value_count: int


class GucRequirementResolverResultDef(StrictGucRequirementResolverModel):
    kind: Literal["guc_requirement_resolver"] = "guc_requirement_resolver"
    schema_version: Literal[1] = 1
    supported: List[GucResolvedRequirementDef]
    unsupported: List[str]
    invalid_values: List[GucInvalidRequirementDef]
    summary: GucRequirementResolverSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "This resolver only validates static GUC capability bindings.",
        "It does not execute SQL or change a GUC.",
        "A resolved gate still requires runtime capture, apply, verify, restore, and verify-restore.",
        "Multiple allowed values remain ambiguous until an execution selector chooses one value.",
    ])

    @model_validator(mode="after")
    def ensure_resolver_shape(self) -> "GucRequirementResolverResultDef":
        supported_keys = [item.requirement_key for item in self.supported]
        if len(set(supported_keys)) != len(supported_keys):
            raise ValueError("GUC supported requirement keys cannot repeat")
        if set(supported_keys) & set(self.unsupported):
            raise ValueError("A GUC requirement cannot be both supported and unsupported")
        invalid_keys = [item.requirement_key for item in self.invalid_values]
        if len(set(invalid_keys)) != len(invalid_keys):
            raise ValueError("GUC invalid requirement keys cannot repeat")
        expected_summary = GucRequirementResolverSummaryDef(
            requested_count=len(supported_keys) + len(self.unsupported) + len(invalid_keys),
            supported_count=len(self.supported),
            unsupported_count=len(self.unsupported),
            invalid_value_count=len(self.invalid_values),
        )
        if self.summary != expected_summary:
            raise ValueError("GUC requirement resolver summary is inconsistent")
        return self


def resolve_guc_requirements(
    gates: Dict[str, List[str]],
    root: Path,
) -> GucRequirementResolverResultDef:
    root = Path(root)
    adapter = GucRequirementAdapterRegistry(root).load()
    capability_matrix = GucCapabilityRegistry(root).load()

    adapter_by_key = {
        item.requirement.key: item
        for item in adapter.requirements
    }
    capability_by_name = {
        item.parameter_name: item
        for item in capability_matrix.capabilities
    }

    supported: List[GucResolvedRequirementDef] = []
    unsupported: List[str] = []
    invalid_values: List[GucInvalidRequirementDef] = []

    for key in sorted(gates):
        if not key.startswith("guc_"):
            continue
        requested_values = list(gates[key])
        adapter_item = adapter_by_key.get(key)
        if adapter_item is None:
            unsupported.append(key)
            continue
        supported_values = list(adapter_item.requirement.allowed_values)
        if not set(requested_values).issubset(set(supported_values)):
            invalid_values.append(GucInvalidRequirementDef(
                requirement_key=key,
                requested_values=requested_values,
                supported_values=supported_values,
            ))
            continue
        capability = capability_by_name[adapter_item.parameter_name]
        supported.append(GucResolvedRequirementDef(
            requirement_key=key,
            parameter_name=adapter_item.parameter_name,
            allowed_values=requested_values,
            fact_refs=list(adapter_item.requirement.fact_refs),
            plan=capability.plan,
        ))

    return GucRequirementResolverResultDef(
        supported=supported,
        unsupported=unsupported,
        invalid_values=invalid_values,
        summary=GucRequirementResolverSummaryDef(
            requested_count=len(supported) + len(unsupported) + len(invalid_values),
            supported_count=len(supported),
            unsupported_count=len(unsupported),
            invalid_value_count=len(invalid_values),
        ),
    )
