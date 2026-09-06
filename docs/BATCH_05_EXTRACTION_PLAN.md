# 第五批：20 个章节与真实依赖输入

## 固定边界

唯一产品正文是本地 `gaussdb-rf-cent.pdf`：V2.0-10.0.0 集中式版参考，文档01，2026-04-30。
父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

- 新章节20个，2564行；既有提供者10个，6901行；补充来源4个，879行。
- 同一 catalog 共34章、10344行。提供者和补充来源不重复计为新增因子。
- 选择与调度依赖：`tests/data/batch_05.json`。
- 原文、页内边界、哈希、任务信封和队列只保存在 `work/doc2spec/batches/batch_05/`。
- 仅本地抽取、有限域生成与静态验证；不连接数据库，不执行候选，不创建服务器目录或用户，不提交/推送 Git。
- 复用现有 V1 模型、生成器与 `prepare_batch_03.py --plan/--batch-root`，不另写批次专用生成器。

## 分组

| 分组 | 本批新章节 | 实际验证范围 |
|---|---|---|
| 程序对象 | CREATE FUNCTION、ALTER FUNCTION、DROP FUNCTION、CALL、DO | PostgreSQL风格标量SQL函数、普通IN参数、有限属性与匿名块；Oracle风格/OUT/包/文件函数单列缺口 |
| 聚集 | CREATE AGGREGATE、ALTER AGGREGATE、DROP AGGREGATE | 转换函数真实前置、现代与BASETYPE语法、单INTEGER聚集；复杂状态函数另列 |
| 文本搜索配置 | CREATE / ALTER / DROP TEXT SEARCH CONFIGURATION | PARSER/COPY、ngram选项、真实词典映射、名称和模式变更；内部测试环境门禁 |
| 文本搜索词典 | CREATE / ALTER / DROP TEXT SEARCH DICTIONARY | 无文件Simple模板与ACCEPT；其他五模板逐项记录，不伪造服务器文件 |
| 物化视图 | CREATE INCREMENTAL MATERIALIZED VIEW、REFRESH INCREMENTAL MATERIALIZED VIEW、ALTER MATERIALIZED VIEW | ASTORE源、简单过滤/UNION ALL、列契约、全量与增量对象类型区别 |
| 注释与辅助命令 | COMMENT、EXPLAIN PLAN、RENAME TABLE | 表/列注释、计划标签ASCII字节边界、重复重命名目标；其他对象/编码/兼容特性保持缺口 |

## 依赖如何落地

调度图只是处理顺序，不等于真实Fact消费。实际边由限定 Fact 和 `requires_fixture_refs` 解析并验证：

- CREATE FUNCTION 的 callable Fixture → CREATE AGGREGATE 的转换函数 → ALTER/DROP AGGREGATE。
- CREATE FUNCTION → CALL、ALTER FUNCTION、DROP FUNCTION。
- CREATE TEXT SEARCH CONFIGURATION + CREATE TEXT SEARCH DICTIONARY → ALTER TEXT SEARCH CONFIGURATION 的有序映射。
- CREATE INCREMENTAL MATERIALIZED VIEW → 基表新增数据 → REFRESH INCREMENTAL MATERIALIZED VIEW。
- 既有 CREATE MATERIALIZED VIEW → ALTER MATERIALIZED VIEW、错误对象类型的增量刷新负向。

Fixture由本包入口引用上游，不让场景直接越过包索引引用其他包的Fixture。
拓扑测试检查上游先建、下游先清理。物化视图源显式为ASTORE与segment=off，不依赖默认存储类型。

四个source-only章节是 CREATE ROLE、CREATE PROCEDURE、CREATE TABLESPACE、PLAN_TABLE。
其中 PLAN_TABLE 是抽取 EXPLAIN PLAN 时按正文引用补入的真实系统表章节（8.3.16.205），
已核对session退出清理、statement_id字段以及仅SELECT/DELETE操作能力；不把补充正文自动计成第五批第21个因子。

## 审核边界

- CREATE FUNCTION 的替换/返回类型重载描述有差异；OUT参数与GUC规则也存在需要按场景校准的措辞。
- CREATE FUNCTION写COST/ROWS大于等于0，ALTER FUNCTION写正数；分别记录，正向暂用正数。
- ALTER FUNCTION的COMPILE主语法未列签名，但示例给了带签名形式；默认只采用主产生式。
- Synonym词典参数说明用SYNONYM，示例用SYNONYMS；文件类型分支不默认生成。
- 文本搜索功能明示内部使用，词典创建需SYSADMIN；用机器可检查的环境门禁，不自动提权。
- EXPLAIN PLAN只生成ASCII标签的30/31字节边界；非ASCII编码差异保持needs_profile。
- COMMENT基础对象不代表全部对象；其它对象类型按矩阵逐项保留。
- 负向候选保持Oracle needs_verification，不编造正文没给的SQLSTATE，不以任意错误判通过。

## 重跑

```bash
python3 scripts/prepare_batch_03.py \
  --batch-root work/doc2spec/batches/batch_05 --plan tests/data/batch_05.json
python3 scripts/manage_extraction_queue.py \
  --state work/doc2spec/batches/batch_05/queue.json summary
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 -m unittest discover -s tests -p test_batch_05_packages.py -v
python3 -m unittest discover -s tests
```

拆章使用已有 `scripts/extract_pdf_sections.py`，精确选择计划中的主章、提供者与补充章节。
选择集合变化时须复核后显式使用 `--replace-catalog`；不要用全书inventory改变本批分母。

最终候选、测试与队列证据见 [第五批结果](BATCH_05_EXTRACTION_PROGRESS.md)。
