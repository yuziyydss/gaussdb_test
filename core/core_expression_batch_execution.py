"""Generic authorized-execution plans and receipt audit for core expression batches.

This module defines static execution plans and receipt schemas for every probe
batch.  It does not connect to GaussDB, execute SQL, or create runtime evidence.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_probe_batches import verify_core_expression_probe_batches

ROOT = Path(__file__).resolve().parents[1]
BATCH_ARTIFACT_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batches.json'
BATCH_OUTPUT_BASE = ROOT / 'generated/core_expression_probe_batches_v1'

SUPPORTED_BATCH_IDS = {
    'batch_01_scalar_types_conditionals',
    'batch_02_strings_and_conversion',
    'batch_03_structured_types',
    'batch_04_aggregates_windows_datetime',
}


class StrictCoreExpressionBatchModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class CoreExpressionBatchExecutionSourceDef(StrictCoreExpressionBatchModel):
    batch_artifact_relpath: str
    batch_artifact_sha256: str
    batch_plan_sha256: str
    batch_id: str
    step_count: int

    @field_validator('batch_artifact_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('batch artifact path must be safe')
        return value

    @field_validator('batch_artifact_sha256', 'batch_plan_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('core expression execution source SHA-256 must be 64 hex characters')
        return value


class CoreExpressionBatchExecutionStepDef(StrictCoreExpressionBatchModel):
    step_order: int = Field(ge=1)
    batch_order: int = Field(ge=1)
    candidate_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    expected_kind: Literal['value']
    compatibility_mode: Literal['any']
    fixture_ref: Literal['no_fixture']
    oracle_status: Literal['needs_verification']

    @field_validator('sql')
    @classmethod
    def ensure_single_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';') or normalized.count(';') != 1:
            raise ValueError('execution plan SQL must be exactly one statement ending with semicolon')
        upper = normalized[:-1].upper()
        if not upper.startswith(('SELECT ', 'WITH ')):
            raise ValueError('execution plan SQL must be read-only SELECT or WITH')
        for token in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
            if token in upper:
                raise ValueError(f'execution plan SQL contains forbidden token {token.strip()}')
        return normalized


class CoreExpressionBatchExecutionPlanDef(StrictCoreExpressionBatchModel):
    schema_version: int = 1
    kind: str = 'core_expression_batch_execution_plan'
    profile: str = 'core_expression_batch_execution_plan_v1'
    id: str
    name: str
    status: str = 'ready_for_authorized_execution'
    batch_id: str
    source: CoreExpressionBatchExecutionSourceDef
    steps: List[CoreExpressionBatchExecutionStepDef]
    execution_requirements: List[str] = Field(default_factory=lambda: [
        'successful_read_only_preflight_with_zero_findings',
        'advanced_package_and_runtime_gate_passed',
        'explicit_cli_and_environment_authorization',
        'single_connection_for_entire_batch',
        'per_step_success_or_failure_receipt',
        'stop_on_first_failed_step',
        'independent_receipt_audit',
    ])
    limits: List[str] = Field(default_factory=lambda: [
        'This plan does not connect to GaussDB or execute SQL.',
        'A generated execution plan is not a runtime receipt.',
        'Oracle status remains needs_verification until database evidence exists.',
        'A valid receipt proves only recorded execution, not complete value-domain coverage.',
    ])

    @model_validator(mode='after')
    def ensure_plan_shape(self) -> 'CoreExpressionBatchExecutionPlanDef':
        if self.batch_id not in SUPPORTED_BATCH_IDS:
            raise ValueError(f'unsupported core expression batch: {self.batch_id}')
        if self.id != f'core_expression_{self.batch_id}_execution_plan_v1':
            raise ValueError('execution plan id does not match batch id')
        if self.source.batch_id != self.batch_id:
            raise ValueError('execution plan source batch id mismatch')
        if self.source.step_count != len(self.steps):
            raise ValueError('execution plan source step count mismatch')
        orders = [item.step_order for item in self.steps]
        if orders != list(range(1, len(self.steps) + 1)):
            raise ValueError('execution plan step_order must be contiguous')
        candidate_ids = [item.candidate_id for item in self.steps]
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('execution plan candidate ids cannot repeat')
        batch_orders = [item.batch_order for item in self.steps]
        if batch_orders != list(range(1, len(self.steps) + 1)):
            raise ValueError('execution plan batch_order must be contiguous')
        return self


class CoreExpressionBatchAuthorizationDef(StrictCoreExpressionBatchModel):
    cli_authorized: bool
    environment_authorized: bool
    database_enabled: bool
    gate_allowed: bool
    preflight_audit_sha256: str

    @field_validator('preflight_audit_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('preflight audit SHA-256 must be 64 hex characters')
        return value

    @model_validator(mode='after')
    def ensure_all_authorized(self) -> 'CoreExpressionBatchAuthorizationDef':
        if not all([self.cli_authorized, self.environment_authorized, self.database_enabled, self.gate_allowed]):
            raise ValueError('runtime receipt requires CLI, environment, database and gate authorization')
        return self


class CoreExpressionBatchReceiptStepDef(StrictCoreExpressionBatchModel):
    step_order: int = Field(ge=1)
    candidate_id: str
    sql: str
    status: Literal['success', 'failed']
    rows: List[List[Any]] = Field(default_factory=list)
    notices: List[str] = Field(default_factory=list)
    error: str = ''
    sqlstate: str
    duration_ms: int = Field(ge=0)

    @field_validator('sqlstate')
    @classmethod
    def ensure_sqlstate(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('runtime receipt step must record SQLSTATE')
        return value

    @model_validator(mode='after')
    def ensure_step_shape(self) -> 'CoreExpressionBatchReceiptStepDef':
        if self.status == 'success' and self.error:
            raise ValueError(f'success step {self.candidate_id} cannot contain error')
        if self.status == 'failed' and not self.error:
            raise ValueError(f'failed step {self.candidate_id} needs error')
        if self.status == 'success' and not self.rows:
            raise ValueError(f'success step {self.candidate_id} must capture rows')
        return self


class CoreExpressionBatchReceiptDef(StrictCoreExpressionBatchModel):
    kind: str = 'core_expression_batch_runtime_receipt'
    schema_version: int = 1
    profile: str = 'core_expression_batch_execution_plan_v1'
    batch_id: str
    status: Literal['runtime_verified', 'failed']
    database_executed: bool
    execution_authorized: bool
    connected_database: str
    connected_user: str
    server_version: str
    sql_compatibility: str
    started_at: str
    finished_at: str
    authorization: CoreExpressionBatchAuthorizationDef
    plan_sha256: str
    plan_step_ids: List[str]
    plan_step_count: int
    executed_steps: int
    runtime_verified_steps: int
    failed_steps: int
    steps: List[CoreExpressionBatchReceiptStepDef]
    limits: List[str] = Field(default_factory=lambda: [
        'This receipt proves only the recorded runtime execution for this batch.',
        'It does not prove untested inputs, database configurations or value domains.',
        'It does not authorize other batches.',
        'Independent audit is required before accepting runtime claims.',
    ])

    @field_validator('batch_id')
    @classmethod
    def ensure_supported_batch(cls, value: str) -> str:
        if value not in SUPPORTED_BATCH_IDS:
            raise ValueError(f'unsupported core expression batch: {value}')
        return value

    @field_validator('plan_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('plan_sha256 must be 64 hex characters')
        return value

    @field_validator('connected_database', 'connected_user', 'server_version', 'sql_compatibility', 'started_at', 'finished_at')
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('runtime receipt identity fields cannot be blank')
        return value

    @model_validator(mode='after')
    def ensure_receipt_shape(self) -> 'CoreExpressionBatchReceiptDef':
        if not self.database_executed or not self.execution_authorized:
            raise ValueError('runtime receipt must claim database execution and authorization')
        if self.executed_steps != len(self.steps):
            raise ValueError('executed_steps mismatch')
        failed_steps = sum(item.status == 'failed' for item in self.steps)
        verified_steps = sum(item.status == 'success' for item in self.steps)
        first_failed = next((index for index, item in enumerate(self.steps) if item.status == 'failed'), None)
        if first_failed is not None and self.steps[first_failed + 1:]:
            raise ValueError('execution must stop on first failed step')
        if self.failed_steps != failed_steps:
            raise ValueError('failed_steps mismatch')
        expected_verified = first_failed if first_failed is not None else len(self.steps)
        if self.runtime_verified_steps != expected_verified:
            raise ValueError('runtime_verified_steps inconsistent with stop-on-first-failure policy')
        if self.failed_steps != failed_steps:
            raise ValueError('failed_steps mismatch')
        expected_status = 'runtime_verified' if first_failed is None and self.steps else 'failed'
        if self.status != expected_status:
            raise ValueError('runtime receipt status is inconsistent')
        return self


class CoreExpressionBatchReceiptAuditDef(StrictCoreExpressionBatchModel):
    kind: str = 'core_expression_batch_runtime_receipt_audit'
    schema_version: int = 1
    batch_id: str
    valid: bool
    plan_verified: bool
    errors: List[str]
    summary: Dict[str, int]
    limits: List[str] = Field(default_factory=lambda: [
        'Audit verifies plan identity, SQL identity, authorization claims and counts only.',
        'It does not prove untested inputs, configurations or value domains.',
        'It does not authorize other batches.',
    ])


def _canonical_hash(payload: dict) -> str:
    canonical = json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':'))
    return hashlib.sha256(canonical.encode('utf-8')).hexdigest()


def plan_output_path(root: Path, batch_id: str) -> Path:
    return Path(root).resolve() / 'generated/core_expression_probe_batches_v1' / f'{batch_id}_execution_plan.json'


def build_core_expression_batch_execution_plan(root: Path, batch_id: str) -> CoreExpressionBatchExecutionPlanDef:
    root = Path(root).resolve()
    if batch_id not in SUPPORTED_BATCH_IDS:
        raise ValueError(f'unsupported core expression batch: {batch_id}')
    batch_payload = verify_core_expression_probe_batches(root)
    batch = next((item for item in batch_payload['batches'] if item['id'] == batch_id), None)
    if batch is None:
        raise ValueError(f'batch {batch_id} is missing')
    artifact_path = root / 'generated/core_expression_probe_batches_v1/batches.json'
    steps = [CoreExpressionBatchExecutionStepDef(
        step_order=index + 1,
        batch_order=step['batch_order'],
        candidate_id=step['candidate_id'],
        capability=step['capability'],
        fact_refs=list(step['fact_refs']),
        sql=step['sql'],
        expected_kind='value',
        compatibility_mode='any',
        fixture_ref='no_fixture',
        oracle_status='needs_verification',
    ) for index, step in enumerate(batch['steps'])]
    return CoreExpressionBatchExecutionPlanDef(
        id=f'core_expression_{batch_id}_execution_plan_v1',
        name=f'Core Expression {batch_id} Authorized Execution Plan',
        batch_id=batch_id,
        source=CoreExpressionBatchExecutionSourceDef(
            batch_artifact_relpath=str(artifact_path.relative_to(root)),
            batch_artifact_sha256=hashlib.sha256(artifact_path.read_bytes()).hexdigest(),
            batch_plan_sha256=batch_payload['plan_sha256'],
            batch_id=batch_id,
            step_count=len(steps),
        ),
        steps=steps,
    )


def build_core_expression_batch_execution_plan_payload(root: Path, batch_id: str) -> dict:
    plan = build_core_expression_batch_execution_plan(root, batch_id)
    payload = plan.model_dump(mode='json')
    payload['plan_sha256'] = _canonical_hash(payload)
    return payload


def verify_core_expression_batch_execution_plan(root: Path, batch_id: str) -> dict:
    root = Path(root).resolve()
    path = plan_output_path(root, batch_id)
    if not path.is_file():
        raise ValueError(f'core expression execution plan artifact is missing: {path}')
    try:
        recorded = json.loads(path.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression execution plan artifact is invalid: {exc}') from exc
    current = build_core_expression_batch_execution_plan_payload(root, batch_id)
    if recorded != current:
        raise ValueError(f'core expression execution plan artifact is stale: {batch_id}')
    return recorded


def audit_core_expression_batch_receipt(
    receipt: Dict[str, Any],
    *,
    plan: CoreExpressionBatchExecutionPlanDef,
    expected_plan_sha256: Optional[str] = None,
) -> CoreExpressionBatchReceiptAuditDef:
    errors: List[str] = []
    plan_verified = False
    try:
        parsed = receipt if isinstance(receipt, CoreExpressionBatchReceiptDef) else CoreExpressionBatchReceiptDef(**receipt)
    except Exception as exc:
        return CoreExpressionBatchReceiptAuditDef(
            batch_id=plan.batch_id,
            valid=False,
            plan_verified=False,
            errors=[f'receipt schema validation failed: {exc}'],
            summary={'plan_steps': len(plan.steps), 'executed_steps': 0, 'runtime_verified_steps': 0, 'failed_steps': 0},
        )

    if parsed.batch_id != plan.batch_id:
        errors.append(f'batch id mismatch: receipt={parsed.batch_id}, plan={plan.batch_id}')
    if expected_plan_sha256 is None:
        errors.append('expected plan hash not supplied; plan identity could not be verified')
    elif parsed.plan_sha256 != expected_plan_sha256:
        errors.append(f'plan hash mismatch: receipt={parsed.plan_sha256}, expected={expected_plan_sha256}')

    expected_ids = [step.candidate_id for step in plan.steps]
    if parsed.plan_step_ids != expected_ids:
        errors.append('plan step ids do not match supplied execution plan')
    if parsed.plan_step_count != len(plan.steps):
        errors.append('plan step count does not match supplied execution plan')

    if not errors:
        plan_verified = True

    for index, (actual, expected) in enumerate(zip(parsed.steps, plan.steps), start=1):
        if actual.step_order != expected.step_order:
            errors.append(f'step {index}: step_order mismatch')
        if actual.candidate_id != expected.candidate_id:
            errors.append(f'step {index}: candidate_id mismatch')
        if actual.sql != expected.sql:
            errors.append(f'step {index}: SQL mismatch')
        if actual.status == 'success' and not actual.rows:
            errors.append(f'step {index}: successful SELECT did not capture rows')

    if parsed.authorization.preflight_audit_sha256 == '0' * 64:
        errors.append('preflight audit hash is placeholder')

    return CoreExpressionBatchReceiptAuditDef(
        batch_id=plan.batch_id,
        valid=not errors,
        plan_verified=plan_verified,
        errors=errors,
        summary={
            'plan_steps': len(plan.steps),
            'executed_steps': len(parsed.steps),
            'runtime_verified_steps': parsed.runtime_verified_steps,
            'failed_steps': parsed.failed_steps,
        },
    )
