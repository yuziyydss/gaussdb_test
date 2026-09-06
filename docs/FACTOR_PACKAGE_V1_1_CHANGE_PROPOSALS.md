# Factor Package V1.1 变更提案登记

状态：`mixed`。P5 的最小依赖闭环已作为向后兼容扩展实现，其余提案继续
`proposed`。Factor Package V1 继续按
`FACTOR_PACKAGE_V1_FREEZE_POLICY.md` 冻结；任何提案都不能由单个章节的
worker 直接修改 Schema、Registry 或生成接口。

## 提案来源

第二批的跨章节交叉审查覆盖 DDL、DML、DCL 与 TCL。其原文账本、引用、规则、
case ID、SQL 去重和 Pairwise 均纳入统一门禁；下列问题在至少两个章节中重复出现，
因此登记为公共模型或流水线提案。`open_question`、`needs_profile` 与 planned
scenario 继续作为 V1 的诚实隔离机制，不因本提案改写为“已覆盖”。

## P1：环境条件参与组合求解

- 状态：`proposed`
- 重复证据：CREATE SEQUENCE 的 B 模式浮点步长；DELETE 的 B 模式 USING 与
  CURRENT OF；UPDATE 的 CURRENT OF、Oracle 兼容项。
- 当前限制：`environment_requirements` 只附加到生成结果，不参与 value
  validity、规则或 expected 分支求解；同一值无法表达“环境 A 成功、环境 B
  失败”。
- V1 处理：值保持 `conditional`，进入 planned scenario 或人工队列。
- V1.1 方向：增加显式环境谓词，使其参与可行组合与 expected 选择；未声明
  环境谓词的 V1 包行为必须保持不变。
- 验收：同一语法值可在两个环境 profile 下产生不同且可解释的预期结果，
  覆盖报告分别计算可行 pair，不把环境不适用组合计为遗漏。
- 2026-09-06 补充：[条件值准入评审](CONDITIONAL_ADMISSION_REVIEW.md) 区分 INSERT
  的环境/对象前置条件与 CREATE/ALTER RESOURCE POOL 的跨章支持性冲突，给出
  证明责任、迁移约束和反例测试要求；仍为 proposed，未放宽 V1 positive 门禁。

## P2：通用赋值形状和类型契约

- 状态：`proposed`
- 重复证据：UPDATE 的多列 SET/子查询；MERGE MATCHED 的元组赋值与
  NOT MATCHED VALUES。
- 当前限制：V1 有 SELECT、INSERT、INDEX 等结构检查，但缺少“目标列形状
  与表达式元组或查询输出形状相容”的通用契约。
- V1 处理：仅生成已知内部一致的有限 profile，其余登记 feature gap。
- V1.1 方向：定义语句无关的 column shape，至少包含列数、顺序、类型族、
  nullability 与来源；UPDATE/MERGE 只引用该契约，不再增加语句专用字符串判断。
- 验收：列数不等、类型不兼容和兼容赋值分别有确定的静态判定与针对性测试。

## P3：无界重复与递归覆盖元数据

- 状态：`proposed`
- 重复证据：GRANT、DROP TABLE、TRUNCATE、DELETE、MERGE、UPDATE、BEGIN。
- 当前限制：SQL 文法中的 `[, ...]`、递归 CTE、嵌套子查询不可能通过有限
  SQL 集合穷尽；当前只能依靠文字说明和 representative profile。
- V1 处理：显式有限展开、`coverage_mode: representative`、`max_depth` 与
  open question；不得声称全域覆盖。
- V1.1 方向：标准化 `domain_kind: unbounded|recursive`、采样基数、最小/最大
  展开深度与边界样本标签。
- 验收：报告必须同时显示“有限抽样已覆盖”和“无限域未穷尽”，二者不能合并
  成一个 100% 指标。

## P4：共享 profile/matrix 契约

- 状态：`proposed`
- 重复证据：TRUNCATE、DELETE、MERGE、UPDATE 的分区 profile，以及
  DELETE/UPDATE 的视图、保留键和多种基表能力。
- 当前限制：fixture 可以无 `factor_ref` 共享；matrix 必须归属单一 factor，
  导致相同对象能力在多个包内复制并可能漂移。
