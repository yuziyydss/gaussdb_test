#!/usr/bin/env python3
"""Recompute an actionable V1 gap inventory without modifying specs or statuses."""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_model import FactorPackageRegistry
from core.progress_reporting import factor_progress
from scripts.manage_extraction_queue import factor_package_sha256, verification_toolchain_sha256


# Routes describe the next evidence-producing action, not an inferred root cause.
ROUTES = {
    'unconsumed_fact': ('source_review', '为已确认事实定位实际消费者，不以空引用消除缺口。', '消费者真正使用事实，原文与实现可对账。'),
    'wrong_fact_consumer': ('source_review', '核对事实类型与消费者职责，不把行为事实降格为语法。', '事实进入适当规则、环境或场景消费者，保留原类型。'),
    'unledgered_fact': ('source_review', '补事实到原文单元的真实映射。', '引用实际来源行，不能复制不相关单元。'),
    'source_missing_line': ('source_review', '阅读未记账原文行并分类。', '原文行有可复核的单元或合理忽略理由。'),
    'unresolved_fact': ('source_review', '核对原文及实际依赖章节，区分歧义与尚未建模；不得按关键词自动认定不支持。', '有逐条来源证据和处置理由；确需运行时验证则保留 needs_verification。'),
    'value_gap': ('generation_model', '定位未选择或意图不匹配的值，补兼容 fixture/manifest 或明确尚缺的契约。', '有效值有正向用例，非法值有目标负向证据；原有值域分母不缩小。'),
    'rule_gap': ('generation_model', '检查规则的正向满足及目标负向证据，核对生成约束是否被真正消费。', '规则证据缺口消失且新回归通过；未确认错误身份不能改为 confirmed。'),
    'feature_gap': ('generation_model', '按 feature 的 fact_refs 核对尚缺分支，补 AST/value/profile/fixture 和独立清单。', '所有声明引用实际生成；representative 不升格为全域覆盖；未建模部分继续留账。'),
    'scenario_pending': ('runtime_oracle', '将本场景步骤、对象状态、会话/权限和断言细化为可实施契约。', '在授权环境产生逐步执行及清理证据前保持未验证。'),
    'scenario_fact_gap': ('runtime_oracle', '为缺少场景的事实补对应状态变化与 Oracle，避免只有空引用。', '事实有可追溯场景；新增 planned 不计为行为通过。'),
    'error_oracle_pending': ('runtime_oracle', '核对目标负向规则及错误身份；PDF 未给出时安排隔离环境校准。', '目标 SQL 的错误身份有独立证据；setup/teardown 错误不能满足 Oracle。'),
    'generation_error': ('generator_or_spec_diagnosis', '重现清单生成异常并追踪到具体输入/约束/fixture，先加失败测试再修复。', '同一清单成功生成且全量回归通过；不得吞异常或删除清单。'),
    'pairwise_gap': ('generator_or_spec_diagnosis', '独立枚举或求解当前有限域的可行 pair，定位缺失投影。', '独立目标集与生成投影一致；不降低覆盖门禁。'),
    'duplicate_case_id': ('generator_or_spec_diagnosis', '查明重复 ID 的来源并验证生成身份稳定性。', '全局 ID 唯一，报告与快照逐条匹配。'),
    'duplicate_sql': ('generator_or_spec_diagnosis', '核查不同参数是否渲染为相同 SQL，区分别名和未消费维度。', '重复来源有明确解释或修复，不能以重命名 ID 掩盖维度失效。'),
    'source_unmapped': ('source_review', '阅读未映射单元并建立正确类型的原子事实与消费者。', '该原文单元处置可复核，不以 out_of_scope 隐藏所属内容。'),
    'source_atomicity': ('source_review', '逐单元复核独立主张及行区间，不批量复制豁免理由。', '原子性告警由真实拆分/证据解决，审计标准不降低。'),
    'no_manifest': ('support_and_runtime_review', '检查本包实际支持性、工具协议及前置条件，区分明确不支持和未实现运行时。', '每包有文档证据与明确处置；无普通清单不得计作 SQL 通过。'),
}

FAMILIES = {
    'source_facts': {'unresolved_fact', 'unconsumed_fact', 'wrong_fact_consumer',
                     'unledgered_fact', 'source_unmapped', 'source_atomicity', 'source_missing_line'},
    'values': {'value_gap'}, 'rules': {'rule_gap'}, 'features': {'feature_gap'},
    'scenarios': {'scenario_pending', 'scenario_fact_gap'}, 'oracles': {'error_oracle_pending'},
    'generation': {'generation_error', 'pairwise_gap', 'duplicate_case_id', 'duplicate_sql'},
    'assets': {'no_manifest'},
}


def family_for(kind):
    return next(name for name, kinds in FAMILIES.items() if kind in kinds)


def summarize_cohorts(factors, items):
    result = {}
    for name, has_cases in (('with_candidates', True), ('without_candidates', False)):
        ids = {f['factor_id'] for f in factors if bool(f['candidate_cases']) == has_cases}
        selected = [item for item in items if item['factor_id'] in ids]
        result[name] = {'factor_count': len(ids), **summarize_items(selected),
                        'affected_by_family': {family: len({i['factor_id'] for i in selected
                            if family_for(i['kind']) == family}) for family in FAMILIES}}
    return result


