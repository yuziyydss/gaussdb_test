"""Inventory all supported advanced packages and their fact readiness.

The matrix separates modeled Pilot V1 packages from unmodeled candidates.  It
does not invent interface signatures or claim that facts are executable plans.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path
from typing import Dict, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.advanced_package import AdvancedPackageRegistry


class StrictAdvancedCandidateModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class AdvancedCandidateSourceDef(StrictAdvancedCandidateModel):
    supported_package_relpath: str
    supported_package_sha256: str
    interface_inventory_relpath: str
    interface_inventory_sha256: str

    @field_validator(
        "supported_package_relpath", "interface_inventory_relpath"
    )
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("advanced candidate source path must be safe")
        return value

    @field_validator("supported_package_sha256", "interface_inventory_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r"[0-9a-f]{64}", value) is None:
            raise ValueError("advanced candidate source SHA-256 must be 64 hex characters")
        return value


class AdvancedCandidatePackageDef(StrictAdvancedCandidateModel):
    package_id: str
    package_name: str
    modeled: bool
    source_files: List[str]
    fact_count: int
    syntax_fact_count: int
    behavior_oracle_fact_count: int
    environment_fact_count: int
    candidate_tier: Literal[
        "modeled_pilot", "near_term_candidate", "later_batch", "needs_extraction"
    ]

    @field_validator("package_id", "package_name")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("advanced candidate package field cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_package_shape(self) -> "AdvancedCandidatePackageDef":
        if self.modeled != (self.candidate_tier == "modeled_pilot"):
            raise ValueError("advanced candidate modeled flag is inconsistent")
        expected_tier = (
            "modeled_pilot" if self.modeled
            else "near_term_candidate" if self.fact_count >= 8
            else "later_batch" if self.fact_count >= 1
            else "needs_extraction"
        )
        if self.candidate_tier != expected_tier:
            raise ValueError("advanced candidate tier is inconsistent")
        if len(self.source_files) != len(set(self.source_files)):
            raise ValueError("advanced candidate source files cannot repeat")
        return self


class AdvancedCandidateSummaryDef(StrictAdvancedCandidateModel):
    supported_package_count: int
    modeled_package_count: int
    unmodeled_package_count: int
    near_term_candidate_count: int
    later_batch_count: int
    needs_extraction_count: int
    fact_count: int
    syntax_fact_count: int
    behavior_oracle_fact_count: int
    environment_fact_count: int


class AdvancedCandidateMatrixDef(StrictAdvancedCandidateModel):
    schema_version: Literal[1]
    kind: Literal["advanced_package_candidate_matrix"]
    id: str = "advanced_package_candidate_matrix_v1"
    name: str = "GaussDB Advanced Package Candidate Matrix"
    description: str = (
        "22个支持的DBE高级包的fact覆盖与建模状态清单；不修改specs，不宣称可执行。"
    )
    source: AdvancedCandidateSourceDef
    packages: List[AdvancedCandidatePackageDef]
    summary: AdvancedCandidateSummaryDef

    @model_validator(mode="after")
    def ensure_matrix_shape(self) -> "AdvancedCandidateMatrixDef":
        ids = [item.package_id for item in self.packages]
        if len(set(ids)) != len(ids):
            raise ValueError("advanced candidate package ids cannot repeat")
        modeled = [item for item in self.packages if item.modeled]
        if len(modeled) != 22:
            raise ValueError("advanced candidate matrix must contain exactly 22 modeled packages")
        expected_summary = AdvancedCandidateSummaryDef(
            supported_package_count=len(self.packages),
            modeled_package_count=len(modeled),
            unmodeled_package_count=len(self.packages) - len(modeled),
            near_term_candidate_count=sum(
                item.candidate_tier == "near_term_candidate"
                for item in self.packages
            ),
            later_batch_count=sum(
                item.candidate_tier == "later_batch"
                for item in self.packages
            ),
            needs_extraction_count=sum(
                item.candidate_tier == "needs_extraction"
                for item in self.packages
            ),
            fact_count=sum(item.fact_count for item in self.packages),
            syntax_fact_count=sum(item.syntax_fact_count for item in self.packages),
            behavior_oracle_fact_count=sum(
                item.behavior_oracle_fact_count for item in self.packages
            ),
            environment_fact_count=sum(item.environment_fact_count for item in self.packages),
        )
        if self.summary != expected_summary:
            raise ValueError("advanced candidate summary does not match packages")
        return self


PACKAGE_FACT_SOURCES = {
    "dbe_output": ("stored_proc_dbe_output_complete.yaml", "dbe_output_"),
    "dbe_sql": ("stored_proc_dbe_sql_complete.yaml", "dbe_sql_"),
    "dbe_lob": ("stored_proc_dbe_lob_complete.yaml", "dbe_lob_"),
    "dbe_random": ("stored_proc_dbe_session_random.yaml", "dbe_random_"),
    "dbe_raw": ("stored_proc_dbe_raw_complete.yaml", "dbe_raw_"),
    "dbe_file": ("stored_proc_dbe_file_complete.yaml", "dbe_file_"),
    "dbe_session": ("stored_proc_dbe_session_random.yaml", "dbe_session_"),
    "dbe_match": ("stored_proc_dbe_match.yaml", "dbe_match_"),
    "dbe_utility": ("stored_proc_dbe_utility_complete.yaml", "dbe_utility_"),
    "dbe_scheduler": ("stored_proc_dbe_task_scheduler.yaml", "dbe_scheduler_"),
    "dbe_stats": ("stored_proc_dbe_remaining_packages.yaml", "dbe_stats_"),
    "dbe_describe": ("stored_proc_dbe_remaining_packages.yaml", "dbe_describe_"),
    "dbe_alert": ("stored_proc_dbe_remaining_packages.yaml", "dbe_alert_"),
    "dbe_application_info": ("stored_proc_dbe_profiler_appinfo.yaml", "dbe_appinfo_"),
    "dbe_xmldom": ("stored_proc_dbe_remaining_packages.yaml", "dbe_xmldom_"),
    "dbe_xmlparser": ("stored_proc_dbe_remaining_packages.yaml", "dbe_xmlparser_"),
    "dbe_xmlgen": ("stored_proc_dbe_remaining_packages.yaml", "dbe_xmlgen_"),
    "dbe_ilm": ("stored_proc_dbe_remaining_packages.yaml", "dbe_ilm_"),
    "dbe_ilm_admin": ("stored_proc_dbe_remaining_packages.yaml", "dbe_ilm_admin_"),
    "dbe_compression": ("stored_proc_dbe_remaining_packages.yaml", "dbe_compression_"),
    "dbe_heat_map": ("stored_proc_dbe_remaining_packages.yaml", "dbe_heat_map_"),
    "dbe_obfuscation": ("stored_proc_dbe_obfuscation.yaml", "dbe_obf_"),
}


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _load_yaml(path: Path):
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def build_advanced_package_candidate_matrix(root: Path) -> AdvancedCandidateMatrixDef:
    root = Path(root)
    supported_path = root / "docs/compat_facts/oracle_advanced_packages.yaml"
    inventory_path = root / "environments/advanced_packages_v1.yaml"

    supported_payload = _load_yaml(supported_path)
    registry = AdvancedPackageRegistry(root)
    registry.load_all()
    modeled_ids = {package.id for package in registry.environment.packages}
    package_names = {
        package.id: package.name for package in registry.environment.packages
    }

    facts_by_file: Dict[str, List[dict]] = {}
    for relpath in {relpath for relpath, _ in PACKAGE_FACT_SOURCES.values()}:
        path = root / "docs/compat_facts" / relpath
        payload = _load_yaml(path)
        facts_by_file[relpath] = payload.get("facts", [])

    packages: List[AdvancedCandidatePackageDef] = []
    for supported in supported_payload.get("facts", []):
        supported_id = supported.get("id", "")
        if not supported_id.startswith("ora_pkg_dbe_"):
            continue
        package_id = supported_id.removeprefix("ora_pkg_")
        relpath, prefix = PACKAGE_FACT_SOURCES[package_id]
        facts = [
            fact for fact in facts_by_file[relpath]
            if str(fact.get("id", "")).startswith(prefix)
        ]
        type_counts = Counter(fact.get("type", "unknown") for fact in facts)
        source_relpaths = ["docs/compat_facts/" + relpath]
        if package_id in modeled_ids:
            package = registry.packages[package_id]
            source_relpaths.append(package.source.source_relpath)

        packages.append(AdvancedCandidatePackageDef(
            package_id=package_id,
            package_name=package_names.get(package_id, supported["statement"].split("：", 1)[0]),
            modeled=package_id in modeled_ids,
            source_files=sorted(set(source_relpaths)),
            fact_count=len(facts),
            syntax_fact_count=type_counts.get("syntax", 0),
            behavior_oracle_fact_count=type_counts.get("behavior_oracle", 0),
            environment_fact_count=type_counts.get("environment", 0),
            candidate_tier=(
                "modeled_pilot" if package_id in modeled_ids
                else "near_term_candidate" if len(facts) >= 8
                else "later_batch" if facts
                else "needs_extraction"
            ),
        ))

    packages.sort(key=lambda item: item.package_id)
    return AdvancedCandidateMatrixDef(
        schema_version=1,
        kind="advanced_package_candidate_matrix",
        source=AdvancedCandidateSourceDef(
            supported_package_relpath=str(supported_path.relative_to(root)),
            supported_package_sha256=_sha256(supported_path),
            interface_inventory_relpath=str(inventory_path.relative_to(root)),
            interface_inventory_sha256=_sha256(inventory_path),
        ),
        packages=packages,
        summary=AdvancedCandidateSummaryDef(
            supported_package_count=len(packages),
            modeled_package_count=sum(item.modeled for item in packages),
            unmodeled_package_count=sum(not item.modeled for item in packages),
            near_term_candidate_count=sum(
                item.candidate_tier == "near_term_candidate"
                for item in packages
            ),
            later_batch_count=sum(
                item.candidate_tier == "later_batch"
                for item in packages
            ),
            needs_extraction_count=sum(
                item.candidate_tier == "needs_extraction"
                for item in packages
            ),
            fact_count=sum(item.fact_count for item in packages),
            syntax_fact_count=sum(item.syntax_fact_count for item in packages),
            behavior_oracle_fact_count=sum(
                item.behavior_oracle_fact_count for item in packages
            ),
            environment_fact_count=sum(item.environment_fact_count for item in packages),
        ),
    )
