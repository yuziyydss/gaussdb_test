# SQL Reference Wave 8-216 Extraction V1

## 目标

抽取 GUC升级参数/其它选项/等待事件/Query/系统性能快照：`7.3.24 升级参数` + `7.3.25 其它选项` + `7.3.26 等待事件` + `7.3.27 Query` + `7.3.28 系统性能快照`（页 4696–4742）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5（完整节合并） |
| 物理页 | 46 |
| 结构化 facts | 14 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 升级参数（7.3.24）：IsInplaceUpgrade/inplace_upgrade_next_system_object_oids/om_operation_mode/upgrade_mode（0不在升级/1就地/2灰度）
- 其它选项（7.3.25）：enable_access_server_directory（DIRECTORY对象权限）/enable_default_ustore_table/enable_ustore/enable_segment_datafile_preallocate/consistency_check_module（INDEX模块校验）/reserve_space_for_nullable_atts/server_version等INTERNAL固定参数/basebackup_timeout/datanode_heartbeat_interval/dfs_partition_directory_length/max_concurrent_autonomous_transactions（实际最大值计算公式）/enable_seqscan_fusion/cluster_run_mode/max_resource_package/enable_gpi_auto_update/enable_gpi_fast_prune/enable_partition_autoextend_retry/enable_gsplsql_execopt/dynamic_procedure_cache_count/multi_insert_min_rows（批量插入约束/性能提升）/enable_force_smp/stream_queue_batch_size/enable_partrouting_optimization（常量分区键约束）/enable_unique_checking_of_unusable_index/enable_extension/bisheng_compiler_option/plsql_code_type/enable_cross_partition_dead_row_cache/enable_art_tid_cache/enable_verify_datafiles（inotify能力依赖）/vacuum_truncate/enable_tde/tde_key_info
