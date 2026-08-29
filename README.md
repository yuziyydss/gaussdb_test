# GaussDB 规格驱动 SQL 测试生成系统

本项目把 GaussDB 产品文档转换为可追溯、可静态校验的 Factor Package V1，再通过约束感知的组合生成器输出 SQL 测试用例。当前阶段聚焦“文档抽取 → 规格建模 → SQL 生成 → 静态覆盖审计”，默认不连接数据库。

公司内网文档无法外传时，从 [内网 AI 执行入口](INTRANET_AI_INSTRUCTIONS.md) 开始。完整批量流程见 [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)。

## 当前能力

- Factor Package V1：每条 SQL 语句使用一个自包含目录，统一管理 source ledger、factor、syntax、manifest、matrix、fixture 和 scenario。
- 严格规格加载：未知字段、重复 ID、悬空引用、非法值域和无法编译的约束都会阻止加载。
- 递归 AST：支持顶层多产生式、choice、optional、repeat、subgrammar 和嵌套查询。
- 结构契约：校验列数、列类型、GROUP BY/ORDER BY、集合运算、INSERT 输入和索引键能力。
- 约束感知 Pairwise：先计算可行组合，再覆盖全部可行参数对；生成后验证缺失 pair 和重复 case ID。
- Fixture 与目标错误 Oracle：生成 setup/test/teardown，并为负向用例保存目标错误类别、SQLSTATE 候选集或错误正则。
- Source Unit 覆盖账本：逐行记录原文处置，并审计 source unit 原子性、fact 消费和值域覆盖。
- 离线内网任务队列：支持 SHA-256 对账、任务认领、断点续跑、失败恢复和与 AI 厂商无关的任务文件。
- Web/API：浏览 V1 factor、manifest、覆盖报告和生成 SQL。

当前仓库包含5个 V1示例因子：CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT 和 INSERT。

## 当前验证基线

截至当前提交：

| 项目 | 当前结果 |
|---|---:|
| V1规格文件 | 159 |
| Factor | 5 |
| Fixture | 19 |
| Manifest | 56 |
| Matrix | 8 |
| Scenario | 61 |
| 确定性生成SQL | 865 |
| 自动化测试 | 69项通过 |

这些数字表示当前仓库的静态基线，不表示5800页文档已经抽取完成，也不表示 planned scenario 已在数据库执行。

当前已确认：

- 159个 V1文件可以严格加载；
- 56个 manifest 可以生成865个全局唯一 case；
- 适用 Pairwise 的 manifest 均完成可行 pair 覆盖；
- 69项自动化测试通过。

当前尚未闭环：

- 现有样例仍有 source unit 原子性和 documented feature 缺口；
- 61个 scenario 中仍有 planned 场景；
- V1 fixture/scenario 尚未接入真实数据库执行器；
- 生成SQL通过的是静态结构校验，不等于特定 GaussDB 版本已实际接受。

## 架构

```text
产品文档章节
    │ 内网本地切片；保留版本、行号和 SHA-256
    ▼
Doc2Spec 离线任务队列
    │ 一次认领一个章节；任意内网 AI 只写一个输出目录
    ▼
specs/<category>/<factor>/
    ├── *.source.yaml       原文单元覆盖账本
    ├── *.factor.yaml       事实、维度、值域、规则与引用索引
    ├── *.syntax.yaml       SQL递归AST
    ├── manifests/          测试选择、策略和目标Oracle
    ├── matrices/           对象与语义能力Profile
    ├── fixtures/           setup/provides/teardown
    └── scenarios/          多步骤状态变化和行为断言
             │
             ▼
FactorPackageRegistry 严格加载与引用校验
             │
       ┌─────┴────────┐
       ▼              ▼
约束感知SQL生成    因子级覆盖审计
       │              │
       └─────┬────────┘
             ▼
generated/factor_packages/ + Web/API
```

更详细的职责和数据流见 [当前架构说明](docs/ARCHITECTURE.md)。

## 目录

