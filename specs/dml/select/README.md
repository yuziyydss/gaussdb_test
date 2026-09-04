# SELECT Factor Package（PDF 基线）

本目录以本地 PDF 拆章产物 `intranet_corpus/general/dml/select.txt` 为唯一产品事实源，
对应 `GaussDB V2.0-10.0.0 集中式参考 / 1.13.19.3 SELECT`。本包只完成静态抽取、
建模、组合生成和覆盖审计；本轮没有连接或执行数据库，因此任何 `success`/`invalid`
都是文档驱动的静态预期，不代表数据库实测结论。

## 事实源

- 文档版本：`V2.0-10.0.0`
- catalog document：`gaussdb_v2_0_10_0_0_centralized_reference_01`
- catalog chapter：`general/dml/select.txt`
- 章节 SHA-256：`704be074e80aa4db10f5bd8f4c587e31be2602640aced00c4985610d674fa4cc`
- 拆章行数：2333（PDF physical page 1806–1849）
- `supplemental_sources=[]`：本章点名但 catalog 尚未拆出的跨章语法没有用旧网页、旧版本或模型记忆补齐。

## 当前静态结果

- Source Ledger：269 个 unit 覆盖 2333/2333 行；258 个 `mapped`、7 个
  `open_question`、4 个版式/结构 `out_of_scope`，无忽略行或缺失行。复合枚举启发式仍识别出 72 个需要继续拆分或给出理由的 atomicity gap，所以 source 尚未闭环。
- 事实：51 条 `confirmed`、14 条 `open_question`；confirmed fact 均已被语法、
  值、规则、能力矩阵或场景消费。
- 语法：一个顶层 `choice` 明确区分完整 profile、结构化 SELECT AST 和 TABLE
  简化产生式；AST 使用命名 subgrammar、`choice`、`optional`、`repeat` 和有限深度
  SELECT 展开，并用表达式/列契约过滤投影、来源、GROUP BY、ORDER BY 和集合运算的伪合法组合。
  当前集合 AST 只组合一个右操作数，不覆盖任意深度、连续操作符优先级或括号子表达式。
- 能力矩阵：70 个 query profile（64 个文档支持的代表形态、6 个文档明确禁止的
  负向形态）；集合运算的现有 UNION/INTERSECT/EXCEPT/MINUS profile 只记为
  `representative`，完整的多操作符优先级、左结合和括号 AST 矩阵仍是 `needs_profile`。
- Fixture：7 个受控对象 profile，包含普通源表、右表、层次表、分区表、闪回表、
  Hint 表/索引和分组模式表。
- Manifest：16 个，共生成 110 个静态 case（104 个正向预期、6 个负向预期）；
  所有适用的可行 Pair 均 100% 覆盖，case ID 与 SQL 无重复。
- Scenario：16 个行为/元数据场景均为 `planned`，没有把未执行场景记成已验证。

其中 22 个环境相关正向 case 的 `expected.scope` 为 `syntax_only`；它们的前置条件异构，
所以没有伪造一个全局 environment gate，也不得整批自动执行。PIVOT XML 负向 case
已单独声明 `compatibility_mode=A` gate，防止用兼容模式错误代替目标功能错误。6 个负向规则有
文档中的“禁止/报错”事实，但 SELECT 章没有给出对应 SQLSTATE 或稳定错误文本，
因此其 manifest 保持 `needs_review`、`oracle_status: needs_verification`，不写猜测的
SQLSTATE，也不使用 `.*`/`.+` 之类宽泛正则。

## 双轨生成为什么保留

SELECT 同时包含 WITH/递归 CTE、三个 INTO 位置、递归 FROM、XMLTABLE、
PIVOT/UNPIVOT、层次查询、集合运算、分页与锁定。若直接把所有子句拆成独立字符串
做笛卡尔积或 Pairwise，会组合出顺序看似正确、语义却冲突的 SQL。

因此当前采用两条互补路径：

1. 完整 query profile 保存复杂语句内部的一致性，并承载尚不适合自由组合的文档示例。
2. 有限展开的结构化 AST 对高置信子集做组合；列契约先筛掉不可行组合，再对可行集合计算并验证 Pairwise。

`generation_model_complete=true` 只表示当前建模值都被选择、规则与结构契约生效、
可行 Pair 完整覆盖且无重复；它不等于整章所有能力已经建模，更不等于数据库行为闭环。

## 诚实保留的缺口

以下 12 项仍是 `needs_profile`：

- targetlist 别名引用的完整表达式正反矩阵
- CTE 中 INSERT/UPDATE/DELETE 主体及 RETURNING/列契约
- FROM 函数的已确认函数签名与输出列契约
- XMLTABLE 的完整兼容模式/类型/错误矩阵
- `(+)` 外连接的完整表达式矩阵
- `ONLY_FULL_GROUP_BY` 的键依赖与 JOIN 方向矩阵
- DISTINCT/ORDER BY 表达式等价与函数易变性矩阵
- 完整 plan_hint 子语法（本章只给 indexscan/rows 示例）
- DENSE_RANK FIRST/LAST 的跨章完整语法
- INTO 用户变量的会话前置与行为
- INTO OUTFILE/DUMPFILE 的权限、路径与导出行为
- 集合运算的多操作符优先级、左结合和括号子表达式 AST 矩阵

此外，DATABASE LINK、层次函数细节和错误码身份位于未拆出的其他章节，继续作为
`open_question`，等待同一 catalog 的本地章节出现后再合并；严禁凭记忆补规则。

## 本轮验证口径

已执行的检查仅为：规格 lint、静态 SQL 生成、基础 SQL 形态校验、Source Unit/事实/
值/规则/Pairwise/重复项审计。当前审计结论为：

- `source_extraction_complete=false`（行已登记，但仍有 72 个原子性复核缺口）
- `generation_model_complete=true`
- `static_coverage_complete=false`
- `behavior_coverage_complete=false`
- `pairwise_interaction_coverage_present=true`

默认生成命令可将 SQL 写入 `generated/factor_packages/select/`；在数据库执行、Oracle
校准和 planned scenario 落地前，不应把这些静态 SQL 描述为“全部可执行并已通过”。
