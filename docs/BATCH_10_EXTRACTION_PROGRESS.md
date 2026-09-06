# 第十批：安全策略、事件、包与外部资源契约

29 章完成原文处置与有限生成域对账，累计 199/224 包。本批没有数据库执行。

| 指标 | 结果 |
| --- | ---: |
| 有候选 SQL / 外部契约待实现 / 文档不支持 | 16 / 12 / 1 |
| 原文行 / Source unit | 2915 / 719 |
| Confirmed fact（含示例） | 715 |
| Open question / Planned scenario | 54 / 35 |
| Manifest / 候选 SQL | 38 / 182 |
| Pairwise 适用清单 / needs_profile 特性 | 10 / 52 |

29 包的原文原子性及事实消费审计通过；16 个生成包的逐任务 case/report/audit 与规范报告精确一致。专项 16/16、全量 333/333 通过（822.972 秒）。

关键校对：

- 审计策略区分 ACCESS 与 PRIVILEGES；ADD/REMOVE、DROP FILTER 都建立匹配的初始状态。
- 脱敏函数使用完整 ON LABEL 子句及真实文本列；正则函数参数不完整时不进入普通清单。
- RLS 使用布尔表达式和已启用的受控表，明确 INSERT 不属于本章策略命令域。
- 事件在专用 Schema 内创建并禁用，重命名清理旧名和新名；异步触发行为仍待验证。
- PACKAGE BODY 有匹配声明；ALTER PACKAGE COMPILE 的文档矛盾保留，不强行生成。
- 密钥、DBLINK、外表保留真实外部依赖与 COPY 正文来源，缺少运行时契约时没有普通 manifest。
- CREATE GLOBAL INDEX 是本版本明确不支持的 GSI，不能与分区表 GLOBAL 索引混为一谈。

[机器证据](../work/doc2spec/batches/batch_10/final_task_results.json)保存源、包、工具链、SQL 报告及测试哈希。所有新包仍为 needs_review，原文账本完成不等于全域 SQL 或行为覆盖完成。
