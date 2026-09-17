#!/usr/bin/env python3
"""Build a bounded dry-run plan for the insert_same_key runtime pilot.

This is deliberately not a database executor and has no execute flag.  It only
revalidates an offline preparation artifact and emits the exact ordered plan to
run after explicit authorization, connection details, and environment checks.
"""
import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.execution_preparation import sql_identity
from core.insert_conflict_key_contract import check_same_key_tuple

PROFILE = "insert_same_key"
SUPPORTED_PROFILES = (PROFILE,)


def _require(condition, message):
    if not condition:
        raise ValueError(message)


def _validate_preparation(preparation):
    """Fail closed unless the artifact is the frozen three-unit pilot batch."""
    _require(isinstance(preparation, dict), "preparation must be an object")
    _require(preparation.get("kind") == "offline_execution_preparation_batch",
             "input kind must be offline_execution_preparation_batch")
    _require(preparation.get("schema_version") == 1, "preparation schema_version must be 1")
    _require(preparation.get("profile") == PROFILE, "preparation profile must be insert_same_key")
    _require(preparation.get("database_executed") is False, "input must not claim database_executed")
    _require(preparation.get("execution_authorized") is False,
             "input must not claim execution_authorized")
    _require(preparation.get("runtime_verified", 0) == 0, "input runtime_verified must be zero")

    summary = preparation.get("summary")
    _require(isinstance(summary, dict), "preparation summary must be an object")
    _require(summary.get("candidates") == 3, "insert_same_key preparation must have 3 candidates")
    _require(summary.get("scenario_sequences") == 3, "insert_same_key preparation must have 3 units")
    _require(summary.get("bound_candidate_ids") == 3, "all 3 candidates must be bound")
    _require(summary.get("unbound_candidate_ids") == [], "no candidate may remain unbound")
    _require(summary.get("runtime_verified") == 0, "summary runtime_verified must be zero")
    _require(summary.get("physical_modes") == ["PG"], "physical mode must be PG only")
    _require(summary.get("unit_status_counts") == {"oracle_calibration_pending": 3},
             "all units must remain oracle_calibration_pending")

    candidates = preparation.get("candidates")
    units = preparation.get("units")
    _require(isinstance(candidates, list) and len(candidates) == 3, "candidate inventory must contain 3 records")
    _require(isinstance(units, list) and len(units) == 3, "unit inventory must contain 3 records")
    candidate_ids = [case.get("case_id") for case in candidates]
    _require(all(candidate_ids) and len(set(candidate_ids)) == 3, "candidate IDs must be present and unique")
    return candidates, units


