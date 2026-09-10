"""Presentation-only progress; legacy audit flags are not execution evidence."""


def generation_diagnostics(audit: dict) -> dict:
    """Explain existing audit gates, not a new SQL validator or support decision.

    Reconcile with the declared flag to surface drift rather than silently
    replacing the auditor's conclusion. Oracle calibration is a separate layer.
    """
    manifests = audit['manifests']
    values = audit.get('values', {})
    rules = audit.get('rules', {})
    required = ((manifests, ('total', 'generated_case_count', 'errors',
                            'duplicate_case_ids', 'duplicate_sql', 'pairwise_incomplete')),
                (values, ('coverage_gaps', 'unselected_by_validity',
                          'valid_without_positive', 'invalid_without_negative')),
                (rules, ('gaps',)))
    complete = all(key in section for section, keys in required for key in keys)
    blockers = []

    def add(code, label, items):
        if items:
            # Current audit errors may be a manifest -> error mapping. Preserve
            # identifiers and messages; display consumers must autoescape them.
            details = ([f'{key}: {value}' for key, value in sorted(items.items())]
                       if isinstance(items, dict) else sorted(set(items)))
            blockers.append({'code': code, 'label': label, 'count': len(details), 'items': details})

    if not manifests.get('total') or not manifests['generated_case_count']:
        add('no_candidates', '缺少清单或实际候选（不等于不支持）', ['no_candidates'])
    add('generation_errors', '生成异常', manifests.get('errors', []))
    add('duplicate_case_ids', '重复用例ID', manifests.get('duplicate_case_ids', []))
    # Absence means the old audit did not distinguish setup. Retain its
    # conservative duplicate gate; explicit [] proves distinct inputs.
    add('duplicate_inputs', '重复输入或旧报告未区分前置',
        manifests.get('duplicate_inputs', manifests.get('duplicate_sql', [])))
    add('incomplete_pairs', '要求的参数对未覆盖', manifests.get('pairwise_incomplete', []))
    remaining = set(values.get('coverage_gaps', []))
    groups = (
        ('conditional_values_unselected', '条件值尚未纳入（须先核支持条件）',
         values.get('unselected_by_validity', {}).get('conditional', [])),
        ('invalid_values_without_negative', '无效值缺目标负例', values.get('invalid_without_negative', [])),
        ('valid_values_without_positive', '有效值缺正向用例', values.get('valid_without_positive', [])),
    )
    for code, label, candidates in groups:
        selected = remaining.intersection(candidates)
        add(code, label, selected)
        remaining -= selected
    add('other_value_coverage_gaps', '其他取值覆盖缺口（需逐项复核）', remaining)
    add('rule_coverage_gaps', '规则缺少对应覆盖', rules.get('gaps', []))
    declared = audit['conclusions']['generation_model_complete']
    if not complete:
        status = 'unavailable'
    elif declared != (not blockers):
        status = 'inconsistent'
    elif not manifests['generated_case_count']:
        status = 'no_cases'
    else:
        status = 'gaps' if blockers else 'satisfied'
    labels = {'unavailable': '诊断字段不完整', 'inconsistent': '结论与证据不一致',
              'no_cases': '无候选，不计满足', 'gaps': '生成模型有缺口',
              'satisfied': '声明的生成模型满足'}
    return {
        'status': status, 'label': labels[status], 'evidence_complete': complete,
        'declared_complete': declared, 'blockers': blockers,
        'unresolved_error_oracles': sorted(set(manifests.get('unresolved_error_oracles', []))),
        'review_context_fact_refs': sorted(set(audit.get('facts', {}).get('unresolved', []))),
        'limits': '条件值不等于不支持；包级待审事实仅供查证，不自动关联为每个缺口的原因。'
                  '错误Oracle待校准属于静态覆盖层，不属于生成模型阻断；实机证据未接入。',
    }


def factor_progress(audit: dict) -> dict:
    manifests = audit['manifests']
    has_cases = manifests['generated_case_count'] > 0
    errors = bool(manifests['errors'])
    static = has_cases and not errors and audit['conclusions']['static_coverage_complete']
    return {
        'package_built': True,  # Called only for a loaded package audit.
        'source_accounted': audit['conclusions']['source_extraction_complete'],
        'has_candidates': has_cases,
        'generation_status': 'partial' if errors else ('generated' if has_cases else 'no_cases'),
        'static_status': 'covered' if static else ('gaps' if has_cases else 'no_cases'),
        # No current-version runtime evidence reader is connected to this view.
        # Even behavior_coverage_complete=True is a specification flag, not a run.
        'runtime_verified': None,
        'runtime_status': 'not_connected',
        'generation_diagnostics': generation_diagnostics(audit),
    }


def summarize_progress(audits: dict) -> dict:
    rows = [factor_progress(audit) for audit in audits.values()]
    return {
        'package_count': len(rows),
        'with_candidates_count': sum(p['has_candidates'] for p in rows),
        'without_candidates_count': sum(not p['has_candidates'] for p in rows),
        'static_covered_count': sum(p['static_status'] == 'covered' for p in rows),
        'runtime_verified_count': None,
        'runtime_evidence_connected': False,
        'generation_model_satisfied_count': sum(p['generation_diagnostics']['status'] == 'satisfied' for p in rows),
        'generation_model_gap_count': sum(p['generation_diagnostics']['status'] == 'gaps' for p in rows),
        'generation_diagnostics_unavailable_count': sum(
            p['generation_diagnostics']['status'] in {'unavailable', 'inconsistent'} for p in rows),
        'unresolved_oracle_package_count': sum(bool(p['generation_diagnostics']['unresolved_error_oracles']) for p in rows),
        'unresolved_oracle_manifest_count': sum(len(p['generation_diagnostics']['unresolved_error_oracles']) for p in rows),
        'limits': 'Candidate presence is not complete generation coverage; static coverage '
                  'is limited to declared audit criteria; runtime evidence is not connected.',
    }
