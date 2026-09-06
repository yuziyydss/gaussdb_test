# 第三批：20 个新章节与实际依赖正文

## 边界与当前进度

第三批 20 个新章节均已形成因子包与有限域 SQL 候选，不代表全部特性或数据库行为已完成。产品依据仍是本地
`gaussdb-rf-cent.pdf`（V2.0-10.0.0，文档 01），不沿用历史 226 包的统计。

- 新因子目标：20 个章节、2029 行正文。
- 已有因子提供者：14 个章节、9608 行正文；复用已有包，不计为新增成果。
- 补充来源：14 个章节、3224 行正文；只供查阅与溯源，不自动生成因子任务。
- 总输入：同一 catalog 下 48 章、14861 行。正文及队列保存在本地 `work/`，不公开发布。
- 已建立首个新包 `rollback`：14 个 source unit、58 行、6 个事实、3 个维度值、1 个 manifest、3 条 SQL。
- `rollback` 的来源信封、全库 lint、生成和静态覆盖门禁均通过，队列为 `static_complete`。
  三个行为场景仍是 `planned`，包保留 `needs_review`；没有运行数据库，不是数据库验收完成。
- 后续已新增 ABORT、START TRANSACTION、SAVEPOINT、RELEASE SAVEPOINT、ROLLBACK TO SAVEPOINT、
  SET TRANSACTION、DROP VIEW、DROP SEQUENCE、DROP INDEX：累计 10/20 个新包落盘。
  只有 ROLLBACK、ABORT 通过严格静态完成门禁；其余 8 包保留文档歧义或目标错误 Oracle 待验证。
  本段继续新增 CREATE/ALTER/DROP SCHEMA、VALUES、PREPARE、EXECUTE、DEALLOCATE，累计
  **17/20 个新包、400 条候选**。DEALLOCATE 也通过严格静态审计，所有包的行为仍未执行。
  最后新增 ALTER VIEW、ALTER SEQUENCE、ALTER INDEX，累计 **20/20 个新包、539 条候选**。
  三个 ALTER 的来源与有限域生成审计通过，完整静态覆盖仍待审核；没有执行数据库。
  详见 [阶段结果](BATCH_03_EXTRACTION_PROGRESS.md)。没有后台 AI worker。

## 固定输入

- 配置：`tests/data/batch_03.json`。
- 父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。
- Catalog SHA-256：`548598ffd1bc3b16d43b92474da19e21c43b5d66cfb934c30bd7b9eaf5afba4c`。
- Catalog：`work/doc2spec/batches/batch_03/corpus/catalog.json`。
- 带路径、章节哈希、行数和页码的完整索引：`work/doc2spec/batches/batch_03/source_index.json`。
- 任务队列：`work/doc2spec/batches/batch_03/queue.json`。
- 20 份任务信封：`work/doc2spec/batches/batch_03/tasks/`。

任务信封内嵌主章节全文，并列出直接依赖及补充正文的本地路径、行数与哈希。
所有主来源和补充来源都位于**同一 catalog**，可由 `supplemental_sources.catalog_chapter_ref`
校验。准备脚本从调度队列排除 14 个只提供正文的章节，不把它们误算成新因子。

## 新章节清单

