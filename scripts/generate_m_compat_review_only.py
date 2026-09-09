#!/usr/bin/env python3
"""Render the OM-only command for review, never create an executable test case."""
import json
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.m_compat_environment import BOOTSTRAP_PATH

FACTOR_ID='m_generated_update_system'
OUTPUT=ROOT/'generated/m_compat_review_only'/FACTOR_ID


def build_review(registry):
    factor=registry.factors[FACTOR_ID]
    syntax=registry.syntaxes[factor.syntax_ref]
    if factor.manifest_refs or factor.dimensions or syntax.slots:
        raise ValueError('Review-only export must not contain a manifest or parameter domain')
    if not factor.fixture_refs or any(registry.fixtures[f].execution.status!='not_implemented' for f in factor.fixture_refs):
        raise ValueError('Expected explicit unresolved OM fixture contract')
    if not factor.scenario_refs or any(registry.scenarios[s].status!='planned' for s in factor.scenario_refs):
        raise ValueError('Review-only scenarios must remain planned')
    generator=FactorPackageSQLGenerator(registry)
    raw=generator._render_ast_node(syntax.ast,syntax.subgrammars,{}, {}, {}, [],set(),set())
    sql=raw.strip().rstrip(';')+syntax.rendering.statement_terminator
    scenario=registry.scenarios[factor.scenario_refs[0]]
    return dict(factor_id=FACTOR_ID,status='review_only_external_contract_missing',
        package_registered=True,review_sql=sql,generated_case_count=0,ordinary_manifest_count=0,
        finite_static_verified=False,database_executed=False,executable=False,
        source_sha256=factor.source.artifact_sha256,parent_pdf_sha256=factor.source.parent_pdf_sha256,
        syntax_ref=syntax.id,source_fact_refs=syntax.source_fact_refs,
        m_environment_plan_ref=BOOTSTRAP_PATH,
        environment_note='M bootstrap alone does not provide OM upgrade state; do not change upgrade_mode manually.',
        preconditions=scenario.preconditions,fixture_refs=factor.fixture_refs,
        pending_contracts=[f.statement for f in factor.facts if f.type=='open_question'],
        execution_requirements=scenario.execution_requirements)


def render_review_sql(review):
    # Intentionally comment every line. Bulk execution of this file has no effect.
    return ('-- REVIEW ONLY: NOT AN EXECUTABLE TEST SUITE.\n'
            '-- No manifest, no case ID, no verified fixture or Oracle.\n'
            '-- M environment plan: '+review['m_environment_plan_ref']+'\n'
            '-- OM upgrade and rollback artifact lifecycle require an authoritative contract.\n'
            +'\n'.join('-- '+line for line in review['review_sql'].splitlines())+'\n')


def main():
    registry=FactorPackageRegistry(ROOT/'specs');registry.load_all()
    review=build_review(registry)
    OUTPUT.mkdir(parents=True,exist_ok=True)
    (OUTPUT/'review.json').write_text(json.dumps(review,ensure_ascii=False,indent=2)+'\n')
    (OUTPUT/'review.sql').write_text(render_review_sql(review))
    print(FACTOR_ID,'review_only; ordinary cases=0; database executed=false')


if __name__=='__main__':main()
