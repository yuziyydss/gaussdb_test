# GaussDB 规格驱动 SQL 测试生成系统

本项目把 GaussDB 产品文档转换为可追溯、可静态校验的 Factor Package V1，再通过约束感知的组合生成器输出 SQL 测试用例。当前阶段聚焦“文档抽取 → 规格建模 → SQL 生成 → 静态覆盖审计”，默认不连接数据库。

公司内网文档无法外传时，从 [内网 AI 执行入口](INTRANET_AI_INSTRUCTIONS.md) 开始。完整批量流程见 [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)。

## 当前能力

- Factor Package V1：每条 SQL 语句使用一个自包含目录，统一管理 source ledger、factor、syntax、manifest、matrix、fixture 和 scenario。
- 严格规格加载：未知字段、重复 ID、悬空引用、非法值域和无法编译的约束都会阻止加载。
- 有限展开的结构化 AST：支持顶层多产生式、choice、optional、repeat、subgrammar 和受控嵌套；不把有限层代表误报为递归语法域全覆盖。
- 结构契约：校验列数、列类型、GROUP BY/ORDER BY、集合运算、INSERT 输入和索引键能力。
- 约束感知 Pairwise：先计算可行组合，再覆盖全部可行参数对；生成后验证缺失 pair 和重复 case ID。
- Fixture 与目标错误 Oracle：生成 setup/test/teardown，并为负向用例保存目标错误类别、SQLSTATE 候选集或错误正则。
- Source Unit 覆盖账本：逐行记录原文处置，并审计 source unit 原子性、fact 消费和值域覆盖。
- 离线内网任务队列：支持 SHA-256 对账、任务认领、断点续跑、失败恢复和与 AI 厂商无关的任务文件。
- Web/API：浏览 V1 factor、manifest、覆盖报告和生成 SQL。

首批五个 PDF 校准因子是 CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT 和
INSERT。仓库随后按独立批次加入代表性 DDL、DML、DCL 与 TCL 因子；当前数量、
生成用例和覆盖结论始终以严格 lint、生成报告和批次队列的实时输出为准，不在
README 中维护容易漂移的固定数字。

跨章依赖批次可通过 `python3 scripts/verify_cross_chapter_dependencies.py` 重跑，
需要当前 Python 安装 `pypdf` 且 PATH 中有 `pdftotext`；也可以使用
`--pdf-python /path/to/python` 指定单独的 PDF 运行环境。
批次选择、逐项证据和验收边界见 [12 章依赖验证](docs/CROSS_CHAPTER_DEPENDENCY_RESULT.md)。

## 当前验证基线

当前基线不再使用历史“226 个因子”作为分母。唯一产品证据是仓库中的冻结 PDF 与其 `catalog.json`；CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT、INSERT 是首批五章校准集。实时数量和结论由下列命令重算，README 不复制容易陈旧的 case 数：

```bash
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 scripts/audit_factor_coverage_v1.py
python3 scripts/audit_pdf_catalog_coverage.py \
  --source-catalog intranet_corpus/catalog.json \
  --spec-root specs \
  --queue work/doc2spec/queue.json \
  --output generated/audit/pdf_catalog_coverage.json
```

五章均已绑定 PDF 版本、父文档/章节哈希、完整书签路径和精确页内边界。静态生成的 SQL 是“文档驱动候选”，只有在 source、值域、feature domain、规则、Fixture 和目标 Oracle 的审计缺口全部关闭后，才可称为静态闭环；只有在指定 GaussDB 版本执行并通过行为/元数据 Oracle 后，才可称为数据库验证通过。Pairwise 100% 只证明已建模且可行的二元交互，不证明 PDF 全章、全值域或数据库行为覆盖。

## 架构

```text
冻结的产品 PDF
    │ 书签路径+页内坐标精确拆章
    ▼
PDF source catalog + 稳定章节文本
    │ 保留产品版本、父PDF/章节哈希、页码和坐标
    ▼
Doc2Spec 离线任务队列
    │ 一次认领一个章节；任意内网 AI 只写一个输出目录
    ▼
specs/<category>/<factor>/
    ├── *.source.yaml       原文单元覆盖账本
    ├── *.factor.yaml       事实、维度、值域、规则与引用索引
    ├── *.syntax.yaml       SQL结构化AST（有限展开）
    ├── manifests/          测试选择、策略和目标Oracle
    ├── matrices/           对象与语义能力Profile
    ├── fixtures/           setup/provides/teardown
    └── scenarios/          多步骤状态变化和行为断言
             │
             ▼
FactorPackageRegistry 严格加载、限定 Fact/Fixture 引用与依赖 DAG 校验
             │
       ┌─────┴────────┐
       ▼              ▼
约束感知SQL生成    因子级覆盖审计
       │              │
       └─────┬────────┘
             ▼
generated/factor_packages/ + Web/API
```

更详细的职责和数据流见 [当前架构说明](docs/ARCHITECTURE.md)。整本 PDF 入口见 [PDF 到 Factor Package 权威流程](docs/PDF_DOC2SPEC_PIPELINE.md)。

## 目录

```text
gaussdb_test/
├── specs/                         Factor Package V1 唯一写入位置
├── core/
│   ├── factor_package_model.py    V1严格模型与注册表
│   ├── factor_package_generator.py V1结构化AST与组合生成器
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

测试数量会随 PDF 校准持续变化；以命令退出码和本次完整输出为准，不在文档中固定一个会陈旧的数字。

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

输入是含书签的整本 PDF 时，先生成 source catalog 和章节文本：

```bash
python3 scripts/extract_pdf_sections.py \
  --pdf gaussdb-rf-cent.pdf \
  --output-root intranet_corpus
```

创建队列并认领任务：

```bash
python3 scripts/manage_extraction_queue.py inventory \
  --corpus-dir intranet_corpus \
  --source-catalog intranet_corpus/catalog.json
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

当前文档索引见 [docs/README.md](docs/README.md)。最重要的五份文档是：

- [Factor Package Schema V1](docs/FACTOR_PACKAGE_SCHEMA_V1.md)
- [Factor Package V1 冻结与批次推进规则](docs/FACTOR_PACKAGE_V1_FREEZE_POLICY.md)
- [Doc2Spec Extraction Rules V1](docs/DOC2SPEC_EXTRACTION_RULES_V1.md)
- [内网批量 Doc2Spec 运行手册](docs/INTRANET_AI_BATCH_EXTRACTION.md)
- [当前架构说明](docs/ARCHITECTURE.md)

## 下一步

五个首批因子是框架验收样本，不是要在扩批前做到数据库行为 100%。后续节奏为：

1. 以当前五章回归结果冻结 Factor Package V1 模型、抽取规则和生成接口；
2. 立即抽取第二批约 10 个代表性 SQL 章节，覆盖简单 DDL、DCL、事务语句、普通 DML 和复杂语法；
3. 第二批通过后，按每批 20～30 章扩大，不逐个手工精修；
4. 自动抽取失败、原文异常或高风险章节进入 `needs_review`/`blocked` 人工队列，不阻塞其他章节；
5. 数据库行为验证作为独立轨道逐步补齐，不是第二批的前置条件。

冻结边界见 [Factor Package V1 冻结与批次规则](docs/FACTOR_PACKAGE_V1_FREEZE_POLICY.md)，完整路线见 [ROADMAP.md](docs/ROADMAP.md)。
