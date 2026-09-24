"""Strict audit for Phase 1 auto-validation reports."""
from __future__ import annotations

from typing import Any, Dict, List, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator


class StrictPhase1ReportModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class Phase1ResultDef(StrictPhase1ReportModel):
    id: str
    desc: str
    sql: str
    expected: Dict[str, Any]
    actual: str
    status: Literal["PASS", "FAIL", "BLOCKED"]
    error: str = ""
    stage: Literal["setup", "target", "teardown"]
    returncode: int

    @field_validator("id", "desc", "sql", "actual")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("Phase 1 result field cannot be blank")
        return value

    @field_validator("expected")
    @classmethod
    def ensure_oracle(cls, value: Dict[str, Any]) -> Dict[str, Any]:
        if not value:
            raise ValueError("Phase 1 result must have an Oracle")
        return value


class Phase1SummaryDef(StrictPhase1ReportModel):
    total: int
    passed: int
    failed: int
    blocked: int
    executed: int
    pass_rate: str
    database: str
    user: str
    start: str
    end: str
    duration_sec: float

    @model_validator(mode="after")
    def ensure_nonnegative(self) -> "Phase1SummaryDef":
        for name in ("total", "passed", "failed", "blocked", "executed"):
            if getattr(self, name) < 0:
                raise ValueError(f"Phase 1 summary {name} cannot be negative")
        return self


class Phase1ReportDef(StrictPhase1ReportModel):
    summary: Phase1SummaryDef
    environment: Dict[str, str]
    results: List[Phase1ResultDef]

    @model_validator(mode="after")
    def ensure_result_count(self) -> "Phase1ReportDef":
        if self.summary.total != len(self.results):
            raise ValueError("Phase 1 summary.total does not match results")
        return self


class Phase1ReportAuditResult(StrictPhase1ReportModel):
    kind: Literal["phase1_report_audit"] = "phase1_report_audit"
    schema_version: Literal[1] = 1
    valid: bool
    errors: List[str] = Field(default_factory=list)
    summary: Dict[str, int]
    runtime_verified: bool = False
    limits: List[str] = Field(default_factory=lambda: [
        "A valid Phase 1 report proves only these 12 recorded steps, not general SQL coverage.",
        "Runtime verification requires setup, all 10 targets, and cleanup to pass.",
        "This audit does not replace database authorization or connection security review.",
    ])


def audit_phase1_report(report: Dict[str, Any]) -> Phase1ReportAuditResult:
    errors: List[str] = []
    try:
        parsed = Phase1ReportDef(**report)
    except Exception as exc:
        return Phase1ReportAuditResult(
            valid=False,
            errors=[f"Phase 1 report schema validation failed: {exc}"],
            summary={"total": 0, "passed": 0, "failed": 0, "blocked": 0, "executed": 0},
        )

    stages = [result.stage for result in parsed.results]
    expected_stages = ["setup"] + ["target"] * 10 + ["teardown"]
    if stages != expected_stages:
        errors.append(f"Phase 1 stages do not match setup + 10 targets + teardown: {stages}")

    target_ids = [result.id for result in parsed.results if result.stage == "target"]
    expected_ids = [f"P1-{index:03d}" for index in range(1, 11)]
    if target_ids != expected_ids:
        errors.append(f"Phase 1 target IDs do not match P1-001..P1-010: {target_ids}")

    setup_results = [result for result in parsed.results if result.stage == "setup"]
    teardown_results = [result for result in parsed.results if result.stage == "teardown"]
    if len(setup_results) != 1 or len(teardown_results) != 1:
        errors.append("Phase 1 report must contain exactly one setup and one teardown result")
    else:
        if setup_results[0].status != "PASS":
            errors.append("Phase 1 setup did not pass")
        if teardown_results[0].status != "PASS":
            errors.append("Phase 1 cleanup did not pass")

    targets = [result for result in parsed.results if result.stage == "target"]
    if len(targets) != 10:
        errors.append(f"Phase 1 report must contain 10 target results: {len(targets)}")
    else:
        blocked_without_failure = False
        previous_failed = False
        for result in targets:
            if result.status == "BLOCKED" and not previous_failed:
                blocked_without_failure = True
            previous_failed = result.status == "FAIL"
        if blocked_without_failure:
            errors.append("Phase 1 target BLOCKED without a prior target/setup failure")

    actual_passed = sum(result.status == "PASS" for result in parsed.results)
    actual_failed = sum(result.status == "FAIL" for result in parsed.results)
    actual_blocked = sum(result.status == "BLOCKED" for result in parsed.results)
    actual_executed = sum(result.returncode is not None for result in parsed.results)
    if actual_passed != parsed.summary.passed:
        errors.append(f"Phase 1 passed count mismatch: summary={parsed.summary.passed}, actual={actual_passed}")
    if actual_failed != parsed.summary.failed:
        errors.append(f"Phase 1 failed count mismatch: summary={parsed.summary.failed}, actual={actual_failed}")
    if actual_blocked != parsed.summary.blocked:
        errors.append(f"Phase 1 blocked count mismatch: summary={parsed.summary.blocked}, actual={actual_blocked}")
    if actual_executed != parsed.summary.executed:
        errors.append(f"Phase 1 executed count mismatch: summary={parsed.summary.executed}, actual={actual_executed}")

    runtime_verified = (
        not errors
        and len(targets) == 10
        and all(result.status == "PASS" for result in targets)
        and bool(setup_results)
        and setup_results[0].status == "PASS"
        and bool(teardown_results)
        and teardown_results[0].status == "PASS"
    )

    return Phase1ReportAuditResult(
        valid=not errors,
        errors=errors,
        summary={
            "total": len(parsed.results),
            "passed": actual_passed,
            "failed": actual_failed,
            "blocked": actual_blocked,
            "executed": actual_executed,
        },
        runtime_verified=runtime_verified,
    )
