"""GaussDB 测试因子库 — Web 应用入口。"""
import json
import os
from datetime import datetime
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse, PlainTextResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from core.registry import FactorRegistry
from core.generator import generate_cases
from core.executor import Executor, ExecConfig
from core.reporter import generate_report
from core.scenario import ScenarioEngine, ScenarioDef, ScenarioStepDef
from core.symbol_table import SchemaContext
from core.spec_model import SpecRegistry
from core.spec_generator import SpecSQLGenerator
from core.factor_package_model import FactorPackageLoadError, FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.generation_gap_dispositions import category_label as generation_gap_category_label
from core.generation_gap_dispositions import load_generation_gap_dispositions
from core.no_manifest_dispositions import category_label, load_no_manifest_dispositions
from core.package_inventory import package_inventory
from core.progress_reporting import factor_progress, summarize_progress
from core.runtime_status import build_runtime_status
from core.guc_environment import GucEnvironmentRegistry
from core.guc_plan_export import GucOverlayPlanExportRegistry, render_guc_overlay_plan_sql
from core.guc_audit import build_guc_v2_audit
from core.guc_capability import GucCapabilityRegistry
from core.guc_requirement_adapter import GucRequirementAdapterRegistry
from core.guc_requirement_resolver import resolve_guc_requirements
from core.guc_execution_selector import GucExecutionSelectionError, select_guc_execution_values
from core.guc_preflight import GucV2PreflightRegistry
from core.guc_readiness import build_guc_v2_readiness
from core.guc_execution_gate import evaluate_guc_v2_execution_gate
from core.guc_evidence_bundle import build_guc_v2_evidence_bundle, verify_guc_v2_evidence_bundle
from core.guc_runtime_pilot import GucV2RuntimePilotRegistry
from core.advanced_package import AdvancedPackageRegistry
from core.advanced_package_candidate import build_advanced_package_candidate_matrix
from core.advanced_package_gate import evaluate_advanced_package_gate
from core.advanced_package_evidence import AdvancedEvidenceBundleRegistry, verify_advanced_package_evidence_bundle
from core.runtime_validation_pilot import RuntimePilotPlanDef
from core.advanced_package_gate import evaluate_advanced_package_gate

BASE_DIR = Path(__file__).resolve().parent
FACTORS_DIR = BASE_DIR / "factors"
SPECS_DIR = BASE_DIR / "specs"
REPORTS_DIR = BASE_DIR / "reports"
STATIC_DIR = BASE_DIR / "web" / "static"
TEMPLATES_DIR = BASE_DIR / "web" / "templates"

app = FastAPI(title="GaussDB 测试因子库")
app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")
templates = Jinja2Templates(directory=str(TEMPLATES_DIR))

# Legacy 注册表只在兼容路由中按需加载；默认工作台只读取 PDF-first V1。
registry = FactorRegistry(str(FACTORS_DIR))
spec_registry = SpecRegistry(str(BASE_DIR))

factor_package_registry = FactorPackageRegistry(SPECS_DIR)
factor_package_registry.load_all()

# 执行器（桩模式）
executor = Executor(ExecConfig(enabled=False))


