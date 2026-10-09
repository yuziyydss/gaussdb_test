# SQL Reference Wave 8-212 Extraction V1

## 目标

抽取 GUC客户端连接缺省设置/锁管理：`7.3.15 客户端连接缺省设置`（语句行为/区域和格式化/其他缺省）+ `7.3.16 锁管理`（页 4466–4496）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 30 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 语句行为（7.3.15.1）：search_path（pg_temp第一优先级/pg_catalog第二优先级）/current_schema/default_tablespace/temp_tablespaces/default_transaction_isolation（当前版本暂不支持设置默认隔离级别/serializable等价repeatable read）/default_transaction_read_only/deferrable/session_replication_role/statement_timeout/vacuum_freeze_min_age/vacuum_freeze_table_age/bytea_output/xmlbinary/xmloption/max_compile_functions/gin_pending_list_limit
- 区域和格式化（7.3.15.2）：timezone_abbreviations/extra_float_digits/client_encoding/lc_messages/lc_monetary/lc_numeric/lc_time/lc_time_names/default_week_format
- 其他缺省（7.3.15.3）：dynamic_library_path（$libdir替换）/gin_fuzzy_search_limit/enable_astore_gin/enable_astore_gist/local_preload_libraries
- 锁管理（7.3.16）：deadlock_timeout/lockwait_timeout/update_lockwait_timeout/ddl_lockwait_timeout/max_locks_per_transaction/max_pred_locks_per_transaction/gs_clean_timeout/partition_lock_upgrade_timeout/fault_mon_timeout/enable_online_ddl_waitlock/xloginsert_locks（NUMA倍数）/num_internal_lock_partitions/enable_wait_exclusive_lock/barrier_lock_timeout/track_activity_history_query_number/enable_xid_abort_check