def _validate_unit(unit, candidates):
    _require(isinstance(unit, dict), "unit must be an object")
    scenario_ref = unit.get("scenario_ref")
    _require(isinstance(scenario_ref, str) and scenario_ref.startswith("scenario_insert_same_key_"),
             "unit scenario identity is outside insert_same_key")
    _require(unit.get("factor_ref") == "insert", "unit factor must be insert")
    _require(unit.get("static_blockers") == [], f"{scenario_ref}: static_blockers must be empty")
    _require(unit.get("execution_authorized") is False, f"{scenario_ref}: execution_authorized must remain false")
    _require(unit.get("database_executed") is False, f"{scenario_ref}: database was not executed")
    _require(unit.get("preparation_status") == "oracle_calibration_pending",
             f"{scenario_ref}: preparation status must remain oracle_calibration_pending")
    _require(unit.get("oracle_calibration_pending"), f"{scenario_ref}: Oracle calibration must remain pending")
    _require(unit.get("environment_requirements", {}).get("compatibility_mode") == ["PG"],
             f"{scenario_ref}: physical mode must be PG")
    _require(unit.get("ownership_plan", {}).get("runtime_ownership_proven") is False,
             f"{scenario_ref}: runtime ownership must remain unproven")
    _require("file_preparation_plan" not in unit,
             f"{scenario_ref}: insert_same_key must not require a file plan")

    evidence = unit.get("finite_contract_evidence")
    _require(isinstance(evidence, list) and len(evidence) == 1,
             f"{scenario_ref}: exactly one finite contract is required")
    evidence = evidence[0]
    _require(evidence.get("contract") == "same_inline_integer_key_tuple_v1",
             f"{scenario_ref}: finite contract identity mismatch")
    _require(evidence.get("runtime_proven") is False,
             f"{scenario_ref}: finite contract must not claim runtime proof")
    _require(evidence.get("arbitrary_key_change_proven") is False,
             f"{scenario_ref}: arbitrary key-change proof is out of scope")
    _require(evidence.get("planned_rows") is not None,
             f"{scenario_ref}: finite planned rows are required")
    _require(evidence.get("oracle_sql"), f"{scenario_ref}: finite Oracle SQL is required")

    steps = unit.get("steps")
    _require(isinstance(steps, list) and len(steps) == 1, f"{scenario_ref}: exactly one target step is required")
    step = steps[0]
    case_id = step.get("case_id")
    target_sql = step.get("resolved_sql")
    _require(case_id and target_sql, f"{scenario_ref}: bound target identity is required")
    case = next((item for item in candidates if item.get("case_id") == case_id), None)
    _require(case is not None, f"{scenario_ref}: bound case is absent from candidate inventory")
    _require(case.get("sql") == target_sql, f"{scenario_ref}: target SQL differs from candidate")
    _require(case.get("setup_sqls") == unit.get("setup_sqls"),
             f"{scenario_ref}: setup lifecycle differs from candidate")
    _require(case.get("teardown_sqls") == unit.get("teardown_sqls"),
             f"{scenario_ref}: teardown lifecycle differs from candidate")
    _require(case.get("expected") == "success", f"{scenario_ref}: target must expect success")
    _require(case.get("expected_scope") == "syntax_only",
             f"{scenario_ref}: target syntax-only scope must remain separate from runtime proof")
    _require(len(unit.get("setup_sqls", [])) == 2,
             f"{scenario_ref}: finite contract requires exactly two setup statements")
    _require(len(unit.get("teardown_sqls", [])) == 1,
             f"{scenario_ref}: finite contract requires exactly one teardown statement")
    gates = {}
    for gate in case.get("environment_requirements", []):
        key, values = gate.get("key"), gate.get("allowed_values")
        _require(isinstance(key, str) and isinstance(values, list) and key not in gates,
                 f"{scenario_ref}: duplicate or malformed environment gate")
        gates[key] = values
    try:
        recomputed = check_same_key_tuple(target_sql, unit["setup_sqls"],
                                           unit["teardown_sqls"], gates)
    except ValueError as exc:
        raise ValueError(f"{scenario_ref}: finite contract recomputation failed: {exc}") from exc
    recomputed["step_id"] = step["step_id"]
    _require(recomputed == evidence,
             f"{scenario_ref}: finite_contract_evidence differs from actual candidate")

    scenario = unit.get("source_scenario")
    _require(isinstance(scenario, dict), f"{scenario_ref}: source scenario is required")
    oracles = scenario.get("oracles")
    _require(isinstance(oracles, list) and len(oracles) == 1,
             f"{scenario_ref}: exactly one result-set Oracle is required")
    oracle = oracles[0]
    _require(oracle.get("kind") == "result_set", f"{scenario_ref}: Oracle must be result_set")
    _require(oracle.get("step_id") == step.get("step_id"),
             f"{scenario_ref}: Oracle step identity mismatch")
    _require(oracle.get("expected") == evidence.get("planned_rows"),
             f"{scenario_ref}: finite oracle identity mismatch: expected rows")
    try:
        oracle_identity = sql_identity(oracle.get("sql", ""))
        finite_identity = sql_identity(evidence["oracle_sql"])
    except ValueError as exc:
        raise ValueError(f"{scenario_ref}: finite oracle identity mismatch: {exc}") from exc
    _require(oracle_identity == finite_identity,
             f"{scenario_ref}: finite oracle identity mismatch: SQL")
    return scenario_ref, case_id, evidence, step, oracle, case


