# SQL Reference Wave 8-196 Extraction V1

## 目标

抽取 MySQL兼容M模式系统表和系统视图：`4.4.2.7.9 系统表和系统视图`（表4-169，页 3495–3498）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 3 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- information_schema.columns：generation_expression/data_type/column_type差异
- information_schema.tables：ENGINE/version/row_format/avg_row_length/max_data_length/data_free/check_time/create_time/update_time/table_collation差异
- information_schema.statistics：collation/packed/sub_part/comment差异
- information_schema.partitions：subpartition_name/subpartition_ordinal_position/partition_method/subpartition_method/partition_description/partition_expression/subpartition_expression/data_length等差异
- 整型类型回显：精度范围不支持/int→integer
- 不支持字段：columns_priv/tables_priv/procs_priv/proc/func
- 统计信息依赖：ANALYZE
- 索引列：表达式列不在statistics视图
