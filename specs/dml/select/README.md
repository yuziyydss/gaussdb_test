# SELECT Factor Package 适配验证

本目录使用 Factor Package Schema V1 抽取用户提供的 553 行 GaussDB `SELECT` 产品文档，目标是检验 CREATE VIEW 上形成的策略能否迁移到复杂查询语句，而不是宣称数据库执行已经闭环。

来源：

- 文档标题：`SELECT`
- 产品版本：正文未显式标注，记为 `unknown`
- 原文 SHA-256：`5e8a4e12707cea415d14b0f46517d30c17f5eb6cf7f371579190413440b95573`
- 文末失效本地链接出现 `GaussDB Kernel 507.0.0`，但不把它提升为正文版本事实

## 当前结果

- 43 个 source unit 登记了 553/553 行，无 `unmapped`；原子性审计发现 20 个长 unit 尚未拆分或复核，所以不再把行覆盖率误报成抽取完整。
- 31 条 confirmed fact，9 条 open question；confirmed fact 均有下游消费者。
- 保留 62 个兼容完整查询 profile，同时新增 15 个 AST 维度和 8 个结构化 manifest。
- 共 16 个 manifest、99 个 case：93 个正向、6 个带目标错误 Oracle 的负向；case ID 和 SQL 全局唯一。
- 新增的 37 个 AST case 覆盖 SELECT/TABLE 两个顶层产生式、WITH、重复投影、表/CTE/嵌套源、WHERE、GROUP BY、集合运算、ORDER BY、LIMIT 和锁定分支。
- AST 结构契约校验投影列、源列、GROUP BY、ORDER BY、集合运算列数/类型以及不兼容锁定组合。
- 6 条硬规则都有正向满足证据和单一目标负向证据。
- 文档能力台账 21/30 已覆盖；TABLE 顶层产生式已由 AST value 覆盖，剩余 9 项登记为 `needs_profile`。
- Fixture 编译器会为当前可生成用例生成真实 setup/seed/teardown；12 个环境/行为 scenario 仍为 `planned`，尚未连接数据库执行。

审计结论：

- `source_extraction_complete=false`（20 个 Source Unit 原子性缺口）
- `generation_model_complete=true`
- `static_coverage_complete=false`
- `behavior_coverage_complete=false`
- `pairwise_interaction_coverage_present=true`

`generation_model_complete` 表示当前选值都进入用例、规则和结构契约生效、所有可行 Pair 完整覆盖且 ID/SQL 唯一；它不代表剩余文档特性、原子性债务或数据库行为已经闭环。

## 为什么采用“完整 profile + AST”双轨

SELECT 原文同时包含递归 CTE、三处 INTO、嵌套 FROM 项、PIVOT/UNPIVOT/XMLTABLE、层次查询、集合运算、分页和锁定。把这些内容直接拆成十几个独立字符串槽位进行 Pairwise，会生成大量语法顺序正确但语义互相冲突的 SQL，例如层次查询加行锁、集合运算输入加锁、投影列与分组列不一致等。

最初只用完整查询 profile，保证复杂 SQL 的内部一致性，但没有子句交互覆盖。本次没有一次性删除这些 profile，而是把它们作为兼容分支，同时用递归 AST 逐步结构化高置信子集：

1. `choice` 表达 SELECT、TABLE 和旧 profile 三个顶层分支。
2. 命名 subgrammar 表达 SELECT 主体、FROM、nested SELECT、GROUP BY、集合运算和 ORDER BY。
3. `repeat` 从结构化 value 的 `items` 渲染投影、分组、排序和集合右侧列表。
4. 列契约先过滤伪合法组合，再计算理论可行 Pair 并验证 100% 覆盖。

当前 AST 是有限展开模型：类型和 subgrammar 引用结构递归，但一次 SQL 不允许无终止循环。尚未完成证据或环境建模的复杂分支继续保留为 profile/open question，不为了追求组合数强行拆槽。

## 尚缺 9 项 profile

- 具体 `plan_hint` 子语法
- `DENSE_RANK FIRST/LAST` 完整语法
- 三处用户变量 `INTO`
- `INTO OUTFILE/DUMPFILE`
- 保真的 `XMLTABLE` 示例
- targetlist 别名跨表达式引用矩阵
- 旧式 `(+)` 外连接表达式矩阵
- `ONLY_FULL_GROUP_BY` 完整键/JOIN 模式矩阵
- DISTINCT/ORDER BY 表达式等价和函数易变性矩阵

生成结果位于 `generated/factor_packages/select/`，审计位于其中的 `coverage_audit.json`。
