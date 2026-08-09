"""GaussDB 测试因子库 — Web 应用入口。"""
import os
from pathlib import Path

from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from core.registry import FactorRegistry
from core.generator import generate_cases
from core.executor import Executor, ExecConfig
from core.reporter import generate_report

BASE_DIR = Path(__file__).resolve().parent
FACTORS_DIR = BASE_DIR / "factors"
REPORTS_DIR = BASE_DIR / "reports"
STATIC_DIR = BASE_DIR / "web" / "static"
TEMPLATES_DIR = BASE_DIR / "web" / "templates"

app = FastAPI(title="GaussDB 测试因子库")
app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")
templates = Jinja2Templates(directory=str(TEMPLATES_DIR))

# 初始化因子注册表
registry = FactorRegistry(str(FACTORS_DIR))
registry.load()

# 执行器（桩模式）
executor = Executor(ExecConfig(enabled=False))


@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    """主页：侧边栏 + 欢迎区。"""
    registry.load()
    return templates.TemplateResponse("index.html", {
        "request": request,
        "categories": registry.by_category(),
        "factor_count": len(registry.all()),
    })


@app.get("/factor/{factor_id}", response_class=HTMLResponse)
async def factor_detail(request: Request, factor_id: str):
    """因子详情页（HTMX 片段）。"""
    factor = registry.get(factor_id)
    if not factor:
        return HTMLResponse("因子未找到", status_code=404)
    return templates.TemplateResponse("_factor_detail.html", {
        "request": request,
        "factor": factor,
    })


@app.post("/generate", response_class=HTMLResponse)
async def generate(request: Request,
                   factor_id: str = Form(...),
                   strategy: str = Form(...)):
    """生成 SQL 测试用例（HTMX 片段）。"""
    factor = registry.get(factor_id)
    if not factor:
        return HTMLResponse("因子未找到", status_code=404)
    cases = generate_cases(factor, strategy)
    return templates.TemplateResponse("_case_list.html", {
        "request": request,
        "factor": factor,
        "cases": cases,
        "strategy": strategy,
    })


@app.post("/execute", response_class=HTMLResponse)
async def execute(request: Request,
                  factor_id: str = Form(...),
                  strategy: str = Form(...)):
    """生成 + 执行 + 报告（HTMX 片段）。"""
    factor = registry.get(factor_id)
    if not factor:
        return HTMLResponse("因子未找到", status_code=404)
    cases = generate_cases(factor, strategy)
    results = executor.execute_batch(cases)
    report_path = generate_report(cases, results, factor.name, strategy,
                                  str(REPORTS_DIR))
    report_name = os.path.basename(report_path)
    return templates.TemplateResponse("_exec_result.html", {
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
    """重新扫描 factors/ 目录，热加载因子定义。"""
    registry.load()
    return JSONResponse({
        "count": len(registry.all()),
        "factors": list(registry.all().keys()),
    })


@app.get("/api/factors")
async def api_factors():
    """JSON API：所有因子定义。"""
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
    cases = generate_cases(factor, strategy)
    return JSONResponse({
        "factor_id": factor.id,
        "strategy": strategy,
        "count": len(cases),
        "cases": [c.to_dict() for c in cases],
    })


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
