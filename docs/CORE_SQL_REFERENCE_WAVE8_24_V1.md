# SQL Reference Wave 8-24 Extraction V1

## 目标

抽取 `1.13.9.50 CREATE TABLE PARTITION`，补齐范围/间隔/哈希/列表分区建模、分区数量与键类型限制、LIKE继承、存储参数、ILM压缩和行迁移能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.50` | 19 | CREATE TABLE PARTITION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 19 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 分区表逻辑/物理结构与四种行存分区方案
- RANGE、INTERVAL、HASH、LIST路由与错误语义
- UNIQUE/PRIMARY KEY的LOCAL/GLOBAL索引判定
- 哈希单列、间隔INSERT权限和PARTITION FOR常量约束
- 最大分区数、推荐分区数、XML和rowid/rowno限制
- 主语法、LIKE继承、table_option与列/表约束
- WITH存储参数、TDE、hasrowid和ILM压缩策略
- VALUES LESS THAN、START/END/EVERY、AUTOMATIC、PARTITIONS
- ENABLE/DISABLE ROW MOVEMENT与跨分区并发行为

## Open questions

| ID | 内容 |
|---|---|
| `partition_wave8_24_oq_runtime` | 分区表在真实数据规模、分区数量、自动扩展、行迁移、ILM压缩和约束索引组合下的路由、错误与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_24_v1.yaml
generated/core_sql_reference_wave8_24_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_24.py
python scripts/build_core_sql_reference_wave8_24.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_24.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE TABLE PARTITION或DDL。