def asset_routes_by_factor(factors, routes):
    expected = {f['factor_id'] for f in factors if not f['manifest_count']}
    result = {}
    for group in routes['groups']:
        if group['count'] != len(group['members']):
            raise ValueError('Asset route count disagrees with members')
        for fid in group['members']:
            if fid in result:
                raise ValueError('Duplicate asset routing: '+fid)
            result[fid] = {k: group[k] for k in ('id', 'label', 'evidence', 'next_action', 'acceptance')}
            result[fid]['readiness'] = 'not_assessed'
    if set(result) != expected:
        raise ValueError('Asset routing does not exactly match packages without manifests')
    return result


def collect_audit_gaps(audit):
    paths = [
        ('unresolved_fact', 'facts', 'unresolved'),
        ('unconsumed_fact', 'facts', 'unconsumed_confirmed'),
        ('wrong_fact_consumer', 'facts', 'wrong_consumer_type'),
        ('unledgered_fact', 'facts', 'unledgered'),
        ('value_gap', 'values', 'coverage_gaps'),
        ('rule_gap', 'rules', 'gaps'),
        ('feature_gap', 'documented_features', 'coverage_gaps'),
        ('scenario_pending', 'scenarios', 'non_ready'),
        ('scenario_fact_gap', 'scenarios', 'missing_required_fact_coverage'),
        ('error_oracle_pending', 'manifests', 'unresolved_error_oracles'),
        ('generation_error', 'manifests', 'errors'),
        ('pairwise_gap', 'manifests', 'pairwise_incomplete'),
        ('duplicate_case_id', 'manifests', 'duplicate_case_ids'),
        ('duplicate_sql', 'manifests', 'duplicate_sql'),
        ('source_unmapped', 'source_units', 'unmapped'),
    ]
    result = [(kind, item) for kind, section, field in paths
              for item in audit[section][field]]
    result.extend(('source_atomicity', item)
                  for item in audit['source_units']['atomicity']['gaps'])
    result.extend(('source_missing_line', item)
                  for item in audit['source_units']['line_coverage']['missing'])
    return result


def summarize_items(items):
    return {
        'issue_count': len(items),
        'factors_with_issues': len({x['factor_id'] for x in items}),
        'by_kind': dict(sorted(Counter(x['kind'] for x in items).items())),
    }


def find_entity(reference, entities, fallback):
    if reference in entities:
        return entities[reference]
    entity_id, separator, _ = reference.partition(': ')
    if separator and entity_id in entities:
        return entities[entity_id]
    # Value gaps use dimension.value_id; dimension values/profile IDs are
    # unique within a factor, so this preserves their actual file and facts.
    if '.' in reference:
        value_id = reference.split('.', 1)[1]
        if value_id in entities:
            return entities[value_id]
    return fallback, {}