```text
gaussdb_test/
├── specs/                         Factor Package V1 唯一写入位置
├── core/
│   ├── factor_package_model.py    V1严格模型与注册表
│   ├── factor_package_generator.py V1递归AST与组合生成器
│   ├── factor_coverage_auditor.py V1因子级覆盖审计
│   ├── constraint_solver.py       约束DSL解析与求值
│   └── combinator.py              组合覆盖算法
├── scripts/
│   ├── lint_factor_packages_v1.py
│   ├── generate_factor_package_sql.py
│   ├── audit_factor_coverage_v1.py
│   └── manage_extraction_queue.py
├── prompts/                       内网 AI 单任务抽取模板
├── intranet_corpus/               内网章节语料；正文被 Git 忽略
├── generated/factor_packages/     确定性 SQL 快照与审计报告
├── web/                           FastAPI 页面与静态资源
├── tests/                         自动化测试
├── docs/                          当前规范、运行手册与历史资料
├── factors/                       Legacy V0兼容输入
├── grammars/                      Legacy V0兼容输入
├── matrices/                      Legacy V0兼容输入
└── manifests/                     Legacy V0兼容输入
```

根目录的 `factors/`、`grammars/`、`matrices/` 和 `manifests/` 属于 Legacy V0。现有兼容运行时仍可能读取它们，但新的文档抽取只写 `specs/`，禁止人工双写同一条规则。

## 快速开始

### 安装

```bash
git clone https://github.com/yuziyydss/gaussdb_test.git
cd gaussdb_test
python3 -m pip install -r requirements.txt
```

### 运行测试

```bash
python3 -m unittest discover -s tests
```

当前预期：69项测试通过。

### 严格加载 V1

```bash
python3 scripts/lint_factor_packages_v1.py specs
```

### 生成 SQL

生成所有 V1 manifest：

```bash
python3 scripts/generate_factor_package_sql.py
```

只生成一个 factor：

```bash
python3 scripts/generate_factor_package_sql.py --factor create_view
```

SQL默认写入 `generated/factor_packages/<factor>/`，总报告写入 `generated/factor_packages/generation_report.json`。

### 审计静态覆盖

```bash
python3 scripts/audit_factor_coverage_v1.py --factor create_view
```

CI严格模式：

```bash
python3 scripts/audit_factor_coverage_v1.py --factor create_view --fail-on-gaps
```

严格模式失败表示存在静态覆盖缺口，不代表脚本异常。报告会分别给出 source、generation、static 和 behavior 四种结论。

### 启动 Web

```bash
python3 -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

浏览器打开 `http://127.0.0.1:8000/`。

## 内网批量抽取

准备章节语料：

```text
intranet_corpus/
  general/ddl/create_table.txt
  general/dml/update.txt
  m_compat/dml/select.txt
```

创建队列并认领任务：

```bash
python3 scripts/manage_extraction_queue.py inventory --corpus-dir intranet_corpus
python3 scripts/manage_extraction_queue.py claim --worker company-ai-01 --render
```

AI生成候选 V1 package 后：

```bash
python3 scripts/manage_extraction_queue.py update \
  --task-id <TASK_ID> \
  --status generated

python3 scripts/manage_extraction_queue.py verify --task-id <TASK_ID>
```

`static_complete` 只能由任务信封对账和三道静态程序门禁共同写入。它不代表数据库行为已验证。

## 文档入口

当前文档索引见 [docs/README.md](docs/README.md)。最重要的四份文档是：

- [Factor Package Schema V1](docs/FACTOR_PACKAGE_SCHEMA_V1.md)
- [Doc2Spec Extraction Rules V1](docs/DOC2SPEC_EXTRACTION_RULES_V1.md)
- [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)
- [当前架构说明](docs/ARCHITECTURE.md)

## 下一步

下一阶段不是直接导入全部5800页，而是：

1. 关闭现有5个样例的静态审计缺口；
2. 在内网选择10个代表性 SQL章节完成试点；
3. 根据首轮门禁失败原因修正规格模型和提示词；
4. 扩展到一个完整 DML目录；
5. 最后再进行通用 SQL全量和兼容模式分批抽取。

完整路线见 [ROADMAP.md](docs/ROADMAP.md)。
