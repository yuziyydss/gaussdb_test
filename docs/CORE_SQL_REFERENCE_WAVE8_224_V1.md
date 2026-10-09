# SQL Reference Wave 8-224 Extraction V1

## 目标

抽取 Schema：`10 Schema`（Information Schema/DBE_PERF/WDR Snapshot/DB4AI/DBE_PLDEBUGGER/DBE_PLDEVELOPER/DBE_COMPRESSION/DBE_HEAT_MAP/DBE_ILM/DBE_ILM_ADMIN/PRVT_ILM，页 5431–5617）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 186 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- Information Schema（10.1）：INFORMATION_SCHEMA._PG_FOREIGN_DATA_WRAPPER/_PG_FOREIGN_SERVERS/_PG_FOREIGN_TABLE_COLUM/_PG_FOREIGN_TABLES/_PG_USER_MAPPINGS/INFORMATION_SCHEMA_CATALOG_NAME/TRIGGERS等7个视图
- DBE_PERF Schema（10.2）：OS系列（OS_RUNTIME/GLOBAL_OS_RUNTIME/OS_THREADS/GLOBAL_OS_THREADS/NODE_NAME/PERF_QUERY/SHAKING_COLLECT_STATUS）+ Instance系列（INSTANCE_TIME/GLOBAL_INSTANCE_TIME）+ Memory系列（MEMORY_NODE_DETAIL/GLOBAL_MEMORY_NODE_DETAIL/SHARED_MEMORY_DETAIL/GLOBAL_SHARED_MEMORY_DETAIL）+ File/Xact/Query/Session/Transaction/Wait/Event/Utility/SQL/Workload/Resource系列
- WDR Snapshot Schema（10.3）：SNAPSHOT.TABLES_IN_DATABASE/STATEMENTS等WDR快照系统表
- DB4AI Schema（10.4）：DB4AI.SNAPSHOT/TRAINING_INFO/PREDICTION_FUNC等AI4DB相关
- DBE_PLDEBUGGER Schema（10.5）：21个调试函数（turn_on/turn_off/local_debug_server_info/attach/info_locals/next/continue/abort/print_var/info_code/step/add_breakpoint/delete_breakpoint/info_breakpoints/backtrace/enable_breakpoint/disable_breakpoint/finish/set_var/error_backtrace/error_end/error_info_locals）
- DBE_PLDEVELOPER（10.6）：GS_SOURCE（源码）/GS_ERRORS（编译错误）
- DBE_COMPRESSION Schema（10.7）/DBE_HEAT_MAP Schema（10.8）/DBE_ILM Schema（10.9）/DBE_ILM_ADMIN Schema（10.10）/PRVT_ILM Schema（10.11）
