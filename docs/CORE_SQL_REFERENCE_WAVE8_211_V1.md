# SQL Reference Wave 8-211 Extraction V1

## 目标

抽取 GUC告警上报/运行时统计/负载管理/自动清理：`7.3.11 告警上报` + `7.3.12 运行时统计` + `7.3.13 负载管理` + `7.3.14 自动清理`（页 4422–4466）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4（完整节合并） |
| 物理页 | 44 |
| 结构化 facts | 12 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CSV格式写日志（7.3.10.4）：字段含义表7-18（~25个字段）/COPY FROM导入gaussdb_log表/简化输入建议
- 告警上报（7.3.11）：enable_alarm（仅DN）/connection_alarm_rate/alarm_report_interval/alarm_component（gs_preinstall --alarm-type）/table_skewness_warning_threshold/rows
- 运行时统计（7.3.12）：track_activities（存储过程内perform可见/off影响空间回收）/track_counts/track_procedure_sql/track_io_timing/track_functions（pl/all/none）/track_activity_query_size/update_process_title（INTERNAL固定）/stats_temp_directory/track_thread_wait_status_interval/enable_save_datachanged_timestamp/enable_plan_trace/plan_collect_thresh/track_sql_count
- 负载管理（7.3.13）：use_workload_manager（资源管理总开关）/enable_control_group/enable_cgroup_switch/cgroup_name/enable_backend_control（DefaultBackend/HaBackend）/enable_vacuum_control/cpu_collect_timer/memory_tracking_mode/memory_detail_tracking/enable_resource_track/record/logical_io_statistics/user_metric_persistent/retention_time/instance_metric_persistent/retention_time/resource_track_level/cost/duration/disable_memory_protect/query_band/memory_fault_percent/enable_bbox_dump/count/path/blanklist_items（8种脱敏选项）/enable_ffic_log/io_limits/io_priority/io_control_unit/session_respool/session_statistics_memory/session_history_memory/topsql_retention_time/transaction_pending_time
- 自动清理（7.3.14）：autovacuum/autovacuum_mode/autoanalyze_timeout/autovacuum_io_limits/log_autovacuum_min_duration/autovacuum_max_workers（实际取值上限计算公式）/autovacuum_naptime/vacuum_threshold/analyze_threshold/vacuum_scale_factor/analyze_scale_factor/freeze_max_age/multixact_freeze_max_age/vacuum_cost_delay/limit/defer_csn_cleanup_time/clog_keep_xids/csnlog_keep_xids/multixact_keep_mxids
