# SQL Reference Wave 8-206 Extraction V1

## 目标

抽取 GUC磁盘空间/内核资源/清理延迟/后端写线程/异步I/O：`7.3.4.2 磁盘空间` + `7.3.4.3 内核资源使用` + `7.3.4.4 基于开销的清理延迟` + `7.3.4.5 后端写线程` + `7.3.4.6 异步I/O`（页 4224–4237）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5（完整节合并） |
| 物理页 | 13 |
| 结构化 facts | 8 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 磁盘空间（7.3.4.2）：sql_use_spacelimit/temp_file_limit（SMP场景/CM接管/pgsql_tmp清理）
- 内核资源（7.3.4.3）：max_files_per_process/shared_preload_libraries
- 清理延迟（7.3.4.4）：vacuum_cost_delay/page_hit/page_miss/page_dirty/vacuum_cost_limit/vacuum_defer_cleanup_age
- 后端写线程（7.3.4.5）：bgwriter_delay/candidate_buf_percent_target/bgwriter_lru_maxpages/bgwriter_lru_multiplier/pagewriter_thread_num/dirty_page_percent_max/pagewriter_sleep/max_io_capacity/enable_consider_usecount/enable_buffer_evictor/eviction_clean_page_percent_min/eviction_candidate_list_size/pagewriter_flush_mode/dw_file_num/dw_file_size/postmaster_parallel_init_thread_num
- 异步I/O（7.3.4.6）：checkpoint_flush_after/bgwriter_flush_after/backend_flush_after/enable_adio_function/enable_adio_debug
