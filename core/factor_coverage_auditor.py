"""Factor-level coverage audit across source, specs, generation, and scenarios."""
from __future__ import annotations

from collections import Counter, defaultdict
from typing import Any, Dict, Iterable, List, Set

from .constraint_solver import ConstraintSolver
from .factor_package_generator import FactorPackageSQLGenerator
from .factor_package_model import FactorPackageRegistry
from .spec_generator import GenerationValidationError


# A rationale is an explicit, reviewable exception to the compound-statement
# heuristic.  Reusing the exact same waiver across a large batch of units is
# itself evidence that the units were not reviewed individually.  Keep the
# threshold high enough for a few genuinely identical example steps, while
# rejecting bulk boilerplate such as one sentence copied across a whole
# chapter.
MAX_IDENTICAL_ATOMICITY_RATIONALE_USES = 8


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
                "status": manifest.status,
                "oracle_status": manifest.expected.oracle_status,
                "environment_requirements": [
                    requirement.model_dump()
                    for requirement in manifest.environment_requirements
                ],
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
        units_by_line: Dict[int, List[Any]] = defaultdict(list)
        for unit in ledger.units:
            for line in range(unit.line_start, unit.line_end + 1):
                units_by_line[line].append(unit)
        declared_overlap_lines = {
            str(line): {
                "unit_ids": [unit.id for unit in units],
                "overlap_group": units[0].overlap_group,
                "rationale": units[0].overlap_rationale,
            }
            for line, units in sorted(units_by_line.items())
            if len(units) > 1
        }
        atomic_rationale_counts = Counter(
            unit.atomicity_rationale.strip()
            for unit in ledger.units
            if unit.atomicity == "atomic" and unit.atomicity_rationale
        )
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
                unit.atomicity == "atomic"
                and unit.statement.count("、") >= 2
                and not unit.atomicity_rationale
            ):
                reasons.append("compound_statement_requires_atomicity_rationale")
            if (
                unit.atomicity == "atomic"
                and unit.atomicity_rationale
                and atomic_rationale_counts[unit.atomicity_rationale.strip()]
                > MAX_IDENTICAL_ATOMICITY_RATIONALE_USES
            ):
                reasons.append("atomicity_rationale_reused_as_bulk_waiver")
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
                    "atomicity_rationale": unit.atomicity_rationale,
                    "reasons": reasons,
                })

        ledgered_fact_ids = {
            fact_id for unit in ledger.units for fact_id in unit.fact_refs
        }
        fact_consumers: Dict[str, Set[str]] = defaultdict(set)
        external_fact_consumers: Dict[str, Set[str]] = defaultdict(set)

        def record_consumers(
            refs: Iterable[str],
            consumer: str,
            owner_factor_id: str,
        ) -> None:
            for fact_ref in refs:
                target_factor_id, target_fact_id = self.registry._split_fact_ref(
                    owner_factor_id, fact_ref
                )
                if target_factor_id != factor.id or target_fact_id is None:
                    continue
                fact_consumers[target_fact_id].add(consumer)
                if owner_factor_id != factor.id:
                    external_fact_consumers[target_fact_id].add(
                        f"{owner_factor_id}:{consumer}"
                    )

        def record_factor_consumers(consumer_factor: Any) -> None:
            owner_factor_id = consumer_factor.id
            syntax = self.registry.get_syntax(consumer_factor.syntax_ref)
            if syntax is not None:
                record_consumers(
                    _iter_fact_refs(syntax.model_dump()), "syntax", owner_factor_id
                )
            for rule in consumer_factor.rules:
                record_consumers(rule.fact_refs, "rule", owner_factor_id)
            for check in consumer_factor.structural_checks:
                record_consumers(
                    check.fact_refs, "structural_check", owner_factor_id
                )
            for dimension in consumer_factor.dimensions.values():
                for equivalence_class in dimension.classes:
                    for value in equivalence_class.values:
                        record_consumers(
                            value.fact_refs, "dimension_value", owner_factor_id
                        )
            for manifest_id in consumer_factor.manifest_refs:
                manifest = self.registry.get_manifest(manifest_id)
                if manifest is None:
                    continue
                for local_rule in manifest.local_rules:
                    record_consumers(
                        local_rule.fact_refs, "manifest_rule", owner_factor_id
                    )
                for requirement in manifest.environment_requirements:
                    record_consumers(
                        requirement.fact_refs, "environment_gate", owner_factor_id
                    )
                record_consumers(
                    manifest.expected.fact_refs, "error_oracle", owner_factor_id
                )
            for matrix_id in consumer_factor.matrix_refs:
                matrix = self.registry.matrices.get(matrix_id)
                if matrix is not None:
                    record_consumers(
                        _iter_fact_refs(matrix.model_dump()), "matrix", owner_factor_id
                    )
            for fixture_id in consumer_factor.fixture_refs:
                fixture = self.registry.fixtures.get(fixture_id)
                if fixture is not None:
                    record_consumers(
                        _iter_fact_refs(fixture.model_dump()), "fixture", owner_factor_id
                    )
            for scenario_id in consumer_factor.scenario_refs:
                scenario = self.registry.scenarios.get(scenario_id)
                if scenario is not None:
                    record_consumers(
                        _iter_fact_refs(scenario.model_dump()), "scenario", owner_factor_id
                    )

        for consumer_factor in self.registry.factors.values():
            record_factor_consumers(consumer_factor)

        downstream_fact_ids = set(fact_consumers)

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
        unresolved_facts = sorted(
            fact.id for fact in factor.facts if fact.status == "needs_verification"
        )
        allowed_consumers = {
            "syntax": {"syntax", "dimension_value", "matrix"},
            "constraint": {
                "dimension_value", "matrix", "rule", "structural_check",
                "manifest_rule", "error_oracle", "scenario",
            },
            "environment": {
                "dimension_value", "matrix", "fixture", "scenario",
                "environment_gate",
            },
            "lifecycle": {"scenario"},
            "behavior_oracle": {"scenario", "error_oracle"},
            "metadata_oracle": {"scenario"},
            "example": {
                "syntax", "dimension_value", "matrix", "fixture", "scenario",
                "rule", "structural_check", "manifest_rule", "error_oracle",
            },
            "open_question": {"dimension_value", "matrix", "scenario", "manifest_rule"},
        }
        wrong_consumer_facts = sorted(
            fact.id
            for fact in factor.facts
            if fact.status == "confirmed"
            and fact.type != "example"
            and fact_consumers.get(fact.id)
            and not (fact_consumers[fact.id] & allowed_consumers[fact.type])
        )

        selected_values: Dict[str, Set[str]] = defaultdict(set)
        selected_values_by_suite: Dict[str, Set[tuple[str, str]]] = defaultdict(set)
        for case in cases:
            manifest = self.registry.get_manifest(case.case_id.rsplit("_", 1)[0])
            consumed_dimension_ids = set(
                getattr(case, "consumed_dimension_ids", case.params.keys())
            )
            for dimension_id, value_id in case.params.items():
                if dimension_id not in consumed_dimension_ids:
                    continue
                selected_values[dimension_id].add(value_id)
                if manifest is not None:
                    selected_values_by_suite[manifest.suite_type].add(
                        (dimension_id, value_id)
                    )
        all_values = {
            (dimension_id, value.id): value
            for dimension_id, values in resolved.items()
            for value in values.values()
        }
        valid_values = {
            key for key, value in all_values.items() if value.validity == "valid"
        }
        invalid_values = {
            key for key, value in all_values.items() if value.validity == "invalid"
        }
        conditional_values = {
            key for key, value in all_values.items() if value.validity == "conditional"
        }
        unknown_values = {
            key for key, value in all_values.items() if value.validity == "unknown"
        }
        actually_selected = {
            (dimension_id, value_id)
            for dimension_id, values in selected_values.items()
            for value_id in values
        }
        positive_selected = selected_values_by_suite.get("positive", set())
        negative_selected = selected_values_by_suite.get("negative", set())
        valid_unselected = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in valid_values - actually_selected
        )
        known_unselected = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in (
                valid_values | invalid_values | conditional_values
            ) - actually_selected
        )
        valid_without_positive = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in valid_values - positive_selected
        )
        invalid_without_negative = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in invalid_values - negative_selected
        )
        conditional_unselected = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in conditional_values - actually_selected
        )
        unknown_selected = sorted(
            f"{dimension_id}.{value_id}"
            for dimension_id, value_id in unknown_values & actually_selected
        )
        value_coverage_gaps = sorted(set(
            valid_without_positive
            + invalid_without_negative
            + conditional_unselected
            + unknown_selected
        ))
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
        documented_feature_details: Dict[str, Any] = {}
        feature_representation_gaps: List[str] = []
        feature_domain_gaps: List[str] = []
        for feature in documented_features:
            required_refs = set(feature.coverage_refs)
            selected_refs = required_refs & selected_profile_ids
            represented = feature.status == "covered" and bool(selected_refs)
            if feature.coverage_mode == "all":
                domain_complete = represented and required_refs <= selected_refs
            elif feature.coverage_mode == "any":
                domain_complete = represented
            else:
                domain_complete = False
            missing_refs = sorted(required_refs - selected_refs)
            documented_feature_details[feature.id] = {
                "status": feature.status,
                "coverage_mode": feature.coverage_mode,
                "profile_refs": list(feature.profile_refs),
                "value_refs": list(feature.value_refs),
                "selected_refs": sorted(selected_refs),
                "missing_refs": missing_refs,
                "represented": represented,
                "domain_complete": domain_complete,
            }
            if not represented:
                feature_representation_gaps.append(feature.id)
            if not domain_complete:
                feature_domain_gaps.append(feature.id)
        feature_representation_gaps.sort()
        feature_domain_gaps.sort()
        feature_gaps = sorted(set(feature_representation_gaps + feature_domain_gaps))

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
        non_ready_scenarios = sorted(
            scenario.id for scenario in scenarios if scenario.status != "ready"
        )
        unresolved_error_oracles = sorted(
            manifest_id
            for manifest_id in factor.manifest_refs
            for manifest in [self.registry.get_manifest(manifest_id)]
            if manifest is not None
            and manifest.expected.default == "error"
            and manifest.expected.oracle_status == "needs_verification"
        )

        pairwise_incomplete = sorted(
            manifest_id for manifest_id, detail in manifest_details.items()
            if not detail["pairwise_complete"]
        )
        # Empty domains/manifests have no counterexamples, but also no generation
        # evidence. In particular, a registered review-only package is not done.
        generation_model_complete = bool(factor.manifest_refs) and bool(cases) and not any((
            manifest_errors,
            duplicate_case_ids,
            duplicate_sql,
            pairwise_incomplete,
            value_coverage_gaps,
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
            and not wrong_consumer_facts
            and not unresolved_facts
            and not unresolved_error_oracles
        )
        behavior_coverage_complete = (
            static_coverage_complete
            and not non_ready_scenarios
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
                "declared_overlaps": {
                    "line_count": len(declared_overlap_lines),
                    "lines": declared_overlap_lines,
                },
            },
            "facts": {
                "total": len(factor.facts),
                "confirmed": sum(fact.status == "confirmed" for fact in factor.facts),
                "open_questions": sum(fact.type == "open_question" for fact in factor.facts),
                "unresolved_open_questions": unresolved_open_questions,
                "unresolved": unresolved_facts,
                "unledgered": unledgered_facts,
                "unconsumed_confirmed": unconsumed_confirmed_facts,
                "wrong_consumer_type": wrong_consumer_facts,
                "consumers": {
                    fact_id: sorted(consumers)
                    for fact_id, consumers in sorted(fact_consumers.items())
                },
                "external_consumers": {
                    fact_id: sorted(consumers)
                    for fact_id, consumers in sorted(external_fact_consumers.items())
                },
            },
            "values": {
                "total": len(all_values),
                "selected": len(actually_selected),
                "valid_total": len(valid_values),
                "valid_selected": len(valid_values & actually_selected),
                "valid_unselected": valid_unselected,
                "known_unselected": known_unselected,
                "valid_without_positive": valid_without_positive,
                "invalid_without_negative": invalid_without_negative,
                "conditional_unselected": conditional_unselected,
                "unknown_selected": unknown_selected,
                "coverage_gaps": value_coverage_gaps,
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
                "unresolved_error_oracles": unresolved_error_oracles,
            },
            "documented_features": {
                "total": len(documented_features),
                "covered": sum(
                    detail["domain_complete"]
                    for detail in documented_feature_details.values()
                ),
                "represented": sum(
                    detail["represented"]
                    for detail in documented_feature_details.values()
                ),
                "details": documented_feature_details,
                "needs_profile": feature_representation_gaps,
                "not_domain_complete": feature_domain_gaps,
                "coverage_gaps": feature_gaps,
            },
            "scenarios": {
                "total": len(scenarios),
                "status_counts": dict(sorted(scenario_status_counts.items())),
                "planned": planned_scenarios,
                "non_ready": non_ready_scenarios,
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
