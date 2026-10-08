# SQL Reference Wave 8-101 Extraction V1

## 目标

抽取 1.13 章收官批：`SQL语法格式说明`、`DCL/DDL/DML/其他语法一览表` 与 `Online DDL及其操作`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.1` | 2 | SQL语法格式说明 |
| `1.13.2` | 2 | DCL语法一览表 |
| `1.13.3` | 15 | DDL语法一览表 |
| `1.13.4` | 3 | DML语法一览表 |
| `1.13.5` | 3 | 其他语法一览表 |
| `1.13.6` | 3 | Online DDL及其操作 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 23 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- 表1-317八种SQL语法格式约定（[]/.../|选一/[...]/[,...]组合）
- DCL定位与GRANT/REVOKE/ALTER DEFAULT PRIVILEGES/REASSIGN OWNED
- 角色/用户/运行参数三张SQL映射表（1-318/319/320）
- DDL一览表约35类对象分类映射（表1-321~1-363）
- 独立语句PURGE/CLUSTER/COMMENT/SELECT INTO/TIMECAPSULE TABLE/TRUNCATE/VACUUM
- CREATE/ALTER/DROP三段式模式、主节点不完整禁DDL说明
- DML全集（INSERT/INSERT ALL/UPDATE/MERGE INTO/SELECT/DELETE）
- 锁（LOCK/LOCK BUCKETS）、预备语句三件套、游标表1-367
- COPY/CALL/ALTER SYSTEM KILL SESSION/REPLACE/VALUES/LOAD DATA/EXPLAIN
- 事务相关SQL表1-369、用户标识符、数据库升级表1-370
- 即时变更类DDL五类操作与ONLINE关键字忽略规则
- 数据操作类DDL与在线DDL（ONLINE关键字、不支持rowid表、表1-372）

## Open questions

| ID | 内容 |
|---|---|
| `syntax_overview_wave8_101_oq_runtime` | Online DDL在并发长事务与数据量组合下的实际耗时、ONLINE索引并发创建与业务负载的相互影响、DDL一览表各语句与实际语法章节的一致性核对需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_101_v1.yaml
generated/core_sql_reference_wave8_101_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_101.py
python scripts/build_core_sql_reference_wave8_101.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_101.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行一览表所列语句。