def _factor_package_coverage_report() -> dict:
    """Compute one live, evidence-layered report for all PDF factor packages."""
    factor_package_registry.load_all()
    auditor = FactorCoverageAuditor(factor_package_registry)
    audits = {
        factor_id: auditor.audit(factor_id)
        for factor_id in sorted(factor_package_registry.factors)
    }
    progress = summarize_progress(audits)
    for audit in audits.values():
        audit['display_progress'] = factor_progress(audit)
    dispositions = load_no_manifest_dispositions() or {}
    inventory = package_inventory(
        factor_package_registry,
        list(factor_package_registry.manifests),
        dispositions,
    )
    for row in inventory["without_manifest"]:
        row["blocking_category_label"] = category_label(row["blocking_category"])
        audits[row["factor_ref"]]["no_manifest_disposition"] = row
    generation_gap_dispositions = load_generation_gap_dispositions() or {}
    generation_gap_refs = {
        factor_id for factor_id, audit in audits.items()
        if audit["manifests"]["total"]
        and not audit["conclusions"]["generation_model_complete"]
    }
    if set(generation_gap_dispositions) != generation_gap_refs:
        missing = sorted(generation_gap_refs - set(generation_gap_dispositions))
        unexpected = sorted(set(generation_gap_dispositions) - generation_gap_refs)
        raise ValueError(
            "Generation-gap disposition set mismatch: "
            f"missing={missing}, unexpected={unexpected}"
        )
    generation_model_gaps = []
    for factor_id in sorted(generation_gap_refs):
        disposition = generation_gap_dispositions[factor_id]
        audit = audits[factor_id]
        row = {
            "factor_ref": factor_id,
            "status": "generation_model_not_complete",
            "blocking_category": disposition["blocking_category"],
            "blocking_category_label": generation_gap_category_label(
                disposition["blocking_category"]
            ),
            "blocking_reason": disposition["blocking_reason"],
            "next_action": disposition["next_action"],
            "value_gaps": audit["values"]["coverage_gaps"],
            "feature_gaps": audit["documented_features"]["coverage_gaps"],
            "unresolved_fact_refs": audit["facts"]["unresolved"],
        }
        generation_model_gaps.append(row)
        audits[factor_id]["generation_gap_disposition"] = row
    catalog_path = BASE_DIR / "generated" / "audit" / "pdf_catalog_coverage.json"
    catalog_summary = {
        "total": 0,
        "cataloged": 0,
        "extracted": len(audits),
        "package_bound": len(audits),
        "static_complete": sum(
            audit["conclusions"]["static_coverage_complete"]
            for audit in audits.values()
        ),
    }
    if catalog_path.exists():
        catalog_payload = json.loads(catalog_path.read_text(encoding="utf-8"))
        stored_summary = catalog_payload.get("summary", {})
        if isinstance(stored_summary, dict):
            # The catalog inventory is persistent evidence, while package binding and
            # completion counts are live.  Do not let a first-batch audit snapshot
            # overwrite the current registry after later batches are added.
            catalog_summary.update({
                key: int(stored_summary.get(key, catalog_summary[key]))
                for key in ("total", "cataloged")
            })
    return {
        "created_at": datetime.now().astimezone().isoformat(timespec="seconds"),
        "catalog": catalog_summary,
        "factor_count": len(audits),
        "progress": progress,
        "legacy_count_note": "*_complete_count 是兼容性规格指标，不是有用例或实机通过数；展示请使用 progress。",
        "manifest_count": len(factor_package_registry.manifests),
        "generated_case_count": sum(
            audit["manifests"]["generated_case_count"]
            for audit in audits.values()
        ),
        "source_complete_count": sum(
            audit["conclusions"]["source_extraction_complete"]
            for audit in audits.values()
        ),
        "generation_complete_count": sum(
            audit["conclusions"]["generation_model_complete"]
            for audit in audits.values()
        ),
        "static_complete_count": sum(
            audit["conclusions"]["static_coverage_complete"]
            for audit in audits.values()
        ),
        "behavior_complete_count": sum(
            audit["conclusions"]["behavior_coverage_complete"]
            for audit in audits.values()
        ),
        "atomicity_gap_count": sum(
            len(audit["source_units"]["atomicity"]["gaps"])
            for audit in audits.values()
        ),
        "value_gap_count": sum(
            len(audit["values"]["coverage_gaps"])
            for audit in audits.values()
        ),
        "feature_gap_count": sum(
            len(audit["documented_features"]["coverage_gaps"])
            for audit in audits.values()
        ),
        "unresolved_oracle_count": sum(
            len(audit["manifests"]["unresolved_error_oracles"])
            for audit in audits.values()
        ),
        "planned_scenario_count": sum(
            len(audit["scenarios"]["planned"])
            for audit in audits.values()
        ),
        "package_inventory": inventory,
        "generation_model_gap_count": len(generation_model_gaps),
        "generation_model_gaps": generation_model_gaps,
        "without_manifest_count": inventory["without_manifest_count"],
        "without_manifest": inventory["without_manifest"],
        "no_manifest_disposition_categories": {
            category: sum(
                row["blocking_category"] == category
                for row in inventory["without_manifest"]
            )
            for category in sorted({row["blocking_category"] for row in inventory["without_manifest"]})
        },
        "factors": audits,
    }


@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    """PDF-first V1 主页：不扫描历史 226 因子。"""
    factor_package_registry.load_all()
    return templates.TemplateResponse(request, "index.html", {
        "request": request,
        "v1_factors": factor_package_registry.factors,
        "v1_manifests": factor_package_registry.manifests,
    })


@app.get("/specs/factor/{factor_id}", response_class=HTMLResponse)
async def factor_package_detail(request: Request, factor_id: str):
    """Factor Package V1 详情页（HTMX 片段）。"""
    try:
        factor_package_registry.load_all()
    except FactorPackageLoadError as exc:
        return HTMLResponse(str(exc), status_code=422)
    factor = factor_package_registry.get_factor(factor_id)
    if factor is None:
        return HTMLResponse("Factor Package 未找到", status_code=404)
    confirmed_count = sum(1 for fact in factor.facts if fact.status == "confirmed")
    open_questions = [fact for fact in factor.facts if fact.type == "open_question"]
    coverage_audit = FactorCoverageAuditor(factor_package_registry).audit(factor_id)
    disposition = (load_no_manifest_dispositions() or {}).get(factor_id)
    if disposition is not None:
        disposition = {
            **disposition,
            "blocking_category_label": category_label(disposition["blocking_category"]),
        }
    generation_gap = (load_generation_gap_dispositions() or {}).get(factor_id)
    if generation_gap is not None:
        generation_gap = {
            **generation_gap,
            "blocking_category_label": generation_gap_category_label(
                generation_gap["blocking_category"]
            ),
        }
    return templates.TemplateResponse(request, "_factor_package_detail.html", {
        "request": request,
        "factor": factor,
        "confirmed_count": confirmed_count,
        "open_questions": open_questions,
        "coverage_audit": coverage_audit,
        "progress": factor_progress(coverage_audit),
        "no_manifest_disposition": disposition,
        "generation_gap_disposition": generation_gap,
        "manifests": [
            factor_package_registry.get_manifest(manifest_id)
            for manifest_id in factor.manifest_refs
        ],
    })


@app.get("/specs/manifest/{manifest_id}", response_class=HTMLResponse)
async def factor_package_manifest_detail(request: Request, manifest_id: str):
    """Factor Package V1 manifest 详情页（HTMX 片段）。"""
    try:
        factor_package_registry.load_all()
    except FactorPackageLoadError as exc:
        return HTMLResponse(str(exc), status_code=422)
    manifest = factor_package_registry.get_manifest(manifest_id)
    if manifest is None:
        return HTMLResponse("V1 测试清单未找到", status_code=404)
    return templates.TemplateResponse(request, "_factor_package_manifest_detail.html", {
        "request": request,
        "manifest": manifest,
    })


