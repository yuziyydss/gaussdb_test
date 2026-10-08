# SQL Reference Wave 8-29 Extraction V1

## 目标

抽取 `1.13.9.53 CREATE TABLE SUBPARTITION`，补齐二级分区建模、两层分区策略、模板、自动扩展、ILM压缩和指定分区DML能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.53` | 17 | CREATE TABLE SUBPARTITION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 17 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 二级分区逻辑/物理结构与九类两层组合方案
- 一级/二级Range、List、Hash、KEY策略和键数限制
- UNIQUE/PRIMARY KEY的LOCAL/GLOBAL判定
- 自动二级分区、最大分区数和推荐规模
- 行存、hashbucket、cluster、密态/账本/RLS边界
- `PARTITION/SUBPARTITION FOR`常量与关键字拼写行为
- 主语法、LIKE、table_option、列/表约束
- WITH存储参数、TDE相关参数与ILM压缩
- INTERVAL、AUTOMATIC两层自动扩展
- PARTITIONS/SUBPARTITIONS、SUBPARTITION TEMPLATE
- ROW MOVEMENT与指定分区INSERT/SELECT/UPDATE/DELETE

## Open questions

| ID | 内容 |
|---|---|
| `subpart_wave8_29_oq_runtime` | 二级分区表在真实数据规模、两层自动扩展、模板、行迁移、ILM压缩和约束索引组合下的路由、错误与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_29_v1.yaml
generated/core_sql_reference_wave8_29_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_29.py
python scripts/build_core_sql_reference_wave8_29.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_29.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE TABLE SUBPARTITION或DDL。
