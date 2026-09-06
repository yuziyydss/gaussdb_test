# 第四批：20 个新章节，抽取与有限域生成已落盘

## 固定边界

继续使用本地 `gaussdb-rf-cent.pdf`：V2.0-10.0.0 集中式版参考，文档 01（2026-04-30）。
父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。
本批 catalog SHA-256：`e7713862640c2180683a4e7d3dac35e375cfd5b5d036dba8c9b38f718a184e69`。

- 新章节：20 个，2628 行正文。
- 既有提供者：23 个，10454 行正文，不计为新增成果。
- 补充来源：6 个，1903 行正文，只供引用，不自动产生抽取任务。
- 总输入：同一 catalog 下 49 章、14985 行。正文和任务信封只保存在本地 `work/`。
- 当前落盘：20/20 个新包，70 个 manifest、470 条有限域候选。高级能力与行为验证独立留账。
- 本轮只抽取、生成和静态验证，不连接数据库、不修改实例配置、不自动创建用户或表空间。

TRUNCATE 已属于现有包，本次作为提供者纳入，**没有再次计为新因子**。
本批复用 `prepare_batch_03.py` 已有的 `--plan/--batch-root` 参数，不复制一份同逻辑准备脚本，
不改变 Factor Package V1 模型或生成器接口。

## 新章节及处理分组

| 分组 | 新章节 | 范围与依赖 |
|---|---|---|
| 游标 | DECLARE、FETCH、MOVE、CLOSE | DECLARE 提供事务与游标；FETCH 提供方向事实，MOVE 引用；CLOSE 验证关闭与保持属性 |
| 会话设置 | SET、RESET、SHOW | 先有限 GUC 形态；RESET 依赖 SET 的事务恢复语义，完整参数章另行补充 |
| 事务约束 | LOCK、SET CONSTRAINTS | 普通表/约束对象、事务与权限；系统表和远程对象不进入默认执行范围 |
| 查询建表 | CREATE TABLE AS、SELECT INTO | SELECT 投影/类型、CREATE TABLE 能力；复杂 ILM 和通用递归域保留缺口 |
| 同义词 | CREATE SYNONYM、ALTER SYNONYM、DROP SYNONYM | CREATE 提供对象，再处理所有者变更和删除；PUBLIC、权限、远程对象需独立门禁 |
| 物化视图 | CREATE MATERIALIZED VIEW、REFRESH MATERIALIZED VIEW、DROP MATERIALIZED VIEW | 创建 → 基表变更 → 全量刷新/删除；不将增量物化视图混作同一种对象 |
| 维护与计划 | ANALYZE / ANALYSE、REINDEX、EXPLAIN | 普通对象优先；全数据库维护、并发重建、分区统计、高级 Hint 单独限制 |

章节编号、物理页、正文哈希与路径由 `work/doc2spec/batches/batch_04/source_index.json`
给出；选择和调度依赖固定在 `tests/data/batch_04.json`。

## 依赖证据的边界

1. 调度依赖用于先安排提供者，不代表已经消费了 Fact。
2. 主章、相关章和补充章都在同一 catalog，来源引用按章节哈希核对。
3. 包落盘后用 Registry 解析的限定 Fact/Fixture 引用构造真实 DAG。
4. 新包通过本包 Fixture 入口的 `requires_fixture_refs` 依赖上游，不能复制上游 setup。
5. 相关链接的反向引用不自动形成依赖边；例如 FETCH、MOVE、CLOSE 的互链不产生循环。

23 个既有提供者包括保存点链的真实上游 START TRANSACTION、BEGIN、ROLLBACK，以及
VALUES、CREATE SEQUENCE、DROP INDEX 等；不能只列直接前置名称却漏掉已使用的上游正文。

六个 source-only 章节：CURSOR、CREATE TABLE PARTITION、CREATE TABLESPACE、CREATE ROLE、
CREATE USER、CREATE INCREMENTAL MATERIALIZED VIEW。每一项的消费章节与理由保存在计划中。
它们的正文可用，不等于全部事实已经导出或所有传递引用均已闭合。

## 已知需要保留的问题

- DECLARE 与 BEGIN 都有匿名块产生式；本批只生成固定整数声明/打印样例，不冒充完整过程语言。
- FETCH ALL 的“最后一行”与前文“最后一行后面”措辞不同；FETCH/MOVE 的 direction 可选性
  在文本和铁路图中也有差别。按文本建立候选，同时保留待复核项。
- DECLARE 未声明 NO SCROLL 时，回扫能力取决于计划；不能自行添加未列出的 SCROLL 关键字。
- SET 的完整 GUC 值域、CTAS 的 ILM 白名单、ANALYZE 的 statistic_granularity 章尚未纳入。
- LOCK 和同义词的 DATABASE LINK 转引开发指南；EXPLAIN 高级 Hint 转引 SQL 调优指南。
  本地参考 PDF 不足以补齐这些外部正文。
- DROP SYNONYM 注意事项写的是 DROP ANY SEQUENCE；记录疑点，不凭记忆改成另一权限名称。
- 计划没有授权全库维护、DROP OWNED、实例 GUC 变更、远程访问或数据库执行。

## 重跑与继续

已经有本批冻结语料时：

```bash
python3 scripts/prepare_batch_03.py \
  --batch-root work/doc2spec/batches/batch_04 --plan tests/data/batch_04.json
python3 scripts/manage_extraction_queue.py \
  --state work/doc2spec/batches/batch_04/queue.json summary
python3 scripts/generate_factor_package_sql.py
python3 -m unittest tests.test_batch_04_cursor_packages -v
python3 -m unittest tests.test_batch_04_settings_packages -v
python3 -m unittest discover -s tests -p test_batch_04_remaining_packages.py -v
```

需要重新拆章时，使用第三批计划中的同一拆章命令模式，改为读取 `tests/data/batch_04.json`，
输出至 `work/doc2spec/batches/batch_04/corpus`；按 `new_chapters + existing_providers +
supplemental_sections` 精确选章。不要用通用 inventory 把六个补充章计入新因子分母。
catalog 选章集合改变时必须先复核再明确使用 `--replace-catalog`。

当前结果见 [第四批抽取与有限域生成结果](BATCH_04_EXTRACTION_PROGRESS.md)。
SELECT INTO 实际依赖 CREATE TABLE AS 的源表 Fixture/导出事实；DROP MATERIALIZED VIEW
还复用 REFRESH MATERIALIZED VIEW 的增量对象 Fixture。调度计划已补入这些真实依赖。
20 章落盘不等于全部语法值域或数据库行为全覆盖：复杂域保持 needs_profile/planned，
未将其假改成 unsupported，也没有执行 SQL 或实例级维护。
