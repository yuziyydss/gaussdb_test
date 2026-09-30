"""Decision registry for core-expression oracle human review.

The baseline artifact keeps every oracle as ``pending``.  Confirmed or blocked
decisions require explicit reviewer evidence; this module never invents them.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_oracle_review_sheet import verify_core_expression_oracle_review_sheet

ROOT = Path(__file__).resolve().parents[1]
REVIEW_SHEET_PATH = ROOT / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_review_decisions_v1/review_decisions.json'

DecisionStatus = Literal['pending', 'confirmed', 'needs_revision', 'blocked']


class StrictOracleDecisionModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class OracleDecisionSourceDef(StrictOracleDecisionModel):
    review_sheet_relpath: str
    review_sheet_sha256: str

    @field_validator('review_sheet_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('review sheet path must be safe')
        return value

    @field_validator('review_sheet_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('review sheet SHA-256 must be 64 hex characters')
        return value


class OracleReviewEvidenceDef(StrictOracleDecisionModel):
    reviewer: str
    reviewed_at: str
    rows_json_sha256: str
    notices_sha256: str
    sqlstate: str
    server_version: str
    sql_compatibility: str
    notes: str = ''

    @field_validator('reviewer', 'reviewed_at', 'sqlstate', 'server_version', 'sql_compatibility')
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('confirmed oracle evidence fields cannot be blank')
        return value

    @field_validator('rows_json_sha256', 'notices_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('captured evidence SHA-256 must be 64 hex characters')
        return value


class OracleDecisionStepDef(StrictOracleDecisionModel):
    oracle_id: str
    candidate_id: str
    batch_id: str
    capability: str
    fact_refs: List[str]
    decision: DecisionStatus = 'pending'
    reason: str = ''
    evidence: Optional[OracleReviewEvidenceDef] = None

    @field_validator('oracle_id', 'candidate_id', 'batch_id', 'capability')
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('oracle decision fields cannot be blank')
        return value

    @field_validator('fact_refs')
    @classmethod
    def ensure_fact_refs(cls, value: List[str]) -> List[str]:
        if not value or len(value) != len(set(value)):
            raise ValueError('oracle decision fact_refs must be non-empty and unique')
        return value

    @model_validator(mode='after')
    def ensure_decision_evidence(self) -> 'OracleDecisionStepDef':
        if self.decision == 'pending':
            if self.evidence is not None:
                raise ValueError(f'pending oracle {self.oracle_id} cannot have evidence')
            if self.reason:
                raise ValueError(f'pending oracle {self.oracle_id} cannot have a decision reason')
        elif self.decision == 'confirmed':
            if self.evidence is None:
                raise ValueError(f'confirmed oracle {self.oracle_id} requires captured evidence')
            if not self.reason:
                raise ValueError(f'confirmed oracle {self.oracle_id} requires reviewer conclusion')
        else:
            if not self.reason:
                raise ValueError(f'{self.decision} oracle {self.oracle_id} requires reason')
            if self.evidence is not None and not self.reason:
                raise ValueError(f'{self.decision} oracle {self.oracle_id} requires reason')
        return self


class OracleDecisionSummaryDef(StrictOracleDecisionModel):
    review_step_count: int
    decision_count: int
    pending_count: int
    confirmed_count: int
    needs_revision_count: int
    blocked_count: int
    confirmed_with_complete_evidence_count: int
    executable_oracle_candidate_count: int = 0
    all_decisions_recorded: bool

    database_executed: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OracleDecisionSummaryDef':
        if self.decision_count != self.review_step_count:
            raise ValueError('oracle decision count does not cover review sheet')
        if self.pending_count + self.confirmed_count + self.needs_revision_count + self.blocked_count != self.decision_count:
            raise ValueError('oracle decision status counts are inconsistent')
        if self.confirmed_with_complete_evidence_count != self.confirmed_count:
            raise ValueError('confirmed oracle evidence count is inconsistent')
        if self.executable_oracle_candidate_count != self.confirmed_count:
            raise ValueError('executable oracle candidate count is inconsistent')
        if self.database_executed or self.runtime_verified:
            raise ValueError('decision registry cannot claim runtime execution')
        return self


class CoreExpressionOracleReviewDecisionRegistryDef(StrictOracleDecisionModel):
    schema_version: int = 1
    kind: str = 'core_expression_oracle_review_decisions'
    id: str = 'core_expression_oracle_review_decisions_v1'
    name: str = 'Core Expression Oracle Review Decision Registry'
    description: str = (
        '94个oracle review项的决策登记；基线全部pending，确认必须提供reviewer与捕获证据。'
    )
    source: OracleDecisionSourceDef
    decisions: List[OracleDecisionStepDef]
    summary: OracleDecisionSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'A pending decision has no database evidence.',
        'A confirmed decision still does not prove complete value-domain coverage.',
        'This registry does not execute SQL or create runtime receipts.',
        'Executable oracle assertions require a separate promotion artifact.',
    ])

    @model_validator(mode='after')
    def ensure_registry_shape(self) -> 'CoreExpressionOracleReviewDecisionRegistryDef':
        oracle_ids = [item.oracle_id for item in self.decisions]
        candidate_ids = [item.candidate_id for item in self.decisions]
        if len(oracle_ids) != len(set(oracle_ids)):
            raise ValueError('oracle decision ids cannot repeat')
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('oracle decision candidate ids cannot repeat')
        if self.summary.decision_count != len(self.decisions):
            raise ValueError('oracle decision summary count is inconsistent')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_core_expression_oracle_review_decisions(root: Path = ROOT) -> CoreExpressionOracleReviewDecisionRegistryDef:
    root = Path(root).resolve()
    sheet_payload = verify_core_expression_oracle_review_sheet(root)
    sheet_path = root / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.json'
    decisions = [OracleDecisionStepDef(
        oracle_id=step['oracle_id'],
        candidate_id=step['candidate_id'],
        batch_id=step['batch_id'],
        capability=step['capability'],
        fact_refs=list(step['fact_refs']),
        decision='pending',
    ) for step in sheet_payload['steps']]
    statuses = [item.decision for item in decisions]
    confirmed_count = statuses.count('confirmed')
    return CoreExpressionOracleReviewDecisionRegistryDef(
        source=OracleDecisionSourceDef(
            review_sheet_relpath=str(REVIEW_SHEET_PATH.relative_to(root)),
            review_sheet_sha256=_sha256(REVIEW_SHEET_PATH),
        ),
        decisions=decisions,
        summary=OracleDecisionSummaryDef(
            review_step_count=len(decisions),
            decision_count=len(decisions),
            pending_count=statuses.count('pending'),
            confirmed_count=confirmed_count,
            needs_revision_count=statuses.count('needs_revision'),
            blocked_count=statuses.count('blocked'),
            confirmed_with_complete_evidence_count=confirmed_count,
            executable_oracle_candidate_count=confirmed_count,
            all_decisions_recorded=True,
        ),
    )


def validate_core_expression_oracle_review_decisions(
    decisions_payload: dict,
    *,
    root: Path = ROOT,
) -> CoreExpressionOracleReviewDecisionRegistryDef:
    """Validate a decision payload against the current review sheet."""
    root = Path(root).resolve()
    sheet_payload = verify_core_expression_oracle_review_sheet(root)
    expected_ids = [step['oracle_id'] for step in sheet_payload['steps']]
    actual_ids = [item.get('oracle_id') for item in decisions_payload.get('decisions', [])]
    if len(actual_ids) != len(expected_ids) or sorted(actual_ids) != sorted(expected_ids):
        raise ValueError('oracle decisions must cover every review sheet step exactly once')
    statuses = [item.get('decision', 'pending') for item in decisions_payload['decisions']]
    summary = dict(decisions_payload.get('summary', {}))
    summary.update({
        'review_step_count': len(decisions_payload['decisions']),
        'decision_count': len(decisions_payload['decisions']),
        'pending_count': statuses.count('pending'),
        'confirmed_count': statuses.count('confirmed'),
        'needs_revision_count': statuses.count('needs_revision'),
        'blocked_count': statuses.count('blocked'),
        'confirmed_with_complete_evidence_count': statuses.count('confirmed'),
        'executable_oracle_candidate_count': statuses.count('confirmed'),
        'all_decisions_recorded': True,
    })
    decisions_payload['summary'] = summary
    return CoreExpressionOracleReviewDecisionRegistryDef(**decisions_payload)


class CoreExpressionOracleReviewDecisionRegistry:
    def __init__(self, root: Path = ROOT):
        self.root = Path(root).resolve()

    def build(self) -> CoreExpressionOracleReviewDecisionRegistryDef:
        return build_core_expression_oracle_review_decisions(self.root)

    def verify(self) -> CoreExpressionOracleReviewDecisionRegistryDef:
        path = self.root / 'generated/core_expression_oracle_review_decisions_v1/review_decisions.json'
        if not path.is_file():
            raise ValueError('core expression oracle decision artifact is missing')
        try:
            recorded = json.loads(path.read_text(encoding='utf-8'))
        except Exception as exc:
            raise ValueError(f'core expression oracle decision artifact is invalid: {exc}') from exc
        current = build_core_expression_oracle_review_decisions(self.root)
        if recorded != current.model_dump(mode='json'):
            raise ValueError('core expression oracle decision artifact is stale')
        return current


def verify_core_expression_oracle_review_decisions(root: Path = ROOT) -> CoreExpressionOracleReviewDecisionRegistryDef:
    return CoreExpressionOracleReviewDecisionRegistry(root).verify()