@app.get("/specs/scenarios", response_class=HTMLResponse)
async def factor_package_scenarios(request: Request):
    """列出 PDF-first V1 planned/ready 场景，不触发数据库执行。"""
    try:
        factor_package_registry.load_all()
    except FactorPackageLoadError as exc:
        return HTMLResponse(str(exc), status_code=422)
    scenarios_by_factor = {
        factor_id: [
            factor_package_registry.scenarios[scenario_id]
            for scenario_id in factor.scenario_refs
            if scenario_id in factor_package_registry.scenarios
        ]
        for factor_id, factor in factor_package_registry.factors.items()
    }
    return templates.TemplateResponse(request, "_factor_package_scenarios.html", {
        "request": request,
        "scenarios_by_factor": scenarios_by_factor,
        "scenario_count": sum(map(len, scenarios_by_factor.values())),
    })


@app.post("/specs/manifest/generate", response_class=HTMLResponse)
async def factor_package_manifest_generate(request: Request, manifest_id: str = Form(...)):
    """生成 V1 SQL 与覆盖证据，不连接数据库。"""
    try:
        factor_package_registry.load_all()
        manifest = factor_package_registry.get_manifest(manifest_id)
        if manifest is None:
            return HTMLResponse("V1 测试清单未找到", status_code=404)
        cases, report = FactorPackageSQLGenerator(factor_package_registry).generate_with_report(manifest)
    except (FactorPackageLoadError, ValueError) as exc:
        return HTMLResponse(str(exc), status_code=422)
    return templates.TemplateResponse(request, "_case_list.html", {
        "request": request,
        "factor": manifest,
        "cases": cases,
        "strategy": manifest.strategy,
        "report": report,
        "allow_execute": False,
    })


@app.get("/manifest/{manifest_id}", response_class=HTMLResponse)
async def manifest_detail(request: Request, manifest_id: str):
    """测试清单详情页（HTMX 片段）。"""
    spec_registry.load_all()
    manifest = spec_registry.get_manifest(manifest_id)
    if not manifest:
        return HTMLResponse("测试清单未找到", status_code=404)
    return templates.TemplateResponse(request, "_manifest_detail.html", {
        "request": request,
        "manifest": manifest,
    })


@app.post("/manifest/generate", response_class=HTMLResponse)
async def manifest_generate(request: Request, manifest_id: str = Form(...)):
    """根据测试清单生成用例（HTMX 片段）。"""
    spec_registry.load_all()
    manifest = spec_registry.get_manifest(manifest_id)
    if not manifest:
        return HTMLResponse("测试清单未找到", status_code=404)
    gen = SpecSQLGenerator(spec_registry)
    cases = gen.generate_cases_for_manifest(manifest)
    return templates.TemplateResponse(request, "_case_list.html", {
        "request": request,
        "factor": manifest,
        "cases": cases,
        "strategy": manifest.strategy,
        "allow_execute": False,
    })


@app.get("/coverage", response_class=HTMLResponse)
async def coverage_view(request: Request):
    """展示 PDF 目录、V1 静态模型与行为层的分层结论。"""
    try:
        report = _factor_package_coverage_report()
    except (FactorPackageLoadError, ValueError) as exc:
        return HTMLResponse(str(exc), status_code=422)
    return templates.TemplateResponse(request, "_factor_package_coverage.html", {
        "request": request,
        "report": report,
    })


@app.get("/api/coverage/export-md")
async def coverage_export_md():
    """下载当前 PDF-first V1 分层覆盖报告。"""
    from fastapi.responses import Response
    report = _factor_package_coverage_report()
    lines = [
        "# PDF-first Factor Package 覆盖报告",
        "",
        f"生成时间：{report['created_at']}",
        "",
        "## PDF 目录口径",
        "",
        f"- cataloged: {report['catalog']['cataloged']}",
        f"- extracted: {report['catalog']['extracted']}",
        f"- package_bound: {report['catalog']['package_bound']}",
        f"- 有用例且满足静态条件: {report['progress']['static_covered_count']}",
        "",
        "## 全部因子包：四阶段进度",
        "",
        f"包已建：{report['progress']['package_count']}；有候选：{report['progress']['with_candidates_count']}；有用例且静态覆盖满足：{report['progress']['static_covered_count']}。",
        "实机验证：未接入执行证据，不从场景 ready 或行为规格布尔值推断。",
        "来源账本处置不代表语义穷尽；旧规格完整计数不用于可执行覆盖率。",
        f"生成模型满足声明条件：{report['progress']['generation_model_satisfied_count']}包；"
        f"有候选但模型仍有缺口：{report['progress']['generation_model_gap_count']}包；"
        f"诊断无法核对：{report['progress']['generation_diagnostics_unavailable_count']}包。",
        f"另列错误Oracle待校准：{report['progress']['unresolved_oracle_package_count']}包 / "
        f"{report['progress']['unresolved_oracle_manifest_count']}份清单，不是生成异常。",
        "条件值未纳入不等于产品不支持；应先核实来源与支持条件，不直接补为正向。",
        "",
        "## 生成模型剩余缺口",
        "",
        f"当前 {report['generation_model_gap_count']} 个有manifest包仍未满足生成模型声明条件。",
        "",
        "| Factor | 阻断类别 | 当前原因 | 下一步动作 |",
        "|---|---|---|---|",
    ]
    for row in report["generation_model_gaps"]:
        lines.append(
            f"| {row['factor_ref']} | {row['blocking_category_label']} | "
            f"{row['blocking_reason']} | {row['next_action']} |"
        )
    lines.extend([
        "",
        "## 无普通manifest处置",
        "",
        f"当前 {report['without_manifest_count']} 包无普通manifest；无manifest不是统一的不支持结论。",
        "",
        "| Factor | 阻断类别 | 当前原因 | 下一步动作 |",
        "|---|---|---|---|",
    ])
    for row in report["without_manifest"]:
        lines.append(
            f"| {row['factor_ref']} | {row['blocking_category_label']} | "
            f"{row['blocking_reason']} | {row['next_action']} |"
        )
    lines.extend([
        "",
        "| Factor | 包已建 | SQL候选数 | 原文账本 | 候选生成 | 生成模型诊断 | 静态覆盖 | 实机验证 |",
        "|---|---|---:|---|---|---|---|---|",
    ])
    for factor_id, audit in report["factors"].items():
        p = audit['display_progress']
        generation = {'generated': '有候选', 'partial': '部分生成/有异常', 'no_cases': '无候选'}[p['generation_status']]
        static = {'covered': '声明范围满足', 'gaps': '有缺口', 'no_cases': '无用例，不计通过'}[p['static_status']]
        diagnostics = p['generation_diagnostics']
        reason = diagnostics['label'] + ''.join(
            f"；{item['label']} {item['count']}" for item in diagnostics['blockers'])
        lines.append(
            f"| {factor_id} | 已建 | {audit['manifests']['generated_case_count']} | "
            f"{'已登记' if p['source_accounted'] else '有缺口'} | {generation} | {reason} | {static} | 未接入证据 |"
        )
    md_content = "\n".join(lines) + "\n"
    return Response(
        content=md_content,
        media_type="text/markdown",
        headers={"Content-Disposition": "attachment; filename=gaussdb_pdf_factor_coverage.md"}
    )


