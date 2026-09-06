# 第六批：过程、规则、触发器、事务与维护命令

## 范围与依据

本批从本地冻结 PDF 的 general SQL 目录继续选取 20 个未建包章节。只做原文抽取、有限域 SQL 生成和静态验证，不连接数据库。
父 PDF SHA-256：`716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`。

实际完整 SHA 及书签边界以 `tests/data/batch_06.json` 指向的 catalog 为准。计划包括 6 个既有提供者的同版正文，不复制其他包的事实或 Fixture。

## 新章节

- CREATE PROCEDURE
- ALTER PROCEDURE
- DROP PROCEDURE
- CREATE RULE
- DROP RULE
- CREATE TRIGGER
- ALTER TRIGGER
- DROP TRIGGER
- PREPARE TRANSACTION
- COMMIT PREPARED
- ROLLBACK PREPARED
- SET ROLE
- SET SESSION AUTHORIZATION
- CHECKPOINT
- CLEAN CONNECTION
- CLUSTER
- VACUUM
- CREATE CAST
- DROP CAST
- CURSOR

## 依赖与处理边界

- CREATE PROCEDURE → ALTER/DROP PROCEDURE，通过已有过程 Fixture 建立真实依赖。
- CREATE TRIGGER → ALTER/DROP TRIGGER；函数与表先创建，触发器后创建，逆序清理。
- CREATE RULE → DROP RULE；CREATE CAST → DROP CAST。
- PREPARE TRANSACTION → COMMIT/ROLLBACK PREPARED，复用已导出的标识符与容量前置事实。
- CURSOR 复用 DECLARE 的源表 Fixture 和已导出约束；不复制源表数据。
- CREATE FUNCTION/TABLE/VIEW/INDEX、BEGIN 和 DECLARE 的正文纳入同批 catalog，具体消费关系以 Registry DAG 为准；计划依赖不等于全部已形成 Fact 边。

## 不允许的捷径

- 不创建或删除用户、角色、数据库、服务器目录，不修改 GUC，不执行连接终止或事务操作。
- 角色切换不填假密码；缺凭据注入契约的分支保留 planned，当前仅生成重置语句。
- 两阶段事务仅生成专用 gid 候选，保留失败路径状态清理缺口。普通 ROLLBACK 不能清理 prepared 事务。
- CAST 不先删系统既有转换来制造成功条件；样例在事务内创建包装函数，回滚恢复。
- VACUUM ONLINE 的 NOTICE 降级不能当作错误用例。每一种尚未覆盖的目标形态单独列入 feature 缺口。
- CLUSTER/VACUUM 不包在 BEGIN 中，也不默认生成无目标的全库维护。
- 不把“原文已处置”“有限域可生成”或 0/0 pair 说成全特性/行为覆盖。

## 验证命令

```bash
python3 scripts/prepare_batch_03.py --batch-root work/doc2spec/batches/batch_06 --plan tests/data/batch_06.json
python3 scripts/lint_factor_packages_v1.py specs
python3 scripts/generate_factor_package_sql.py
python3 -m unittest discover -s tests -p 'test_batch_06*.py'
python3 -m unittest discover -s tests -p test_zero_dimension_generation.py
python3 -m unittest discover -s tests
```

每个任务另由 `manage_extraction_queue.py verify` 保存任务信封、依赖快照与三道门禁结果。详细结果见 [本批进展](BATCH_06_EXTRACTION_PROGRESS.md)。
