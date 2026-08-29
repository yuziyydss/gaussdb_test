# CREATE VIEW Factor Package

本目录是 Factor Package Schema V1 的首个参考实现，来源为用户提供的 GaussDB `CREATE VIEW` 产品文档原文。

来源摘要：

- 文档标题：`CREATE VIEW`
- 产品版本：原文正文未显式标注，记录为 `unknown`
- 来源文件 SHA-256：`29f390c3509b249495992def92633e0a8e217806af2f789c7e943d8153329dd3`
- 原文中嵌入的失效本地链接提到 `GaussDB Kernel 507.0.0`，但它不被提升为本文档版本事实

文件职责：

- `create_view.factor.yaml`：维度、等价类、文档事实、规则和待验证问题。
- `create_view.source.yaml`：64 个原文 source unit 的行号、处置状态和 fact 映射账本。
- `create_view.syntax.yaml`：CREATE VIEW 主产生式与槽位。
- `matrices/query_capabilities.matrix.yaml`：可复用查询形态、输出列契约、可更新性，以及文档特性的覆盖台账。
- `fixtures/source_two_ints.fixture.yaml`：基础 SQL 所需的两列整数表能力。
- `fixtures/flashback_source.fixture.yaml`：TIMECAPSULE profile 所需的 Ustore 两列源表能力。
- `manifests/*.manifest.yaml`：按目的拆分的静态生成清单。
- `scenarios/*.scenario.yaml`：需要数据库状态、会话或后续 DML 的计划场景。

当前原文账本：原文 71 行已全部登记（64 行由 source unit 覆盖，7 行为有理由忽略的标题或空行）。64 个 source unit 已全部处置（51 mapped、10 open question、3 out of scope），不存在 `unmapped`。原文未展开的 UNPIVOT、START WITH CONNECT BY 和闪回子语法使用两份带版本、URL、检索日期和锚点的 GaussDB 官方补充来源，不从名称猜测 SQL。

当前静态生成：7 个 manifest、10 个 planned scenario、44 条 confirmed fact、10 条被隔离的 open question。43/43 个 valid value 均已进入 140 条生成用例，4 条硬规则均有正向与目标负向证据，全部 manifest 的可行 Pair 为 100%。文档列出的 16 类不可更新查询特征全部拥有已进入 manifest 的 query profile。

因子级审计的当前结论是：`source_extraction_complete=true`、`generation_model_complete=true`、`static_coverage_complete=true`、`behavior_coverage_complete=false`。报告保存在 `generated/factor_packages/create_view/coverage_audit.json`，也可从 `/api/specs/v1/audit/create_view` 查看。静态闭环只证明抽取、模型和候选 SQL 覆盖完整；数据库执行、10 个 planned scenario 和 10 个 open question 尚未验证，因此不代表 GaussDB 已实际接受这些 SQL。