@app.get("/api/coverage/summary")
async def coverage_api_summary():
    """JSON API：PDF-first V1 的分层覆盖事实。"""
    return JSONResponse(_factor_package_coverage_report())


@app.get("/runtime", response_class=HTMLResponse)
async def runtime_status_page(request: Request):
    """Runtime readiness page; reads local artifacts only."""
    return templates.TemplateResponse(request, "_runtime_status.html", {
        "request": request,
        "status": build_runtime_status(BASE_DIR).model_dump(),
    })


@app.get("/api/runtime/status")
async def runtime_status_api():
    """JSON API：聚合当前 runtime 计划、回执、审计与预检状态。"""
    return JSONResponse(build_runtime_status(BASE_DIR).model_dump())


# ===== GUC V2 API =====
def _guc_v2_environment():
    """Load the strict GUC Environment V2 inventory."""
    registry = GucEnvironmentRegistry(
        BASE_DIR,
        inventory_path=BASE_DIR / "environments/guc_parameters_v2.yaml",
    )
    registry.load_all()
    return registry


def _guc_v2_plan_export():
    """Load the deterministic GUC V2 overlay plan export."""
    return GucOverlayPlanExportRegistry(BASE_DIR).load()


@app.get("/guc", response_class=HTMLResponse)
async def guc_v2_page(request: Request):
    """GUC V2 browser page; local artifacts only, no database execution."""
    registry = _guc_v2_environment()
    export = _guc_v2_plan_export()
    return templates.TemplateResponse(request, "_guc.html", {
        "request": request,
        "environment": registry.environment.model_dump(),
        "parameters": [
            parameter.model_dump()
            for parameter in sorted(
                registry.parameters.values(),
                key=lambda item: (item.category, item.name),
            )
        ],
        "plans": export.model_dump(),
        "plan_sql": render_guc_overlay_plan_sql(export),
        "audit": build_guc_v2_audit(BASE_DIR).model_dump(),
        "preflight": GucV2PreflightRegistry(BASE_DIR).load().model_dump(),
        "readiness": build_guc_v2_readiness(BASE_DIR).model_dump(),
        "capabilities": GucCapabilityRegistry(BASE_DIR).load().model_dump(),
        "requirement_adapter": GucRequirementAdapterRegistry(BASE_DIR).load().model_dump(),
        "execution_selections": select_guc_execution_values(
            resolve_guc_requirements(
                {
                    item.requirement.key: item.requirement.allowed_values
                    for item in GucRequirementAdapterRegistry(BASE_DIR).load().requirements
                },
                BASE_DIR,
            ),
            BASE_DIR,
        ).model_dump(),
        "evidence_bundle": build_guc_v2_evidence_bundle(BASE_DIR).model_dump(),
        "evidence_verification": verify_guc_v2_evidence_bundle(BASE_DIR).model_dump(),
        "execution_gate": evaluate_guc_v2_execution_gate(
            build_guc_v2_readiness(BASE_DIR),
            authorized_flag=False,
            authorization_environment_set=os.getenv("GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED", "").lower() in {"true", "1", "yes"},
            database_enabled=os.getenv("GAUSSDB_ENABLED", "false").lower() in {"true", "1", "yes"},
        ).model_dump(),
        "runtime_plan": GucV2RuntimePilotRegistry(BASE_DIR).load(
            BASE_DIR / "generated/guc_environment_v2/runtime_dry_run.json"
        ).model_dump(),
    })


@app.get("/api/guc/v2/summary")
async def guc_v2_summary_api():
    """JSON API：GUC Environment V2 与 overlay plan export 摘要。"""
    registry = _guc_v2_environment()
    export = _guc_v2_plan_export()
    return JSONResponse({
        "environment": registry.environment.model_dump(exclude={"parameters"}),
        "overlay_plans": export.model_dump(exclude={"plans"}),
    })


@app.get("/api/guc/v2/parameters")
async def guc_v2_parameters_api(policy: Optional[str] = None):
    """JSON API：GUC Environment V2 参数清单，可按 policy 过滤。"""
    registry = _guc_v2_environment()
    parameters = [
        parameter.model_dump()
        for parameter in sorted(
            registry.parameters.values(),
            key=lambda item: (item.category, item.name),
        )
        if policy is None or parameter.execution_policy == policy
    ]
    return JSONResponse({
        "total": len(parameters),
        "policy_filter": policy,
        "parameters": parameters,
    })


