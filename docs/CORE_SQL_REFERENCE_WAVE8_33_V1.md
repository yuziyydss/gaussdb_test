# SQL Reference Wave 8-33 Extraction V1

## 目标

抽取 `1.13.9.49 CREATE TABLE AS`，补齐从查询结果建表、临时/UNLOGGED表、存储参数、ILM压缩和`WITH [NO] DATA`能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.49` | 7 | CREATE TABLE AS |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CTAS与视图语义差异
- 仅继承SELECT字段名/类型、不支持分区表
- UNLOGGED表数据丢失与备机不复制边界
- GLOBAL/LOCAL临时表、ON COMMIT和pg_temp Schema
- IF NOT EXISTS、字段名覆盖、ENGINE语法适配
- WITH存储参数、TDE参数、FILLFACTOR
- autovacuum参数、vacuum_truncate、hasrowid
- ILM ADVANCED/TURBO/NONE压缩
- TABLESPACE、SELECT/VALUES/EXECUTE query、WITH [NO] DATA
- M模式datetime隐式转换差异

## Open questions

| ID | 内容 |
|---|---|
| `ctas_wave8_33_oq_runtime` | CREATE TABLE AS在真实数据规模、临时表、TDE、ILM压缩、类型转换和WITH [NO] DATA组合下的建表结果与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_33_v1.yaml
generated/core_sql_reference_wave8_33_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_33.py
python scripts/build_core_sql_reference_wave8_33.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_33.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE TABLE AS或DDL。
