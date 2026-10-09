# SQL Reference Wave 8-205 Extraction V1

## 目标

抽取 GUC通信库参数/内存：`7.3.3.3 通信库参数` + `7.3.4.1 内存`（页 4197–4224）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 27 |
| 结构化 facts | 19 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 通信库：plat_compat_allow_public_key_retrieval/ldap_ca_file/tcp_keepalives_idle/interval/count/tcp_user_timeout/comm_proxy_attr（欧拉2.9 ARM单机）/umdk_enabled/umdk_port
- 内存：memorypool_enable/size/enable_memory_limit（逻辑内存管理/OOM）/enable_threads_memory_reserve（后台线程隔离/优先级预留内存）/max_process_memory（计算公式/集中式推荐值）/local_syscache_threshold（内存淘汰）/enable_memory_context_control/uncontrolled_memory_context（DEBUG版本）/huge_pages（on/try/off）/shared_buffers（集中式推荐值/内存约束公式）/enable_scale_cache/pin_buffer_group_cores（ARM 8+）/enable_shared_storage_aio/page_version_check（off/memory/persistence）/page_version_full_validation/page_missing_dirty_check/page_version_max_num/page_version_partitions/page_version_recycler_thread_num/enable_cached_context/verify_log_buffers/segment_buffers/bulk_read_ring_size/bulk_write_ring_size/standby_shared_buffers_fraction/temp_buffers/max_prepared_transactions/work_mem（计算公式/性能影响）/query_mem/query_max_mem/maintenance_work_mem（向量索引采样）/max_stack_depth（系统栈-640kB）/enable_early_free/memory_trace_level/memory_log_config/resilience_memory_reject_percent/resilience_escape_user_permissions/local_plsqlcache_threshold/start_with_max_mem
