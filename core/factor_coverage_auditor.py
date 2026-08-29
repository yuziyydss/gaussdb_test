"""Factor-level coverage audit across source, specs, generation, and scenarios."""
from __future__ import annotations

from collections import Counter, defaultdict
from typing import Any, Dict, Iterable, List, Set

from .constraint_solver import ConstraintSolver
from .factor_package_generator import FactorPackageSQLGenerator
from .factor_package_model import FactorPackageRegistry
from .spec_generator import GenerationValidationError


def _iter_fact_refs(node: Any) -> Iterable[str]:
    if isinstance(node, dict):
        for key, value in node.items():
            if key in {"fact_refs", "source_fact_refs"} and isinstance(value, list):
                yield from value
            yield from _iter_fact_refs(value)
    elif isinstance(node, list):
        for value in node:
            yield from _iter_fact_refs(value)


class FactorCoverageAuditor:
    """Produce an evidence-based global audit for one Factor Package V1 factor."""

    def __init__(self, registry: FactorPackageRegistry):
        self.registry = registry
        self.generator = FactorPackageSQLGenerator(registry)

    def audit(self, factor_id: str) -> Dict[str, Any]:
        factor = self.registry.get_factor(factor_id)
        if factor is None:
            raise ValueError(f"factor 不存在: {factor_id}")
        ledger = self.registry.get_source_ledger(factor.source_ledger_ref)
        if ledger is None:
            raise ValueError(f"source ledger 不存在: {factor.source_ledger_ref}")

        resolved = self.registry.resolve_dimension_values(factor.id)
        cases: List[Any] = []
        manifest_details: Dict[str, Any] = {}
        manifest_errors: List[str] = []
        seen_case_ids: Set[str] = set()
        seen_sql: Set[str] = set()
        duplicate_case_ids: Set[str] = set()
        duplicate_sql: Set[str] = set()

        for manifest_id in factor.manifest_refs:
            manifest = self.registry.get_manifest(manifest_id)
            if manifest is None:
                manifest_errors.append(f"missing manifest: {manifest_id}")
                continue
            try:
                generated, generation_report = self.generator.generate_with_report(manifest)
            except GenerationValidationError as exc:
                manifest_errors.append(f"{manifest_id}: {exc}")
                continue
            interaction_dimension_count = sum(
                len(values) > 1 for values in manifest.bindings.values()
            )
            manifest_details[manifest_id] = {
                "suite_type": manifest.suite_type,
                "dimension_count": len(manifest.bindings),
                "interaction_dimension_count": interaction_dimension_count,
                "pairwise_applicable": interaction_dimension_count >= 2,
                "generated_case_count": len(generated),
                "candidate_combination_estimate": generation_report.candidate_combination_estimate,
                "feasible_combination_count": generation_report.feasible_combination_count,
                "feasible_pair_count": generation_report.feasible_pair_count,
                "covered_pair_count": generation_report.covered_pair_count,
                "missing_pairs": generation_report.missing_pairs,
                "pairwise_complete": generation_report.pairwise_complete,
            }
            for case in generated:
                if case.case_id in seen_case_ids:
                    duplicate_case_ids.add(case.case_id)
                if case.sql in seen_sql:
                    duplicate_sql.add(case.sql)
                seen_case_ids.add(case.case_id)
                seen_sql.add(case.sql)
            cases.extend(generated)

        source_status_counts = Counter(unit.status for unit in ledger.units)
        unit_covered_lines = {
            line
            for unit in ledger.units
            for line in range(unit.line_start, unit.line_end + 1)
        }
        ignored_source_lines = {item.line for item in ledger.ignored_lines}
        missing_source_lines = sorted(
            set(range(1, ledger.source_line_count + 1))
            - unit_covered_lines
            - ignored_source_lines
        )
        unmapped_units = [
            {
                "id": unit.id,
                "section": unit.section,
                "source_anchor": unit.source_anchor,
                "line_start": unit.line_start,
                "line_end": unit.line_end,
                "statement": unit.statement,
                "rationale": unit.rationale,
            }
            for unit in ledger.units if unit.status == "unmapped"
        ]
        accounted_source_units = len(ledger.units) - len(unmapped_units)
        atomicity_gaps: List[Dict[str, Any]] = []
        for unit in ledger.units:
            span = unit.line_end - unit.line_start + 1
            reasons: List[str] = []
            if unit.atomicity == "unreviewed":
                reasons.append("unit_not_reviewed")
                if span > 8:
                    reasons.append("long_unit_not_reviewed")
            if span > 12 and unit.atomicity == "atomic":
                reasons.append("atomic_unit_span_too_large")
            if (
                unit.atomicity == "grouped"
                and unit.status in {"mapped", "open_question"}
                and len(set(unit.fact_refs)) < unit.independent_claim_count
            ):
                reasons.append("independent_claims_exceed_fact_mappings")
            if reasons:
                atomicity_gaps.append({
                    "id": unit.id,
                    "line_start": unit.line_start,
                    "line_end": unit.line_end,
                    "line_span": span,
                    "atomicity": unit.atomicity,
                    "independent_claim_count": unit.independent_claim_count,
                    "fact_ref_count": len(set(unit.fact_refs)),
                    "reasons": reasons,
                })

        ledgered_fact_ids = {
            fact_id for unit in ledger.units for fact_id in unit.fact_refs
        }
        related_entities: List[Any] = []
        syntax = self.registry.get_syntax(factor.syntax_ref)
        if syntax is not None:
            related_entities.append(syntax)
        for refs, collection in (
            (factor.manifest_refs, self.registry.manifests),
            (factor.matrix_refs, self.registry.matrices),
            (factor.fixture_refs, self.registry.fixtures),
            (factor.scenario_refs, self.registry.scenarios),
        ):
            related_entities.extend(
                collection[entity_id] for entity_id in refs if entity_id in collection
            )
        downstream_fact_ids: Set[str] = set()
        for rule in factor.rules:
            downstream_fact_ids.update(rule.fact_refs)
        for check in factor.structural_checks:
            downstream_fact_ids.update(check.fact_refs)
        for dimension in factor.dimensions.values():
            for equivalence_class in dimension.classes:
                for value in equivalence_class.values:
                    downstream_fact_ids.update(value.fact_refs)
        for entity in related_entities:
            downstream_fact_ids.update(_iter_fact_refs(entity.model_dump()))

        unledgered_facts = sorted(
            fact.id for fact in factor.facts
            if fact.status != "inferred" and fact.id not in ledgered_fact_ids
        )
        unconsumed_confirmed_facts = sorted(
            fact.id for fact in factor.facts
            if fact.status == "confirmed"
            and fact.type != "example"
            and fact.id not in downstream_fact_ids
        )
        unresolved_open_questions = sorted(
            fact.id for fact in factor.facts
            if fact.type == "open_question" and fact.status == "needs_verification"
        )

        selected_values: Dict[str, Set[str]] = defaultdict(set)
        for case in cases:
            for dimension_id, value_id in case.params.items():
                selected_values[dimension_id].add(value_id)
        all_values = {
            (dimension_id, value.id): value
            for dimension_id, values in resolved.items()
            for value in values.values()
        }
        valid_values = {
            key for key, value in all_values.items() if value.validity == "valid"
        }
        actually_selected = {
            (dimension_id, value_id)
            for dimension_id, values in selected_values.items()
            for value_id in values
        }
        valid_unselected = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in valid_values - actually_selected
        )
        unselected_by_validity: Dict[str, List[str]] = defaultdict(list)
        for (dimension_id, value_id), value in all_values.items():
            if (dimension_id, value_id) not in actually_selected:
                unselected_by_validity[value.validity].append(
                    f"{dimension_id}.{value_id}"
                )
        for values in unselected_by_validity.values():
            values.sort()

        rule_details: Dict[str, Any] = {}
        targeted_rule_ids = {
            rule_id
            for manifest_id in factor.manifest_refs
            for manifest in [self.registry.get_manifest(manifest_id)]
            if manifest is not None and manifest.suite_type == "negative"
            for rule_id in manifest.violates_rule_refs
        }
        rule_gaps: List[str] = []
        for rule in factor.rules:
            solver = ConstraintSolver([rule.expression])
            satisfied = 0
            violated = 0
            positive_satisfied = 0
            negative_violated = 0
            for case in cases:
                enriched = dict(case.params)
                for dimension_id, value_id in case.params.items():
                    enriched.update(resolved[dimension_id][value_id].attributes)
                is_valid, _ = solver.is_valid(enriched)
                manifest = self.registry.get_manifest(case.case_id.rsplit("_", 1)[0])
                if is_valid:
                    satisfied += 1
                    if manifest is not None and manifest.suite_type == "positive":
                        positive_satisfied += 1
                else:
                    violated += 1
                    if manifest is not None and manifest.suite_type == "negative":
                        negative_violated += 1
            targeted = rule.id in targeted_rule_ids
            detail = {
                "targeted_by_negative_manifest": targeted,
                "satisfied_case_count": satisfied,
                "violated_case_count": violated,
                "positive_satisfied_case_count": positive_satisfied,
                "negative_violated_case_count": negative_violated,
            }
            rule_details[rule.id] = detail
            if positive_satisfied == 0:
                rule_gaps.append(f"{rule.id}: no positive satisfying evidence")
            if not targeted:
                rule_gaps.append(f"{rule.id}: not targeted by a negative manifest")
            elif negative_violated == 0:
                rule_gaps.append(f"{rule.id}: negative manifest produced no violation")

        documented_features = [
            feature
            for matrix_id in factor.matrix_refs
            for feature in self.registry.matrices[matrix_id].all_documented_features
        ]
        selected_profile_ids = set().union(*selected_values.values()) if selected_values else set()
        documented_feature_details = {
            feature.id: {
                "status": feature.status,
                "profile_refs": list(feature.profile_refs),
                "value_refs": list(feature.value_refs),
                "selected_profile_refs": sorted(
                    set(feature.coverage_refs) & selected_profile_ids
                ),
            }
            for feature in documented_features
        }
        feature_gaps = sorted(
            feature.id for feature in documented_features
            if feature.status == "needs_profile"
            or not (set(feature.coverage_refs) & selected_profile_ids)
        )

        scenarios = [
            self.registry.scenarios[scenario_id]
            for scenario_id in factor.scenario_refs
            if scenario_id in self.registry.scenarios
        ]
        scenario_fact_ids = {
            fact_id for scenario in scenarios for fact_id in scenario.fact_refs
        }
        scenario_required_facts = {
            fact.id for fact in factor.facts
            if fact.status == "confirmed"
            and fact.type in {"environment", "lifecycle", "behavior_oracle", "metadata_oracle"}
        }
        missing_scenario_facts = sorted(scenario_required_facts - scenario_fact_ids)
        scenario_status_counts = Counter(scenario.status for scenario in scenarios)
        planned_scenarios = sorted(
            scenario.id for scenario in scenarios if scenario.status == "planned"
        )

        pairwise_incomplete = sorted(
            manifest_id for manifest_id, detail in manifest_details.items()
            if not detail["pairwise_complete"]
        )
        generation_model_complete = not any((
            manifest_errors,
            duplicate_case_ids,
            duplicate_sql,
            pairwise_incomplete,
            valid_unselected,
            rule_gaps,
        ))
        source_extraction_complete = (
            not missing_source_lines
            and not unmapped_units
            and not unledgered_facts
            and not atomicity_gaps
        )
        static_coverage_complete = (
            source_extraction_complete
            and generation_model_complete
            and not feature_gaps
            and not unconsumed_confirmed_facts
        )
        behavior_coverage_complete = (
            static_coverage_complete
            and not planned_scenarios
            and not missing_scenario_facts
            and not unresolved_open_questions
        )
        pairwise_applicable_manifests = sorted(
            manifest_id for manifest_id, detail in manifest_details.items()
            if detail["pairwise_applicable"]
        )

        return {
            "factor_id": factor.id,
            "factor_status": factor.status,
            "source_units": {
                "ledger_id": ledger.id,
                "supplemental_sources": [
                    source.model_dump() for source in ledger.supplemental_sources
                ],
                "total": len(ledger.units),
                "accounted": accounted_source_units,
                "accounted_ratio": (
                    accounted_source_units / len(ledger.units) if ledger.units else 1.0
                ),
                "status_counts": dict(sorted(source_status_counts.items())),
                "line_coverage": {
                    "total": ledger.source_line_count,
                    "covered_by_units": len(unit_covered_lines),
                    "ignored": len(ignored_source_lines),
                    "missing": missing_source_lines,
                },
                "unmapped": unmapped_units,
                "atomicity": {
                    "reviewed": sum(
                        unit.atomicity != "unreviewed" for unit in ledger.units
                    ),
                    "unreviewed": sum(
                        unit.atomicity == "unreviewed" for unit in ledger.units
                    ),
                    "gaps": atomicity_gaps,
                    "complete": not atomicity_gaps,
                },
            },
            "facts": {
                "total": len(factor.facts),
                "confirmed": sum(fact.status == "confirmed" for fact in factor.facts),
                "open_questions": sum(fact.type == "open_question" for fact in factor.facts),
                "unresolved_open_questions": unresolved_open_questions,
                "unledgered": unledgered_facts,
                "unconsumed_confirmed": unconsumed_confirmed_facts,
            },
            "values": {
                "total": len(all_values),
                "selected": len(actually_selected),
                "valid_total": len(valid_values),
                "valid_selected": len(valid_values & actually_selected),
                "valid_unselected": valid_unselected,
                "unselected_by_validity": dict(sorted(unselected_by_validity.items())),
            },
            "rules": {
                "total": len(factor.rules),
                "details": rule_details,
                "gaps": rule_gaps,
            },
            "manifests": {
                "total": len(factor.manifest_refs),
                "generated_case_count": len(cases),
                "details": manifest_details,
                "errors": manifest_errors,
                "pairwise_incomplete": pairwise_incomplete,
                "duplicate_case_ids": sorted(duplicate_case_ids),
                "duplicate_sql": sorted(duplicate_sql),
                "pairwise_applicable": pairwise_applicable_manifests,
                "profile_enumeration_only": not pairwise_applicable_manifests,
            },
            "documented_features": {
                "total": len(documented_features),
                "covered": sum(feature.status == "covered" for feature in documented_features),
                "details": documented_feature_details,
                "needs_profile": feature_gaps,
            },
            "scenarios": {
                "total": len(scenarios),
                "status_counts": dict(sorted(scenario_status_counts.items())),
                "planned": planned_scenarios,
                "missing_required_fact_coverage": missing_scenario_facts,
            },
            "conclusions": {
                "source_extraction_complete": source_extraction_complete,
                "generation_model_complete": generation_model_complete,
                "static_coverage_complete": static_coverage_complete,
                "behavior_coverage_complete": behavior_coverage_complete,
                "pairwise_interaction_coverage_present": bool(pairwise_applicable_manifests),
            },
        }
