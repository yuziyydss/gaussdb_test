"""Screen core-expression candidates into a fixture-free static SQL dry-run plan.

The plan is not execution authorization.  It only selects read-only,
compatibility-neutral, object-free candidates for later authorized review.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_candidate_chain import CoreExpressionCandidateChainRegistry


ROOT = Path(__file__).resolve().parents[1]
CHAIN_PATH = ROOT / 'generated/core_expression_candidate_chain_v1/candidates.json'
OUTPUT_PATH = ROOT / 'generated/core_expression_probe_plan_v1/dry_run.json'

ALLOWED_CAPABILITIES = {
    'numeric_type_domain',
    'boolean_and_bit',
    'string_domain',
    'numeric_functions',
    'datetime_functions',
    'type_conversion',
    'json_domain',
    'hll_domain',
    'array_domain',
    'range_domain',
    'aggregate_domain',
    'window_domain',
    'conditional_domain',
    'expression_semantics',
}

STATEFUL_TOKEN_RE = re.compile(
    r'\b(CURRENT_DATE|CURRENT_TIME|CURRENT_TIMESTAMP|LOCALTIME|LOCALTIMESTAMP|'
    r'NOW\s*\(|SYSDATE|STATEMENT_TIMESTAMP|TRANSACTION_TIMESTAMP|CLOCK_TIMESTAMP|'
    r'TIMEOFDAY|PG_SLEEP|CURRENT_USER|SESSION_USER|CURRENT_SCHEMA|CURRENT_CATALOG)\b',
    re.IGNORECASE,
)
COMPATIBILITY_TOKEN_RE = re.compile(
    r'\b(LPAD_S|NVL\s*\(|NVL2\s*\(|DECODE\s*\(|IF\s*\(|IFNULL\s*\(|'
    r'EMPTY_BLOB|EMPTY_CLOB|ROWID|HASH16|HASH32|YEAR\b|SHA2\s*\(|'
    r'GROUP_CONCAT\s*\(|KEEP\s*\(|LNNVL\s*\(|TO_DATEA\s*\()',
    re.IGNORECASE,
)
RESOURCE_HEAVY_TOKEN_RE = re.compile(r'\b(REPEAT\s*\()', re.IGNORECASE)
MODE_DEPENDENT_EMPTY_JSON_RE = re.compile(r"TO_JSONB\s*\(\s*''", re.IGNORECASE)


class StrictCoreExpressionProbeModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class CoreExpressionProbeSourceDef(StrictCoreExpressionProbeModel):
    candidate_chain_relpath: str
    candidate_chain_sha256: str
    candidate_count: int

    @field_validator('candidate_chain_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('candidate chain path must be safe')
        return value

    @field_validator('candidate_chain_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('candidate chain SHA-256 must be 64 hex characters')
        return value


class CoreExpressionProbeStepDef(StrictCoreExpressionProbeModel):
    plan_order: int = Field(ge=1)
    candidate_id: str
    capability: str
    fact_refs: List[str]
    sql: str
    expected_kind: Literal['value']
    compatibility_mode: Literal['any']
    oracle_status: Literal['needs_verification']
    execution_status: Literal['not_executed']
    fixture_ref: Literal['no_fixture']

    @field_validator('sql')
    @classmethod
    def ensure_single_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';') or normalized.count(';') != 1:
            raise ValueError('probe SQL must be exactly one statement ending with a semicolon')
        upper = ' '.join(normalized[:-1].split()).upper()
        if not upper.startswith(('SELECT ', 'WITH ')):
            raise ValueError('probe SQL must be read-only SELECT or WITH')
        for token in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
            if token in upper:
                raise ValueError(f'probe SQL contains forbidden token {token.strip()}')
        return normalized


class CoreExpressionProbeExclusionDef(StrictCoreExpressionProbeModel):
    candidate_id: str
    capability: str
    compatibility_mode: str
    fixture_ref: str
    expected_kind: str
    reasons: List[str]

    @model_validator(mode='after')
    def ensure_reasons(self) -> 'CoreExpressionProbeExclusionDef':
        if not self.reasons:
            raise ValueError(f'excluded candidate {self.candidate_id} needs reasons')
        return self


class CoreExpressionProbeSummaryDef(StrictCoreExpressionProbeModel):
    candidate_count: int
    eligible_count: int
    selected_count: int
    excluded_count: int
    step_count: int
    fixture_free_step_count: int
    mode_independent_step_count: int
    read_only_step_count: int
    database_executed: bool = False
    execution_authorized: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'CoreExpressionProbeSummaryDef':
        if self.candidate_count != self.selected_count + self.excluded_count:
            raise ValueError('core expression probe selected/excluded counts do not cover candidates')
        if self.step_count != self.selected_count:
            raise ValueError('core expression probe step count is inconsistent')
        if self.fixture_free_step_count != self.selected_count:
            raise ValueError('core expression probe fixture-free count is inconsistent')
        if self.mode_independent_step_count != self.selected_count:
            raise ValueError('core expression probe mode-independent count is inconsistent')
        if self.read_only_step_count != self.selected_count:
            raise ValueError('core expression probe read-only count is inconsistent')
        if self.database_executed or self.execution_authorized or self.runtime_verified:
            raise ValueError('core expression probe dry-run cannot claim execution or authorization')
        return self


class CoreExpressionProbePlanDef(StrictCoreExpressionProbeModel):
    schema_version: int = 1
    kind: str = 'core_expression_probe_plan'
    profile: str = 'core_expression_probe_plan_v1'
    id: str = 'core_expression_probe_plan_v1'
    name: str = 'Core Expression Static SQL Probe Dry Run'
    status: str = 'ready_for_static_review'
    description: str = (
        '从Wave 1A/1B候选链筛选兼容模式无关、无fixture、无副作用的只读SQL probe；只做dry run，不授权执行。'
    )
    source: CoreExpressionProbeSourceDef
    selection_rules: List[str]
    steps: List[CoreExpressionProbeStepDef]
    exclusions: List[CoreExpressionProbeExclusionDef]
    summary: CoreExpressionProbeSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'This plan does not connect to GaussDB or execute SQL.',
        'A planned probe is not a runtime receipt.',
        'Representative SQL does not cover every documented value domain.',
        'Authorized execution still requires successful preflight, gate approval and independent audit.',
    ])

    @model_validator(mode='after')
    def ensure_plan_shape(self) -> 'CoreExpressionProbePlanDef':
        ids = [item.candidate_id for item in self.steps]
        if len(ids) != len(set(ids)):
            raise ValueError('core expression probe candidate ids cannot repeat')
        if [item.plan_order for item in self.steps] != list(range(1, len(self.steps) + 1)):
            raise ValueError('core expression probe plan_order must be contiguous')
        if self.summary.selected_count != len(self.steps):
            raise ValueError('core expression probe selected count is inconsistent')
        if self.summary.eligible_count != self.summary.selected_count:
            raise ValueError('core expression probe eligible count is inconsistent')
        return self


def _sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def _canonical_hash(value: dict) -> str:
    canonical = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(',', ':'))
    return hashlib.sha256(canonical.encode('utf-8')).hexdigest()


def build_core_expression_probe_plan(root: Path = ROOT) -> CoreExpressionProbePlanDef:
    root = Path(root)
    chain_path = root / 'generated/core_expression_candidate_chain_v1/candidates.json'
    try:
        chain = CoreExpressionCandidateChainRegistry(root).verify()
    except Exception as exc:
        raise ValueError(f'core expression candidate chain is not current: {exc}') from exc

    selected_steps: List[CoreExpressionProbeStepDef] = []
    exclusions: List[CoreExpressionProbeExclusionDef] = []
    for candidate in chain.candidates:
        reasons: List[str] = []
        if candidate.compatibility_mode != 'any':
            reasons.append(f'compatibility_mode={candidate.compatibility_mode}')
        if candidate.fixture_ref != 'no_fixture':
            reasons.append(f'fixture_required={candidate.fixture_ref}')
        if candidate.expected_kind != 'value':
            reasons.append(f'expected_kind={candidate.expected_kind}')
        if candidate.capability not in ALLOWED_CAPABILITIES:
            reasons.append('capability_not_in_first_batch')
        if STATEFUL_TOKEN_RE.search(candidate.sql):
            reasons.append('stateful_time_user_token')
        if COMPATIBILITY_TOKEN_RE.search(candidate.sql):
            reasons.append('compatibility_specific_token')
        if RESOURCE_HEAVY_TOKEN_RE.search(candidate.sql):
            reasons.append('resource_heavy_token')
        if MODE_DEPENDENT_EMPTY_JSON_RE.search(candidate.sql):
            reasons.append('mode_dependent_empty_json')

        if reasons:
            exclusions.append(CoreExpressionProbeExclusionDef(
                candidate_id=candidate.id,
                capability=candidate.capability,
                compatibility_mode=candidate.compatibility_mode,
                fixture_ref=candidate.fixture_ref,
                expected_kind=candidate.expected_kind,
                reasons=reasons,
            ))
            continue

        selected_steps.append(CoreExpressionProbeStepDef(
            plan_order=len(selected_steps) + 1,
            candidate_id=candidate.id,
            capability=candidate.capability,
            fact_refs=list(candidate.fact_refs),
            sql=candidate.sql,
            expected_kind='value',
            compatibility_mode='any',
            oracle_status='needs_verification',
            execution_status='not_executed',
            fixture_ref='no_fixture',
        ))

    summary = CoreExpressionProbeSummaryDef(
        candidate_count=len(chain.candidates),
        eligible_count=len(selected_steps),
        selected_count=len(selected_steps),
        excluded_count=len(exclusions),
        step_count=len(selected_steps),
        fixture_free_step_count=sum(item.fixture_ref == 'no_fixture' for item in selected_steps),
        mode_independent_step_count=sum(item.compatibility_mode == 'any' for item in selected_steps),
        read_only_step_count=sum(item.sql.strip().upper().startswith(('SELECT ', 'WITH ')) for item in selected_steps),
    )
    return CoreExpressionProbePlanDef(
        source=CoreExpressionProbeSourceDef(
            candidate_chain_relpath=str(chain_path.relative_to(root)),
            candidate_chain_sha256=_sha256_bytes(chain_path.read_bytes()),
            candidate_count=len(chain.candidates),
        ),
        selection_rules=[
            'compatibility_mode must be any',
            'fixture_ref must be no_fixture',
            'expected_kind must be value',
            'capability must be in the first-batch allowlist',
            'SQL must not contain stateful time/user functions',
            'SQL must not contain compatibility-specific functions',
            'SQL must not contain resource-heavy or mode-dependent tokens',
        ],
        steps=selected_steps,
        exclusions=exclusions,
        summary=summary,
    )


def build_core_expression_probe_plan_payload(root: Path = ROOT) -> dict:
    plan = build_core_expression_probe_plan(root)
    payload = plan.model_dump(mode='json')
    payload['plan_sha256'] = _canonical_hash(payload)
    return payload


def verify_core_expression_probe_plan(root: Path = ROOT) -> dict:
    root = Path(root)
    path = root / 'generated/core_expression_probe_plan_v1/dry_run.json'
    if not path.is_file():
        raise ValueError('core expression probe plan artifact is missing')
    try:
        recorded = json.loads(path.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression probe plan artifact is invalid: {exc}') from exc
    current = build_core_expression_probe_plan_payload(root)
    if recorded != current:
        raise ValueError('core expression probe plan artifact is stale')
    return recorded
