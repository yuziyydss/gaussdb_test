"""Ingest audited batch runtime receipts into oracle capture slots.

Ingestion is a conversion and evidence-hash step.  It does not execute SQL,
make review decisions, or promote oracle assertions.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Dict, List

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_batch01_execution import (
    CoreExpressionBatch01ExecutionPlanDef,
    audit_core_expression_batch01_receipt,
    verify_core_expression_batch01_execution_plan,
)
from core.core_expression_batch_execution import (
    CoreExpressionBatchExecutionPlanDef,
    audit_core_expression_batch_receipt,
    verify_core_expression_batch_execution_plan,
)
from core.core_expression_oracle_capture import (
    OracleCaptureEnvironmentDef,
    OracleCaptureStepDef,
    canonical_evidence_sha256,
)

ROOT = Path(__file__).resolve().parents[1]
BATCH01_ID = 'batch_01_scalar_types_conditionals'
BATCH01_PLAN_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batch_01_execution_plan.json'


class StrictOracleCaptureIngestionModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class OracleCaptureIngestionSourceDef(StrictOracleCaptureIngestionModel):
    batch_id: str
    execution_plan_relpath: str
    execution_plan_sha256: str
    receipt_relpath: str
    receipt_sha256: str
    plan_sha256: str

    @field_validator('execution_plan_relpath', 'receipt_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('capture ingestion source path must be safe')
        return value


class OracleCaptureIngestionAuditDef(StrictOracleCaptureIngestionModel):
    valid: bool
    plan_verified: bool
    errors: List[str]
    summary: Dict[str, int]


class OracleCaptureIngestionSummaryDef(StrictOracleCaptureIngestionModel):
    plan_step_count: int
    receipt_step_count: int
    ingested_capture_count: int
    pending_capture_count: int
    captured_count: int
    capture_failed_count: int
    evidence_hash_count: int
    stop_on_first_failure: bool = True
    database_executed: bool = True
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OracleCaptureIngestionSummaryDef':
        if self.ingested_capture_count != self.receipt_step_count:
            raise ValueError('capture ingestion count does not match receipt steps')
        if self.captured_count + self.capture_failed_count != self.ingested_capture_count:
            raise ValueError('capture ingestion status counts are inconsistent')
        if self.evidence_hash_count != self.ingested_capture_count:
            raise ValueError('capture ingestion evidence hash count is inconsistent')
        if not self.database_executed:
            raise ValueError('capture ingestion requires database_executed=true')
        return self


class CoreExpressionOracleCaptureIngestionDef(StrictOracleCaptureIngestionModel):
    schema_version: int = 1
    kind: str = 'core_expression_oracle_capture_ingestion'
    id: str
    name: str
    description: str = (
        '从已审计的batch runtime receipt转换出的oracle capture registry；不执行SQL，不做出review decision。'
    )
    batch_id: str
    source: OracleCaptureIngestionSourceDef
    receipt_audit: OracleCaptureIngestionAuditDef
    capture_registry: object
    summary: OracleCaptureIngestionSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'Ingestion does not make oracle review decisions.',
        'A captured result is not complete value-domain coverage.',
        'The source receipt must already pass independent audit.',
        'Captured evidence still requires human oracle review.',
    ])

    @model_validator(mode='after')
    def ensure_ingestion_shape(self) -> 'CoreExpressionOracleCaptureIngestionDef':
        capture = self.capture_registry
        if getattr(capture, 'kind', '') != 'core_expression_oracle_capture_registry':
            raise ValueError('capture ingestion requires a core expression capture registry')
        if self.summary.ingested_capture_count != (
            capture.summary.captured_count + capture.summary.capture_failed_count
        ):
            raise ValueError('capture ingestion summary does not match capture registry')
        if self.summary.pending_capture_count != capture.summary.pending_capture_count:
            raise ValueError('capture ingestion pending count does not match capture registry')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _canonical_hash(payload: dict) -> str:
    return hashlib.sha256(
        json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
    ).hexdigest()


def _load_and_audit_receipt(root: Path, batch_id: str, receipt_payload: dict):
    if batch_id == BATCH01_ID:
        plan_payload = verify_core_expression_batch01_execution_plan(root)
        plan = CoreExpressionBatch01ExecutionPlanDef(**{
            key: value for key, value in plan_payload.items() if key != 'plan_sha256'
        })
        audit = audit_core_expression_batch01_receipt(
            receipt_payload,
            plan=plan,
            expected_plan_sha256=plan_payload['plan_sha256'],
        )
    else:
        plan_payload = verify_core_expression_batch_execution_plan(root, batch_id)
        plan = CoreExpressionBatchExecutionPlanDef(**{
            key: value for key, value in plan_payload.items() if key != 'plan_sha256'
        })
        audit = audit_core_expression_batch_receipt(
            receipt_payload,
            plan=plan,
            expected_plan_sha256=plan_payload['plan_sha256'],
        )
    if not audit.valid or not audit.plan_verified:
        raise ValueError(
            f'cannot ingest unverified receipt for {batch_id}: '
            + '; '.join(audit.errors)
        )
    return plan, plan_payload, audit


def ingest_core_expression_batch_receipt(
    root: Path,
    batch_id: str,
    receipt_payload: dict,
) -> CoreExpressionOracleCaptureIngestionDef:
    """Convert an already audited runtime receipt into capture slots."""
    root = Path(root).resolve()
    if batch_id == BATCH01_ID:
        plan_payload = verify_core_expression_batch01_execution_plan(root)
        plan = CoreExpressionBatch01ExecutionPlanDef(**{
            key: value for key, value in plan_payload.items() if key != 'plan_sha256'
        })
        audit = audit_core_expression_batch01_receipt(
            receipt_payload,
            plan=plan,
            expected_plan_sha256=plan_payload['plan_sha256'],
        )
    else:
        plan_payload = verify_core_expression_batch_execution_plan(root, batch_id)
        plan = CoreExpressionBatchExecutionPlanDef(**{
            key: value for key, value in plan_payload.items() if key != 'plan_sha256'
        })
        audit = audit_core_expression_batch_receipt(
            receipt_payload,
            plan=plan,
            expected_plan_sha256=plan_payload['plan_sha256'],
        )

    if not audit.valid or not audit.plan_verified:
        raise ValueError(
            f'cannot ingest unverified receipt for {batch_id}: ' + '; '.join(audit.errors)
        )

    plan_step_by_id = {step.candidate_id: step for step in plan.steps}
    receipt_step_by_id = {step['candidate_id']: step for step in receipt_payload['steps']}
    if set(receipt_step_by_id) - set(plan_step_by_id):
        raise ValueError('receipt contains candidate ids not present in execution plan')

    baseline = __import__('core.core_expression_oracle_capture', fromlist=['build_core_expression_oracle_capture']).build_core_expression_oracle_capture(root)
    updated_slots: List[OracleCaptureStepDef] = []
    ingested = 0
    captured = 0
    failed = 0
    for slot in baseline.capture_slots:
        receipt_step = receipt_step_by_id.get(slot.candidate_id)
        if receipt_step is None:
            updated_slots.append(slot)
            continue

        plan_step = plan_step_by_id[slot.candidate_id]
        status = receipt_step['status']
        capture_status = 'captured' if status == 'success' else 'capture_failed'
        environment = OracleCaptureEnvironmentDef(
            server_version=receipt_payload['server_version'],
            sql_compatibility=receipt_payload['sql_compatibility'],
            connected_database=receipt_payload['connected_database'],
            connected_user=receipt_payload['connected_user'],
        )
        evidence_payload = {
            'sql': slot.sql,
            'rows': receipt_step['rows'] if status == 'success' else [],
            'notices': receipt_step['notices'],
            'error': receipt_step['error'],
            'sqlstate': receipt_step['sqlstate'],
            'duration_ms': receipt_step['duration_ms'],
            'environment': environment.model_dump(),
        }
        capture_step = OracleCaptureStepDef(
            oracle_id=slot.oracle_id,
            candidate_id=slot.candidate_id,
            batch_id=batch_id,
            capability=slot.capability,
            fact_refs=list(slot.fact_refs),
            sql=slot.sql,
            capture_status=capture_status,
            captured_at=receipt_payload['finished_at'],
            duration_ms=receipt_step['duration_ms'],
            rows=receipt_step['rows'] if status == 'success' else [],
            notices=receipt_step['notices'],
            error=receipt_step['error'],
            sqlstate=receipt_step['sqlstate'],
            environment=environment,
            evidence_sha256=canonical_evidence_sha256(evidence_payload),
        )
        updated_slots.append(capture_step)
        ingested += 1
        if capture_status == 'captured':
            captured += 1
        else:
            failed += 1

    baseline = baseline.model_copy(update={'capture_slots': updated_slots})
    summary_count = len(updated_slots)
    statuses = [item.capture_status for item in updated_slots]
    capture_registry = baseline.model_copy(update={'summary': baseline.summary.model_copy(update={
        'pending_capture_count': statuses.count('pending_capture'),
        'captured_count': statuses.count('captured'),
        'capture_failed_count': statuses.count('capture_failed'),
        'evidence_count': statuses.count('captured') + statuses.count('capture_failed'),
    })})

    plan_path = (
        BATCH01_PLAN_PATH if batch_id == BATCH01_ID
        else root / 'generated/core_expression_probe_batches_v1' / f'{batch_id}_execution_plan.json'
    )
    execution_plan_sha = _sha256(plan_path)
    audit_summary = audit.summary

    return CoreExpressionOracleCaptureIngestionDef(
        id=f'core_expression_{batch_id}_capture_ingestion_v1',
        name=f'Core Expression {batch_id} Capture Ingestion',
        batch_id=batch_id,
        source=OracleCaptureIngestionSourceDef(
            batch_id=batch_id,
            execution_plan_relpath=str(plan_path.relative_to(root)),
            execution_plan_sha256=execution_plan_sha,
            receipt_relpath='<runtime receipt payload>',
            receipt_sha256=_canonical_hash(receipt_payload),
            plan_sha256=plan_payload['plan_sha256'],
        ),
        receipt_audit=OracleCaptureIngestionAuditDef(
            valid=audit.valid,
            plan_verified=audit.plan_verified,
            errors=list(audit.errors),
            summary=dict(audit_summary),
        ),
        capture_registry=capture_registry,
        summary=OracleCaptureIngestionSummaryDef(
            plan_step_count=len(plan.steps),
            receipt_step_count=len(receipt_payload['steps']),
            ingested_capture_count=ingested,
            pending_capture_count=statuses.count('pending_capture'),
            captured_count=captured,
            capture_failed_count=failed,
            evidence_hash_count=ingested,
        ),
    )


class CoreExpressionOracleCaptureIngestionRegistry:
    def __init__(self, root: Path = ROOT):
        self.root = Path(root).resolve()

    def ingest(self, batch_id: str, receipt_payload: dict) -> CoreExpressionOracleCaptureIngestionDef:
        return ingest_core_expression_batch_receipt(self.root, batch_id, receipt_payload)

    def build(self, batch_id: str) -> CoreExpressionOracleCaptureIngestionDef:
        # Kept for symmetry; no receipt artifact is assumed by this module.
        raise ValueError('runtime receipt payload is required for capture ingestion')
