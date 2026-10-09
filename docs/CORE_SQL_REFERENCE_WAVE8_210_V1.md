# SQL Reference Wave 8-210 Extraction V1

## 目标

抽取 GUC SPM计划管理/错误报告和日志：`7.3.9 SPM计划管理` + `7.3.10 错误报告和日志`（记录位置/时间/内容/CSV格式，页 4398–4422）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 24 |
| 结构化 facts | 11 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- SPM计划管理（7.3.9）：spm_enable_plan_capture（off/auto/manual/store）/spm_enable_plan_selection/spm_plan_capture_filter（db:schema过滤）/spm_plan_global_cached_size/spm_plan_session_cached_size/spm_plan_capture_max_plannum/spm_plan_retention_days/spm_enable_baseline_cleanup/spm_enable_plan_history_logging/spm_plan_history_reserved_percentage/spm_enable_async_flush/spm_async_sub_mq_maxsize
- 日志位置（7.3.10.1）：log_destination（stderr/csvlog/syslog/eventlog）/logging_collector/log_directory/log_filename/log_file_mode/log_truncate_on_rotation/log_rotation_age/log_rotation_size/syslog_facility/syslog_ident/event_source
- 日志时间（7.3.10.2）：client_min_messages/log_min_messages/log_min_error_statement/log_min_duration_statement/backtrace_min_messages/消息严重程度分类（表7-16）
- 日志内容（7.3.10.3）：debug_print_parse/rewritten/plan/debug_pretty_print/log_checkpoints/log_connections/log_disconnections/log_duration/log_error_verbosity/log_hostname/log_lock_waits/log_statement/log_temp_files/log_timezone/log_line_prefix（表7-17转义字符~17种）/logging_module（~130个模块日志控制）
