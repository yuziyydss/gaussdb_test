"""Expected-oracle drafts for the 94 core expression SQL probes.

This is a static review artifact.  It records what must be captured and which
document facts will be reviewed.  It deliberately does not invent expected
literal values or claim database verification.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_probe_batches import verify_core_expression_probe_batches

ROOT = Path(__file__).resolve().parents[1]
PROBE_PLAN_PATH = ROOT / 'generated/core_expression_probe_plan_v1/dry_run.json'
BATCHES_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batches.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'


class StrictOracleDraftModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class OracleDraftSourceDef(StrictOracleDraftModel):
    probe_plan_relpath: str
    probe_plan_sha256: str
    batches_relpath: str
    batches_sha256: str

    @field_validator('probe_plan_relpath', 'batches_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('oracle draft source path must be safe')
        return value

    @field_validator('probe_plan_sha256', 'batches_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('oracle draft source SHA-256 must be 64 hex characters')
        return value


class OracleCaptureSpecDef(StrictOracleDraftModel):
    rows: bool = True
    notices: bool = True
    error: bool = True
    sqlstate: bool = True
    duration_ms: bool = True
    server_version: bool = True
    sql_compatibility: bool = True


class OracleDraftStepDef(StrictOracleDraftModel):
    oracle_id: str
    batch_id: str
    batch_order: int = Field(ge=1)
    plan_order: int = Field(ge=1)
    candidate_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    expected_shape: Literal['to_be_captured']
    expected_literal_claims: List[str]
    planned_assertions: List[str]
    capture: OracleCaptureSpecDef
    oracle_status: Literal['needs_verification']
    draft_status: Literal['ready_for_review']

    @field_validator('expected_literal_claims')
    @classmethod
    def forbid_expected_literals(cls, value: List[str]) -> List[str]:
        if value:
            raise ValueError('oracle draft cannot contain expected literal claims')
        return value

    @field_validator('fact_refs')
    @classmethod
    def ensure_fact_refs(cls, value: List[str]) -> List[str]:
        if not value:
            raise ValueError('oracle draft step needs fact_refs')
        if len(value) != len(set(value)):
            raise ValueError('oracle draft fact_refs cannot repeat')
        return value

    @field_validator('sql')
    @classmethod
    def ensure_single_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';') or normalized.count(';') != 1:
            raise ValueError('oracle draft SQL must be exactly one statement ending with semicolon')
        upper = normalized[:-1].upper()
        if not upper.startswith(('SELECT ', 'WITH ')):
            raise ValueError('oracle draft SQL must be read-only SELECT or WITH')
        for token in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
            if token in upper:
                raise ValueError(f'oracle draft SQL contains forbidden token {token.strip()}')
        return normalized


class OracleDraftSummaryDef(StrictOracleDraftModel):
    probe_plan_step_count: int
    oracle_draft_count: int
    batch_count: int
    fact_reference_count: int
    unique_fact_count: int
    exact_value_assertion_count: int = 0
    needs_verification_count: int
    ready_for_review_count: int
    all_steps_drafted: bool
    runtime_executed: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OracleDraftSummaryDef':
        if self.oracle_draft_count != self.probe_plan_step_count:
            raise ValueError('oracle draft count does not cover probe plan')
        if self.needs_verification_count != self.oracle_draft_count:
            raise ValueError('oracle draft needs_verification count is inconsistent')
        if self.ready_for_review_count != self.oracle_draft_count:
            raise ValueError('oracle draft ready_for_review count is inconsistent')
        if self.exact_value_assertion_count != 0:
            raise ValueError('oracle draft cannot claim exact expected values')
        if self.runtime_executed or self.runtime_verified:
            raise ValueError('oracle draft cannot claim runtime execution')
        return self


class CoreExpressionOracleDraftDef(StrictOracleDraftModel):
    schema_version: int = 1
    kind: str = 'core_expression_oracle_draft'
    id: str = 'core_expression_oracle_draft_v1'
    name: str = 'Core Expression Expected Oracle Draft'
    description: str = (
        '94个只读SQL probe的expected oracle草案；只定义捕获字段与待验证断言，不声明具体输出值。'
    )
    source: OracleDraftSourceDef
    steps: List[OracleDraftStepDef]
    summary: OracleDraftSummaryDef
    next_actions: List[str] = Field(default_factory=lambda: [
        'Capture actual rows, SQLSTATE, notices and duration for each probe.',
        'Compare captured results against the referenced Wave 1A/1B facts.',
        'Promote stable checks to executable oracle assertions only after target review.',
        'Keep exact expected values empty until database evidence is captured.',
    ])
    limits: List[str] = Field(default_factory=lambda: [
        'This artifact does not connect to GaussDB or execute SQL.',
        'A draft oracle is not a runtime receipt.',
        'Exact result values are intentionally absent.',
        'A fact reference does not by itself prove target database behavior.',
    ])

    @model_validator(mode='after')
    def ensure_draft_shape(self) -> 'CoreExpressionOracleDraftDef':
        oracle_ids = [item.oracle_id for item in self.steps]
        if len(oracle_ids) != len(set(oracle_ids)):
            raise ValueError('oracle draft ids cannot repeat')
        candidate_ids = [item.candidate_id for item in self.steps]
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('oracle draft candidate ids cannot repeat')
        if self.summary.oracle_draft_count != len(self.steps):
            raise ValueError('oracle draft summary count is inconsistent')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_core_expression_oracle_draft(root: Path = ROOT) -> CoreExpressionOracleDraftDef:
    root = Path(root).resolve()
    verify_core_expression_probe_batches(root)

    probe_payload = json.loads(PROBE_PLAN_PATH.read_text(encoding='utf-8'))
    batches_payload = json.loads(BATCHES_PATH.read_text(encoding='utf-8'))
    batch_by_step: Dict[int, dict] = {}
    for batch in batches_payload['batches']:
        for step in batch['steps']:
            batch_by_step[step['probe_plan_order']] = {
                'batch_id': batch['id'],
                'batch_order': step['batch_order'],
            }

    draft_steps: List[OracleDraftStepDef] = []
    fact_reference_count = 0
    for probe_step in probe_payload['steps']:
        plan_order = probe_step['plan_order']
        location = batch_by_step.get(plan_order)
        if location is None:
            raise ValueError(f'probe step {probe_step["candidate_id"]} is not present in batch plan')
        fact_reference_count += len(probe_step['fact_refs'])
        draft_steps.append(OracleDraftStepDef(
            oracle_id=f'oracle_{probe_step["candidate_id"]}',
            batch_id=location['batch_id'],
            batch_order=location['batch_order'],
            plan_order=plan_order,
            candidate_id=probe_step['candidate_id'],
            capability=probe_step['capability'],
            fact_refs=list(probe_step['fact_refs']),
            sql=probe_step['sql'],
            expected_shape='to_be_captured',
            expected_literal_claims=[],
            planned_assertions=[
                'no_unexpected_error',
                'rows_are_captured',
                'sqlstate_is_captured',
                'result_semantics_are_reviewed_against_fact_refs',
            ],
            capture=OracleCaptureSpecDef(),
            oracle_status='needs_verification',
            draft_status='ready_for_review',
        ))

    draft_steps.sort(key=lambda item: (item.batch_id, item.batch_order, item.plan_order))
    unique_fact_count = len({fact for step in draft_steps for fact in step.fact_refs})
    return CoreExpressionOracleDraftDef(
        source=OracleDraftSourceDef(
            probe_plan_relpath=str(PROBE_PLAN_PATH.relative_to(root)),
            probe_plan_sha256=_sha256(PROBE_PLAN_PATH),
            batches_relpath=str(BATCHES_PATH.relative_to(root)),
            batches_sha256=_sha256(BATCHES_PATH),
        ),
        steps=draft_steps,
        summary=OracleDraftSummaryDef(
            probe_plan_step_count=len(probe_payload['steps']),
            oracle_draft_count=len(draft_steps),
            batch_count=len(batches_payload['batches']),
            fact_reference_count=fact_reference_count,
            unique_fact_count=unique_fact_count,
            needs_verification_count=len(draft_steps),
            ready_for_review_count=len(draft_steps),
            all_steps_drafted=len(draft_steps) == len(probe_payload['steps']),
        ),
    )


def build_core_expression_oracle_draft_payload(root: Path = ROOT) -> dict:
    draft = build_core_expression_oracle_draft(root)
    payload = draft.model_dump(mode='json')
    payload['draft_sha256'] = hashlib.sha256(
        json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
    ).hexdigest()
    return payload


def verify_core_expression_oracle_draft(root: Path = ROOT) -> dict:
    root = Path(root).resolve()
    if not OUTPUT_PATH.is_file():
        raise ValueError('core expression oracle draft artifact is missing')
    try:
        recorded = json.loads(OUTPUT_PATH.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression oracle draft artifact is invalid: {exc}') from exc
    current = build_core_expression_oracle_draft_payload(root)
    if recorded != current:
        raise ValueError('core expression oracle draft artifact is stale')
    return recorded
