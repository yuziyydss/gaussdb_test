"""报告生成器：输出 HTML + JSON 格式的测试报告。"""
import json
import os
from datetime import datetime
from typing import List

from .executor import ExecResult
from .generator import GeneratedCase


def generate_report(cases: List[GeneratedCase],
                    results: List[ExecResult] = None,
                    factor_name: str = "",
                    strategy: str = "",
                    output_dir: str = "reports") -> str:
    """生成测试报告，返回 HTML 文件路径。"""
    results = results or []
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    summary = {
        "factor_name": factor_name,
        "strategy": strategy,
        "total": len(cases),
        "executed": len(results),
        "success": sum(1 for r in results if r.status == "success"),
        "error": sum(1 for r in results if r.status == "error"),
        "core": sum(1 for r in results if r.status == "core"),
        "skipped": sum(1 for r in results if r.status == "skipped"),
        "timestamp": timestamp,
    }

    detail = []
    for case in cases:
        r = next((x for x in results if x.case_id == case.case_id), None)
        detail.append({
            "case_id": case.case_id,
            "sql": case.sql,
            "params": case.params,
            "status": r.status if r else "pending",
            "error_msg": r.error_msg if r else "",
            "duration_ms": r.duration_ms if r else 0,
        })

    os.makedirs(output_dir, exist_ok=True)

    safe_name = (factor_name or "report").replace(" ", "_")
    json_path = os.path.join(output_dir, f"{safe_name}_{timestamp}.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump({"summary": summary, "detail": detail}, f,
                   ensure_ascii=False, indent=2)

    html = _render_html(summary, detail)
    html_path = os.path.join(output_dir, f"{safe_name}_{timestamp}.html")
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html)

    return html_path


def _render_html(summary: dict, detail: list) -> str:
    rows = []
    for d in detail:
        status_class = {
            "success": "text-green-600",
            "error": "text-red-600",
            "core": "text-red-700 font-bold",
            "skipped": "text-gray-400",
            "pending": "text-gray-400",
        }.get(d["status"], "text-gray-500")
        rows.append(f"""
        <tr class="border-b border-gray-100 hover:bg-gray-50">
          <td class="py-2 px-3 text-sm font-mono text-gray-500">{d['case_id']}</td>
          <td class="py-2 px-3"><code class="text-xs">{_esc(d['sql'])}</code></td>
          <td class="py-2 px-3 text-sm {status_class}">{d['status']}</td>
          <td class="py-2 px-3 text-xs text-gray-500">{_esc(d['error_msg'])}</td>
        </tr>""")

    return f"""<!DOCTYPE html>
<html lang="zh"><head><meta charset="utf-8">
<title>测试报告 - {_esc(summary['factor_name'])}</title>
<script src="https://cdn.tailwindcss.com"></script></head>
<body class="bg-gray-50 min-h-screen">
<div class="max-w-7xl mx-auto px-6 py-8">
  <h1 class="text-2xl font-bold text-gray-800 mb-1">测试报告</h1>
  <p class="text-sm text-gray-500 mb-6">{_esc(summary['factor_name'])} | 策略: {_esc(summary['strategy'])} | {summary['timestamp']}</p>
  <div class="grid grid-cols-5 gap-4 mb-6">
    <div class="bg-white rounded-lg shadow-sm p-4"><div class="text-2xl font-bold text-gray-800">{summary['total']}</div><div class="text-xs text-gray-500">总用例</div></div>
    <div class="bg-white rounded-lg shadow-sm p-4"><div class="text-2xl font-bold text-green-600">{summary['success']}</div><div class="text-xs text-gray-500">成功</div></div>
    <div class="bg-white rounded-lg shadow-sm p-4"><div class="text-2xl font-bold text-red-600">{summary['error']}</div><div class="text-xs text-gray-500">异常</div></div>
    <div class="bg-white rounded-lg shadow-sm p-4"><div class="text-2xl font-bold text-red-700">{summary['core']}</div><div class="text-xs text-gray-500">Core</div></div>
    <div class="bg-white rounded-lg shadow-sm p-4"><div class="text-2xl font-bold text-gray-400">{summary['skipped']}</div><div class="text-xs text-gray-500">跳过</div></div>
  </div>
  <div class="bg-white rounded-lg shadow-sm overflow-hidden">
    <table class="w-full"><thead><tr class="bg-gray-100 text-xs text-gray-500 uppercase">
      <th class="py-2 px-3 text-left">用例ID</th>
      <th class="py-2 px-3 text-left">SQL</th>
      <th class="py-2 px-3 text-left">状态</th>
      <th class="py-2 px-3 text-left">错误信息</th>
    </tr></thead><tbody>
    {''.join(rows)}
    </tbody></table>
  </div>
</div></body></html>"""


def _esc(text: str) -> str:
    """HTML 转义。"""
    return (text or "").replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace('"', "&quot;")
