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
- 生成缺口诊断：在因子详情展开“为什么未完整”，区分条件取值、规则覆盖、生成异常和待校准Oracle；总览、API和Markdown同口径，见[诊断说明](docs/GENERATION_DIAGNOSTICS.md)。

首批五个 PDF 校准因子是 CREATE VIEW、CREATE INDEX、ALTER TABLE、SELECT 和
INSERT。仓库随后按独立批次加入代表性 DDL、DML、DCL 与 TCL 因子；当前数量、
生成用例和覆盖结论始终以严格 lint、生成报告和批次队列的实时输出为准，不在
README 中维护容易漂移的固定数字。

跨章依赖批次可通过 `python3 scripts/verify_cross_chapter_dependencies.py` 重跑，
需要当前 Python 安装 `pypdf` 且 PATH 中有 `pdftotext`；也可以使用
`--pdf-python /path/to/python` 指定单独的 PDF 运行环境。
批次选择、逐项证据和验收边界见 [12 章依赖验证](docs/CROSS_CHAPTER_DEPENDENCY_RESULT.md)。

按 [第三批抽取计划](docs/BATCH_03_EXTRACTION_PLAN.md) 选择的 20 个新章节均已形成包和 SQL 候选，
并纳入已有提供者及实际引用的补充正文。事务/保存点、ALTER/DROP VIEW/SEQUENCE/INDEX、
模式管理及预备语句子批已落盘；有限域生成完成不等于文档全特性覆盖或数据库行为验收。
见 [第三批阶段结果](docs/BATCH_03_EXTRACTION_PROGRESS.md)，实际进度看独立 `batch_03` 队列。

[第四批](docs/BATCH_04_EXTRACTION_PLAN.md) 的 20 个新章节均已落盘，并纳入实际依赖正文；
累计 70 个 manifest、470 条静态候选（437 正向 / 33 目标负向），原文映射与有限生成域检查通过。
完整特性和行为仍待审核：保留 72 个 open question 与 63 个 planned scenario，不将它们改成已验证。
见 [第四批阶段结果](docs/BATCH_04_EXTRACTION_PROGRESS.md)，不将选章完成或 SQL 生成冒充行为验收。

[第五批](docs/BATCH_05_EXTRACTION_PLAN.md) 已新增函数/聚集、文本搜索、增量物化视图等20个章节包。
默认仅生成有限域候选；内部功能授权、文件型词典、复杂函数与数据库行为继续单独留账。
候选数量与最新验证证据见 [第五批结果](docs/BATCH_05_EXTRACTION_PROGRESS.md)。

[第六批](docs/BATCH_06_EXTRACTION_PLAN.md) 继续新增过程、规则、触发器、两阶段事务和维护命令等20个包。
零参数固定语句已纳入生成回归；权限、凭据和高风险状态仍有明确待审核边界。
见 [第六批结果](docs/BATCH_06_EXTRACTION_PROGRESS.md) 和 [PDF剩余章节队列](docs/PDF_GENERAL_EXTRACTION_BACKLOG.md)。

后续按对象家族完成第七至十一批：
[类型与扩展](docs/BATCH_07_EXTRACTION_PROGRESS.md)、
[数据库与工具命令](docs/BATCH_08_EXTRACTION_PROGRESS.md)、
[身份与权限](docs/BATCH_09_EXTRACTION_PROGRESS.md)、
[策略及外部资源契约](docs/BATCH_10_EXTRACTION_PROGRESS.md)、
[分区、数据流与恢复](docs/BATCH_11_EXTRACTION_PROGRESS.md)。
整本 general SQL 的包绑定与尚未关闭的生成/行为缺口，以
[PDF 目录进度](docs/PDF_GENERAL_EXTRACTION_BACKLOG.md)及其可重算报告为准。
没有普通 manifest 的工具、外部资源或内部命令仍保留证据包，但不计作 SQL 生成通过。
本次补齐任务的固定验收快照见 [剩余129包交付结果](docs/REMAINING_129_EXTRACTION_RESULT.md)，
其中明确区分原文抽取、有限生成、未实现运行时和数据库行为验证。
后续质量改进见 [第三轮：全量对账与持续失效](docs/QUALITY_ROUND_03.md)、
[第二轮：真实写入契约](docs/QUALITY_ROUND_02.md)及
[第一轮质量复核](docs/QUALITY_ROUND_01.md)；历史批次报告保持冻结，不覆盖其旧验收数据。

## 当前验证基线

9月10日后续演进增加了[生成模型可解释诊断](docs/GENERATION_DIAGNOSTICS.md)，只修改展示与进度解释，不改变生成器、规格、SQL及原审计结论；对应相关回归与此前夜间全项目回归分开记账。

本轮最新状态见 [9月9日至10日夜间演进](docs/NIGHT_EVOLUTION_20260910.md)，包含生成列、MERGE默认值与RETURNING输出列共享合同，以及M PREPARE/SET等有限代表。前一完整全量回归保留在 [历史静态验收节点](docs/MILESTONE_STATIC_ACCEPTANCE_20260909.md)，不将旧测试数冒充本轮新代码全量验证；此前来源和修复证据见 [9月9日演进记录](docs/PROJECT_EVOLUTION_20260909.md)。活跃SQL与历史待审SQL独立计数；上面的历次抽取数字仅描述当时批次，不作为当前总量。

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

首批五章校准和后续分批抽取已经推进，不再把“开始第二批”当作当前任务。后续以实时审计缺口为入口：

1. 保持 Factor Package V1 公共模型和生成接口稳定；先重算目录、原文、有限生成域与行为四种口径。
2. 按 `needs_profile` 与 `open_question` 分类补值域、列契约、外部资源和权限场景，不重抽已经有来源证据的章节。
3. 先选择已有受控 Fixture 的候选做独立数据库验证，记录具体环境和目标 Oracle；未执行不得标为 verified。
4. 外部文件、密钥、模型训练、后台任务和库级恢复需先实现运行时契约，不为提高通过率删除事实或改成任意错误通过。
5. 对 PDF 或依赖包变化执行哈希失效与定向回归，继续区分包已存在、原文已处置、能生成、静态闭环和行为已验证。

冻结边界见 [Factor Package V1 冻结与批次规则](docs/FACTOR_PACKAGE_V1_FREEZE_POLICY.md)，完整路线见 [ROADMAP.md](docs/ROADMAP.md)。