def build_inventory(registry, selected, asset_routes=None):
    unknown = set(selected) - set(registry.factors)
    if unknown:
        raise ValueError(f'Unknown review factors: {sorted(unknown)}')
    auditor = FactorCoverageAuditor(registry)
    items, factors = [], []
    for fid, factor in sorted(registry.factors.items()):
        audit = auditor.audit(fid)  # Includes packages without manifests.
        entities = {}
        factor_path = registry.source_paths[fid]

        def register(entity, path):
            data = entity.model_dump() if hasattr(entity, 'model_dump') else entity
            entities[data['id']] = (str(path.relative_to(ROOT)), data)

        for fact in factor.facts:
            register(fact, factor_path)
        for rule in factor.rules:
            register(rule, factor_path)
        for dimension in factor.dimensions.values():
            for cls in dimension.classes:
                for value in cls.values:
                    register(value, factor_path)
        for field in ('manifest_refs', 'scenario_refs', 'matrix_refs'):
            collection = getattr(registry, {'manifest_refs': 'manifests', 'scenario_refs': 'scenarios', 'matrix_refs': 'matrices'}[field])
            for ref in getattr(factor, field):
                entity = collection[ref]
                register(entity, registry.source_paths[ref])
                if field == 'matrix_refs':
                    for feature in entity.documented_features:
                        register(feature, registry.source_paths[ref])
                    for profile in entity.profiles:
                        register(profile, registry.source_paths[ref])
        ledger = registry.source_ledgers[factor.source_ledger_ref]
        fact_ids = {f.id for f in factor.facts}
        for unit in ledger.units:
            register(unit, registry.source_paths[ledger.id])
        gaps = collect_audit_gaps(audit)
        if not factor.manifest_refs:
            gaps.append(('no_manifest', fid))
        start = len(items)
        for kind, evidence in gaps:
            ref = (evidence if isinstance(evidence, str) else
                   evidence.get('id', evidence.get('value_id', evidence.get('unit_id', '')))
                   if isinstance(evidence, dict) else str(evidence))
            path, entity = find_entity(ref, entities, str(factor_path.relative_to(ROOT)))
            ref = entity.get('id', ref)
            refs = entity.get('fact_refs', [])
            if ref in fact_ids:
                refs = [ref]
            locations = [{'unit_id': u.id, 'line_start': u.line_start, 'line_end': u.line_end}
                         for u in ledger.units if set(u.fact_refs) & set(refs)]
            if kind == 'source_missing_line':
                locations = [{'unit_id': None, 'line_start': evidence, 'line_end': evidence}]
            identity = json.dumps([fid, kind, evidence], ensure_ascii=False, sort_keys=True)
            route, action, acceptance = ROUTES[kind]
            items.append({
                'id': 'quality_' + hashlib.sha256(identity.encode()).hexdigest()[:16],
                'factor_id': fid, 'kind': kind, 'route': route,
                'family': family_for(kind),
                'triage_status': 'needs_review', 'selected_for_review': fid in selected,
                'file': path, 'reference': ref, 'evidence': evidence,
                'statement': entity.get('statement') or entity.get('description') or entity.get('name') or entity.get('render') or ref,
                'fact_refs': refs, 'source_units': locations,
                'next_action': action, 'acceptance': acceptance,
            })
        factors.append({
            'factor_id': fid, 'file': str(factor_path.relative_to(ROOT)),
            'package_sha256': factor_package_sha256(factor_path.parent),
            'chapter_sha256': factor.source.artifact_sha256,
            'source_relpath': factor.source.catalog_chapter_ref.source_relpath if factor.source.catalog_chapter_ref else None,
            'manifest_count': len(factor.manifest_refs),
            'candidate_cases': audit['manifests']['generated_case_count'],
            'conclusions': audit['conclusions'], 'issue_count': len(items) - start,
            'progress': factor_progress(audit),
            'gap_counts': {family: sum(i['family'] == family for i in items[start:]) for family in FAMILIES},
            'selected_for_review': fid in selected,
        })
        print(f'{fid}: {len(items) - start} quality items', flush=True)
    ids = [x['id'] for x in items]
    if len(ids) != len(set(ids)):
        raise ValueError('Duplicate quality item identities; inventory not written')
    if asset_routes is not None:
        routed = asset_routes_by_factor(factors, asset_routes)
        for factor in factors:
            factor['asset_route'] = routed.get(factor['factor_id'])
    return {
        'schema_version': 1, 'purpose': 'quality_backlog_not_verification',
        'database_executed': False, 'toolchain_sha256': verification_toolchain_sha256(),
        'selected_factors': sorted(selected),
        'summary': {'factor_count': len(factors), **summarize_items(items)},
        'cohorts': summarize_cohorts(factors, items),
        'limits': ['条目可关联同一问题，不可相加为特性分母或通过率。',
                   '自动路由不是根因判定；不自动关闭问题、修改规格或队列状态。',
                   '原文审计通过不等于消费者落实语义；需独立复核。',
                   '章节哈希是包内声明；本清单不替代目录与磁盘正文哈希对账。'],
        'factors': factors, 'items': items,
    }


def render_markdown(report):
    lines = ['# 按包缺口清单', '', '本报告是待办证据清单，不是通过率。各类信号可能指向同一个问题，不可相加为特性分母。', '',
             '## 可生成包', '', '| 包 | 用例 | 来源/事实 | 值 | 规则 | 特性 | 场景 | Oracle | 生成 | 包级静态 |',
             '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |']
    for factor in report['factors']:
        if not factor['candidate_cases']:
            continue
        g = factor['gap_counts']
        lines.append('| '+ ' | '.join([factor['factor_id'], str(factor['candidate_cases']),
            *(str(g[k]) for k in ('source_facts', 'values', 'rules', 'features', 'scenarios', 'oracles', 'generation')),
            factor['progress']['static_status']])+' |')
    lines += ['', '## 无普通清单包：资产路线，不是支持性或就绪结论', '', '| 包 | 路线 | 就绪评估 |', '| --- | --- | --- |']
    for factor in report['factors']:
        if not factor['manifest_count']:
            route = factor.get('asset_route') or {}
            lines.append(f"| {factor['factor_id']} | {route.get('label', '尚未路由')} | {route.get('readiness', 'not_assessed')} |")
    lines += ['', '逐条reference、原始evidence、fact_refs、来源行、下一步和验收条件见同批JSON。',
              'planned场景不计运行通过；静态covered仍可能有行为场景待验证；数据库执行未授权。', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--review-factor', action='append', default=[])
    parser.add_argument('--asset-routes', type=Path)
    parser.add_argument('--markdown', type=Path)
    args = parser.parse_args()
    registry = FactorPackageRegistry(ROOT / 'specs')
    registry.load_all()
    routes = json.loads(args.asset_routes.read_text()) if args.asset_routes else None
    result = build_inventory(registry, set(args.review_factor), routes)
    if args.asset_routes:
        result['asset_routes_sha256'] = hashlib.sha256(args.asset_routes.read_bytes()).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    if args.markdown:
        args.markdown.parent.mkdir(parents=True, exist_ok=True)
        args.markdown.write_text(render_markdown(result), encoding='utf-8')
    print(json.dumps(result['summary'], ensure_ascii=False))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