@app.get("/api/guc/v2/parameters/{parameter_id}")
async def guc_v2_parameter_api(parameter_id: str):
    """JSON API：单个 GUC Environment V2 参数。"""
    registry = _guc_v2_environment()
    parameter = registry.parameters.get(parameter_id)
    if parameter is None:
        return JSONResponse({"detail": "GUC parameter not found"}, status_code=404)
    return JSONResponse(parameter.model_dump())


@app.get("/api/guc/v2/plans")
async def guc_v2_plans_api():
    """JSON API：19个session overlay计划。"""
    return JSONResponse(_guc_v2_plan_export().model_dump())


@app.get("/api/guc/v2/plans.sql", response_class=PlainTextResponse)
async def guc_v2_plans_sql_api():
    """Plain-text API：session overlay SQL计划。"""
    return PlainTextResponse(
        render_guc_overlay_plan_sql(_guc_v2_plan_export()),
        media_type="text/plain; charset=utf-8",
    )


@app.get("/api/guc/v2/runtime-plan")
async def guc_v2_runtime_plan_api():
    """JSON API：19个GUC V2 runtime pilot dry-run单元。"""
    plan = GucV2RuntimePilotRegistry(BASE_DIR).load(
        BASE_DIR / "generated/guc_environment_v2/runtime_dry_run.json"
    )
    return JSONResponse(plan.model_dump())


@app.get("/api/guc/v2/audit")
async def guc_v2_audit_api():
    """JSON API：跨Reference/Candidate/Environment/Plan的静态审计。"""
    return JSONResponse(build_guc_v2_audit(BASE_DIR).model_dump())


@app.get("/api/guc/v2/preflight-plan")
async def guc_v2_preflight_plan_api():
    """JSON API：27个只读GUC V2 preflight查询。"""
    return JSONResponse(GucV2PreflightRegistry(BASE_DIR).load().model_dump())


@app.get("/api/guc/v2/readiness")
async def guc_v2_readiness_api():
    """JSON API：GUC V2静态、preflight、授权与运行时证据分层。"""
    return JSONResponse(build_guc_v2_readiness(BASE_DIR).model_dump())


@app.get("/api/guc/v2/capabilities")
async def guc_v2_capabilities_api():
    """JSON API：19个GUC V2环境能力适配项。"""
    return JSONResponse(GucCapabilityRegistry(BASE_DIR).load().model_dump())


@app.get("/api/guc/v2/requirement-adapter")
async def guc_v2_requirement_adapter_api():
    """JSON API：GUC V2到Factor Package环境门禁的保守适配层。"""
    return JSONResponse(GucRequirementAdapterRegistry(BASE_DIR).load().model_dump())


@app.get("/api/guc/v2/execution-selector")
async def guc_v2_execution_selector_api(requirement: str, value: Optional[str] = None):
    """JSON API：为一个GUC环境门禁选择具体值并生成五步计划。"""
    adapter = GucRequirementAdapterRegistry(BASE_DIR).load()
    matched = next(
        (item for item in adapter.requirements if item.requirement.key == requirement),
        None,
    )
    if matched is None:
        return JSONResponse({"detail": "GUC requirement not found"}, status_code=404)
    selected_value = value or matched.requirement.allowed_values[0]
    if selected_value not in matched.requirement.allowed_values:
        return JSONResponse(
            {"detail": "GUC value is not allowed", "allowed_values": matched.requirement.allowed_values},
            status_code=400,
        )
    gates = {requirement: [selected_value]}
    resolved = resolve_guc_requirements(gates, BASE_DIR)
    try:
        selection = select_guc_execution_values(
            resolved, BASE_DIR, selections={requirement: selected_value}
        )
    except GucExecutionSelectionError as exc:
        return JSONResponse({"detail": str(exc)}, status_code=400)
    return JSONResponse(selection.model_dump())


@app.get("/api/guc/v2/evidence-bundle")
async def guc_v2_evidence_bundle_api():
    """JSON API：GUC V2静态、Preflight与Runtime证据清单。"""
    return JSONResponse(build_guc_v2_evidence_bundle(BASE_DIR).model_dump())


@app.get("/api/guc/v2/evidence-bundle/verify")
async def guc_v2_evidence_bundle_verify_api():
    """JSON API：校验Evidence Bundle与当前产物文件是否一致。"""
    return JSONResponse(verify_guc_v2_evidence_bundle(BASE_DIR).model_dump())


@app.get("/api/guc/v2/execution-gate")
async def guc_v2_execution_gate_api(authorized: bool = False):
    """JSON API：GUC V2执行门禁预览；不执行数据库操作。"""
    readiness = build_guc_v2_readiness(BASE_DIR)
    gate = evaluate_guc_v2_execution_gate(
        readiness,
        authorized_flag=authorized,
        authorization_environment_set=os.getenv("GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED", "").lower() in {"true", "1", "yes"},
        database_enabled=os.getenv("GAUSSDB_ENABLED", "false").lower() in {"true", "1", "yes"},
    )
    return JSONResponse(gate.model_dump())


# ===== Advanced Package Pilot API =====
def _advanced_package_registry():
    """Load the strict Advanced Package Pilot inventory."""
    registry = AdvancedPackageRegistry(BASE_DIR)
    registry.load_all()
    return registry


