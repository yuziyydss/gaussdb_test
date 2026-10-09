# SQL Reference Wave 8-207 Extraction V1

## 目标

抽取 GUC异步I/O续/数据导入导出/预写式日志：`7.3.4.6 异步I/O（续）` + `7.3.5 数据导入导出` + `7.3.6 预写式日志`（设置/检查点/日志回放/归档，页 4237–4272）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3（完整节合并） |
| 物理页 | 35 |
| 结构化 facts | 19 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 异步I/O（续）：prefetch_quantity/backwrite_quantity/effective_io_concurrency
- 数据导入导出（7.3.5）：raise_errors_if_no_files/safe_data_path白名单/enable_copy_server_files/enable_copy_when_filler/a_format_load_with_constraints_violation（约束冲突跳过）/support_binary_copy_version/copy_special_character_version（编码容错/per_byte）/enable_log_copy_illegal_chars/batch_insert_index_types（rcr_ubtree批量插入索引）/a_format_enable_copy_empty_lobs（空串BLOB CLOB）/enable_copy_case_sensitive（列名大小写）
- 预写式日志设置（7.3.6.1）：wal_level（minimal/archive/hot_standby/logical）/fsync/wal_sync_method/synchronous_commit（on/off/local/remote_write/remote_receive/remote_apply CM接管）/full_page_writes/wal_log_hints/wal_buffers/wal_writer_delay/commit_delay/commit_siblings/wal_block_size/wal_segment_size/walwriter_cpu_bind等绑核/walwriter_sleep_threshold/wal_file_init_num/wal_file_preinit_bounds/xlog_file_path/size/lock_file_path/max_size_for_shared_storage_xlog_write/shared_storage_write_mode/enable_shared_storage_optimization/force_promote/wal_flush_timeout
- 检查点（7.3.6.2）：checkpoint_segments/timeout/completion_target/warning/wait_timeout/enable_incremental_checkpoint/enable_double_write/incremental_checkpoint_timeout/enable_xlog_prune/max_size_for_xlog_prune/max_redo_log_size/checkpoint_lag_alarm_threshold
- 日志回放（7.3.6.3）：recovery_time_target/recovery_max_workers/recovery_parallelism/queue_item_size/recovery_parse_workers/recovery_redo_workers（极致RTO RC→RR）/enable_ondemand_rto/ondemand_waiting_queue_mem_size/ondemand_always_redo/enable_page_lsn_check/promote_lsn_check/recovery_min_apply_delay/dcf_truncate_dump_info_level/redo_bind_cpu_attr/enable_wal_page_header_crc
- 归档（7.3.6.4）：archive_interval
