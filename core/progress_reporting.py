"""Presentation-only progress; legacy audit flags are not execution evidence."""


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
        'limits': 'Candidate presence is not complete generation coverage; static coverage '
                  'is limited to declared audit criteria; runtime evidence is not connected.',
    }
