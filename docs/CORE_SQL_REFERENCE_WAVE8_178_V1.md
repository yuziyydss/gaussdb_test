# SQL Reference Wave 8-178 Extraction V1

## 目标

抽取 M 兼容参考章：`第11章 Schema-M-Compatibility兼容模式`（Information Schema 32视图 + m_schema 5视图 + gs_前缀别名表，页 5618–5663）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整章） |
| 物理页 | 46 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- Schema继承：DBE_PLDEVELOPER/SYS Schema继承、DBE_PERF/PG_CATALOG部分视图gs_前缀别名（约80个别名视图映射表）
- Information Schema 32视图：character_sets/collations/collation_character_set_applicability、columns、global_status/session_status/global_variables/session_variables、tables、statistics、routines、partitions/triggers/views、四类权限视图（column/schema/table/user_privileges）、engines/events/files/key_column_usage/optimizer_trace/parameters/plugins/processlist/profiling/referential_constraints/schemata/table_constraints
- m_schema 5视图：tables_priv/columns_priv/procs_priv/proc/func全字段语义
- sql_mode ansi_quotes对查询的影响、只读访问模式、暂不显示字段清单

## Open questions

| ID | 内容 |
|---|---|
| `pkg2_wave8_178_oq_runtime` | Information Schema部分视图（events/profiling/optimizer_trace）在M-Compatibility模式下的启用时序、m_schema.proc/func视图暂不显示字段在后续版本的补充计划、gs_前缀别名视图与dbe_perf原视图的数据一致性需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_178_v1.yaml
generated/core_sql_reference_wave8_178_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_178.py
python scripts/build_core_sql_reference_wave8_178.py --check
python -m unittest tests.test_core_sql_reference_wave8_178 -v
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不查询系统视图。
