# M 第二批：命名空间、对象管理与事务

本批基于本地 PDF 第二章重新抽取 18 章，不复用通用模式正文冒充 M 来源。使用现有 Factor Package V1 和递归 AST，没有新增 V1 文件类型或修改其公共字段。

## 本批范围

| 组 | 命令 | 本批有限生成范围 |
|---|---|---|
| 命名空间 | CREATE DATABASE、CREATE SCHEMA、DROP DATABASE、DROP SCHEMA、USE | DATABASE/SCHEMA 同义、存在性关键字、单/多 schema、模式切换 |
| 对象生命周期 | DROP TABLE、DROP VIEW、TRUNCATE、RENAME TABLE | 单/多对象、临时表匹配、有限 PURGE、TABLE/TABLES 别名 |
| 事务与保存点 | BEGIN、START TRANSACTION、COMMIT、ROLLBACK、SAVEPOINT、RELEASE SAVEPOINT、ROLLBACK TO SAVEPOINT | 工作关键字、隔离/读写模式、快照子句、真实事务/保存点 setup |
| 查询与元数据 | DESCRIBE、TABLE | 表/视图列说明、通配符、排序分页、同契约自集合运算 |

18 个包、21 个 manifest，生成 130 条 SQL；与首批合计 24 个 M 包、40 个 manifest、231 条 SQL。93 个 M 命令中，余下 69 个仍是正文初抽状态。**24 表示已有有限模型，并非 24 章完整覆盖。**

通用模式仍是 224 包，与 M 分开统计。全库 248 包、568 个 manifest、4152 条生成 SQL。数据库验证数不能从这些数字推导。

## 前置环境先补齐

见 [M 环境准备与执行边界](M_COMPAT_ENVIRONMENT.md)。静态生成已经关联“非 M 连接建物理 M 库 → 重连核验 → schema/USE 核验”。M 的真实执行仍被 Legacy Executor 明确阻止，等待专用运行时校准。

## 具体例子：ROLLBACK TO SAVEPOINT

fixture 创建独立表并插入已提交行 0，再在同一连接中：

```sql
BEGIN;
INSERT INTO m_rollback_to_savepoint_data VALUES (1);
SAVEPOINT m_rollback_to_savepoint_sp1;
INSERT INTO m_rollback_to_savepoint_data VALUES (2);
SAVEPOINT m_rollback_to_savepoint_sp2;
INSERT INTO m_rollback_to_savepoint_data VALUES (3);
```

生成维度：WORK 关键字 3 值 × SAVEPOINT 关键字 2 值 × 已存在保存点 2 值，有限全组合 12 个，Pairwise 选出 6 个。目标 SQL 例如：

```sql
ROLLBACK WORK TO SAVEPOINT m_rollback_to_savepoint_sp1;
```

生成阶段只检查语法结构、取值覆盖、前置保存点存在。planned 场景另声明回退后应剩行 0、1；它没有执行，不能算行为通过。teardown 先 ROLLBACK，再清理本 case 表，不假设 DDL 能随事务回滚。

## 本次保留的真实差异和缺口

- START TRANSACTION 的 WITH CONSISTENT SNAPSHOT 在不适用隔离级别下产生警告、被忽略，不改成错误用例，也不为了提高通过率删除。
- SERIALIZABLE 的文档行为是映射 REPEATABLE READ；保留该语法值，但不宣称实现真正可串行化隔离。
- DROP TABLE/VIEW 的 CASCADE/RESTRICT 在 s1+ 仅语法支持；本批正向只用无依赖对象。真正依赖删除行为留给版本化场景。
- TRUNCATE 主语法多余闭合括号、参数说明误写视图，均保留原文疑问；未渲染可疑括号和依赖选项。
- CREATE DATABASE/SCHEMA 的字符集、字符序说明互有矛盾，需跨章核对，未猜测生成值。
- TABLE 本批集合运算仅用同一已知两整数列表。异构集合输出列/类型合同、标量子查询上下文尚未接入。
- 字符集、分区/继承、权限负向、文件导出、锁并发等未建模分支继续显示 `unmapped`；原子性保留 `unreviewed`，场景保留 `planned`。
- 第二批尚无经实机校准的负向 Oracle；不捏造 SQLSTATE，也不以任意错误验收。

## 重建与核验（全部离线）

```bash
GAUSSDB_ENABLED=false python3 scripts/prepare_m_compat_environment.py
GAUSSDB_ENABLED=false python3 scripts/lint_factor_packages_v1.py
GAUSSDB_ENABLED=false python3 scripts/generate_factor_package_sql.py
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_pilot.py --batch 01
GAUSSDB_ENABLED=false python3 scripts/verify_m_compat_pilot.py --batch 02
GAUSSDB_ENABLED=false python3 -m unittest tests.test_m_compat_environment tests.test_m_compat_pilot tests.test_m_compat_batch_02 tests.test_core -v
```

审计证据：`generated/m_compat_batch_02/generation_report.json`；合并进度和通用 SQL 哈希对照：`generated/m_compat_batch_02/combined_progress.json`。组合复核独立枚举有限域，仍依赖抽取规则的正确性，不能证明数据库可执行或整章完整。

`build_m_compat_batch_02.py` 是本批经人工判断的规格构建器，只输出可审阅补丁，不是通用 BNF 转换器。变更须修改规格/构建器后重新生成，不能手改 SQL 快照。

下一批继续选择 15～20 个有可构造前置条件的 M 命令；复杂环境进入单独队列，不以全章精修阻塞简单章节，也不跳过明确生成契约。
