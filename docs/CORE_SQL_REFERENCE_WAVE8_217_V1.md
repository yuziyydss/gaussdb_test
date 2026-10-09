# SQL Reference Wave 8-217 Extraction V1

## 目标

抽取 GUC黑匣子/安全配置/全局临时表/HyperLogLog/UDF/定时任务/线程池/全文检索/备份恢复/Undo：`7.3.29 黑匣子相关参数` + `7.3.30 安全配置` + `7.3.31 全局临时表` + `7.3.32 HyperLogLog` + `7.3.33 用户自定义函数` + `7.3.34 定时任务` + `7.3.35 线程池` + `7.3.36 全文检索` + `7.3.37 备份恢复` + `7.3.38 Undo`（页 4738–4770）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 10（完整节合并） |
| 物理页 | 32 |
| 结构化 facts | 9 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 黑匣子（7.3.29）：blackbox_number（0~10/$GAUSSLOG/gs_blackbox）/blackbox_directory（tmpfs类型/dev/shm）/gs_perf_retention_days（火焰图保留3天）
- 安全配置（7.3.30）：enable_security_policy（统一审计+动态数据脱敏）/unified_audit_location（rsyslog vs 传统审计文件）/use_elastic_search+elastic_search_ip_addr（ES日志发送https://ip:port:username 9200-9299/初始用户elastic）/enable_tde+tde_key_info（透明加密）/tde_index_default_encrypt/tde_encrypt_config（log_encrypt/log_algorithm/table_algorithm）/block_encryption_mode（aes-128-cbc等15种模式）/enable_tde_async_encryption/tde_async_dek/tde_dkcache_remain_time（DEK缓存1h）/enable_fips（md5/sm3无法登录/password_encryption_type 0/1/3失效强制sha256/OpenSSL需同时FIPS）/enable_thread_permission_down（gs_role_signal_backend权限）/allow_initialuser_exec_others_udf/allow_sysadmin_exec_others_udf/enable_rls_match_index（RLS+unleakproof索引扫描/lossy性能影响）/restrict_nonsystem_relation_kind（view/foreign-table禁用/gs_dump自动设置）
- 全局临时表（7.3.31）：max_active_global_temporary_table（0关闭/>0打开）/vacuum_gtt_defer_check_age/enable_gtt_concurrent_truncate
- HyperLogLog（7.3.32）：hll_default_log2m（10~16误差范围）/hll_default_log2sparse/hll_duplicate_check
- UDF（7.3.33）：udf_memory_limit（不生效）/FencedUDFMemoryLimit/UDFWorkerMemHardLimit/enable_cfunction/enable_default_cfunc_libpath（$libdir/proc_srclib）
- 定时任务（7.3.34）：job_queue_processes（0~1000建议100/超并发延期下轮询）/enable_prevent_job_task_startup
- 线程池（7.3.35）：enable_thread_pool（多租需开启）/enable_connect_thread_pool/thread_pool_attr（thread_num/group_num/cpubind_info/enable_group_reuse/超max_connections时proc不足）/connect_thread_pool_attr（auto/超配500/2秒过载强制关闭超时）/thread_pool_stream_attr（stream_thread_num=CPU*(3~5)/stream_proc_ratio 0.2/max=thread_pool_attr为准）/max_stream_threads/thread_pool_idle_time/resilience_threadpool_reject_cond
- 全文检索（7.3.36）：ngram_gram_size/ngram_grapsymbol_ignore/ngram_punctuation_ignore/default_text_search_config/tsearch_options/operation_mode
- 备份恢复（7.3.37）：enable_cbm_tracking/max_size_for_xlog_retention/max_cbm_retention_time/hadr_max_size_for_xlog_receiver
- Undo（7.3.38）：enable_default_ustore_table等参数已在其他波次覆盖
- DCF参数：dcf_ssl/dcf_config/data_path/log_path/dcf_node_id/max_workers/truncate_threshold/election_timeout（时钟差异约束）/enable_auto_election_priority/election_switch_threshold/dcf_mode（0自动/1手动/2去使能仅少数派恢复）/dcf_log_level（9种级别竖线组合/NONE不能混用）/dcf_log_backup_file_count/dcf_max_log_file_size/dcf_socket_timeout
