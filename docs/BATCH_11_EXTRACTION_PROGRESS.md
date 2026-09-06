# 第十一批：分区、数据流、模型与恢复

25 个剩余章节已落盘，224 个 general SQL 章节均有 PDF 绑定包。本批没有数据库执行。

| 指标 | 当前结果 |
| --- | ---: |
| 有有限候选 SQL / 运行时契约待实现 | 11 / 14 |
| 原文行 / Source unit | 7413 / 2143 |
| Confirmed fact（含示例） | 3235 |
| Open question / Planned scenario | 39 / 25 |
| Manifest / 候选 SQL | 36 / 197 |
| Pairwise 适用清单 / needs_profile 特性 | 29 / 25 |

25 包原文原子性、事实消费检查通过；专项 20/20 通过；全量回归 353/353 通过（1085.263 秒）。25 个任务信封均通过，11 个有 SQL 的包逐任务生成结果与最终全库快照精确一致。最终证据见 `work/doc2spec/batches/batch_11/final_task_results.json`。

这不是静态全域或行为验收通过：逐任务审计仍因已披露的特性、Oracle 和运行时缺口返回 needs_review；未生成普通 SQL 的 14 包不计入 SQL 通过率。

## 已实现的有限生成范围

- CREATE TABLE PARTITION：RANGE、START END、LIST、HASH、时间类型 INTERVAL；填充因子边界与行迁移开关。
- CREATE TABLE SUBPARTITION：RANGE/LIST/HASH 的 9 种二级组合，显式且唯一的叶子分区名。
- ALTER 分区：有真实 ASTORE 分区、种子数据的独立增删、切分、合并、重命名、清空和行迁移操作；不混入 ONLINE 或未提供的 GLOBAL 索引。
- PARTITION/SUBPARTITION AS：两列 INT 投影与分区键匹配，区分 WITH DATA、WITH NO DATA 和缺省。
- COPY：仅 TEXT/CSV TO STDOUT；CSV 的 HEADER/FORCE_QUOTE 不污染 TEXT，输入流和文件不拼成 SQL。
- INSERT ALL：重复 INTO、无条件 ALL、条件 ALL/FIRST/省略关键词，均保留最终 SELECT 和 A 模式门槛。
- REPLACE：VALUES/VALUE、SELECT、SET 三类结构，有真实主键冲突和源表。
- SNAPSHOT：专用 Schema 中单一版本 CREATE AS，清理用 PURGE SNAPSHOT，不再臆造 DROP SNAPSHOT。
- PURGE：仅本轮独占 Schema 的单表或单索引，不生成清空全部回收站。
- TIMECAPSULE TABLE：真实 DROP/TRUNCATE 前置状态，重命名同时清理旧名/新名；不硬编码 CSN 或恢复时间。

## 未生成普通用例的 14 包

CREATE/ALTER/DROP TABLESPACE；CREATE/DROP LLM；CREATE/DROP MODEL 与 PREDICT BY；AUTOHINT、AUTOHINT DROP MODEL、AUTOHINT PURGE、EXPLAIN AUTOHINT；LOAD DATA；TIMECAPSULE DATABASE。

这些不是统一归为“不支持”：分别缺少服务端目录、外部密钥/HTTPS 服务、训练预算和模型所有权、查询历史、文件传输、库级回收状态的执行契约，或原文明确限定为内核内部调用。原文、语法结构、前置限制和待实现场景仍完整保留；没有普通 manifest，因此不计入 SQL 通过率。

原文冲突保留：LLM 示例短 API key、API 路径单复数差异；模型超参数表出现正文 architecture 未列出的 PCA/multiclass/XGBoost；表空间权限及大小措辞差异；间隔分区整数/时间类型跨章差异；COPY FREEZE 错文；INSERT ALL 的 ELSE 仅出现于示例。模型超参数表另经 PDF 页面渲染校对。

跨包限定 Fact 引用与 Fixture 依赖已加入分区、模型、LLM、表空间及 LOAD DATA/COPY 关系；来源改变会影响下游验证快照。所有新包仍 needs_review，场景未执行。
