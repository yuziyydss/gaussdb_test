# PDF 到 Factor Package 的权威流程

本文定义整本 GaussDB 参考 PDF 进入项目后的唯一流程。目标是生成可追溯、可审计、可重复生成的 SQL 测试因子库，而不是把 PDF 页面直接变成若干看似正确的 SQL。

## 1. 覆盖口径

项目必须分开报告四种结论：

1. **PDF 目录覆盖**：每个书签章节都被分类为 SQL factor、兼容模式、函数/操作符、数据类型、参数、系统目录或明确的范围外内容。
2. **章节事实覆盖**：章节文本每一行均进入原子 source unit，或有可审核的 ignored/out-of-scope 理由。
3. **静态生成覆盖**：已建模的值域、确认规则、manifest 和所有可行二元组合均被覆盖。
4. **数据库行为覆盖**：fixture、SQLSTATE、权限、会话、生命周期、行为与元数据 Oracle 已在目标版本执行。

Pairwise 100% 只能证明第 3 层中“已建模的可行参数对”完整，不能代替前两层，也不能证明第 4 层。

## 2. 唯一数据流

```text
冻结的父 PDF
  -> 书签目录与文档身份
  -> 书签路径 + 物理页 + 页内坐标精确拆章
  -> 稳定 UTF-8 章节文本 + catalog.json
  -> Doc2Spec 任务队列
  -> Factor Package V1
  -> 严格加载 + 约束感知 Pairwise + 覆盖审计
  -> 可选的真实数据库验证
```

禁止从旧 factor、模型记忆或其他版本网页反向修改 PDF 事实。旧规格只是差异比较的候选。

## 3. PDF 证据契约

`scripts/extract_pdf_sections.py` 生成：

- `intranet_corpus/catalog.json`：父 PDF SHA-256、产品/文档版本、抽取规则版本、完整书签树和章节边界；
- `intranet_corpus/<variant>/<category>/<factor>.txt`：带物理/印刷页标记的稳定章节文本。

章节边界是 start-inclusive/end-exclusive。只按页码、只按标题字符串或把 general 与 M-Compatibility 同名语句合并，都属于无效抽取。

Factor 主来源保存：

```yaml
source:
  version: V2.0-10.0.0
  artifact_sha256: <chapter_sha256>
  parent_pdf_sha256: <parent_pdf_sha256>
  extraction_rule_version: gaussdb-pdf-outline-v1
  catalog_chapter_ref:
    document_id: <document_id>
    source_relpath: general/ddl/create_view.txt
    chapter_sha256: <chapter_sha256>
```

`artifact_sha256` 绑定稳定章节文本；`parent_pdf_sha256` 绑定父 PDF；
`extraction_rule_version` 绑定产生该章节文本的确定性算法，书签路径和精确坐标由
catalog 解析。队列 verify 要求 factor、source ledger、catalog 三方章节哈希完全相等，
不接受“任一哈希碰巧匹配”。来源、规格或工具链任一漂移，旧的
`static_complete` 都会在全局覆盖审计中变为陈旧结论，不能继续计数。

## 4. 抽取范围与路由

第一批只处理 `1 SQL参考 > 1.13 SQL语法`。`2 SQL参考-M-Compatibility兼容模式` 使用独立 `m_compat` variant，不与 general 合并。其他顶层章节先进入 PDF 目录账本，再分流到专用模型。

| PDF内容 | 出口 |
|---|---|
| DDL/DML/DCL/TCL/Other SQL | Factor Package V1 |
| M-Compatibility SQL | 独立 variant Factor Package |
| 函数与操作符 | 函数签名/表达式能力模型（待定） |
| 数据类型 | 共享类型能力矩阵（待定） |
| GUC/CM参数 | 环境 overlay 与恢复模型（待定） |
| 系统表/视图 | metadata oracle 目录（待定） |
| 工具、日志、报告 | 登记范围，不生成 SQL factor |

## 5. 五章框架校准门禁

首批固定为 CREATE VIEW、CREATE INDEX、INSERT、SELECT 和 ALTER TABLE，分别代表线性语法、能力矩阵、递归输入、嵌套查询和大量互斥 action。

五章的目的是验证公共模型能够发现并如实报告不同类型的缺口。每章依次检查：

1. 章节标题在文本开头，不含前后章标题；
2. 父 PDF、catalog 和章节文本哈希均可重算；
3. source unit 覆盖全部章节行且完成原子性复核；
4. PDF 与旧规格的 changed/conflicting/added/missing 差异均有处置；
5. 语法分支、确认规则、能力 profile、fixture 与 Oracle 职责分离；
6. 严格 lint 和引用检查通过；
7. 所有可行 pair 覆盖 100%，case ID 和 SQL 唯一；
8. 静态完整与数据库已验证分别报告。

冻结 V1 和开始第二批不要求五章的 `static_complete=true`，更不要求数据库行为 100%。冻结门禁是：来源对账、严格加载、生成唯一性、已建模可行 Pairwise 和缺口不能被误报为绿色的全量回归通过。章节级 source/feature/Oracle/scenario 缺口可留在审计报告和人工队列中，与其他章节独立推进。

具体冻结边界见 `docs/FACTOR_PACKAGE_V1_FREEZE_POLICY.md`。

## 6. 本地命令

```bash
python3 scripts/extract_pdf_sections.py \
  --pdf gaussdb-rf-cent.pdf \
  --output-root intranet_corpus

python3 scripts/manage_extraction_queue.py inventory \
  --corpus-dir intranet_corpus \
  --source-catalog intranet_corpus/catalog.json

python3 scripts/manage_extraction_queue.py verify --task-id <TASK_ID>

python3 scripts/audit_pdf_catalog_coverage.py \
  --source-catalog intranet_corpus/catalog.json \
  --spec-root specs \
  --queue work/doc2spec/queue.json \
  --output generated/audit/pdf_catalog_coverage.json
```

`pypdf` 负责书签和坐标。章节文本使用 Poppler `pdftotext` 生成；运行前必须确认系统可执行 `pdftotext`。

不带选择参数时只拆首批五章。第二批使用重复的 `--section <精确书签编号>` 选取约 10 个代表章节；第二批通过后再按 20～30 章建立新的受控批次。准备冻结完整通用 SQL 分母时，才使用 `--all-general-statements --replace-catalog`；连同 M-Compatibility 一次冻结时使用 `--all-sql-statements --replace-catalog`。已有 catalog 的身份或章节集合发生变化时，命令会默认拒绝覆盖，必须审核后显式传入 `--replace-catalog`。catalog 一旦进入任务队列就不应边抽取边改变；扩容应作为新的受控批次重新 inventory。

catalog-backed inventory 是闭集：只有 `catalog.json` 的 `chapters[].source_relpath` 可以入队。目录中出现 catalog 未枚举的 `.txt/.md/.html` 会直接失败，必须先把它纳入同一 catalog，或移出本批语料目录，禁止降级成没有 PDF provenance 的任务。

覆盖审计的四个阶段是单调但不等价的：`cataloged` 表示命令存在于 PDF 分母，`extracted` 表示有精确拆章文本且当前文本哈希仍匹配，`package_bound` 表示恰有一个因子包以匹配哈希绑定该章，`static_complete` 表示该任务通过来源对账、严格 lint、SQL 生成和静态覆盖门禁。verify 快照同时绑定章节文本、catalog、父 PDF、Factor Package 和验证工具链；任一哈希漂移都会把旧完成状态标为 stale。`summary` 不再把 stale 计入完成数，`claim`/`verify` 可以重新处理 stale 任务，新鲜的 `static_complete` 不会被重复认领。
