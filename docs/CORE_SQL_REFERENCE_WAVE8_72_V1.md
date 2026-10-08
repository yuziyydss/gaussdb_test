# SQL Reference Wave 8-72 Extraction V1

## 目标

抽取 T 段时间胶囊族：`TIMECAPSULE TABLE` 表闪回、`TRUNCATE` 清表与 `TIMECAPSULE DATABASE` 库闪回。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.20.1` | 4 | TIMECAPSULE TABLE |
| `1.13.20.2` | 4 | TRUNCATE |
| `1.13.20.3` | 4 | TIMECAPSULE DATABASE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- TIMECAPSULE TABLE用途、闪回旧版本（TO CSN/TIMESTAMP仅Ustore）与回收站闪回（支持Ustore/Astore）
- 不支持对象类型与自定义类型限制
- DDL/DCL/VACUUM FULL间隔失败边界
- Schema CREATE/USAGE/所有者、TRUNCATE权限矩阵
- 回收站关闭/维护态/升级观察期/多对象/回收站清理/写DQL限制等场景
- DROP/TRUNCATE闪回约束：系统名唯一、最近移动对象、子对象名、缺省值/视图不恢复、统计信息ANALYZE、RENAME TO限制、报错信息
- vacuum frozenXid推进与503.0升级限制
- TO TIMESTAMP约3秒精度、Restore point too old
- behavior oracle：TO CSN/TIMESTAMP闪回、TO BEFORE DROP恢复、PURGE
- TRUNCATE与DELETE对比、TRUNCATE/DELETE/DROP差异
- 权限（TRUNCATE ANY TABLE、三权分立）
- 语法：ONLY/CONTINUE IDENTITY/CASCADE/RESTRICT/PURGE/PARTITION FOR/UPDATE GLOBAL INDEX
- behavior oracle：8192→0 bytes、分区清空
- TIMECAPSULE DATABASE库级闪回、M兼容Schema排除
- enable_db_recyclebin等前提、不支持连接/DML等、Dstore/PDB排除、磁盘只读、事务块支持
- gs_db_recyclebin行为基线（系统名/原名/RENAME TO）

## Open questions

| ID | 内容 |
|---|---|
| `timecapsule_wave8_72_oq_runtime` | TIMECAPSULE TABLE/DATABASE闪回与TRUNCATE在真实回收站参数、存储引擎、升级观察期和并发路径下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_72_v1.yaml
generated/core_sql_reference_wave8_72_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_72.py
python scripts/build_core_sql_reference_wave8_72.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_72.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行闪回/清表语句。
