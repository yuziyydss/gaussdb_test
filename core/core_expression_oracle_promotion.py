"""Promote confirmed oracle review decisions into executable-oracle candidates.

Only decisions marked ``confirmed`` with complete evidence may enter this
artifact.  Pending, needs-revision and blocked decisions are excluded.  This
module does not execute SQL and does not claim runtime verification.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import List, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_oracle_review_decision import verify_core_expression_oracle_review_decisions
from core.core_expression_oracle_draft import verify_core_expression_oracle_draft

ROOT = Path(__file__).resolve().parents[1]
DECISIONS_PATH = ROOT / 'generated/core_expression_oracle_review_decisions_v1/review_decisions.json'
DRAFT_PATH = ROOT / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_promotion_v1/executable_oracles.json'


class StrictOraclePromotionModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class OraclePromotionSourceDef(StrictOraclePromotionModel):
    decisions_relpath: str
    decisions_sha256: str
    oracle_draft_relpath: str
    oracle_draft_sha256: str

    @field_validator('decisions_relpath', 'oracle_draft_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('oracle promotion source path must be safe')
        return value

    @field_validator('decisions_sha256', 'oracle_draft_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('oracle promotion source SHA-256 must be 64 hex characters')
        return value


class OraclePromotionEvidenceDef(StrictOraclePromotionModel):
    reviewer: str
    reviewed_at: str
    rows_json_sha256: str
    notices_sha256: str
    sqlstate: str
    server_version: str
    sql_compatibility: str
    notes: str = ''


class ExecutableOracleDef(StrictOraclePromotionModel):
    oracle_id: str
    candidate_id: str
    batch_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    planned_assertions: List[str]
    evidence: OraclePromotionEvidenceDef
    reviewer_conclusion: str
    promotion_status: Literal['ready_for_assertion_authoring']
    exact_literal_claims: List[str] = Field(default_factory=list)
    runtime_verified: bool = False

    @field_validator('fact_refs')
    @classmethod
    def ensure_fact_refs(cls, value: List[str]) -> List[str]:
        if not value:
            raise ValueError('executable oracle fact_refs cannot be empty')
        if len(value) != len(set(value)):
            raise ValueError('executable oracle fact_refs cannot repeat')
        return value

    @field_validator('sql')
    @classmethod
    def ensure_single_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';') or normalized.count(';') != 1:
            raise ValueError('executable oracle SQL must be exactly one statement ending with semicolon')
        upper = normalized[:-1].upper()
        if not upper.startswith(('SELECT ', 'WITH ')):
            raise ValueError('executable oracle SQL must be read-only SELECT or WITH')
        for token in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
            if token in upper:
                raise ValueError(f'executable oracle SQL contains forbidden token {token.strip()}')
        return normalized

    @model_validator(mode='after')
    def ensure_promotion_boundary(self) -> 'ExecutableOracleDef':
        if self.runtime_verified:
            raise ValueError('promotion cannot claim runtime verification')
        if self.promotion_status != 'ready_for_assertion_authoring':
            raise ValueError('executable oracle promotion status is inconsistent')
        return self


class OraclePromotionSummaryDef(StrictOraclePromotionModel):
    decision_count: int
    confirmed_decision_count: int
    pending_decision_count: int
    needs_revision_decision_count: int
    blocked_decision_count: int
    promoted_count: int
    excluded_count: int
    all_promoted_items_are_confirmed: bool
    promotion_complete: bool
    empty_without_confirmed: bool
    database_executed: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OraclePromotionSummaryDef':
        if self.decision_count != (
            self.confirmed_decision_count + self.pending_decision_count
            + self.needs_revision_decision_count + self.blocked_decision_count
        ):
            raise ValueError('oracle promotion decision counts are inconsistent')
        if self.promoted_count != self.confirmed_decision_count:
            raise ValueError('oracle promotion must promote every confirmed decision')
        if self.excluded_count != self.decision_count - self.confirmed_decision_count:
            raise ValueError('oracle promotion excluded count is inconsistent')
        if self.all_promoted_items_are_confirmed != (self.promoted_count == self.confirmed_decision_count):
            raise ValueError('oracle promotion confirmed flag is inconsistent')
        if self.promotion_complete != (self.promoted_count == self.confirmed_decision_count):
            raise ValueError('oracle promotion complete flag is inconsistent')
        if self.empty_without_confirmed != (self.promoted_count == 0 if self.confirmed_decision_count == 0 else True):
            raise ValueError('oracle promotion empty flag is inconsistent')
        if self.database_executed or self.runtime_verified:
            raise ValueError('oracle promotion cannot claim runtime evidence')
        return self


class CoreExpressionOraclePromotionDef(StrictOraclePromotionModel):
    schema_version: int = 1
    kind: str = 'core_expression_executable_oracle_promotion'
    id: str = 'core_expression_executable_oracle_promotion_v1'
    name: str = 'Core Expression Executable Oracle Promotion'
    description: str = (
        '仅允许confirmed且证据完整的oracle决策进入executable oracle候选；pending/needs_revision/blocked全部排除。'
    )
    source: OraclePromotionSourceDef
    executable_oracles: List[ExecutableOracleDef]
    excluded_oracle_ids: List[str]
    summary: OraclePromotionSummaryDef
    next_actions: List[str] = Field(default_factory=lambda: [
        'Author executable assertions only from promoted confirmed items.',
        'Preserve captured rows and notices hashes with each assertion.',
        'Keep pending, needs_revision and blocked items out of execution.',
    ])
    limits: List[str] = Field(default_factory=lambda: [
        'Promotion does not execute SQL.',
        'Promotion does not create a runtime receipt.',
        'A confirmed review still does not prove complete value-domain coverage.',
    ])

    @model_validator(mode='after')
    def ensure_promotion_shape(self) -> 'CoreExpressionOraclePromotionDef':
        promoted_ids = [item.oracle_id for item in self.executable_oracles]
        if len(promoted_ids) != len(set(promoted_ids)):
            raise ValueError('promoted oracle ids cannot repeat')
        if self.summary.promoted_count != len(self.executable_oracles):
            raise ValueError('oracle promotion count is inconsistent')
        if self.summary.excluded_count != len(self.excluded_oracle_ids):
            raise ValueError('oracle promotion excluded count is inconsistent')
        if set(self.excluded_oracle_ids) & set(promoted_ids):
            raise ValueError('an oracle cannot be both promoted and excluded')
        expected_excluded_count = self.summary.decision_count - self.summary.promoted_count
        if len(self.excluded_oracle_ids) != expected_excluded_count:
            raise ValueError('oracle promotion exclusion list is incomplete')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_core_expression_oracle_promotion(root: Path = ROOT) -> CoreExpressionOraclePromotionDef:
    root = Path(root).resolve()
    decisions = verify_core_expression_oracle_review_decisions(root)
    draft_payload = verify_core_expression_oracle_draft(root)
    draft_by_id = {step['oracle_id']: step for step in draft_payload['steps']}
    decisions_path = root / 'generated/core_expression_oracle_review_decisions_v1/review_decisions.json'
    draft_path = root / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'

    promoted: List[ExecutableOracleDef] = []
    excluded: List[str] = []
    for decision in decisions.decisions:
        if decision.decision != 'confirmed':
            excluded.append(decision.oracle_id)
            continue
        draft_step = draft_by_id.get(decision.oracle_id)
        if draft_step is None:
            raise ValueError(f'confirmed decision {decision.oracle_id} has no oracle draft')
        if decision.evidence is None:
            raise ValueError(f'confirmed decision {decision.oracle_id} has no evidence')
        promoted.append(ExecutableOracleDef(
            oracle_id=decision.oracle_id,
            candidate_id=decision.candidate_id,
            batch_id=decision.batch_id,
            capability=decision.capability,
            fact_refs=list(decision.fact_refs),
            sql=draft_step['sql'],
            planned_assertions=list(draft_step['planned_assertions']),
            evidence=OraclePromotionEvidenceDef(
                reviewer=decision.evidence.reviewer,
                reviewed_at=decision.evidence.reviewed_at,
                rows_json_sha256=decision.evidence.rows_json_sha256,
                notices_sha256=decision.evidence.notices_sha256,
                sqlstate=decision.evidence.sqlstate,
                server_version=decision.evidence.server_version,
                sql_compatibility=decision.evidence.sql_compatibility,
                notes=decision.evidence.notes,
            ),
            reviewer_conclusion=decision.reason,
            promotion_status='ready_for_assertion_authoring',
        ))

    excluded.sort()
    statuses = [item.decision for item in decisions.decisions]
    confirmed_count = statuses.count('confirmed')
    return CoreExpressionOraclePromotionDef(
        source=OraclePromotionSourceDef(
            decisions_relpath=str(decisions_path.relative_to(root)),
            decisions_sha256=_sha256(decisions_path),
            oracle_draft_relpath=str(draft_path.relative_to(root)),
            oracle_draft_sha256=_sha256(draft_path),
        ),
        executable_oracles=promoted,
        excluded_oracle_ids=excluded,
        summary=OraclePromotionSummaryDef(
            decision_count=len(decisions.decisions),
            confirmed_decision_count=confirmed_count,
            pending_decision_count=statuses.count('pending'),
            needs_revision_decision_count=statuses.count('needs_revision'),
            blocked_decision_count=statuses.count('blocked'),
            promoted_count=len(promoted),
            excluded_count=len(excluded),
            all_promoted_items_are_confirmed=True,
            promotion_complete=True,
            empty_without_confirmed=True,
        ),
    )


def build_core_expression_oracle_promotion_payload(root: Path = ROOT) -> dict:
    promotion = build_core_expression_oracle_promotion(root)
    payload = promotion.model_dump(mode='json')
    payload['promotion_sha256'] = hashlib.sha256(
        json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
    ).hexdigest()
    return payload


def verify_core_expression_oracle_promotion(root: Path = ROOT) -> dict:
    root = Path(root).resolve()
    if not OUTPUT_PATH.is_file():
        raise ValueError('core expression oracle promotion artifact is missing')
    try:
        recorded = json.loads(OUTPUT_PATH.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression oracle promotion artifact is invalid: {exc}') from exc
    current = build_core_expression_oracle_promotion_payload(root)
    if recorded != current:
        raise ValueError('core expression oracle promotion artifact is stale')
    return recorded
