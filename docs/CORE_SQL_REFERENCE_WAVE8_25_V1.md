# SQL Reference Wave 8-25 Extraction V1

## 目标

抽取 `1.13.7.37 ALTER TABLE PARTITION`，补齐分区维护、分区交换、在线分区DDL、GLOBAL索引维护和分区自动扩展能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.37` | 17 | ALTER TABLE PARTITION |

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

- 分区维护action族、权限和ADD/DROP边界
- GLOBAL索引失效、`UPDATE GLOBAL INDEX`与自动更新参数
- 多分区维护子句的DROP→ADD→其它执行顺序
- MOVE、EXCHANGE、ROW MOVEMENT
- 分区交换结构一致性、校验、VERBOSE和Ustore索引类型边界
- MERGE、MODIFY LOCAL INDEXES、SPLIT
- RANGE/INTERVAL与LIST切割点、无切割点扩展
- ADD分区项、TRUNCATE/RENAME/RESET
- SET PARTITIONING自动扩展与SET INTERVAL互转
- ONLINE/OFFLINE、并行追增参数和失败残留

## Open questions

| ID | 内容 |
|---|---|
| `altp_wave8_25_oq_runtime` | ALTER TABLE PARTITION在真实分区规模、并发DML、GLOBAL索引、在线DDL、交换校验和自动扩展组合下的结果、锁等待、残留对象与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_25_v1.yaml
generated/core_sql_reference_wave8_25_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_25.py
python scripts/build_core_sql_reference_wave8_25.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_25.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER TABLE PARTITION或DDL。