| 章节 | 名称 | 物理页 | 行数 |
|---|---|---|---:|
| 1.13.7.1 | ABORT | 1193–1194 | 67 |
| 1.13.7.17 | ALTER INDEX | 1227–1233 | 322 |
| 1.13.7.29 | ALTER SCHEMA | 1259–1262 | 189 |
| 1.13.7.30 | ALTER SEQUENCE | 1262–1264 | 105 |
| 1.13.7.46 | ALTER VIEW | 1347–1352 | 260 |
| 1.13.9.43 | CREATE SCHEMA | 1520–1523 | 149 |
| 1.13.10.1 | DEALLOCATE | 1646–1647 | 70 |
| 1.13.10.20 | DROP INDEX | 1673–1674 | 83 |
| 1.13.10.36 | DROP SCHEMA | 1688–1689 | 54 |
| 1.13.10.38 | DROP SEQUENCE | 1689–1690 | 43 |
| 1.13.10.49 | DROP VIEW | 1703–1704 | 57 |
| 1.13.11.1 | EXECUTE | 1705–1706 | 54 |
| 1.13.17.2 | PREPARE | 1775–1776 | 37 |
| 1.13.18.6 | RELEASE SAVEPOINT | 1787–1788 | 75 |
| 1.13.18.11 | ROLLBACK | 1800–1801 | 58 |
| 1.13.18.13 | ROLLBACK TO SAVEPOINT | 1802–1803 | 70 |
| 1.13.19.1 | SAVEPOINT | 1803–1804 | 73 |
| 1.13.19.9 | SET TRANSACTION | 1860–1862 | 81 |
| 1.13.19.14 | START TRANSACTION | 1868–1870 | 95 |
| 1.13.22.2 | VALUES | 1893–1894 | 87 |

## 真实引用与抽取顺序

区分三种关系，禁止混用：

1. **正文引用**：相关链接、例子、类型说明，意味着需查阅正文；不自动成为依赖 DAG 的边。
2. **抽取计划依赖**：配置中的 `extraction_dependencies`，用于尚无包时安排提供者先处理。
3. **实际规格依赖**：包中经过加载器验证的限定 Fact 引用及跨包 Fixture 引用。这才进入真实依赖快照。

计划不冒充已经实现的依赖。包出现后，队列使用注册表中的实际依赖；计划仍独立保留，
审查时需逐项解释为何消费、仅作来源对照或未实现。禁止为满足计划而插入无关 Fact 引用。

| 语法组 | 主正文证据 | 处理方向 |
|---|---|---|
| 视图 | ALTER VIEW 区分属性修改与 CREATE OR REPLACE 查询修改；DROP VIEW 说明级联依赖 | CREATE VIEW/SELECT → ALTER、DROP；模式迁移另查 CREATE SCHEMA |
| 序列 | ALTER/DROP 必须匹配创建时的 LARGE；OWNED BY 限同一所有者与模式 | CREATE SEQUENCE/CREATE TABLE → ALTER、DROP；附 SEQUENCE 函数正文 |
| 索引 | DROP CONCURRENTLY 限单索引、非事务内、无 CASCADE；ALTER 分区和表空间有专门分支 | CREATE INDEX/CREATE TABLE → ALTER、DROP；分区表、表空间、REINDEX 为补充来源 |
| 模式 | CREATE SCHEMA 明确列举可嵌入子命令；ALTER/DROP 有权限与系统模式限制 | 先基础 CREATE SCHEMA，再 ALTER、DROP；角色、分区表、触发器子语法保留可追溯来源 |
| 预备语句 | PREPARE 明确支持六种 statement；EXECUTE 要求同会话先 PREPARE 且参数兼容 | VALUES 和已有 DML → PREPARE → EXECUTE、DEALLOCATE |
| 事务 | SAVEPOINT 必须在事务内；RELEASE/ROLLBACK TO 要有保存点 | BEGIN/START → SAVEPOINT → RELEASE、ROLLBACK TO；ROLLBACK → ABORT |
| 值表达式 | VALUES 要求跨行等列数、公共类型；DEFAULT 仅限 INSERT 顶层 | 读取 SELECT/INSERT 及公共类型推导；建立有限行列结构，不能只列几段完整 SQL |

PREPARE 与 DEALLOCATE、SAVEPOINT 与 RELEASE 在文档中互列链接，不能因此
制造调度环。事务组也不能因为 BEGIN/START/COMMIT/ROLLBACK 相互提及就形成循环。

14 个已有包：SELECT、CREATE TABLE、CREATE VIEW、CREATE INDEX、CREATE SEQUENCE、
BEGIN、COMMIT | END、GRANT、INSERT、UPDATE、DELETE、MERGE INTO、ALTER TABLE、DROP TABLE。

