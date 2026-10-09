# SQL Reference Wave 8-214 Extraction V1

## 目标

抽取 GUC双数据库实例复制参数/开发人员选项：`7.3.21 双数据库实例复制参数` + `7.3.22 开发人员选项`（页 4659–4679）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 20 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 双数据库实例复制（7.3.21）：RepOriginId（双向逻辑复制防循环）/auto_csn_barrier（流式容灾barrier打点）/stream_cluster_run_mode（主备实例标识）/hadr_process_type（failover/switchover/dorado系列流程标识）/cluster_name/hadr_primary_cluster_name/hadr_standby_cluster_num/switchover_abort_timeout
- 开发人员选项（7.3.22）：allow_system_table_mods（系统表修改）/allow_create_sysobject（系统模式oid<16384对象创建）/debug_assertions（USE_ASSERT_CHECKING编译宏）/ignore_checksum_failure/ignore_system_indexes/ignore_invalid_pages（PANIC→WARNING快速恢复）/post_auth_delay/pre_auth_delay（调试器附加）/trace_notify/trace_recovery_messages/trace_sort/zero_damaged_pages/string_hash_compatible（char vs varchar/text hash差异/不可修改）/remotetype/max_user_defined_exception（固定1000）/enable_fast_numeric/enable_numeric_optimization/enable_fast_vecop/enable_compress_spill/resource_track_log/support_batch_bind/batch_error_mode_sp_name/numa_distribute_mode（ARM多NUMA节点）/log_pagewriter/advance_xlog_file_num（预扩Xlog占用公式）/enable_beta_opfusion/enable_stream_noblock_memcopy/pldebugger_timeout/plsql_show_all_error/ustore_attr（verify_level/module/index_trace_level/sync_async_rollback）/index_txntype（PCR/RCR）/enable_auto_segment_remain_cleanup/convert_illegal_char_mode（占位符A模式差异）/default_segment
