"""Standard capture schema for future core-expression oracle review evidence.

The baseline artifact contains one ``pending_capture`` slot per probe step.  It
does not fabricate rows, notices, SQLSTATE or runtime evidence.
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
BATCHES_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batches.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_capture_v1/captures.json'

CaptureStatus = Literal['pending_capture', 'captured', 'capture_failed']


class StrictOracleCaptureModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class OracleCaptureSourceDef(StrictOracleCaptureModel):
    batches_relpath: str
    batches_sha256: str

    @field_validator('batches_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('batch artifact path must be safe')
        return value

    @field_validator('batches_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('batch artifact SHA-256 must be 64 hex characters')
        return value


class OracleCaptureEnvironmentDef(StrictOracleCaptureModel):
    server_version: str = ''
    sql_compatibility: str = ''
    connected_database: str = ''
    connected_user: str = ''

    def is_complete(self) -> bool:
        return all(value.strip() for value in (
            self.server_version,
            self.sql_compatibility,
            self.connected_database,
            self.connected_user,
        ))

    @model_validator(mode='after')
    def ensure_only_captured_environment(self) -> 'OracleCaptureEnvironmentDef':
        if any(value.strip() for value in (
            self.server_version, self.sql_compatibility,
            self.connected_database, self.connected_user,
        )):
            if not all(value.strip() for value in (
                self.server_version, self.sql_compatibility,
                self.connected_database, self.connected_user,
            )):
                raise ValueError('captured environment must be complete or entirely blank')
        return self


class OracleCaptureStepDef(StrictOracleCaptureModel):
    oracle_id: str
    candidate_id: str
    batch_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    capture_status: CaptureStatus = 'pending_capture'
    captured_at: str = ''
    duration_ms: int | None = None
    rows: List[List[Any]] = Field(default_factory=list)
    notices: List[str] = Field(default_factory=list)
    error: str = ''
    sqlstate: str = ''
    environment: OracleCaptureEnvironmentDef = Field(default_factory=OracleCaptureEnvironmentDef)
    evidence_sha256: str = ''

    @field_validator('sql')
    @classmethod
    def ensure_single_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';') or normalized.count(';') != 1:
            raise ValueError('capture SQL must be exactly one statement ending with semicolon')
        upper = normalized[:-1].upper()
        if not upper.startswith(('SELECT ', 'WITH ')):
            raise ValueError('capture SQL must be read-only SELECT or WITH')
        for token in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
            if token in upper:
                raise ValueError(f'capture SQL contains forbidden token {token.strip()}')
        return normalized

    @field_validator('oracle_id', 'candidate_id', 'batch_id', 'capability')
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('capture identity fields cannot be blank')
        return value

    @field_validator('fact_refs')
    @classmethod
    def ensure_fact_refs(cls, value: List[str]) -> List[str]:
        if not value or len(value) != len(set(value)):
            raise ValueError('capture fact_refs must be non-empty and unique')
        return value

    @model_validator(mode='after')
    def ensure_capture_shape(self) -> 'OracleCaptureStepDef':
        if self.capture_status == 'pending_capture':
            if any([self.captured_at, self.rows, self.notices, self.error, self.sqlstate]):
                raise ValueError(f'pending capture {self.oracle_id} cannot contain captured evidence')
            if self.duration_ms is not None:
                raise ValueError(f'pending capture {self.oracle_id} cannot contain duration')
            if not self.evidence_sha256 == '':
                raise ValueError(f'pending capture {self.oracle_id} cannot contain evidence hash')
            if any(value.strip() for value in (
                self.environment.server_version,
                self.environment.sql_compatibility,
                self.environment.connected_database,
                self.environment.connected_user,
            )):
                raise ValueError(f'pending capture {self.oracle_id} cannot contain environment evidence')
            return self

        if not self.captured_at.strip():
            raise ValueError(f'non-pending capture {self.oracle_id} needs captured_at')
        if self.duration_ms is None or self.duration_ms < 0:
            raise ValueError(f'non-pending capture {self.oracle_id} needs non-negative duration_ms')

        if self.capture_status == 'captured':
            if self.error:
                raise ValueError(f'captured success {self.oracle_id} cannot contain error')
            if not self.rows:
                raise ValueError(f'captured success {self.oracle_id} must contain rows')
            if not self.sqlstate:
                raise ValueError(f'captured success {self.oracle_id} must contain SQLSTATE')
            if not self.environment.is_complete():
                raise ValueError(f'captured success {self.oracle_id} must contain environment')

        if self.capture_status == 'capture_failed':
            if not self.error:
                raise ValueError(f'capture failure {self.oracle_id} needs error')
            if not self.sqlstate:
                raise ValueError(f'capture failure {self.oracle_id} needs SQLSTATE')
            if self.rows:
                raise ValueError(f'capture failure {self.oracle_id} cannot contain rows')

        if not self.evidence_sha256:
            raise ValueError(f'non-pending capture {self.oracle_id} needs evidence hash')
        return self

    def canonical_evidence_payload(self) -> Dict[str, Any]:
        return {
            'sql': self.sql,
            'rows': self.rows,
            'notices': self.notices,
            'error': self.error,
            'sqlstate': self.sqlstate,
            'duration_ms': self.duration_ms,
            'environment': self.environment.model_dump(),
        }


class OracleCaptureSummaryDef(StrictOracleCaptureModel):
    probe_plan_step_count: int
    capture_slot_count: int
    pending_capture_count: int
    captured_count: int
    capture_failed_count: int
    evidence_count: int
    all_steps_have_capture_slots: bool
    database_executed: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OracleCaptureSummaryDef':
        if self.capture_slot_count != self.probe_plan_step_count:
            raise ValueError('capture slots do not cover probe plan')
        if self.pending_capture_count + self.captured_count + self.capture_failed_count != self.capture_slot_count:
            raise ValueError('capture status counts are inconsistent')
        if self.evidence_count != self.captured_count + self.capture_failed_count:
            raise ValueError('capture evidence count is inconsistent')
        if self.database_executed or self.runtime_verified:
            raise ValueError('capture schema cannot claim runtime verification')
        return self


class CoreExpressionOracleCaptureDef(StrictOracleCaptureModel):
    schema_version: int = 1
    kind: str = 'core_expression_oracle_capture_registry'
    id: str = 'core_expression_oracle_capture_v1'
    name: str = 'Core Expression Oracle Capture Registry'
    description: str = (
        '94个SQL probe的标准捕获槽位与evidence hash规则；基线全部pending_capture，不含伪造证据。'
    )
    source: OracleCaptureSourceDef
    capture_schema: Dict[str, str] = Field(default_factory=lambda: {
        'rows': 'List[List[Any]] captured in server return order.',
        'notices': 'List[String] in server emission order.',
        'error': 'Error text for failed capture; empty for successful capture.',
        'sqlstate': 'Database SQLSTATE or vendor status code.',
        'duration_ms': 'Non-negative execution duration in milliseconds.',
        'server_version': 'value returned by version().',
        'sql_compatibility': 'value returned by current_setting(sql_compatibility).',
        'connected_database': 'value returned by current_database().',
        'connected_user': 'value returned by current_user().',
    })
    evidence_hash_rule: str = (
        'SHA-256 over canonical JSON: sort_keys=true, separators=(,), ensure_ascii=False; '
        'payload keys are sql, rows, notices, error, sqlstate, duration_ms, environment.'
    )
    capture_slots: List[OracleCaptureStepDef]
    summary: OracleCaptureSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'A pending capture has no database evidence.',
        'A capture result is not an oracle review decision.',
        'This registry does not execute SQL or create runtime receipts.',
        'Captured evidence must be reviewed before executable oracle promotion.',
    ])

    @model_validator(mode='after')
    def ensure_registry_shape(self) -> 'CoreExpressionOracleCaptureDef':
        oracle_ids = [item.oracle_id for item in self.capture_slots]
        candidate_ids = [item.candidate_id for item in self.capture_slots]
        if len(oracle_ids) != len(set(oracle_ids)):
            raise ValueError('capture oracle ids cannot repeat')
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('capture candidate ids cannot repeat')
        if self.summary.capture_slot_count != len(self.capture_slots):
            raise ValueError('capture registry summary count is inconsistent')
        return self


def canonical_evidence_sha256(payload: Dict[str, Any]) -> str:
    """Return the canonical evidence hash used by this capture schema."""
    canonical = json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':'))
    return hashlib.sha256(canonical.encode('utf-8')).hexdigest()


def build_core_expression_oracle_capture(root: Path = ROOT) -> CoreExpressionOracleCaptureDef:
    root = Path(root).resolve()
    batch_payload = verify_core_expression_probe_batches(root)
    slots: List[OracleCaptureStepDef] = []
    for batch in batch_payload['batches']:
        for step in batch['steps']:
            slots.append(OracleCaptureStepDef(
                oracle_id=f'oracle_{step["candidate_id"]}',
                candidate_id=step['candidate_id'],
                batch_id=batch['id'],
                capability=step['capability'],
                fact_refs=list(step['fact_refs']),
                sql=step['sql'],
            ))
    statuses = [item.capture_status for item in slots]
    return CoreExpressionOracleCaptureDef(
        source=OracleCaptureSourceDef(
            batches_relpath=str(BATCHES_PATH.relative_to(root)),
            batches_sha256=hashlib.sha256(BATCHES_PATH.read_bytes()).hexdigest(),
        ),
        capture_slots=slots,
        summary=OracleCaptureSummaryDef(
            probe_plan_step_count=batch_payload['summary']['batched_step_count'],
            capture_slot_count=len(slots),
            pending_capture_count=statuses.count('pending_capture'),
            captured_count=statuses.count('captured'),
            capture_failed_count=statuses.count('capture_failed'),
            evidence_count=sum(item.capture_status != 'pending_capture' for item in slots),
            all_steps_have_capture_slots=len(slots) == batch_payload['summary']['batched_step_count'],
        ),
    )


class CoreExpressionOracleCaptureRegistry:
    def __init__(self, root: Path = ROOT):
        self.root = Path(root).resolve()

    def build(self) -> CoreExpressionOracleCaptureDef:
        return build_core_expression_oracle_capture(self.root)

    def verify(self) -> CoreExpressionOracleCaptureDef:
        path = self.root / 'generated/core_expression_oracle_capture_v1/captures.json'
        if not path.is_file():
            raise ValueError('core expression oracle capture artifact is missing')
        try:
            recorded = json.loads(path.read_text(encoding='utf-8'))
        except Exception as exc:
            raise ValueError(f'core expression oracle capture artifact is invalid: {exc}') from exc
        current = self.build().model_dump(mode='json')
        if recorded != current:
            raise ValueError('core expression oracle capture artifact is stale')
        return self.build()

    @staticmethod
    def hash_capture(step: OracleCaptureStepDef) -> str:
        return canonical_evidence_sha256(step.canonical_evidence_payload())


def verify_core_expression_oracle_capture(root: Path = ROOT) -> CoreExpressionOracleCaptureDef:
    return CoreExpressionOracleCaptureRegistry(root).verify()
