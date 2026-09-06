# 第九批：身份、权限与安全标签

本批24章已完成原文处置、有限SQL生成和证据对账，不等于全域或数据库行为验证。

| 项目 | 结果 |
| --- | ---: |
| 新包 / 有候选SQL | 24 / 21 |
| 无普通清单的工具或全局安全字典包 | 3 |
| 原文行 / Source unit | 2545 / 821 |
| Confirmed fact（含示例） | 804 |
| Open question / Planned scenario | 70 / 28 |
| Manifest / 候选SQL | 46 / 216 |
| Pairwise适用清单 / needs_profile特性 | 24 / 70 |

24包原文原子性与事实消费审计通过；21个生成包的逐任务case/report/audit与规范报告精确一致。
专项14/14及全量317/317通过；全量用时725.005秒，运行时170个包。
[机器证据](../work/doc2spec/batches/batch_09/final_task_results.json)保存源、包、工具、SQL报告与测试哈希。

关键校对：

- ROLE/USER/GROUP仅创建独占、NOLOGIN、PASSWORD DISABLE身份，不输出明文或星号密码。
- UNLOCK、REMOVE成员、REVOKE权限等均构造对应初始状态；列级REVOKE不混入表级授权。
- ALTER DEFAULT PRIVILEGES限定独占Schema与明确接收者，先授后撤，清理同一ACL范围。
- DROP OWNED/REASSIGN OWNED仅作为目标语句，作用于专用新角色及显式两张表；从不作为宽泛setup/teardown兜底。
- RESOURCE POOL的MAX_DOP集中式支持与目录正文冲突，因此从普通清单移出，保留conditional值及问题；I/O阈值50%/90%差异未强行统一。
- SECURITY LABEL负向指定目标错误类别，Oracle仍needs_verification，不臆造SQLSTATE。
- DROP GROUP为管理工具专用；创建/删除弱密码字典缺少全局状态恢复契约，这三个包没有普通manifest。

所有包仍needs_review；本批无数据库执行。累计170/224包，剩余54章。
