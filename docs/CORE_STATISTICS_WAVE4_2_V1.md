# Core Statistics Functions Wave 4-2 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第二批：

```text
autovac状态/超时
数据修改与监控指标更新时间
活动会话与后端统计
运行态计划
bgwriter/buffer统计
统计重置
UDF/CPU/内存与控制组
坏块、预备语句与黑匣子
plan trace与备机读延迟
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 821–834，共14页 |
| 结构化 facts | 45 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 45 / 45 |

## 覆盖内容

### Autovacuum与数据变更时间

- `pg_autovac_status`
- `pg_autovac_timeout`
- `pg_stat_get_last_data_changed_time`
- `pg_stat_set_last_data_changed_time`
- `pg_stat_get_last_updated`

关键边界：

- `pg_autovac_status`仅`SYSADMIN`可使用。
- `pg_autovac_timeout`在表信息非法或node信息异常时返回`NULL`。
- 表数量很大时，建议直接调用`pg_stat_get_last_data_changed_time`而不是视图。
- `pg_stat_get_last_updated`的第二参数仅支持`stat_table`、`stat_index`和`stat_io`。

### 活动会话与运行态计划

- `pg_backend_pid`
- `pg_stat_get_activity`
- `pg_stat_get_activity_with_conninfo`
- `gs_get_explain`
- `pg_stat_get_function_calls`
- `pg_stat_get_function_self_time`

关键边界：

- `pg_stat_get_activity`不包含`connection_info`；conninfo变体包含该JSON字段。
- 管理员可查看所有数据，普通用户只能查看自己的结果。
- `gs_get_explain`需要`track_activities=on`，且支持可EXPLAIN、计划不含STREAM算子的SQL。
- `plan_collect_thresh=-1/0/>0`分别对应不收集、条件触发10000起步收集和按阈值增量收集。

### 后端与bgwriter统计

- `pg_stat_get_backend_*`
- `pg_stat_get_bgwriter_*`
- `pg_stat_get_buf_written_backend`
- `pg_stat_get_buf_alloc`

关键边界：

- 后端活动、等待、事务开始等信息通常要求管理员或本会话用户，并打开`track_activities`。
- 无权限时客户端地址/端口返回`NULL`；Unix域套接字地址返回`NULL`、端口返回`-1`。
- bgwriter与buffer统计在PDB内返回默认值0；时间戳字段对应0s的时间戳。

### 统计重置与系统资源

- `pg_stat_clear_snapshot`
- `pg_stat_reset`
- `pg_stat_reset_shared`
- `pg_stat_reset_single_table_counters`
- `pg_stat_reset_single_function_counters`
- `fenced_udf_process`
- `total_cpu`
- `total_memory`

关键边界：

- 统计重置类操作需要系统管理员权限；`pg_stat_clear_snapshot`需要`SYSADMIN`或`MONADMIN`。
- `fenced_udf_process`入参`1/2/3`分别查看Master、查看Worker和终止所有Worker。
- `total_cpu`单位为jiffies，`total_memory`单位为KB。

### 控制组、坏块与预备语句

- `GS_ALL_NODEGROUP_CONTROL_GROUP_INFO`
- `pg_stat_bad_block`
- `pg_stat_bad_block_clear`
- `gs_respool_exception_info`
- `gs_control_group_info`
- `gs_prepared_statements`
- `gs_all_control_group_info`
- `gs_get_control_group_info`
- `gs_get_session_sql_memory`

关键边界：

- 坏块清理需要系统管理员权限；PDB内调用报错。
- `gs_control_group_info`需要`SYSADMIN`权限。
- `gs_prepared_statements`需要`SYSADMIN`权限；PDB内仅返回本PDB信息。

### 黑匣子与plan trace

- `gs_blackbox_dump`
- `gs_blackbox_show`
- `gs_blackbox_list`
- `gs_plan_trace_delete`
- `gs_plan_trace_watch_sqlid`
- `gs_plan_trace_show_sqlids`
- `gs_standby_read_delay`

关键边界：

- 黑匣子文件默认在`$GAUSSLOG/gs_blackbox/{nodename}`。
- `gs_blackbox_show`指定文件时仅支持名称，不支持路径。
- plan trace侦听队列是长度128的循环数组；频繁调用可能覆盖未生成trace的ID。
- `gs_standby_read_delay`仅支持集中式。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_2_oq_activity_backend_matrix` | 活动会话、conninfo变体和backend统计在不同PID、权限、`track_activities`、连接方式和PDB/Non-PDB下的输出矩阵 |
| `stats_wave4_2_oq_reset_trace_blackbox_evidence` | 统计重置、plan trace循环数组覆盖、黑匣子导出/解析以及资源池控制组信息在真实负载、权限和故障场景下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_2_v1.yaml
generated/core_statistics_wave4_2_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_2.py
python scripts/build_core_statistics_wave4_2.py --check
python -m pytest -q tests/test_core_statistics_wave4_2.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不重置统计、不执行VACUUM、不终止UDF worker、不导出/解析黑匣子、不侦听plan trace。
- 不宣称目标环境行为验证通过。
