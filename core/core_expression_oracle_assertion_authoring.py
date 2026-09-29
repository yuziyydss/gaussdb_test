"""Authoring schema for executable core-expression oracle assertions.

This artifact is authored only from promoted confirmed oracle items.  It does
not execute SQL, invent literal expectations, or mark assertions as verified.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import List, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_oracle_promotion import verify_core_expression_oracle_promotion

ROOT = Path(__file__).resolve().parents[1]
PROMOTION_PATH = ROOT / 'generated/core_expression_oracle_promotion_v1/executable_oracles.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.json'
MARKDOWN_PATH = ROOT / 'generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.md'

ALLOWED_ASSERTION_TYPES = {
    'no_error',
    'row_count',
    'result_shape',
    'documented_semantics',
}


class StrictAssertionAuthoringModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class AssertionAuthoringSourceDef(StrictAssertionAuthoringModel):
    promotion_relpath: str
    promotion_sha256: str

    @field_validator('promotion_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('oracle promotion path must be safe')
        return value

    @field_validator('promotion_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('oracle promotion SHA-256 must be 64 hex characters')
        return value


class OracleAssertionDraftDef(StrictAssertionAuthoringModel):
    assertion_id: str
    oracle_id: str
    candidate_id: str
    assertion_type: Literal['no_error', 'row_count', 'result_shape', 'documented_semantics']
    fact_refs: List[str]
    evidence_sha256: str
    status: Literal['pending_authoring']
    expected_literal: None = None
    expected_literal_claim: None = None

    @field_validator('assertion_id')
    @classmethod
    def ensure_assertion_id(cls, value: str) -> str:
        if re.fullmatch(r'[a-z][a-z0-9_]*', value) is None:
            raise ValueError('assertion id must be snake_case')
        return value

    @field_validator('fact_refs')
    @classmethod
    def ensure_fact_refs(cls, value: List[str]) -> List[str]:
        if not value or len(value) != len(set(value)):
            raise ValueError('assertion fact_refs must be non-empty and unique')
        return value

    @field_validator('evidence_sha256')
    @classmethod
    def ensure_evidence_hash(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('assertion evidence SHA-256 must be 64 hex characters')
        return value


class OracleAssertionAuthoringItemDef(StrictAssertionAuthoringModel):
    oracle_id: str
    candidate_id: str
    batch_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    evidence: dict
    reviewer_conclusion: str
    authoring_status: Literal['pending_authoring']
    assertion_drafts: List[OracleAssertionDraftDef] = Field(default_factory=list)
    exact_literal_claims: List[str] = Field(default_factory=list)
    runtime_verified: bool = False

    @field_validator('fact_refs')
    @classmethod
    def ensure_fact_refs(cls, value: List[str]) -> List[str]:
        if not value or len(value) != len(set(value)):
            raise ValueError('authoring fact_refs must be non-empty and unique')
        return value

    @field_validator('evidence')
    @classmethod
    def ensure_evidence_shape(cls, value: dict) -> dict:
        required = {
            'reviewer', 'reviewed_at', 'rows_json_sha256', 'notices_sha256',
            'sqlstate', 'server_version', 'sql_compatibility',
        }
        if set(value) != required:
            raise ValueError('authoring evidence fields do not match promoted oracle evidence')
        for key in ('rows_json_sha256', 'notices_sha256'):
            if re.fullmatch(r'[0-9a-f]{64}', str(value.get(key, ''))) is None:
                raise ValueError(f'authoring evidence {key} must be 64 hex characters')
        for key in ('reviewer', 'reviewed_at', 'sqlstate', 'server_version', 'sql_compatibility'):
            if not str(value.get(key, '')).strip():
                raise ValueError(f'authoring evidence {key} cannot be blank')
        return value

    @model_validator(mode='after')
    def ensure_authoring_boundary(self) -> 'OracleAssertionAuthoringItemDef':
        if self.runtime_verified:
            raise ValueError(f'authoring item {self.oracle_id} cannot claim runtime verification')
        if self.exact_literal_claims:
            raise ValueError(f'authoring item {self.oracle_id} cannot contain exact literal claims')
        for draft in self.assertion_drafts:
            if draft.oracle_id != self.oracle_id:
                raise ValueError(f'assertion {draft.assertion_id} belongs to another oracle')
            if not set(draft.fact_refs).issubset(set(self.fact_refs)):
                raise ValueError(f'assertion {draft.assertion_id} references unknown facts')
            if draft.evidence_sha256 != self.evidence['rows_json_sha256']:
                raise ValueError(f'assertion {draft.assertion_id} evidence hash must reference captured rows hash')
        return self


class OracleAssertionAuthoringSummaryDef(StrictAssertionAuthoringModel):
    promotion_item_count: int
    authoring_item_count: int
    pending_authoring_count: int
    assertion_draft_count: int
    exact_literal_claim_count: int = 0
    runtime_verified_count: int = 0
    all_promoted_items_are_scheduled: bool
    empty_without_promoted: bool
    database_executed: bool = False
    execution_authorized: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OracleAssertionAuthoringSummaryDef':
        if self.authoring_item_count != self.promotion_item_count:
            raise ValueError('assertion authoring does not cover every promoted item')
        if self.pending_authoring_count != self.authoring_item_count:
            raise ValueError('assertion authoring pending count is inconsistent')
        if self.exact_literal_claim_count != 0:
            raise ValueError('assertion authoring cannot contain exact literal claims')
        if self.runtime_verified_count != 0:
            raise ValueError('assertion authoring cannot claim runtime verification')
        if self.database_executed or self.execution_authorized:
            raise ValueError('assertion authoring cannot claim database execution')
        return self


class CoreExpressionAssertionAuthoringDef(StrictAssertionAuthoringModel):
    schema_version: int = 1
    kind: str = 'core_expression_oracle_assertion_authoring'
    id: str = 'core_expression_oracle_assertion_authoring_v1'
    name: str = 'Core Expression Oracle Assertion Authoring Sheet'
    description: str = (
        '从promoted confirmed oracle生成可执行断言编写清单；当前无promoted项时为空。'
    )
    source: AssertionAuthoringSourceDef
    allowed_assertion_types: List[str] = Field(default_factory=lambda: sorted(ALLOWED_ASSERTION_TYPES))
    authoring_items: List[OracleAssertionAuthoringItemDef]
    summary: OracleAssertionAuthoringSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'This authoring sheet does not execute SQL.',
        'A pending authoring item is not a verified oracle.',
        'Literal equality assertions are not allowed in this schema version.',
        'Exact expected values require captured database evidence and separate review.',
    ])

    @model_validator(mode='after')
    def ensure_sheet_shape(self) -> 'CoreExpressionAssertionAuthoringDef':
        oracle_ids = [item.oracle_id for item in self.authoring_items]
        if len(oracle_ids) != len(set(oracle_ids)):
            raise ValueError('assertion authoring oracle ids cannot repeat')
        if self.summary.authoring_item_count != len(self.authoring_items):
            raise ValueError('assertion authoring item count is inconsistent')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _markdown(payload: dict) -> str:
    lines = [
        '# Core Expression Oracle Assertion Authoring',
        '',
        'This sheet is generated from promoted confirmed oracle items.',
        '',
        f"- Promotion SHA-256: `{payload['source']['promotion_sha256']}`",
        f"- Authoring items: {payload['summary']['authoring_item_count']}",
        f"- Assertion drafts: {payload['summary']['assertion_draft_count']}",
        f"- Exact literal claims: {payload['summary']['exact_literal_claim_count']}",
        '',
        'Allowed assertion types:',
        '',
    ]
    lines.extend(f"- `{item}`" for item in payload['allowed_assertion_types'])
    lines.extend([
        '',
        'No promoted oracle items are available in the current baseline.',
        '',
        '## Boundary',
        '',
        '- Pending authoring is not runtime verification.',
        '- Literal equality assertions require a future schema with captured actual values.',
        '- This artifact does not execute SQL.',
    ])
    return '\n'.join(lines) + '\n'


def build_core_expression_oracle_assertion_authoring(root: Path = ROOT) -> CoreExpressionAssertionAuthoringDef:
    root = Path(root).resolve()
    promotion_payload = verify_core_expression_oracle_promotion(root)
    promotion_path = root / 'generated/core_expression_oracle_promotion_v1/executable_oracles.json'

    items: List[OracleAssertionAuthoringItemDef] = []
    assertion_count = 0
    for promoted in promotion_payload['executable_oracles']:
        evidence = dict(promoted['evidence'])
        drafts = [OracleAssertionDraftDef(
            assertion_id=f"{promoted['oracle_id']}_{assertion_type}",
            oracle_id=promoted['oracle_id'],
            candidate_id=promoted['candidate_id'],
            assertion_type=assertion_type,
            fact_refs=list(promoted['fact_refs']),
            evidence_sha256=evidence['rows_json_sha256'],
            status='pending_authoring',
            expected_literal=None,
            expected_literal_claim=None,
        ) for assertion_type in sorted(ALLOWED_ASSERTION_TYPES)]
        assertion_count += len(drafts)
        items.append(OracleAssertionAuthoringItemDef(
            oracle_id=promoted['oracle_id'],
            candidate_id=promoted['candidate_id'],
            batch_id=promoted['batch_id'],
            capability=promoted['capability'],
            fact_refs=list(promoted['fact_refs']),
            sql=promoted['sql'],
            evidence=evidence,
            reviewer_conclusion=promoted['reviewer_conclusion'],
            authoring_status='pending_authoring',
            assertion_drafts=drafts,
        ))

    return CoreExpressionAssertionAuthoringDef(
        source=AssertionAuthoringSourceDef(
            promotion_relpath=str(promotion_path.relative_to(root)),
            promotion_sha256=_sha256(promotion_path),
        ),
        authoring_items=items,
        summary=OracleAssertionAuthoringSummaryDef(
            promotion_item_count=len(promotion_payload['executable_oracles']),
            authoring_item_count=len(items),
            pending_authoring_count=len(items),
            assertion_draft_count=assertion_count,
            all_promoted_items_are_scheduled=len(items) == len(promotion_payload['executable_oracles']),
            empty_without_promoted=len(items) == 0,
        ),
    )


def build_core_expression_oracle_assertion_authoring_payloads(root: Path = ROOT) -> tuple[dict, str]:
    sheet = build_core_expression_oracle_assertion_authoring(root)
    payload = sheet.model_dump(mode='json')
    payload['authoring_sha256'] = hashlib.sha256(
        json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
    ).hexdigest()
    markdown = _markdown(payload)
    return payload, markdown


def verify_core_expression_oracle_assertion_authoring(root: Path = ROOT) -> dict:
    root = Path(root).resolve()
    if not OUTPUT_PATH.is_file() or not MARKDOWN_PATH.is_file():
        raise ValueError('core expression assertion authoring artifact is missing')
    try:
        recorded = json.loads(OUTPUT_PATH.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression assertion authoring artifact is invalid: {exc}') from exc
    current, markdown = build_core_expression_oracle_assertion_authoring_payloads(root)
    if recorded != current or MARKDOWN_PATH.read_text(encoding='utf-8') != markdown:
        raise ValueError('core expression assertion authoring artifact is stale')
    return recorded
