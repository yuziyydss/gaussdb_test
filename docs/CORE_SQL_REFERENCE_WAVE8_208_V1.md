# SQL Reference Wave 8-208 Extraction V1

## 目标

抽取 GUC双机复制：`7.3.7 双机复制`（发送端服务器/主服务器/备服务器/逻辑复制，页 4272–4323）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 51 |
| 结构化 facts | 17 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 发送端（7.3.7.1）：max_wal_senders/wal_keep_segments/wal_sender_timeout/max_replication_slots/enable_slot_log/enable_wal_shipping_compression/repl_auth_mode（UUID验证）/repl_uuid/replconninfo1~18/cross_cluster_replconninfo1~8/available_zone/enable_availablezone/enable_time_report/thread_top_level/page_work_queue_size/parallel_build_thread_num/enable_parallel_build_compression/replay_delay/replay_mode/hadr_replconninfo_config_mode/hadr_source_info
- 主服务器（7.3.7.2）：synchronous_standby_names（ANY/FIRST同步备选择）/most_available_sync/keep_sync_window/enable_stream_replication/enable_mix_replication/enable_wal_replication_compression（lz4/zstd）/wal_replication_compression_thread_settings/wal_replication_compression_settings/data_replicate_buffer_size/walsender_max_send_size/wal_buffer_reserve_percent/ha_module_debug/catchup2normal_wait_time/check_sync_standby/sync_config_strategy/hadr_sync_mode
- 备服务器（7.3.7.3）：hot_standby（备机读限制/极致RTO备机读RC→RR）/max_standby_archive_delay/max_standby_streaming_delay/wal_receiver_status_interval/hot_standby_feedback/wal_receiver_timeout/connect_timeout/connect_retries/wal_receiver_buffer_size/primary_slotname/max_standby_base_page_size/max_standby_lsn_info_size/max_keep_csn_info_size/base_page_saved_interval/standby_force_recycle_ratio/standby_recycle_interval/standby_max_query_time/exrto_standby_read_opt/walrcv_writer_crc_check_level/enable_standby_bufferpool/standby_bufferpool_scale/wal_replication_ssl/enable_standby_walsync_optimization（ADIO/DIO）
- 逻辑复制（7.3.7.4）：max_changes_in_memory/max_cached_tuplebufs/logical_decode_options_default/logical_sender_timeout/enable_logicalrepl_xlog_prune/enable_logical_replication_ddl/enable_logical_replication_dictionary/disable_logical_repl_dict_cache/max_keep_log_seg/logical_replication_dictionary_retention_time/sqlapply系列（writeset_maxsize/preserve_commit_order/apply_worker_count/cache_memory_maxsize/replica_identity_force/logical_decode_options/autorun/guard_mode/logical_switch_time/dumptxn_when/sharestorage_delaytime）