@app.get("/advanced-package", response_class=HTMLResponse)
async def advanced_package_page(request: Request):
    """Advanced Package browser page; local artifacts only, no database execution."""
    registry = _advanced_package_registry()
    candidate_matrix = build_advanced_package_candidate_matrix(BASE_DIR)
    evidence = AdvancedEvidenceBundleRegistry(BASE_DIR).build()
    runtime_status = build_runtime_status(BASE_DIR)
    return templates.TemplateResponse(request, "_advanced_package.html", {
        "request": request,
        "environment": registry.environment.model_dump(),
        "packages": [
            package.model_dump()
            for package in sorted(
                registry.environment.packages,
                key=lambda item: item.name,
            )
        ],
        "candidate_matrix": candidate_matrix.model_dump(),
        "evidence": evidence.model_dump(),
        "runtime_status": runtime_status.model_dump(),
        "execution_gate": evaluate_advanced_package_gate(
            BASE_DIR,
            authorized_flag=False,
            authorization_environment_set=os.getenv("GAUSSDB_RUNTIME_PILOT_AUTHORIZED", "").lower() in {"true", "1", "yes"},
            database_enabled=os.getenv("GAUSSDB_ENABLED", "false").lower() in {"true", "1", "yes"},
        ).model_dump(),
    })


@app.get("/api/advanced-package/runtime-plan")
async def advanced_package_runtime_plan_api():
    """JSON API：高级包 Runtime Validation Pilot dry-run 计划。"""
    path = BASE_DIR / "generated/runtime_validation_pilot/dry_run.json"
    payload = json.loads(path.read_text(encoding="utf-8"))
    payload.pop("plan_sha256", None)
    plan = RuntimePilotPlanDef(**payload)
    return JSONResponse(plan.model_dump())


@app.get("/api/advanced-package/pilot")
async def advanced_package_pilot_api():
    """JSON API：高级包Pilot的包、接口与runtime候选合同。"""
    registry = _advanced_package_registry()
    return JSONResponse(registry.environment.model_dump())


@app.get("/api/advanced-package/candidate-matrix")
async def advanced_package_candidate_matrix_api():
    """JSON API：22个支持高级包的扩展候选矩阵。"""
    return JSONResponse(build_advanced_package_candidate_matrix(BASE_DIR).model_dump())


@app.get("/api/advanced-package/evidence-bundle")
async def advanced_package_evidence_bundle_api():
    """JSON API：高级包静态合同、runtime dry run与缺失证据清单。"""
    return JSONResponse(AdvancedEvidenceBundleRegistry(BASE_DIR).build().model_dump())


@app.get("/api/advanced-package/runtime-candidate-coverage")
async def advanced_package_runtime_candidate_coverage_api():
    """JSON API：高级包runtime candidate接口与runtime dry run覆盖对账。"""
    evidence = AdvancedEvidenceBundleRegistry(BASE_DIR).build()
    runtime_candidate_interface_ids = sorted({
        interface.id
        for package in _advanced_package_registry().environment.packages
        for interface in package.interfaces
        if interface.execution_policy == "runtime_candidate"
    })
    runtime_case_interface_ids = sorted({
        interface_id
        for unit in evidence.runtime_dry_run.units
        for interface_id in unit.interface_refs
    })
    uncovered_runtime_candidate_interface_ids = sorted(
        set(runtime_candidate_interface_ids) - set(runtime_case_interface_ids)
    )
    return JSONResponse({
        "kind": "advanced_package_runtime_candidate_coverage",
        "schema_version": 1,
        "runtime_candidate_interface_count": len(runtime_candidate_interface_ids),
        "runtime_case_interface_count": len(runtime_case_interface_ids),
        "uncovered_runtime_candidate_interface_count": len(uncovered_runtime_candidate_interface_ids),
        "runtime_candidate_case_coverage_complete": not uncovered_runtime_candidate_interface_ids,
        "runtime_candidate_interface_ids": runtime_candidate_interface_ids,
        "runtime_case_interface_ids": runtime_case_interface_ids,
        "uncovered_runtime_candidate_interface_ids": uncovered_runtime_candidate_interface_ids,
    })


@app.get("/api/advanced-package/execution-gate")
async def advanced_package_execution_gate_api(authorized: bool = False):
    """JSON API：高级包执行门禁预览；不执行数据库操作。"""
    gate = evaluate_advanced_package_gate(
        BASE_DIR,
        authorized_flag=authorized,
        authorization_environment_set=os.getenv("GAUSSDB_RUNTIME_PILOT_AUTHORIZED", "").lower() in {"true", "1", "yes"},
        database_enabled=os.getenv("GAUSSDB_ENABLED", "false").lower() in {"true", "1", "yes"},
    )
    return JSONResponse(gate.model_dump())


@app.get("/api/advanced-package/evidence-bundle/verify")
async def advanced_package_evidence_bundle_verify_api():
    """JSON API：校验高级包Evidence Bundle与当前产物文件是否一致。"""
    return JSONResponse(verify_advanced_package_evidence_bundle(BASE_DIR).model_dump())


@app.get("/factor/{factor_id}", response_class=HTMLResponse)
async def factor_detail(request: Request, factor_id: str):
    """Legacy V0 因子详情页（兼容入口，按需加载）。"""
    registry.load()
    factor = registry.get(factor_id)
    if not factor:
        return HTMLResponse("因子未找到", status_code=404)
    return templates.TemplateResponse(request, "_factor_detail.html", {
        "request": request,
        "factor": factor,
    })


@app.post("/generate", response_class=HTMLResponse)
async def generate(request: Request,
                   factor_id: str = Form(...),
                   strategy: str = Form(...)):
    """Legacy V0 生成入口（兼容入口，按需加载）。"""
    registry.load()
    factor = registry.get(factor_id)
    if not factor:
        return HTMLResponse("因子未找到", status_code=404)
    cases = generate_cases(factor, strategy, registry)
    return templates.TemplateResponse(request, "_case_list.html", {
        "request": request,
        "factor": factor,
        "cases": cases,
        "strategy": strategy,
        "allow_execute": True,
    })


