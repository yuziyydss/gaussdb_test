# 第二批 PDF Doc2Spec 抽取计划

本批用于验证冻结后的 Factor Package V1 能否跨语句类型复用。它不是首批五章的继续精修，也不要求数据库行为覆盖达到 100%。

最终静态验收、缺口与扩批结论见 [第二批 PDF Doc2Spec 验收结果](BATCH_02_RESULT.md)。

## 1. 固定输入

- 父 PDF：`gaussdb-rf-cent.pdf`
- 产品版本：`V2.0-10.0.0`
- 文档版本：`01`
- 父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`
- 批次目录：`work/doc2spec/batches/batch_02/`
- 本批 catalog SHA-256：`cbea45ca5a96938432c0562d3a15c58cefee430f0ddfece1bb682820e31f9fad`

第二批使用独立 catalog 和 queue，不覆盖首批五章的 `intranet_corpus/catalog.json` 或 `work/doc2spec/queue.json`。

## 2. 章节选择

| 章节 | 标题 | 类别 | 物理页 | 文本行数 | 选择目的 |
|---|---|---|---:|---:|---|
| 1.13.8.1 | BEGIN | TCL | 1362–1363 | 93 | 事务起点与有限语法选项 |
| 1.13.9.7 | COMMIT \| END | TCL | 1374–1375 | 66 | 同义顶层产生式与事务终点 |
| 1.13.9.45 | CREATE SEQUENCE | DDL | 1524–1528 | 199 | 中小型对象创建及数值边界 |
| 1.13.9.48 | CREATE TABLE | DDL | 1532–1558 | 1351 | 大型、多分支、嵌套复杂语法 |
| 1.13.10.3 | DELETE | DML | 1650–1657 | 421 | 普通 DML、WITH、目标与条件子句 |
| 1.13.10.41 | DROP TABLE | DDL | 1692–1693 | 64 | 简单 DDL 与对象生命周期 |
| 1.13.13.2 | GRANT | DCL | 1721–1733 | 636 | 权限对象矩阵、角色与环境前置条件 |
| 1.13.16.2 | MERGE INTO | DML | 1769–1772 | 154 | 多分支 action 和源/目标列契约 |
| 1.13.20.2 | TRUNCATE | DDL | 1874–1877 | 156 | 多对象、依赖范围与事务行为 |
| 1.13.21.1 | UPDATE | DML | 1880–1887 | 432 | 普通 DML、WITH/FROM/RETURNING 组合 |

合计 10 章、3572 行；类别分布为 DDL 4、DML 3、DCL 1、TCL 2。BEGIN 与 COMMIT/END 同时入选，用于覆盖事务两端；不再加入语义高度重叠的 START TRANSACTION。

## 3. 可重复命令

```bash
/Users/wangyangbo/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 \
  scripts/extract_pdf_sections.py \
  --pdf gaussdb-rf-cent.pdf \
  --output-root work/doc2spec/batches/batch_02/corpus \
  --section 1.13.8.1 \
  --section 1.13.9.7 \
  --section 1.13.9.45 \
  --section 1.13.9.48 \
  --section 1.13.10.3 \
  --section 1.13.10.41 \
  --section 1.13.13.2 \
  --section 1.13.16.2 \
  --section 1.13.20.2 \
  --section 1.13.21.1

python3 scripts/manage_extraction_queue.py \
  --state work/doc2spec/batches/batch_02/queue.json \
  inventory \
  --corpus-dir work/doc2spec/batches/batch_02/corpus \
  --source-catalog work/doc2spec/batches/batch_02/corpus/catalog.json
```

运行时状态以此命令为准：

```bash
python3 scripts/manage_extraction_queue.py \
  --state work/doc2spec/batches/batch_02/queue.json \
  summary
```

## 4. Worker 边界

- 每个 worker 只修改任务信封指定的 `OUTPUT_DIR`。
- PDF 章节是唯一产品事实；legacy 规格只能做差异提示。
- 不允许 worker 修改 `core/`、Schema、公共生成接口或其他因子包。
- 无法由冻结 V1 可靠表达的事实登记为 model gap，任务进入 `needs_review`；来源或信封不一致则进入 `blocked`。
- `needs_review`/`blocked` 不阻塞其他章节继续完成。

## 5. 批次验收

第二批结束时必须输出：

1. 10 个来源信封的哈希、路径、页界和行数对账结果；
2. `static_complete`、`needs_review`、`blocked` 和失败任务数量；
3. 首轮静态门禁通过率、重试率和各失败根因聚类；
4. 各包 source atomicity gap、feature gap、open question、planned scenario 和生成 case 数；
5. 全局 case ID/SQL 重复与 Pairwise 缺失检查；
6. 人工抽检样本及发现的问题。

扩大到下一批 20～30 章的条件，不是本批 10 章全部 `static_complete`，而是：简单章节不存在系统性公共缺陷，复杂/高风险章节能被诚实隔离，所有失败都有明确状态和根因。若至少两个章节暴露同一公共模型缺口，先形成版本化变更提案，不由单个 worker直接修改 V1。