- V1 处理：各因子保留本地 matrix；可共享 fixture，但不绕过 Registry 成员校验。
- V1.1 方向：引入可复用 capability profile，并让产品规则仍归属消费它的
  factor；需要明确导入版本、覆盖方式和漂移检查。
- 验收：两个因子可引用同一对象能力定义，各自仍能追溯本章 fact，修改共享
  profile 时能识别受影响包。

## P5：catalog 依赖闭包与稳定导入

- 状态：`partially_implemented`
- 重复证据：DELETE、UPDATE、MERGE 依赖 SELECT、CREATE VIEW、分区、Hint
  或 DBLINK；BEGIN 匿名块依赖 DML 子语法。
- 当前限制：`supplemental_sources` 能记录已选择的来源，但批次规划不会自动把
  被引用章节纳入 catalog，也没有稳定的语法/profile import。
- 已实现：`factor_id::fact_id` 限定引用与 confirmed fact 显式导出；跨包 Fact
  类型校验；因子依赖 DAG/循环检测；Fixture `requires_fixture_refs` 拓扑；队列
  依赖顺序；验证快照中的直接/传递依赖章节和包哈希，以及精准 stale 判定。
- 仍缺：抽取前仅凭 catalog 正文自动发现尚未建包的依赖、全局 Capability
  Matrix 导入和公共 Subgrammar 导入。缺失章节继续保持 open question，不得凭
  旧规格或模型记忆补齐。
- 验收：给定一个章节，工具能输出确定的直接/传递依赖清单，导入来源变更会让
  旧静态完成状态失效。
- 集成验证：已用 12 个现有 PDF 章节验证 19 条事实引用、2 条 Fixture 引用、
  17 条包依赖边；正文未重新 inventory 的漂移漏报已修复。逐项证据及尚未覆盖
  的边界见 `CROSS_CHAPTER_DEPENDENCY_RESULT.md`，不据此把 P5 整项标为完成。
- 后续第三轮验证：15 包/17 章正文、20 条 Fact 引用、18 次变更注入通过；内部
  快照增加补充正文的磁盘哈希核对及消费者失效。见 `QUALITY_ROUND_03.md`。
  全库 224 包的来源绑定也已核对，但不等价于自动发现未声明依赖或全局 Subgrammar 复用。

## P6：保留验证历史与首轮质量指标

- 状态：`proposed`
- 重复证据：第二批 10 个任务的 queue 能保存最后一次 `checks`，但重新验证会
  覆盖旧输出；`attempt` 只表示认领次数，无法可靠还原首轮通过率、修复轮次和
  重试率。
- 当前限制：本批只能报告最终门禁和人工修复记录，不能从机器事实源重建每次
  verify 的完整时间序列。
- V1 处理：最终结果明确标注该指标不可重建，不用主观回忆伪造百分比。
- V1.1 方向：为每次 verify 追加不可变 history 记录，至少保存时间、工具链
  hash、输入快照、各阶段 return code、状态迁移和缺口摘要；保留现有 `checks`
  作为最新快照以兼容 V1。
- 验收：可从 queue 单独重算首轮门禁通过率、每任务重试次数和按根因聚类的
  收敛曲线，且旧 V1 queue 仍能正常加载。

## 明确不属于 V1.1 Schema 修改

- 缺少分区、视图、角色、DBLINK 等 fixture：进入共享资产建设队列。
- PDF 没给 SQLSTATE 或稳定错误文本：保留 `oracle_status: needs_verification`，
  等数据库校准，不能放宽目标错误门禁。
- 多用户、多会话、事务、计划、性能和元数据行为：进入 scenario 执行轨道。
- 单个包的 SQL、fixture、别名或列引用错误：作为 V1 包内缺陷直接修复。

## 决策门禁

V1.1 进入实现前必须同时满足：

1. 至少两个独立章节提供可复现证据；
2. 有兼容性与迁移方案；
3. 有失败先行的模型、生成和覆盖测试；
4. 不把无限域、环境未知或未执行行为包装成全覆盖；
5. 经单独评审批准，不与某一批章节抽取混合提交。