@app.post("/execute", response_class=HTMLResponse)
async def execute(request: Request,
                  factor_id: str = Form(...),
                  strategy: str = Form(...)):
    """生成 + 执行 + 报告（HTMX 片段）。"""
    factor = registry.get(factor_id)
    if not factor:
        return HTMLResponse("因子未找到", status_code=404)
    cases = generate_cases(factor, strategy, registry)
    results = executor.execute_batch(cases)
    report_path = generate_report(cases, results, factor.name, strategy,
                                  str(REPORTS_DIR))
    report_name = os.path.basename(report_path)
    return templates.TemplateResponse(request, "_exec_result.html", {
        "request": request,
        "factor": factor,
        "cases": cases,
        "results": {r.case_id: r for r in results},
        "report_name": report_name,
        "strategy": strategy,
    })


@app.get("/report/{report_name}")
async def download_report(report_name: str):
    """下载报告文件。"""
    path = REPORTS_DIR / report_name
    if not path.exists():
        return HTMLResponse("报告不存在", status_code=404)
    return FileResponse(str(path), filename=report_name)


@app.post("/api/reload")
async def api_reload():
    """重新扫描默认 PDF-first Factor Package V1。"""
    factor_package_registry.load_all()
    return JSONResponse({
        "v1_factor_count": len(factor_package_registry.factors),
        "v1_factors": list(factor_package_registry.factors),
        "v1_manifest_count": len(factor_package_registry.manifests),
    })


@app.get("/api/factors")
async def api_factors():
    """Legacy V0 JSON API（兼容入口，按需加载）。"""
    registry.load()
    return JSONResponse({
        fid: {
            "id": f.id,
            "name": f.name,
            "category": f.category,
            "description": f.description,
            "params": list(f.params.keys()),
            "default_strategy": f.default_strategy,
        }
        for fid, f in registry.all().items()
    })


@app.get("/api/generate/{factor_id}")
async def api_generate(factor_id: str, strategy: str = "pairwise"):
    """JSON API：生成测试用例。"""
    factor = registry.get(factor_id)
    if not factor:
        return JSONResponse({"error": "factor not found"}, status_code=404)
    cases = generate_cases(factor, strategy, registry)
    return JSONResponse({
        "factor_id": factor.id,
        "strategy": strategy,
        "count": len(cases),
        "cases": [c.to_dict() for c in cases],
    })


@app.get("/api/specs/v1/manifests")
async def api_factor_package_manifests():
    """JSON API：列出 Factor Package V1 manifests。"""
    try:
        factor_package_registry.load_all()
    except FactorPackageLoadError as exc:
        return JSONResponse({"error": str(exc)}, status_code=422)
    return JSONResponse({
        manifest_id: {
            "id": manifest.id,
            "name": manifest.name,
            "factor_ref": manifest.factor_ref,
            "suite_type": manifest.suite_type,
            "strategy": manifest.strategy,
            "expected": manifest.expected.model_dump(),
        }
        for manifest_id, manifest in factor_package_registry.manifests.items()
    })


@app.get("/api/specs/v1/generate/{manifest_id}")
async def api_factor_package_generate(manifest_id: str):
    """JSON API：生成 V1 SQL、参数 ID 和 Pairwise 覆盖报告。"""
    try:
        factor_package_registry.load_all()
        manifest = factor_package_registry.get_manifest(manifest_id)
        if manifest is None:
            return JSONResponse({"error": "V1 manifest not found"}, status_code=404)
        cases, report = FactorPackageSQLGenerator(factor_package_registry).generate_with_report(manifest)
    except (FactorPackageLoadError, ValueError) as exc:
        return JSONResponse({"error": str(exc)}, status_code=422)
    return JSONResponse({
        "manifest_id": manifest.id,
        "factor_id": manifest.factor_ref,
        "count": len(cases),
        "report": report.to_dict(),
        "cases": [case.to_dict() for case in cases],
    })


@app.get("/api/specs/v1/audit/{factor_id}")
async def api_factor_package_audit(factor_id: str):
    """JSON API：审计一个因子的原文、事实、值域、规则和场景覆盖。"""
    try:
        factor_package_registry.load_all()
        if factor_package_registry.get_factor(factor_id) is None:
            return JSONResponse({"error": "V1 factor not found"}, status_code=404)
        audit = FactorCoverageAuditor(factor_package_registry).audit(factor_id)
        audit['display_progress'] = factor_progress(audit)
    except (FactorPackageLoadError, ValueError) as exc:
        return JSONResponse({"error": str(exc)}, status_code=422)
    return JSONResponse(audit)


def _get_default_scenario() -> ScenarioDef:
    return ScenarioDef(
        id="sc_order_lifecycle",
        name="表全生命周期业务场景",
        description="建表 (CREATE) -> 插入数据 (INSERT) -> 查询验证 (SELECT) -> 动态加列 (ALTER)",
        steps=[
            ScenarioStepDef(step_name="01_create_table", factor_id="create_table", strategy="equivalence"),
            ScenarioStepDef(step_name="02_insert_data", factor_id="insert_values", strategy="equivalence", bind_from_context=True),
            ScenarioStepDef(step_name="03_query_data", factor_id="select_basic", strategy="equivalence", bind_from_context=True),
            ScenarioStepDef(step_name="04_alter_schema", factor_id="alter_table", strategy="equivalence", params_override={"action": "ADD COLUMN col_new VARCHAR(50)"}, bind_from_context=True),
        ]
    )


@app.get("/scenarios", response_class=HTMLResponse)
async def scenarios_view(request: Request):
    """场景链可视化与执行页（HTMX 片段）。"""
    registry.load()
    scenario = _get_default_scenario()
    return templates.TemplateResponse(request, "_scenario_view.html", {
        "request": request,
        "scenario": scenario,
        "result_case": None,
    })


