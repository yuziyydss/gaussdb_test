"""Human-review sheet for core-expression expected-oracle drafts.

The sheet organizes each draft by capability and records a pending reviewer
decision.  It does not mark any oracle as verified and does not execute SQL.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.core_expression_oracle_draft import verify_core_expression_oracle_draft

ROOT = Path(__file__).resolve().parents[1]
DRAFT_PATH = ROOT / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'
OUTPUT_JSON_PATH = ROOT / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.json'
OUTPUT_MD_PATH = ROOT / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.md'

CAPABILITY_LABELS = {
    'numeric_type_domain': '数值类型域',
    'numeric_functions': '数字函数',
    'boolean_and_bit': '布尔与位串',
    'string_domain': '字符串与模式匹配',
    'datetime_functions': '日期时间函数',
    'type_conversion': '类型转换',
    'json_domain': 'JSON / JSONB',
    'hll_domain': 'HLL',
    'array_domain': '数组',
    'range_domain': '范围类型',
    'aggregate_domain': '聚集函数',
    'window_domain': '窗口函数',
    'conditional_domain': '条件表达式',
    'expression_semantics': '表达式语义与类型推导',
}

REVIEW_QUESTIONS = [
    '实际执行是否成功且无非预期错误？',
    '结果行与字段是否已完整捕获？',
    'SQLSTATE 是否已记录？',
    '结果语义是否与引用 facts 一致？',
    '是否存在兼容模式、编码或版本限制？',
]


class StrictOracleReviewModel(BaseModel):
    model_config = ConfigDict(extra='forbid')


class OracleReviewSourceDef(StrictOracleReviewModel):
    oracle_draft_relpath: str
    oracle_draft_sha256: str

    @field_validator('oracle_draft_relpath')
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split('/')
        if value.startswith('/') or '\\' in value or any(part in {'', '.', '..'} for part in parts):
            raise ValueError('oracle draft path must be safe')
        return value

    @field_validator('oracle_draft_sha256')
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r'[0-9a-f]{64}', value) is None:
            raise ValueError('oracle draft SHA-256 must be 64 hex characters')
        return value


class OracleReviewStepDef(StrictOracleReviewModel):
    oracle_id: str
    batch_id: str
    plan_order: int = Field(ge=1)
    candidate_id: str
    capability: str
    capability_label: str
    fact_refs: List[str]
    sql: str
    planned_assertions: List[str]
    review_questions: List[str]
    review_status: Literal['pending_review']

    @field_validator('oracle_id', 'candidate_id', 'capability', 'capability_label')
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError('oracle review fields cannot be blank')
        return value


class OracleReviewCapabilityGroupDef(StrictOracleReviewModel):
    capability: str
    capability_label: str
    step_count: int
    oracle_ids: List[str]
    review_status: Literal['pending_review']


class OracleReviewSummaryDef(StrictOracleReviewModel):
    oracle_draft_step_count: int
    review_step_count: int
    capability_group_count: int
    pending_review_count: int
    verified_count: int = 0
    exact_value_claim_count: int = 0
    all_steps_scheduled_for_review: bool
    database_executed: bool = False
    runtime_verified: bool = False

    @model_validator(mode='after')
    def ensure_summary_shape(self) -> 'OracleReviewSummaryDef':
        if self.review_step_count != self.oracle_draft_step_count:
            raise ValueError('oracle review sheet does not cover every draft step')
        if self.pending_review_count != self.review_step_count:
            raise ValueError('oracle review pending count is inconsistent')
        if self.verified_count != 0:
            raise ValueError('oracle review sheet cannot mark steps verified')
        if self.exact_value_claim_count != 0:
            raise ValueError('oracle review sheet cannot add exact value claims')
        if self.database_executed or self.runtime_verified:
            raise ValueError('oracle review sheet cannot claim database execution')
        return self


class CoreExpressionOracleReviewSheetDef(StrictOracleReviewModel):
    schema_version: int = 1
    kind: str = 'core_expression_oracle_review_sheet'
    id: str = 'core_expression_oracle_review_sheet_v1'
    name: str = 'Core Expression Expected Oracle Review Sheet'
    description: str = (
        '94个SQL probe的oracle草案按能力域分组，形成人工确认清单；不执行SQL，不声明验证通过。'
    )
    source: OracleReviewSourceDef
    review_questions: List[str]
    steps: List[OracleReviewStepDef]
    capability_groups: List[OracleReviewCapabilityGroupDef]
    summary: OracleReviewSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        'This review sheet is not a runtime receipt.',
        'A pending review item has no database evidence.',
        'Exact expected values must be added only after target database review.',
        'Marking an item verified requires captured rows, SQLSTATE and reviewer evidence.',
    ])

    @model_validator(mode='after')
    def ensure_sheet_shape(self) -> 'CoreExpressionOracleReviewSheetDef':
        oracle_ids = [item.oracle_id for item in self.steps]
        candidate_ids = [item.candidate_id for item in self.steps]
        if len(oracle_ids) != len(set(oracle_ids)):
            raise ValueError('oracle review sheet ids cannot repeat')
        if len(candidate_ids) != len(set(candidate_ids)):
            raise ValueError('oracle review candidate ids cannot repeat')
        if self.summary.review_step_count != len(self.steps):
            raise ValueError('oracle review summary count is inconsistent')
        group_ids = [oracle_id for group in self.capability_groups for oracle_id in group.oracle_ids]
        if sorted(group_ids) != sorted(oracle_ids):
            raise ValueError('oracle review capability groups do not cover every step')
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _render_markdown(payload: dict) -> str:
    lines = [
        '# Core Expression Oracle Review Sheet',
        '',
        '本文由 `core_expression_oracle_review_sheet_v1` 生成，只用于人工确认 oracle 草案。',
        '',
        f"- Source draft SHA-256: `{payload['source']['oracle_draft_sha256']}`",
        f"- Review steps: {payload['summary']['review_step_count']}",
        f"- Capability groups: {payload['summary']['capability_group_count']}",
        f"- Exact value claims: {payload['summary']['exact_value_claim_count']}",
        '',
        '## 公共检查',
        '',
    ]
    lines.extend(f"- {question}" for question in payload['review_questions'])
    lines.append('')
    for group in payload['capability_groups']:
        lines.append(f"## {group['capability_label']} (`{group['capability']}`)")
        lines.append('')
        lines.append(f"Steps: {group['step_count']}; Review status: **{group['review_status']}**")
        lines.append('')
        for step in payload['steps']:
            if step['capability'] != group['capability']:
                continue
            lines.append(f"### `{step['oracle_id']}`")
            lines.append('')
            lines.append(f"- Batch / Plan order: `{step['batch_id']}` / {step['plan_order']}")
            lines.append(f"- Candidate: `{step['candidate_id']}`")
            lines.append(f"- Fact refs: {', '.join(f'`{item}`' for item in step['fact_refs'])}")
            lines.append('- SQL:')
            lines.append('')
            lines.append('```sql')
            lines.append(step['sql'])
            lines.append('```')
            lines.append('- Planned assertions:')
            lines.extend(f"  - {item}" for item in step['planned_assertions'])
            lines.append(f"- Review status: **{step['review_status']}**")
            lines.append('')
    lines.extend([
        '## 边界',
        '',
        '- Pending review 不代表数据库行为已验证。',
        '- 完成确认必须记录实际 rows、notices、SQLSTATE 和 reviewer 结论。',
        '- 不得在未捕获目标数据库证据时填写 expected value。',
    ])
    return '\n'.join(lines) + '\n'


def build_core_expression_oracle_review_sheet(root: Path = ROOT) -> CoreExpressionOracleReviewSheetDef:
    root = Path(root).resolve()
    draft_payload = verify_core_expression_oracle_draft(root)
    draft_path = root / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'

    steps: List[OracleReviewStepDef] = []
    grouped: Dict[str, List[str]] = {}
    for draft_step in draft_payload['steps']:
        capability = draft_step['capability']
        label = CAPABILITY_LABELS.get(capability, capability.replace('_', ' ').title())
        steps.append(OracleReviewStepDef(
            oracle_id=draft_step['oracle_id'],
            batch_id=draft_step['batch_id'],
            plan_order=draft_step['plan_order'],
            candidate_id=draft_step['candidate_id'],
            capability=capability,
            capability_label=label,
            fact_refs=list(draft_step['fact_refs']),
            sql=draft_step['sql'],
            planned_assertions=list(draft_step['planned_assertions']),
            review_questions=list(REVIEW_QUESTIONS),
            review_status='pending_review',
        ))
        grouped.setdefault(capability, []).append(draft_step['oracle_id'])

    capability_groups = [OracleReviewCapabilityGroupDef(
        capability=capability,
        capability_label=CAPABILITY_LABELS.get(capability, capability.replace('_', ' ').title()),
        step_count=len(oracle_ids),
        oracle_ids=oracle_ids,
        review_status='pending_review',
    ) for capability, oracle_ids in sorted(grouped.items())]

    return CoreExpressionOracleReviewSheetDef(
        source=OracleReviewSourceDef(
            oracle_draft_relpath=str(draft_path.relative_to(root)),
            oracle_draft_sha256=_sha256(draft_path),
        ),
        review_questions=list(REVIEW_QUESTIONS),
        steps=steps,
        capability_groups=capability_groups,
        summary=OracleReviewSummaryDef(
            oracle_draft_step_count=len(draft_payload['steps']),
            review_step_count=len(steps),
            capability_group_count=len(capability_groups),
            pending_review_count=len(steps),
            all_steps_scheduled_for_review=len(steps) == len(draft_payload['steps']),
        ),
    )


def build_core_expression_oracle_review_sheet_payloads(root: Path = ROOT) -> tuple[dict, str]:
    sheet = build_core_expression_oracle_review_sheet(root)
    payload = sheet.model_dump(mode='json')
    payload['sheet_sha256'] = hashlib.sha256(
        json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
    ).hexdigest()
    markdown = _render_markdown(payload)
    return payload, markdown


def verify_core_expression_oracle_review_sheet(root: Path = ROOT) -> dict:
    root = Path(root).resolve()
    json_path = root / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.json'
    markdown_path = root / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.md'
    if not json_path.is_file() or not markdown_path.is_file():
        raise ValueError('core expression oracle review sheet artifact is missing')
    try:
        recorded = json.loads(json_path.read_text(encoding='utf-8'))
    except Exception as exc:
        raise ValueError(f'core expression oracle review sheet artifact is invalid: {exc}') from exc
    current, markdown = build_core_expression_oracle_review_sheet_payloads(root)
    if recorded != current or markdown_path.read_text(encoding='utf-8') != markdown:
        raise ValueError('core expression oracle review sheet artifact is stale')
    return recorded
