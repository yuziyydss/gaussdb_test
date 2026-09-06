# 第六批抽取与有限域生成结果

更新时间：2026-09-05。第六批 20 个包的有限域抽取、SQL 生成、全量回归与逐包证据对账已完成；不代表严格静态全域或数据库行为闭环。

## 已生成的有限域

| 项目 | 本批结果 |
| --- | ---: |
| 新章节包 | 20 |
| 源文本行数 | 2,419 |
| Source unit | 567 |
| confirmed fact（含 example） | 495 |
| manifest | 33 |
| 候选 SQL | 140（138 正向 / 2 目标负向） |
| open question | 63 |
| planned scenario | 24 |
| 显式 needs_profile feature | 68 |
| 原文处置门禁 | 20/20 |
| 有限生成模型门禁 | 20/20 |
| Pairwise 适用清单 | 13/33；其余固定语句或不足两个变化维度，不计 pair 覆盖率 |
| 严格静态全域闭环 | 0/20 |
| 数据库行为闭环 | 0/20；本阶段未执行 |

needs_profile 数不等于所有覆盖缺口的总数：已有 representative 也不证明其语法全域完整。
原文处置门禁包含合理登记的 open question，不代表这些问题已经解决。

## 包级数量

| 因子 | 清单 | SQL | Open question | 待建 profile |
| --- | ---: | ---: | ---: | ---: |
| alter_procedure | 3 | 17 | 6 | 6 |
| alter_trigger | 1 | 2 | 2 | 2 |
| checkpoint | 1 | 1 | 1 | 0 |
| clean_connection | 1 | 4 | 3 | 3 |
| cluster | 4 | 6 | 3 | 3 |
| commit_prepared | 1 | 1 | 3 | 2 |
| create_cast | 1 | 3 | 4 | 4 |
| create_procedure | 2 | 9 | 8 | 8 |
| create_rule | 3 | 19 | 4 | 4 |
| create_trigger | 3 | 19 | 7 | 7 |
| cursor | 1 | 7 | 2 | 2 |
| drop_cast | 1 | 6 | 1 | 1 |
| drop_procedure | 2 | 3 | 1 | 1 |
| drop_rule | 1 | 6 | 2 | 2 |
| drop_trigger | 1 | 6 | 2 | 2 |
| prepare_transaction | 1 | 2 | 2 | 2 |
| rollback_prepared | 1 | 1 | 2 | 1 |
| set_role | 1 | 1 | 1 | 1 |
| set_session_authorization | 1 | 4 | 1 | 1 |
| vacuum | 3 | 23 | 8 | 16 |

## 本次校对与修正

1. 固定无参数语句暴露了零维度生成 bug。先新增失败回归，再在 V1 生成入口将固定语句解释为一个空赋值；仍执行规则检查，不改变旧组合器 API，也不为固定语句添加假维度。
2. Source unit 按实际示例步骤重分，避免一个含多种操作的摘要复制到每十行；参数推荐顺序与语法自由顺序分成两条事实。
3. CLUSTER 的“首次且无 USING”是组合错误，表本身仍是合法值。补充该目标表配显式索引的正向用例，未把整张表错误标为 invalid。
4. CREATE TRIGGER 的 TRUNCATE × ROW 为目标负向，正常 DELETE 使用返回 OLD 的函数，INSERT/UPDATE 使用返回 NEW 的函数。
5. CLEAN CONNECTION 只生成 TO ALL 且同时限定专用数据库和用户的形式；无目标清理保留缺口。
6. COMMIT/ROLLBACK PREPARED 的参数说明与功能说明存在 ID 措辞冲突，留 open question，未凭猜测改成硬规则。
7. VACUUM 的不支持在线对象逐项登记，FREEZE + ONLINE 的降级语义保留为行为场景而非报错预期。

## 验证证据

- 专项测试：`work/doc2spec/batches/batch_06/tests_targeted.log`，21 项通过。
- 零参数修复：`zero_dimension_red.log`（修复前失败）与 `zero_dimension_green.log`（3 项通过）。
- 全量回归：`work/doc2spec/batches/batch_06/tests_final_verified.log`，275/275 通过，耗时 500.041 秒。
- 首轮全量回归曾有 1 项旧断言失败：它要求所有 SQL 都消耗维度。已改为对零参数语句验证无槽位、无占位符、无 AST 参数；有参数用例仍要求维度溯源。修复前日志保存在 `tests_before_fixed_traceability.log`，单测红绿证据为 `fixed_traceability_red.log` / `fixed_traceability_green.log`，最终全量已重新运行。
- 逐包证据：`work/doc2spec/batches/batch_06/verification/<factor>/`，20 包完成；任务信封、lint、生成检查通过，严格覆盖 audit 返回 1 并诚实保留 needs_review。33 个清单的用例与报告、20 个包的覆盖对象均与规范生成报告精确一致。
- 机器可读对账：[final_task_results.json](../work/doc2spec/batches/batch_06/final_task_results.json)，保存源文档、章节目录、包、工具链、规范报告及最终测试日志的哈希。
- 规范 SQL：`generated/factor_packages/<factor>/manifest_*.sql`。
- 全局生成报告：`generated/factor_packages/generation_report.json`，当前 348 个清单、2,985 个唯一 case ID、2,957 种 SQL 文本。跨包同文 SQL 保留来源，不计为同包重复。

## 全本进度与安全边界

本地 PDF 通用 SQL 分母是 **224**，不是历史版本的 226。当前有 **95 个绑定该 PDF 的包**，还有 **129 章未建包**。
224 章正文均已拆分至 `work/doc2spec/full_general_corpus/`；这只是文本拆章完成，不是 224 章因子抽取完成。
完整目录对账与后续队列见 [剩余章节清单](PDF_GENERAL_EXTRACTION_BACKLOG.md)。

全局当前原文处置门禁 95/95、有限生成模型门禁 88/95、严格静态门禁 3/95。不能将文件存在或 SQL 已生成等同于完整覆盖；旧包的 7 个有限生成模型缺口未在本批顺带宣告解决。全本队列没有导入旧验证快照，因此其 static_complete 为 0，与当前规范审计的 3/95 是不同口径。

本批所有包仍为 needs_review。两阶段事务失败清理、角色凭据注入、复杂过程体、视图/约束触发器、分区与在线维护等尚未完成，禁止将这批 SQL 整文件直接投入共享数据库批跑。
