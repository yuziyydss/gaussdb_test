"""Split core-expression SQL probes into review-sized authorized-execution batches.

This module only creates dry-run batch plans.  It does not connect to GaussDB,
execute SQL, authorize execution, or produce runtime receipts.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_probe_plan import verify_core_expression_probe_plan

ROOT = Path(__file__).resolve().parents[1]
PROBE_PLAN_PATH = ROOT / 'generated/core_expression_probe_plan_v1/dry_run.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batches.json'

BATCH_DEFINITIONS = [
    {
        'id': 'batch_01_scalar_types_conditionals',
        'name': 'Batch 01: Scalar types and conditionals',
        'capabilities': [
            'numeric_type_domain', 'boolean_and_bit', 'numeric_functions',
            'conditional_domain', 'expression_semantics',
        ],
        'description': '字面量类型域、位串、数字函数、条件表达式和表达式语义。',
    },
    {
        'id': 'batch_02_strings_and_conversion',
        'name': 'Batch 02: Strings and conversion',
        'capabilities': ['string_domain', 'type_conversion'],
        'description': '字符串函数、模式匹配、编码、hash以及显式类型转换。',
    },
    {
        'id': 'batch_03_structured_types',
        'name': 'Batch 03: JSON, arrays and ranges',
        'capabilities': ['json_domain', 'array_domain', 'range_domain', 'hll_domain'],
        'description': 'JSON/JSONB、数组、range和HLL结构化类型。',
    },
    {
        'id': 'batch_04_aggregates_windows_datetime',
        'name': 'Batch 04: Aggregates, windows and datetime',
        'capabilities': ['aggregate_domain', 'window_domain', 'datetime_functions'],
        'description': '确定性日期函数、聚集函数和窗口函数。',
    },
]


class StrictProbeBatchModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class ProbeBatchSourceDef(StrictProbeBatchModel):
    probe_plan_relpath: str
    probe_plan_sha256: str
    probe_step_count: int

    @field_validator('probe_plan_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('probe plan path must be safe')
        return value

    @field_validator('probe_plan_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('probe plan SHA-256 must be 64 hex characters')
        return value


class ProbeBatchStepDef(StrictProbeBatchModel):
    batch_order: int = Field(ge=1)
    probe_plan_order: int = Field(ge=1)
    candidate_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    expected_kind: Literal['value']
    compatibility_mode: Literal['any']
    fixture_ref: Literal['no_fixture']
    oracle_status: Literal['needs_verification']
    execution_status: Literal['not_executed']

    @field_validator('sql')
    @classmethod
    def ensure_single_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';') or normalized.count(';') != 1:
            raise ValueError('batch SQL must be exactly one statement ending with a semicolon')
        upper = normalized[:-1].upper()
        if not upper.startswith(('SELECT ', 'WITH ')):
            raise ValueError('batch SQL must be read-only SELECT or WITH')
        for token in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
            if token in upper:
                raise ValueError(f'batch SQL contains forbidden token {token.strip()}')
        return normalized


class ProbeBatchDef(StrictProbeBatchModel):
    id: str
    name: str
    description: str
    capabilities: List[str]
    steps: List[ProbeBatchStepDef]
    step_count: int
    execution_policy: Literal['requires_explicit_authorization'] = 'requires_explicit_authorization'
    database_executed: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_batch_shape(self) -> 'ProbeBatchDef':
        ids = [item.candidate_id for item in self.steps]
        orders = [item.batch_order for item in self.steps]
        if len(ids) != len(set(ids)):
            raise ValueError(f'batch {self.id} candidate ids cannot repeat')
        if orders != list(range(1, len(self.steps) + 1)):
            raise ValueError(f'batch {self.id} batch_order must be contiguous')
        if self.step_count != len(self.steps):
            raise ValueError(f'batch {self.id} step_count is inconsistent')
        if self.steps and self.database_executed:
            raise ValueError(f'batch {self.id} dry-run cannot claim database execution')
        return self


class ProbeBatchSummaryDef(StrictProbeBatchModel):
    probe_plan_step_count: int
    batch_count: int
    batched_step_count: int
    unbatched_step_count: int
    batch_step_counts: Dict[str, int]
    read_only_step_count: int
    fixture_free_step_count: int
    mode_independent_step_count: int
    database_executed: bool = False
    execution_authorized: bool = False
    runtime_verified_count: int = 0

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'ProbeBatchSummaryDef':
        if self.batched_step_count != sum(self.batch_step_counts.values()):
            raise ValueError('core expression batch step counts are inconsistent')
        if self.probe_plan_step_count != self.batched_step_count + self.unbatched_step_count:
            raise ValueError('core expression batch coverage is incomplete or excessive')
        if self.read_only_step_count != self.batched_step_count:
            raise ValueError('core expression batch read-only count is inconsistent')
        if self.fixture_free_step_count != self.batched_step_count:
            raise ValueError('core expression batch fixture-free count is inconsistent')
        if self.mode_independent_step_count != self.batched_step_count:
            raise ValueError('core expression batch mode-independent count is inconsistent')
        if self.database_executed or self.execution_authorized or self.runtime_verified_count:
            raise ValueError('core expression batch dry-run cannot claim execution or verification')
        return self


class ProbeBatchPlanResultDef(StrictProbeBatchModel):
    schema_version: int = 1
    kind: str = 'core_expression_probe_batch_plan'
    profile: str = 'core_expression_probe_batches_v1'
    id: str = 'core_expression_probe_batches_v1'
    name: str = 'Core Expression SQL Probe Batches V1'
    status: str = 'ready_for_authorized_review'
    description: str = (
        '94个只读核心表达式probe按能力域拆成4个授权审查批次；仅dry run，不执行SQL。'
    )
    source: ProbeBatchSourceDef
    batches: List[ProbeBatchDef]
    summary: ProbeBatchSummaryDef
    execution_requirements: List[str] = Field(default_factory=lambda: [
        'successful_read_only_preflight',
        'advanced_package_and_runtime_gate_passed',
        'explicit_cli_and_environment_authorization',
        'single_connection_per_batch',
        'per_step_success_receipt',
        'independent_runtime_receipt_audit',
    ])
    limits: List[str] = Field(default_factory=lambda: [
        'Batch plans do not connect to GaussDB or execute SQL.',
        'A batch plan is not a runtime receipt.',
        'Representative SQL does not prove complete value-domain coverage.',
        'Runtime evidence requires receipts and independent audit.',
    ])

    @model_validator(mode='after')
    def ensure_plan_shape(self) -> 'ProbeBatchPlanResultDef':
        batch_ids = [item.id for item in self.batches]
        if len(batch_ids) != len(set(batch_ids)):
            raise ValueError('batch ids cannot repeat')
        if self.summary.batch_count != len(self.batches):
            raise ValueError('batch count is inconsistent')
        candidate_ids = [step.candidate_id for batch in self.batches for step in batch.steps]
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('candidate id appears in more than one batch')
        if self.summary.batched_step_count != len(candidate_ids):
            raise ValueError('batch plan candidate coverage is inconsistent')
        if self.summary.database_executed or self.summary.execution_authorized or self.summary.runtime_verified_count:
            raise ValueError('batch plan cannot claim runtime evidence')
        return self


def _canonical_hash(payload: dict) -> str:
    canonical = json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':'))
    return hashlib.sha256(canonical.encode('utf-8')).hexdigest()


def build_core_expression_probe_batches(root: Path = ROOT) -> ProbeBatchPlanResultDef:
    root = Path(root).resolve()
    probe_payload = verify_core_expression_probe_plan(root)
    probe_steps = probe_payload['steps']
    steps_by_capability: Dict[str, List[dict]] = {}
    for step in probe_steps:
        steps_by_capability.setdefault(step['capability'], []).append(step)

    batches: List[ProbeBatchDef] = []
    batch_counts: Dict[str, int] = {}
    batched_steps = 0
    for definition in BATCH_DEFINITIONS:
        steps: List[ProbeBatchStepDef] = []
        for capability in definition['capabilities']:
            for source in steps_by_capability.get(capability, []):
                steps.append(ProbeBatchStepDef(
                    batch_order=len(steps) + 1,
                    probe_plan_order=source['plan_order'],
                    candidate_id=source['candidate_id'],
                    capability=capability,
                    fact_refs=list(source['fact_refs']),
                    sql=source['sql'],
                    expected_kind='value',
                    compatibility_mode='any',
                    fixture_ref='no_fixture',
                    oracle_status='needs_verification',
                    execution_status='not_executed',
                ))
        batch = ProbeBatchDef(
            id=definition['id'],
            name=definition['name'],
            description=definition['description'],
            capabilities=list(definition['capabilities']),
            steps=steps,
            step_count=len(steps),
        )
        batches.append(batch)
        batch_counts[batch.id] = len(steps)
        batched_steps += len(steps)

    if batched_steps != len(probe_steps):
        missing = batched_steps - len(probe_steps)
        raise ValueError(f'probe batching does not cover all steps: delta={missing}')

    return ProbeBatchPlanResultDef(
        source=ProbeBatchSourceDef(
            probe_plan_relpath=str(PROBE_PLAN_PATH.relative_to(root)),
            probe_plan_sha256=probe_payload['plan_sha256'],
            probe_step_count=len(probe_steps),
        ),
        batches=batches,
        summary=ProbeBatchSummaryDef(
            probe_plan_step_count=len(probe_steps),
            batch_count=len(batches),
            batched_step_count=batched_steps,
            unbatched_step_count=0,
            batch_step_counts=batch_counts,
            read_only_step_count=batched_steps,
            fixture_free_step_count=batched_steps,
            mode_independent_step_count=batched_steps,
        ),
    )


def build_core_expression_probe_batches_payload(root: Path = ROOT) -> dict:
    plan = build_core_expression_probe_batches(Path(root).resolve())
    payload = plan.model_dump(mode='json')
    payload['plan_sha256'] = _canonical_hash(payload)
    return payload


def verify_core_expression_probe_batches(root: Path = ROOT) -> dict:
    root = Path(root).resolve()
    path = root / 'generated/core_expression_probe_batches_v1/batches.json'
    if not path.is_file():
        raise ValueError('core expression probe batch artifact is missing')
    try:
        recorded = json.loads(path.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression probe batch artifact is invalid: {exc}') from exc
    current = build_core_expression_probe_batches_payload(root)
    if recorded != current:
        raise ValueError('core expression probe batch artifact is stale')
    return recorded
