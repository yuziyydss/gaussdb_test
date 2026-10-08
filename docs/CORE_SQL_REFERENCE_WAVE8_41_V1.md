# SQL Reference Wave 8-41 Extraction V1

## 目标

抽取 `1.13.7.17 ALTER INDEX`，补齐索引重命名、表空间、存储参数、UNUSABLE/REBUILD、分区索引和可见性能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.17` | 7 | ALTER INDEX |

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

- ALTER INDEX主action族、权限和不可见索引DML风险
- rowid系统列索引限制
- RENAME TO、SET TABLESPACE、SET/RESET存储参数
- UNUSABLE、REBUILD、索引分区重命名和分区表空间
- VISIBLE/INVISIBLE状态
- IF EXISTS、名称与存储数据影响
- 表空间数据文件迁移
- ACTIVE_PAGES参数、REINDEX需求和Ustore LOCAL索引边界
- 唯一索引不可用时的GUC控制
- 并行重建限制与AUTO页面级回退
- GSIVALID/GSIUSABLE不支持、disable_keyword_options和备机读边界

## Open questions

| ID | 内容 |
|---|---|
| `altidx_wave8_41_oq_runtime` | ALTER INDEX在真实索引规模、分区索引、不可用/重建、可见性切换和备机读组合下的计划与性能矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_41_v1.yaml
generated/core_sql_reference_wave8_41_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_41.py
python scripts/build_core_sql_reference_wave8_41.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_41.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER INDEX或DDL。
