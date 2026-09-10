"""GaussDB 测试因子库 — Web 应用入口。"""
import json
import os
from datetime import datetime
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse
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
from core.progress_reporting import factor_progress, summarize_progress

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
    return templates.TemplateResponse(request, "_factor_package_detail.html", {
        "request": request,
        "factor": factor,
        "confirmed_count": confirmed_count,
        "open_questions": open_questions,
        "coverage_audit": coverage_audit,
        "progress": factor_progress(coverage_audit),
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
        "| Factor | 包已建 | SQL候选数 | 原文账本 | 候选生成 | 生成模型诊断 | 静态覆盖 | 实机验证 |",
        "|---|---|---:|---|---|---|---|---|",
    ]
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


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
