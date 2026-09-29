"""Static fact -> fixture -> SQL candidate chain for core expression domains.

The chain is a review artifact only.  It does not execute SQL, authorize a
database connection, or claim runtime verification.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

ROOT = Path(__file__).resolve().parents[1]
ENV_PATH = ROOT / 'environments/core_expression_candidate_chain_v1.yaml'
WAVE_FACT_PATHS = {
    'wave_1a': ROOT / 'docs/compat_facts/core_type_expression_domain_v1.yaml',
    'wave_1b': ROOT / 'docs/compat_facts/core_function_operator_domain_v1.yaml',
    'wave_2a': ROOT / 'docs/compat_facts/core_function_operator_wave2a_v1.yaml',
}
OUTPUT_PATH = ROOT / 'generated/core_expression_candidate_chain_v1/candidates.json'

FORBIDDEN_CANDIDATE_TOKENS = (
    'INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ',
    'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_',
)


class StrictCoreExpressionModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class CoreExpressionFactSourceDef(StrictCoreExpressionModel):
    id: str
    path: str
    sha256: str
    fact_count: int

    @field_validator('path')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('core expression fact source path must be safe')
        return value

    @field_validator('sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('core expression fact source SHA-256 must be 64 hex characters')
        return value


class CoreExpressionFixtureDef(StrictCoreExpressionModel):
    id: str
    description: str
    setup_sql: List[str] = Field(default_factory=list)
    teardown_sql: List[str] = Field(default_factory=list)

    @field_validator('id')
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if re.fullmatch(r'[a-z][a-z0-9_]*', value) is None:
            raise ValueError('core expression fixture id must be snake_case')
        return value


class CoreExpressionCandidateSpecDef(StrictCoreExpressionModel):
    id: str
    capability: str
    fact_refs: List[str]
    fixture_ref: str
    sql: str
    expected_kind: Literal['value', 'metadata', 'lifecycle', 'error_boundary']
    compatibility_mode: Literal['any', 'A', 'B', 'C', 'PG', 'M'] = 'any'
    notes: str = ''

    @field_validator('id')
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if re.fullmatch(r'[a-z][a-z0-9_]*', value) is None:
            raise ValueError('core expression candidate id must be snake_case')
        return value

    @field_validator('sql')
    @classmethod
    def ensure_static_read_only_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized.endswith(';'):
            raise ValueError(f'candidate {value[:32]} SQL must end with one semicolon')
        body = normalized[:-1]
        if ';' in body:
            raise ValueError('candidate SQL must contain exactly one statement')
        upper = ' '.join(body.split()).upper()
        if not (upper.startswith('SELECT ') or upper.startswith('WITH ')):
            raise ValueError('candidate SQL must be a SELECT or WITH read-only probe')
        for token in FORBIDDEN_CANDIDATE_TOKENS:
            if token in upper:
                raise ValueError(f'candidate SQL contains forbidden token {token.strip()}')
        return normalized


class CoreExpressionEnvironmentDef(StrictCoreExpressionModel):
    schema_version: int = 1
    kind: Literal['core_expression_candidate_chain_environment']
    id: str
    name: str
    description: str
    coverage_mode: Literal['representative']
    runtime_executed: Literal[False]
    fact_sources: List[dict]
    fixtures: List[CoreExpressionFixtureDef]
    candidate_specs: List[CoreExpressionCandidateSpecDef]

    @model_validator(mode='after')
    def ensure_environment_shape(self) -> 'CoreExpressionEnvironmentDef':
        fixture_ids = [item.id for item in self.fixtures]
        if len(fixture_ids) != len(set(fixture_ids)):
            raise ValueError('core expression fixture ids cannot repeat')
        candidate_ids = [item.id for item in self.candidate_specs]
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('core expression candidate ids cannot repeat')
        fixture_set = set(fixture_ids)
        for spec in self.candidate_specs:
            if spec.fixture_ref not in fixture_set:
                raise ValueError(f'candidate {spec.id} references unknown fixture {spec.fixture_ref}')
        return self


class CoreExpressionCandidateDef(StrictCoreExpressionModel):
    id: str
    capability: str
    fact_refs: List[str]
    fixture_ref: str
    fixture_setup_sql: List[str]
    fixture_teardown_sql: List[str]
    sql: str
    expected_kind: str
    compatibility_mode: str
    oracle_status: Literal['needs_verification'] = 'needs_verification'
    execution_status: Literal['not_executed'] = 'not_executed'
    notes: str


class CoreExpressionChainSummaryDef(StrictCoreExpressionModel):
    source_fact_count: int
    candidate_count: int
    fixture_count: int
    referenced_fact_count: int
    candidate_fact_reference_count: int
    uncovered_fact_count: int
    all_candidates_read_only: bool
    static_chain_complete: bool
    runtime_executed: Literal[False] = False
    runtime_verified: Literal[False] = False


class CoreExpressionCandidateChainResultDef(StrictCoreExpressionModel):
    schema_version: int = 1
    kind: Literal['core_expression_candidate_chain'] = 'core_expression_candidate_chain'
    id: str = 'core_expression_candidate_chain_v1'
    name: str = 'Core Expression Candidate Chain V1'
    description: str = (
        'Wave 1A/1B facts bound to fixtures and static SQL candidates; review only, no database execution.'
    )
    fact_sources: List[CoreExpressionFactSourceDef]
    fixtures: List[CoreExpressionFixtureDef]
    candidates: List[CoreExpressionCandidateDef]
    referenced_fact_ids: List[str]
    uncovered_fact_ids: List[str]
    summary: CoreExpressionChainSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'This chain does not connect to GaussDB or execute SQL.',
        'A generated candidate is not a runtime receipt.',
        'Representative coverage does not prove every documented input domain.',
        'Oracle status remains needs_verification until database evidence exists.',
    ])

    @model_validator(mode='after')
    def ensure_chain_shape(self) -> 'CoreExpressionCandidateChainResultDef':
        candidate_ids = [item.id for item in self.candidates]
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('generated candidate ids cannot repeat')
        sql_statements = [item.sql for item in self.candidates]
        if len(sql_statements) != len(set(sql_statements)):
            raise ValueError('generated candidate SQL cannot repeat')
        if self.summary.candidate_count != len(self.candidates):
            raise ValueError('core expression candidate count is inconsistent')
        if self.summary.fixture_count != len(self.fixtures):
            raise ValueError('core expression fixture count is inconsistent')
        if self.summary.referenced_fact_count != len(self.referenced_fact_ids):
            raise ValueError('core expression referenced fact count is inconsistent')
        if self.summary.uncovered_fact_count != len(self.uncovered_fact_ids):
            raise ValueError('core expression uncovered fact count is inconsistent')
        if self.summary.candidate_fact_reference_count != sum(
            len(item.fact_refs) for item in self.candidates
        ):
            raise ValueError('core expression candidate fact reference count is inconsistent')
        if self.summary.all_candidates_read_only != all(
            item.sql.strip().upper().startswith(('SELECT ', 'WITH '))
            for item in self.candidates
        ):
            raise ValueError('core expression candidate read-only flag is inconsistent')
        if self.summary.static_chain_complete != (
            bool(self.candidates)
            and self.summary.all_candidates_read_only
            and self.summary.runtime_executed is False
        ):
            raise ValueError('core expression static_chain_complete is inconsistent')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _load_facts() -> tuple[Dict[str, dict], List[CoreExpressionFactSourceDef], List[str]]:
    registry: Dict[str, dict] = {}
    sources: List[CoreExpressionFactSourceDef] = []
    errors: List[str] = []
    for source_id, path in WAVE_FACT_PATHS.items():
        try:
            payload = yaml.safe_load(path.read_text(encoding='utf-8'))
            facts = payload.get('facts', [])
            digest = _sha256(path)
            sources.append(CoreExpressionFactSourceDef(
                id=source_id,
                path=path.relative_to(ROOT).as_posix(),
                sha256=digest,
                fact_count=len(facts),
            ))
            for fact in facts:
                fact_id = fact.get('id')
                if fact_id in registry:
                    errors.append(f'duplicate fact id across waves: {fact_id}')
                registry[fact_id] = fact
        except Exception as exc:
            errors.append(f'{path}: {exc}')
    if errors:
        raise ValueError('; '.join(errors))
    return registry, sources, errors


def build_core_expression_candidate_chain(root: Path = ROOT) -> CoreExpressionCandidateChainResultDef:
    root = Path(root)
    env_path = root / ENV_PATH.relative_to(ROOT)
    payload = yaml.safe_load(env_path.read_text(encoding='utf-8'))
    environment = CoreExpressionEnvironmentDef(**payload)
    fact_registry, fact_sources, _ = _load_facts()

    fixture_by_id = {item.id: item for item in environment.fixtures}
    candidates: List[CoreExpressionCandidateDef] = []
    referenced: set[str] = set()
    total_refs = 0
    for spec in environment.candidate_specs:
        unknown_refs = sorted(set(spec.fact_refs) - set(fact_registry))
        if unknown_refs:
            raise ValueError(f'candidate {spec.id} references unknown facts: {unknown_refs}')
        fixture = fixture_by_id[spec.fixture_ref]
        total_refs += len(spec.fact_refs)
        referenced.update(spec.fact_refs)
        candidates.append(CoreExpressionCandidateDef(
            id=spec.id,
            capability=spec.capability,
            fact_refs=list(spec.fact_refs),
            fixture_ref=spec.fixture_ref,
            fixture_setup_sql=list(fixture.setup_sql),
            fixture_teardown_sql=list(fixture.teardown_sql),
            sql=spec.sql,
            expected_kind=spec.expected_kind,
            compatibility_mode=spec.compatibility_mode,
            notes=spec.notes,
        ))

    uncovered = sorted(set(fact_registry) - referenced)
    static_complete = bool(candidates) and all(
        item.sql.strip().upper().startswith(('SELECT ', 'WITH '))
        for item in candidates
    )
    return CoreExpressionCandidateChainResultDef(
        fact_sources=fact_sources,
        fixtures=environment.fixtures,
        candidates=candidates,
        referenced_fact_ids=sorted(referenced),
        uncovered_fact_ids=uncovered,
        summary=CoreExpressionChainSummaryDef(
            source_fact_count=len(fact_registry),
            candidate_count=len(candidates),
            fixture_count=len(environment.fixtures),
            referenced_fact_count=len(referenced),
            candidate_fact_reference_count=total_refs,
            uncovered_fact_count=len(uncovered),
            all_candidates_read_only=static_complete,
            static_chain_complete=static_complete,
        ),
    )


class CoreExpressionCandidateChainRegistry:
    def __init__(self, root: Path = ROOT):
        self.root = Path(root)

    def build(self) -> CoreExpressionCandidateChainResultDef:
        return build_core_expression_candidate_chain(self.root)

    def verify(self) -> CoreExpressionCandidateChainResultDef:
        path = self.root / 'generated/core_expression_candidate_chain_v1/candidates.json'
        if not path.is_file():
            raise ValueError('core expression candidate chain artifact is missing')
        try:
            recorded = CoreExpressionCandidateChainResultDef(**json.loads(path.read_text(encoding='utf-8')))
        except Exception as exc:
            raise ValueError(f'core expression candidate chain artifact is invalid: {exc}') from exc
        current = self.build()
        if recorded.model_dump(mode='json') != current.model_dump(mode='json'):
            raise ValueError('core expression candidate chain artifact is stale')
        return recorded


def verify_core_expression_candidate_chain(root: Path = ROOT) -> CoreExpressionCandidateChainResultDef:
    return CoreExpressionCandidateChainRegistry(root).verify()
