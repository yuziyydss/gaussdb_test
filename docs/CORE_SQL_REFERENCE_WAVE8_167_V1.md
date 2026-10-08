# SQL Reference Wave 8-167 Extraction V1

## 目标

抽取 高级包第二十批切片：`3.12.2.20 DBE_STATS` 第五切片——DELETE 族与 SQLID 族（页 2952–2971），DBE_STATS 收官。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（3.12 切片 2952–2971） |
| 物理页 | 20 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- DELETE四接口全原型：COLUMN（表达式删除、二级分区级联、多列别名）/INDEX（置零语义）/TABLE（cascade_parts/columns/indexes三维联）/SCHEMA；force锁定删除
- GET_TABLES_BY_SQLID（四个unique_sqlid来源：pg_stat_activity/dbe_perf.statement/statement_history/存储过程parent_unique_sql_id关联）与四组示例基线
- ANALYZE_SQLID（实际收集统计信息、all_complete选项、tabname仅含成功收集表）与analyze_count 1→4递增基线
- dbe_stats_tools.py（dump/restore参数表、gs_stats.meta+gs_stats.csv、dump complete!/restore complete!基线）

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_167_oq_runtime` | ANALYZE_SQLID的all_complete选项在部分表收集失败时的返回行为、DELETE_TABLE_STATS置零与真空统计恢复的交互、dbe_stats_tools.py跨版本meta兼容性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_167_v1.yaml
generated/core_sql_reference_wave8_167_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_167.py
python scripts/build_core_sql_reference_wave8_167.py --check
python -m unittest tests.test_core_sql_reference_wave8_167 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不删除统计信息。
