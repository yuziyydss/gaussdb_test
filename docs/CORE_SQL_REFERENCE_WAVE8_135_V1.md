# SQL Reference Wave 8-135 Extraction V1

## 目标

抽取 M 兼容 `SELECT INTO` 与 `SHOW`（11 页）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 14 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- SELECT INTO：查询结果建表填充（数据不返回客户端）、全局/本地临时表两种模式、pg_temp schema须知、其他参数参见SELECT
- SHOW语法全集15种（参数/字符集/排序规则/列/建表语句/数据库/引擎/索引/进程/状态/变量/表/表状态）
- SHOW CHARACTER SET/COLLATION列信息（Charset/Id/Default/Compiled/Sortlen）
- SHOW [FULL] COLUMNS权限与10列字段（Field/Type/Collation/Null/Key PRI-UNI-MUL/Default/Extra/Privileges/Comment）
- SHOW CREATE DATABASE/TABLE/VIEW（s2结果集变化、精度开关）
- SHOW ENGINES/STATUS/VARIABLES（GLOBAL/SESSION缺省当前会话）
- SHOW PROCESSLIST（无SYSADMIN仅本用户线程、Info列100字符截断）
- SHOW TABLES/TABLE STATUS（information_schema pattern转小写、utf8mb4_bin排序）
- LIKE/WHERE筛选子句

## Open questions

| ID | 内容 |
|---|---|
| `m_si_show_wave8_135_oq_runtime` | M兼容SELECT INTO全局临时表在多会话并发下的隔离边界、SHOW TABLE STATUS字段与information_schema.tables的映射完整性、SHOW INDEX临时表Schema限定行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_135_v1.yaml
generated/core_sql_reference_wave8_135_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_135.py
python scripts/build_core_sql_reference_wave8_135.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_135.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容SELECT INTO/SHOW语句。
