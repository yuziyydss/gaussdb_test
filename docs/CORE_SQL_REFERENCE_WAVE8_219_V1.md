# SQL Reference Wave 8-219 Extraction V1

## 目标

抽取 GUC闪回/AI特性/GlobalSysCache/HTAP/向量数据库/GaussStor等：`7.3.40 闪回相关参数` + `7.3.41 回滚相关参数` + `7.3.42 AI特性` + `7.3.43 Global SysCache` + `7.3.44 备机数据修复` + `7.3.45 分隔符` + `7.3.46 Global PLsql Cache` + `7.3.47 账本数据库` + `7.3.48 在线创建索引` + `7.3.49 在线DDL` + `7.3.50 ILM压缩` + `7.3.51 向量数据库` + `7.3.52-7.3.59`（页 4778–4838）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 20（完整节合并） |
| 物理页 | 60 |
| 结构化 facts | 11 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 闪回（7.3.40）：enable_recyclebin（BIN开头隐藏对象）/enable_db_recyclebin/recyclebin_retention_time/dbrecyclebin_retention_time/dbrecyclebin_maxsize/undo_retention_time（0不保留闪回点/设置公式time1+1.5*time2）
- 回滚（7.3.41）：max_undo_workers（异步回滚线程1~100默认5）
- AI特性（7.3.42）：enable_hypo_index/enable_ai_stats/multi_stats_type/ai_stats_cache_limit/enable_operator_prefer/enable_cachedplan_mgr（自适应计划选择）/max_stmt_aplan_num/recommend_session_aplan_memory/repick_plan_min_duration/enable_adaptive_cost/enable_feedback_cardest/adaptive_cardest_strategy/maximal_feedback_model_num/feedback_model_cache_limit/expired_time/adaptive_cost_min_time（建议慢查询时长20%）/cost_update_window_size/adaptive_costest_strategy/adaptive_costmodel_calibration_interval/adaptcost_extended_feature/enable_collect_abo_history/feedback_record_expired_time/autohint_model_cache_limit/autohint_max_task_num
- AI Watchdog（7.3.42）：enable_ai_watchdog/forcible_oom_detection/healing/max_cpu_usage/oom_dynamic_used_threshold/oom_growth_confidence/oom_malloc_failures/oom_other_used_memory_threshold（-1按规格20/40/60GB）/oom_process_threshold/oom_shared_threshold/rto_restriction_time/tolerance_times/tps_threshold/wait_time/warning_retention
- Global SysCache（7.3.43）：enable_global_syscache/global_syscache_threshold（=min(hot dbs,threads)*memofdb/底噪2M每表+11k）
- 备机数据修复（7.3.44）：standby_page_repair（CRC/未初始化/LSN三种/不支持VM/Xlog/clog/MOT）
- 分隔符（7.3.45）：delimiter_name
- Global PLsql Cache（7.3.46）：enable_global_plsqlcache/max_execute_functions/max_compile_packages（=(max_process_memory*2%)/4.4MB）/max_compile_functions
- 账本数据库（7.3.47）：enable_ledger/ledger_hist_level
- 在线DDL（7.3.48-49）：delete_cctmp_table/自增列SQLBYPASS/enable_online_ddl_waitlock（不生效）
- ILM压缩（7.3.50）：enable_ilm（需license）/ilm_instance_compress（turbo跨页透明压缩）/ilm_instance_compress_configuration/turbo_compress_shared_buffers/turbo_compress_default_configuration/turbo_compress_pattern_encoder
- 向量数据库（7.3.51）：diskann_hybrid_search_type/pre_filter_selectivity/pullup_selectivity/flat_upper_bound/neighbor_search_prune_factor
- HTAP（7.3.54）：enable_htap（IMCV列式内存引擎）/htap_max_mem_size/htap_memctl_policy等
- 多租（7.3.55）：enable_mtd/backend_resource_attr/pdb_transaction_read_only等
- NVMe（7.3.56）：nvme_cache_seg_num/local_storage_directory/nvme_cache_sub_heat_range/enable_nvme_cache_immediately_after_read/nvme_io_capacity/nvme_victim_strategy/nvme_cache_thread_num/enable_vldb_flow_control/adapt_period/max_iops_speed/nvme_cache_pagetype/enable_spdk_function/spdk_poller_thread_num/spdk_nvme_pcie_addr
- GaussStor/DR（7.3.57）：enable_dr_gaussstor_mode/dr_gaussstor_cms_url_list/config/parallel_write/gaussstor_auth_type/psk_path/hash_check/recycle_ttl（IO-WORM保护）/enable_ima/dr_gaussstor_client_info（IPv6方括号）
- SQL异常/预留（7.3.58-59）：autonomy系列/wait_dummy_time/enable_incremental_catchup/enable_expr_fusion/enable_roach_standby_cluster/max_logical_replication_workers
