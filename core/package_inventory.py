"""Registry denominator and selection inventory, never a support verdict."""


def package_inventory(registry, selected_manifest_ids):
    selected = set(selected_manifest_ids)
    unknown = selected - set(registry.manifests)
    if unknown:
        raise ValueError('Unknown selected manifests: ' + ', '.join(sorted(unknown)))
    selected_factors = {registry.manifests[mid].factor_ref for mid in selected}
    with_manifests = {fid for fid, factor in registry.factors.items() if factor.manifest_refs}
    groups, missing = {}, []
    for label, ids in (
        ('general', {fid for fid in registry.factors if not fid.startswith('m_')}),
        ('M', {fid for fid in registry.factors if fid.startswith('m_')}),
    ):
        groups[label] = {'registered': len(ids), 'with_manifest': len(ids & with_manifests),
                         'selected': len(ids & selected_factors),
                         'without_manifest': len(ids - with_manifests)}
    for fid in sorted(set(registry.factors) - with_manifests):
        factor = registry.factors[fid]
        missing.append({
            'factor_ref': fid, 'status': 'no_manifest_not_a_support_verdict',
            'scenario_refs': list(factor.scenario_refs), 'fixture_refs': list(factor.fixture_refs),
            'review_fact_refs': [fid+'::'+f.id for f in factor.facts
                                 if f.type == 'open_question' or f.status == 'needs_verification'],
        })
    return {
        'registered_package_count': len(registry.factors),
        'with_manifest_count': len(with_manifests),
        'without_manifest_count': len(missing),
        'selected_package_count': len(selected_factors),
        'selected_package_refs': sorted(selected_factors),
        'not_selected_with_manifest_refs': sorted(with_manifests - selected_factors),
        'by_package_namespace': groups, 'without_manifest': missing,
        'runtime_evidence_connected': False,
        'limits': ['Package namespace is not a verified physical database mode.',
                   'A selected manifest does not prove nonzero cases, full coverage or execution.',
                   'Missing manifest is a workflow gap, not an unsupported feature decision.'],
    }
