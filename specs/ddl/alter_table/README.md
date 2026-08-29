# ALTER TABLE Factor Package V1

该目录是 ALTER TABLE 的单一事实源。Legacy `factors/`、`grammars/` 和根目录 `manifests/` 不再用于维护本次抽取规则。

## 当前结果

- 原文：566 / 566 行已登记。
- Source Unit：69 / 69，原子性缺口为 0。
- 事实：54 条 confirmed，10 条 open question。
- 结构：1 个多顶层 AST syntax，2 个能力 matrix，4 个可执行 fixture。
- 生成：15 个 manifest，共 273 条 SQL；261 条正向，12 条目标错误。
- 覆盖：所有 manifest 的可行 Pair 100% 覆盖；72 / 72 个 valid value 已选中；规则缺口为 0。
- 行为：18 个 scenario 已规划但尚未连接 GaussDB 执行。

## 关键建模决定

1. 通用 action、表/列/约束重命名、SET SCHEMA、ADD 多列分别使用顶层 AST 分支。
2. `table_name`、`table_name*`、`ONLY table_name`、`ONLY (table_name)` 使用目标 choice，而不是字符串后处理。
3. ONLINE 不支持某形态时，原文规定 NOTICE 后降级离线；这类事实进入 scenario，不误建成目标错误。
4. B 模式、A 模式 ROWID、TDE、ILM、COLVIEW、外表、加密列和子分区在缺少环境 Fixture 时保持 conditional/open question。
5. 负向 SQL 都声明目标规则和错误 Oracle；`nextval()` 用例预先创建序列，避免“序列不存在”掩盖目标限制。

## 尚未闭环

以下 10 类能力需要补充环境或外链章节：A/B 兼容数据库、在线 DDL 故障环境、TDE/KMS、ILM 白名单、COLVIEW/HTAP、ADD CONSTRAINT 索引方法、加密列、外表、子分区。

因此当前结论是：`source_extraction_complete=true`、`generation_model_complete=true`，但 `static_coverage_complete=false`、`behavior_coverage_complete=false`。生成 SQL 已完成静态审计，尚未在真实 GaussDB 执行。