14 份补充正文：CREATE ROLE、CREATE USER、CREATE TABLE PARTITION、CREATE TABLESPACE、
CREATE TRIGGER、REINDEX、DECLARE、FETCH、CLOSE、SEQUENCE 函数、类型转换/操作符、
类型转换/函数、UNION/CASE 相关构造、模式级字符集和字符序。

## 仍未关闭的来源问题

这不是“整本 PDF 的传递依赖全部闭合”。本次核实了 20 个主章节的首层依赖，后续按实际使用继续补充：

- ALTER VIEW 指向另一本《开发指南》的失效重编译正文，本地尚无该文档。
- 字符集表 1-379 的精确定位以及 M-Compatibility 对应章节尚待核实。
- 部分 GUC 的完整参数章尚未加入；当前只能使用命令正文明确写出的门控条件。
- SET TRANSACTION 的语法块与示例在多个事务属性的组合写法上需要逐项比对，不能仅照抄例子扩语法。
- 补充来源只表示全文可用，不表示已逐条转化为导出 Fact、共享 Subgrammar 或可执行 Fixture。

上述问题不阻塞普通事务、普通对象生命周期等简单分支。受限分支进入 `needs_review`
或 planned scenario，不从统计中删除，也不擅自修改数据库配置、角色或系统对象。

## 重建和继续处理

首次重建全文时，在项目根目录运行以下命令；PDF Python 需要 `pypdf`，PATH 需要 `pdftotext`：

```bash
/path/to/pdf-python - <<'PY'
import json, subprocess, sys
from pathlib import Path
plan = json.loads(Path('tests/data/batch_03.json').read_text())
catalog = json.loads(Path(plan['source_catalog']).read_text())
lookup = {x['title']: x['section_number'] for x in catalog['outline']
          if x.get('content_route') == 'general_sql_statement'}
sections = [lookup[t] for t in plan['new_chapters'] + plan['existing_providers']]
sections += [x['section'] for x in plan['supplemental_sections']]
command = [sys.executable, 'scripts/extract_pdf_sections.py', '--pdf', 'gaussdb-rf-cent.pdf',
           '--output-root', 'work/doc2spec/batches/batch_03/corpus']
for section in sections:
    command += ['--section', section]
subprocess.run(command, check=True)
PY

python3 scripts/prepare_batch_03.py
python3 scripts/manage_extraction_queue.py \
  --state work/doc2spec/batches/batch_03/queue.json summary
```

已有 catalog 的章节范围改变时，抽取器会拒绝覆盖；复核后才在抽取命令中加
`--replace-catalog`。本批应使用 `prepare_batch_03.py` 合并队列，不能用普通 inventory
把 source-only 补充章误认领为待抽取因子。准备脚本不会清除已有审核状态或执行 SQL。

后续 AI 按拓扑顺序认领一个任务，读取 `tasks/<factor>.md` 的完整主原文与实际需要的
依赖正文，只修改该因子包；完成后使用原有 update/verify 流程。来源、原子性、值域、
负向 Oracle 或 Fixture 有缺口时照实记录，不通过删除选项、改预期或扩大忽略范围提高指标。

逐包证据：`work/doc2spec/batches/batch_03/verification/<factor>/`。
模式组、预备语句组及三个 ALTER 包均已落地。后续可选择下一批 20～30 章及实际依赖正文；
当前包的待审核项单独跟踪，不要求先跑完全部数据库行为场景。

## 本次配套修正

在真实补充章输入中复现了中文标题无法生成文件名的问题。抽取器现在对无英文 slug
且有合法章节编号的标题使用 `section_<编号>`；原有 SQL 章节文件名保持不变。
新增回归覆盖中文标题、同名章节不碰撞、计划环/悬空依赖、来源哈希漂移和 ROLLBACK
三个语法形态。未修改 V1 模型、生成接口或数据库执行策略。
