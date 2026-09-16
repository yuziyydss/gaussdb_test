# 来源原子性与 DEFAULT / CASE / UNION 复核

本轮仅本地静态工作：先拆来源账本，再评审 DEFAULT，最后展示公共类型证据。
未连接数据库，未提交或推送。不是全库语义闭环声明。

## 来源账本

| 包 | 对照 PDF 后的修改 |
| --- | --- |
| ALTER TABLE | CHANGE 分开 B 模式、外表、密态内存、分区键类型/排序规则、规则引用列、物化视图引用列 6 个条件，补 5 个独立事实 |
| CREATE TABLE | 生成表达式拆为其他行、其他生成列、系统列、结果集、子查询、聚集函数、窗口函数、仅允许 IMMUTABLE 共 8 个事实 |
| COMMENT | 3 组分支补 22 个语法事实，包括同一行的表列/视图列两个分支 |

依据本地 `gaussdb-rf-cent.pdf`，物理页分别为 1279–1280、1547、1372。
同一行多个子句保留重叠原因，行覆盖按并集计数。保留旧汇总事实，不删除历史引用。
新增事实只接入语法或既有 planned 场景，不宣称增加了数据库负向测试。
COMMENT 的 OPERATOR 仍为 needs_profile，TYPE 仍只代表性覆盖。
反向回归要求：把七个 COMMENT 主张重新合并后，审计仍必须报原子性缺口。

`source_extraction_complete` 仅表示当前账本映射和原子性检查通过，
不是所有语义已发现、所有规则已实现，更不是实机通过。

## DEFAULT：保留来源差异与未知

| 来源 | 原文含义 | 判断 |
| --- | --- | --- |
| 一般 ALTER TABLE，正文 L438–442，物理页 1280 | 视图缺省在 ON INSERT 规则应用前加入 INSERT | 未证明基表默认值自动继承，也未说明 UPDATE |
| 一般 ALTER VIEW，L80–81，物理页 1349 | SET/DROP DEFAULT 暂无实际意义 | 与上一条需区分操作入口及有效范围 |
| M ALTER VIEW，L61–62，物理页 2063 | 同样说明暂无实际意义 | 不能借一般模式或其他数据库实现补齐 |
| INSERT / UPDATE 的 DEFAULT 描述 | 使用对应列缺省值或 NULL | 未确定视图、派生目标与基表的默认值关系 |

已有事实：`alter_view::alter_view_fact_default_no_effect`、
`m_alter_view::m_alter_view_fact_defaults_noop`。不将 ALTER TABLE 的描述提升为
通用继承规则，也不将一般模式规则自动提供给 M。

保留 `default_unknown`；不改预期、不删正向候选、不改为 unsupported。
回归覆盖一般/M、视图/派生目标、显式 DEFAULT/省略列、基表无默认/NULL/常量/函数默认。
M INSERT 派生目标若先被入口检查拦截，明确为 `syntax_unknown`，不声称已检查 DEFAULT。

后续需分别校准基表默认、显式视图默认、INSERT 重写阶段、UPDATE/派生目标默认。
可用不同的基表/视图常量，观察省略列、DEFAULT、显式值及 SET/DROP DEFAULT 前后结果。
必须先确认模式和规则机制并获得数据库授权；当前不虚构期望结果或 SQLSTATE。

正文 SHA-256：

- ALTER TABLE：`ff15f5547fd4f2b5aa4888b0d8c67b74f0586098cf3c87d3b2628506562e786e`
- ALTER VIEW：`90553d8d8acee8e3d9e527aa0e9619ba404744c4e7afddc2f118a97f40a49a04`
- M ALTER VIEW：`70f9aca1199488ffe84fa01ea163f3cd54d5c2014e3ffd1180157497902b8170`

## CASE / UNION：独立展示已有类型证据

生成器已有 `pg_scalar_union_case_v1`、`a_integer_union_case_v1`，检查明确模式、
实际源表 DDL、分支输出类型/列数、目标赋值精确类型。通用有限写入检查器不识别
这些完整查询形态，因此部分写入仍为 needs_review；这不是没有任何类型证据。

新增 `scripts/audit_common_type_evidence.py`：

1. 从正式规格选择显式合同，重新生成对应清单并逐字段匹配旧候选。
2. 在真实 SQL/DDL 上重跑类型检查，不复用旧绿色标签。
3. 输出 `checked_types`，独立保留 `finite_write_status`，且
   `full_write_proven=false`、`runtime_proven=false`。
4. SQL、setup、模式、case_id、消费维度变化均不能复用旧证据；重复 ID 失败。

未选择该合同的候选计入 outside_contract_scope，不算通过。
结果值、行数、NULL/约束、通用隐式转换和 Oracle 不在该类型合同证明范围内。

```sh
python3 scripts/audit_common_type_evidence.py --output work/my_review/common_type_evidence.json
python3 scripts/audit_rendered_sql_contracts.py --output work/my_review/rendered_sql_contracts.json
```

两个报告一起读：类型证据不覆盖有限写入状态。

## 验证记录

工作目录 `work/semantic_review_20260915/` 保留前置失败和修复后回归日志。

- 全量生成：843 清单、5,290 条候选。完整候选对象和 843 个 SQL 快照均未变，
  只有 ALTER TABLE、COMMENT、CREATE TABLE 的覆盖报告更新；见 `generation_comparison.json`。
- 当前账本检查：一般模式 224/224、M 93/93，共 317 个包通过来源账本检查，
  比本轮前增加 3 个；按当前定义静态覆盖仍只有 46 包，897 个场景全部 planned。
  见 `package_status.json`，不要把来源账本通过解释为语义全覆盖。
- 有限写入：331 checked、20 needs_review、26 negative rejected、4,913 not_applicable；
  正向 rejected=0。16 条 DEFAULT 与 4 条公共类型写入的逐 case 处置见 `remaining_write_review.json`。
- 类型证据：15 条 checked_types（11 SELECT + 4 INSERT），4 条 INSERT 仍为有限写入 needs_review。
  见 `common_type_evidence.json` 与 `rendered_sql_contracts.json`，二者不合并成通过率。
- 最终受影响静态回归：**119 模块、1,003 项通过**；四分片 48 / 285 / 357 / 313，
  均 exit 0、OK，无跳过或 expected-failure。不是全项目所有模块的全量测试。
- 已校验日志、启动记录、实际发现的测试数与模块清单；9,664 个被跟踪输入的前/后/当前哈希一致。
  最终回执为 `static_final/result.json` 及 `static_final/shard_*/receipt.json`。
- 初始新增事实位置错误、遗漏的旧来源状态断言、审计器新增前的失败与第一次中止回归均保留，
  不计入通过数。第一次 `static/` 四分片 exit -15；有效证据仅取 `static_final/`。

正式生成报告 SHA-256：
`7eb767f65cd9629a02666680e292c3d13b8883bf283e9dff3d06dedfc15b5aba`。
没有数据库执行证据，也未新增执行授权。
