# SQL Reference Wave 8-30 Extraction V1

## 目标

抽取 `1.13.7.38 ALTER TABLE SUBPARTITION`，补齐二级分区维护、分区交换、GLOBAL索引维护、二级分区模板和自动扩展能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.38` | 11 | ALTER TABLE SUBPARTITION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 二级分区维护action族与权限
- ADD/DROP一级和二级分区边界
- GLOBAL索引失效、`UPDATE GLOBAL INDEX`与自动更新参数
- 多分区维护子句的DROP→ADD→其它执行顺序
- MOVE、EXCHANGE、ROW MOVEMENT
- 二级分区交换结构一致性与统计信息置换
- MERGE、MODIFY LOCAL INDEXES、SPLIT
- RANGE/LIST二级分区切割点与无切割点扩展
- TRUNCATE、ILM、SET PARTITIONING/SUBPARTITIONING、SET INTERVAL
- 二级分区模板、RENAME和RESET PARTITION

## Open questions

| ID | 内容 |
|---|---|
| `subaltp_wave8_30_oq_runtime` | ALTER TABLE SUBPARTITION在真实分区规模、并发DML、GLOBAL索引、交换校验、模板和自动扩展组合下的结果、锁等待、残留对象与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_30_v1.yaml
generated/core_sql_reference_wave8_30_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_30.py
python scripts/build_core_sql_reference_wave8_30.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_30.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER TABLE SUBPARTITION或DDL。