@app.post("/scenarios/execute", response_class=HTMLResponse)
async def scenarios_execute(request: Request, scenario_id: str = Form(...)):
    """执行场景链测试并在临时沙箱中推进状态机（HTMX 片段）。"""
    import json
    registry.load()
    scenario = _get_default_scenario()
    engine = ScenarioEngine(registry)
    cases = engine.generate_scenario(scenario)
    result_case = cases[0] if cases else None

    # 如果启用了数据库执行，在独立沙箱中依次执行步骤
    if result_case and executor.config.enabled:
        executor.execute_batch(result_case.step_cases)

    context_json = json.dumps(result_case.final_context.to_dict() if result_case else {}, ensure_ascii=False, indent=2)

    return templates.TemplateResponse(request, "_scenario_view.html", {
        "request": request,
        "scenario": scenario,
        "result_case": result_case,
        "context_json": context_json,
    })


@app.get("/api/db-config-modal", response_class=HTMLResponse)
async def db_config_modal(request: Request):
    """数据库配置弹窗（HTMX 片段）。"""
    return templates.TemplateResponse(request, "_db_config_modal.html", {
        "request": request,
        "config": executor.config,
    })


@app.post("/api/db-config", response_class=HTMLResponse)
async def save_db_config(request: Request,
                         host: str = Form("localhost"),
                         port: int = Form(5432),
                         database: str = Form("postgres"),
                         user: str = Form("gaussdb"),
                         password: str = Form(""),
                         enabled: Optional[str] = Form(None),
                         use_sandbox: Optional[str] = Form(None)):
    """保存数据库配置。"""
    executor.config.host = host
    executor.config.port = port
    executor.config.database = database
    executor.config.user = user
    executor.config.password = password
    executor.config.enabled = bool(enabled)
    executor.config.use_sandbox = bool(use_sandbox)
    executor.disconnect()

    status_badge = '<span class="text-green-600 font-medium">配置已保存 (真实执行已启用)</span>' if executor.config.enabled else '<span class="text-amber-600 font-medium">配置已保存 (桩模式已启用)</span>'
    return HTMLResponse(f'<div class="p-2 bg-green-50 rounded border border-green-200 text-xs">{status_badge}</div>')


@app.post("/api/db-config/test", response_class=HTMLResponse)
async def test_db_config(host: str = Form("localhost"),
                         port: int = Form(5432),
                         database: str = Form("postgres"),
                         user: str = Form("gaussdb"),
                         password: str = Form("")):
    """测试数据库连通性。"""
    import time
    try:
        import psycopg2
        start = time.time()
        conn = psycopg2.connect(
            host=host,
            port=port,
            dbname=database,
            user=user,
            password=password,
            connect_timeout=3
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        ver = cur.fetchone()[0]
        cur.close()
        conn.close()
        latency = int((time.time() - start) * 1000)
        return HTMLResponse(f'<div class="p-2 bg-green-50 rounded border border-green-200 text-xs text-green-700">✓ 连接成功 ({latency}ms) · {ver[:40]}...</div>')
    except Exception as e:
        return HTMLResponse(f'<div class="p-2 bg-red-50 rounded border border-red-200 text-xs text-red-600">✗ 连接失败: {str(e)[:80]}</div>')


@app.get("/api/scenarios/generate_default")
async def api_generate_default_scenario():
    """JSON API：生成默认全生命周期业务场景用例 (基于符号表状态迁移)。"""
    registry.load()
    engine = ScenarioEngine(registry)
    default_scenario = _get_default_scenario()
    cases = engine.generate_scenario(default_scenario)
    return JSONResponse({
        "scenario_id": default_scenario.id,
        "name": default_scenario.name,
        "cases": [c.to_dict() for c in cases],
    })




# ===== 兼容性Facts API =====
COMPAT_FACTS_DIR = BASE_DIR / "docs" / "compat_facts"

def _load_compat_facts():
    """Load all compatibility facts YAML files."""
    import yaml
    facts_by_file = {}
    if not COMPAT_FACTS_DIR.exists():
        return facts_by_file
    for yml in sorted(COMPAT_FACTS_DIR.glob("*.yaml")):
        try:
            data = yaml.safe_load(open(yml))
            if data and "facts" in data:
                facts_by_file[yml.stem] = data
        except Exception:
            continue
    return facts_by_file


@app.get("/api/compat-facts")
async def api_compat_facts(category: Optional[str] = None):
    """List all compatibility facts, optionally filtered by category keyword."""
    data = _load_compat_facts()
    result = []
    for filename, doc in data.items():
        for fact in doc.get("facts", []):
            if fact.get("status") != "confirmed":
                continue
            item = {
                "source_file": filename,
                "document": doc.get("document", ""),
                **{k: v for k, v in fact.items() if v is not None},
            }
            if category and category.lower() not in filename.lower() and category.lower() not in str(item.get("statement", "")).lower():
                continue
            result.append(item)
    return {
        "total": len(result),
        "categories": sorted(data.keys()),
        "facts": result,
    }


@app.get("/api/compat-facts/summary")
async def api_compat_facts_summary():
    """Summarize compatibility facts by category."""
    data = _load_compat_facts()
    summary = []
    for filename, doc in data.items():
        facts = doc.get("facts", [])
        confirmed = sum(1 for f in facts if f.get("status") == "confirmed")
        summary.append({
            "file": filename,
            "document": doc.get("document", ""),
            "total": len(facts),
            "confirmed": confirmed,
            "types": sorted(set(f.get("type", "unknown") for f in facts)),
        })
    return {"categories": summary, "total_confirmed": sum(s["confirmed"] for s in summary)}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
