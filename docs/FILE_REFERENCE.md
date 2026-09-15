# GaussDB 规格驱动SQL测试生成系统 — 文件参考

## 项目核心目录

```
gaussdb_test/
├── specs/                    # 317个因子包（224 general + 93 M兼容）
│   ├── dcl/                  # DDL因子包
│   ├── ddl/                   # DDL因子包
│   ├── dml/                   # DML因子包
│   ├── utility/               # M兼容模式因子包
│   └── ...
│
├── docs/
│   ├── compat_facts/          # 936条结构化facts（67个YAML文件）
│   ├── minimal_validation_script.sql   # 10条核心验证
│   ├── extended_validation_script.sql  # 100条扩展验证
│   ├── ASSERTION_ENHANCEMENT_PLAN.md  # 276条facts增强分析
│   ├── ASSERTION_ENHANCEMENT_SQL.md   # 26组增强SQL
│   ├── ERROR_DIAGNOSIS_HANDBOOK.md   # 错误码速查表
│   ├── EXECUTION_VALIDATION_PLAN.md   # 三阶段验证方案
│   ├── FACT_INTEGRATION_PLAN.md       # Facts接入计划
│   ├── VALUE_GAP_DISPOSITION_20260911.md  # 25条gap处置
│   ├── PROJECT_DELIVERY_REPORT_20260914.md  # 完整交付报告
│   └── ...                            # 批次文档
│
├── generated/
│   └── factor_packages/       # 841个manifest / 5,273条SQL
│
├── core/
│   ├── factor_package_model.py      # V1模型定义
│   ├── factor_package_generator.py   # SQL生成器
│   ├── factor_coverage_auditor.py   # 覆盖审计器
│   └── ...                          # 合同检查器
│
├── scripts/
│   ├── auto_validate.py       # 自动化验证执行器
│   ├── generate_factor_package_sql.py  # SQL生成入口
│   ├── run_static_regression.py       # 静态回归
│   └── ...
│
├── tests/                     # 257个测试文件（1,916项测试
├── web/                       # Web界面
│   ├── templates/              # Jinja2模板
│   ├── static/                 # CSS/JS
│   └── ...
├── main.py                    # FastAPI Web入口
├── requirements.txt
└── gaussdb-rf-cent.pdf         # 原始PDF（5,686页）
```

## 新增文件说明（连库后使用）

### `scripts/auto_validate.py`
自动化验证执行器。连库后运行：
```bash
python3 scripts/auto_validate.py --host 10.83.35.52 --port 8507 --db postgres --user gaussdb
```
自动执行10条核心测试，生成JSON+文本报告，零LLM依赖。

### `docs/minimal_validation_script.sql`
10条核心验证SQL，手动运行：
```bash
gsql -h $HOST -p $PORT -d $DB -U $USER -W -f docs/minimal_validation_script.sql
```

### `docs/extended_validation_script.sql`
100条扩展验证SQL，覆盖DDL/DML/DCL/GUC差异/存储过程等。

### `docs/ASSERTION_ENHANCEMENT_PLAN.md`
276条behavior_oracle facts的增强分析，分为4类：
- 54条Boundary（边界测试）
- 37条Error Precision（错误精确化）
- 38条GUC Toggle（GUC前后对比）
- 91条Mode Specific（模式特定行为）

### `docs/ASSERTION_ENHANCEMENT_SQL.md`
26组具体增强SQL，包含：
- 7组边界测试（LPAD/INT溢出/精度/前缀索引等）
- 6组错误精确化（IF/REPLACE/ROUND/CHAR/CAST等）
- 6组GUC切换（behavior_compat_options前后对比）
- 5组模式特定（BOOL输出/NULL排序/COMMENT/XOR/TIME精度）
- 2组权限 + 2组存储过程

### `docs/ERROR_DIAGNOSIS_HANDBOOK.md`
错误码速查表。遇到错误按表操作，不需要分析能力。

## Web界面

启动Web界面：
```bash
python3 -m uvicorn main:app --host 0.0.0.0 --port 8080 --reload
```

关键页面：
| URL | 功能 |
|---|---|
| http://localhost:8080/ | 主页（317因子浏览） |
| http://localhost:8080/coverage | 覆盖报告 |
| http://localhost:8080/docs | Swagger API文档 |
| http://localhost:8080/api/factors | 全部因子JSON |
| http://localhost:8080/api/coverage/summary | 覆盖摘要 |
| http://localhost:8080/api/compat-facts | 882条兼容性facts |
| http://localhost:8080/api/compat-facts/summary | facts分类摘要 |

## 环境要求

- Python 3.9+
- 依赖：FastAPI, Pydantic, Jinja2, PyYAML
- gsql或psql（用于连库验证）
- 代理（用于访问GitHub）
