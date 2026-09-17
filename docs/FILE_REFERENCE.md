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
│   ├── compat_facts/          # 885条参考事实（67个YAML；文件名::ID定位，不等于SQL覆盖）
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
│   └── factor_packages/       # 846个manifest / 5,295条候选SQL（静态生成）
│
├── core/
│   ├── factor_package_model.py      # V1模型定义
│   ├── factor_package_generator.py   # SQL生成器
│   ├── factor_coverage_auditor.py   # 覆盖审计器
│   └── ...                          # 合同检查器
│
├── scripts/
│   ├── auto_validate.py       # 自动化验证执行器
│   ├── prepare_execution_batch.py # 离线执行准备器
│   ├── execute_prepared_batch.py # insert_same_key dry-run/显式runtime执行器
│   ├── generate_factor_package_sql.py  # SQL生成入口
│   ├── run_static_regression.py       # 静态回归
│   └── ...
│
├── tests/                     # 270个测试文件（静态测试入口持续增加
├── web/                       # Web界面
│   ├── templates/              # Jinja2模板
│   ├── static/                 # CSS/JS
│   └── ...
├── main.py                    # FastAPI Web入口
├── requirements.txt
└── gaussdb-rf-cent.pdf         # 原始PDF（5,686页）
```

## 新增离线产物（2026-09-15）

[外表格式合同](FOREIGN_OPTIONS_CONTRACT_20260915.md)：TEXT/CSV OPTIONS 与本地文件资产、旧候选对账；保留 BINARY/FIXED 和远端验证缺口。

[语义复核报告](SEMANTIC_REVIEW_20260915.md)：三个包的来源原子性拆分、视图 DEFAULT 来源差异，
以及 `scripts/audit_common_type_evidence.py` 公共类型证据审计；不提升为整条 SQL 或实机通过。

[M INSERT/UPDATE 字符串包报告](M_STRING_PACKAGES_20260915.md)：两个正式清单、两个独立 Fixture、
17 个 planned 场景与生成 SQL 的直接绑定。`scripts/prepare_execution_batch.py --profile m_string_storage`
只准备离线产物，不连接数据库。具体命令与限制见报告。

[PG同键与file_fdw执行准备](INSERT_KEY_EXECUTION_PREPARATION_20260916.md)：
`insert_same_key` 与 `file_fdw_options` 两个 bounded profile 生成离线准备单元，
绑定 finite contract evidence、目标 CREATE 所有权和 Oracle 身份；未部署文件、未连接数据库。

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
