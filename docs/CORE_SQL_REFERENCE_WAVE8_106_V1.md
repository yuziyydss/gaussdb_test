# SQL Reference Wave 8-106 Extraction V1

## 目标

抽取 M 兼容 `ALTER TABLE PARTITION`、`ALTER TABLE SUBPARTITION`、`ALTER USER` 与 `ALTER VIEW`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 18 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- ALTER TABLE PARTITION八类维护操作（move/exchange/merge/split/add/drop/truncate/analyze/rename）
- 多子句DROP→ADD→其它执行顺序保证
- 1048575分区上限、哈希分区禁切割合并增删、pg_global禁用
- GLOBAL索引失效与UPDATE GLOBAL INDEX、enable_gpi_auto_update/m_format_dev_version=s4自动更新
- EXCHANGE交换条件五项与统计信息重收集、中间表交换方式、自增列不重置
- MERGE源分区上限300、范围连续递增、USTORE禁事务块
- SPLIT切割点/无切割点两种方式、partition_less_than_item 16键/start_end 1键
- 二级分区SUBPARTITION仅支持HASH/KEY且禁增删切割合并（含一级非HASH例外）
- ALTER USER密码四类三类字符规则、PGUSER不可改
- ALTER VIEW七种形式、CHECK OPTION CASCADED/LOCAL、COMPILE重编译（pg_object.valid基线）

## Open questions

| ID | 内容 |
|---|---|
| `m_alter3_wave8_106_oq_runtime` | 分区维护子句多子句DROP/ADD执行顺序在边界分区上的实际效果、EXCHANGE交换后统计信息与自增列行为、enable_gpi_auto_update自动更新GLOBAL索引的时延、视图失效重编译在依赖链上的行为需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_106_v1.yaml
generated/core_sql_reference_wave8_106_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_106.py
python scripts/build_core_sql_reference_wave8_106.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_106.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容分区/用户/视图语句。