def build_dry_run(preparation, *, input_path=None):
    """Revalidate a preparation batch and return an execution-only dry-run plan."""
    candidates, units = _validate_preparation(preparation)
    planned_units = []
    for unit in units:
        scenario_ref, case_id, evidence, step, oracle, case = _validate_unit(unit, candidates)
        setup_sqls = unit["setup_sqls"]
        teardown_sqls = unit["teardown_sqls"]
        execution_plan = [{
            "phase": "environment_check",
            "action": "verify_connection_and_physical_mode",
            "required_values": {"compatibility_mode": ["PG"]},
            "must_succeed": True,
        }]
        execution_plan.extend({
            "phase": "setup", "sequence": index, "sql": sql,
            "expected": "command_success", "must_succeed": True,
        } for index, sql in enumerate(setup_sqls, 1))
        execution_plan.append({
            "phase": "target", "case_id": case_id, "sql": step["resolved_sql"],
            "expected": "target_success", "must_succeed": True,
        })
        execution_plan.append({
            "phase": "oracle", "sql": oracle["sql"],
            "expected_rows": evidence["planned_rows"],
            "comparison": "exact_ordered_rows", "must_succeed": True,
        })
        execution_plan.extend({
            "phase": "teardown", "sequence": index, "sql": sql,
            "expected": "command_success", "execute_only_with_owned_create_receipt": True,
        } for index, sql in enumerate(teardown_sqls, 1))

        planned_units.append({
            "scenario_ref": scenario_ref,
            "case_id": case_id,
            "status": "ready_for_authorized_execution",
            "database_executed": False,
            "runtime_verified": False,
            "environment_requirements": unit["environment_requirements"],
            "finite_contract": evidence,
            "execution_plan": execution_plan,
            "cleanup": {
                "only_owned_objects": True,
                "runtime_ownership_proven": False,
                "requires_create_receipts": True,
                "requires_residue_check": True,
            },
            "failure_policy": unit["failure_policy"],
        })

    ready_units = sum(unit["status"] == "ready_for_authorized_execution" for unit in planned_units)
    blocked_units = len(planned_units) - ready_units
    return {
        "kind": "runtime_execution_dry_run",
        "schema_version": 1,
        "profile": PROFILE,
        "status": "ready_for_authorized_execution" if ready_units == 3 and blocked_units == 0 else "blocked",
        "database_executed": False,
        "execution_authorized": False,
        "runtime_verified": 0,
        "input_path": str(Path(input_path).resolve()) if input_path else None,
        "input_sha256": preparation.get("input_sha256"),
        "summary": {
            "units": len(planned_units),
            "ready_units": ready_units,
            "blocked_units": blocked_units,
            "planned_target_steps": sum(unit["execution_plan"][3]["phase"] == "target"
                                         for unit in planned_units),
            "planned_oracles": sum(unit["execution_plan"][4]["phase"] == "oracle"
                                    for unit in planned_units),
        },
        "units": planned_units,
        "execution_requirements": [
            "explicit_database_authorization",
            "verified_PG_physical_mode",
            "isolated_connection_and_namespace",
            "per_setup_success_receipt",
            "per_target_result",
            "exact_oracle_result",
            "owned_cleanup_and_residue_check",
        ],
        "limits": [
            "This dry run does not open a database connection or execute SQL.",
            "A planned target success is not a runtime proof or Oracle result.",
            "Cleanup may run only for objects proven created by the same unit run.",
            "The three units must run independently; never concatenate their SQL.",
        ],
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True,
                        help="Existing insert_same_key offline preparation JSON")
    parser.add_argument("--output", type=Path, required=True,
                        help="New dry-run JSON receipt; existing paths are never overwritten")
    parser.add_argument("--profile", choices=SUPPORTED_PROFILES, default=PROFILE)
    args = parser.parse_args(argv)
    try:
        _require(args.input.is_file(), f"input preparation not found: {args.input}")
        _require(not args.output.exists(), f"output already exists: {args.output}")
        preparation = json.loads(args.input.read_text(encoding="utf-8"))
        _require(preparation.get("profile") == args.profile,
                 f"input profile must be {args.profile}")
        plan = build_dry_run(preparation, input_path=args.input)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        parser.error(str(exc))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("x", encoding="utf-8") as stream:
        json.dump(plan, stream, ensure_ascii=False, indent=2)
        stream.write("\n")
    print(json.dumps({
        "output": str(args.output.resolve()),
        "summary": plan["summary"],
        "status": plan["status"],
        "database_executed": plan["database_executed"],
        "sha256": hashlib.sha256(args.output.read_bytes()).hexdigest(),
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
