# Core System Management Wave 2B-11 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.17 其它函数（第二批：刷脏、buffer、回放、全局SQL、事务控制、COPY错误表）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 756–764，共9页 |
| 结构化 facts | 35 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 35 / 35 |

## 覆盖内容

### 刷脏、脏页队列与Buffer

- `local_pagewriter_accumulate_stat`
- `local_dirty_queue_advance_stat`
- `local_single_flush_dw_stat`
- `local_pagewriter_stat`
- `local_buffer_scale_state`
- `local_buffer_io_state`

关键边界：

- BufferPool扩缩容状态包括`none`、`start_extend`、`start_shrink`、`extending`、`shrinking`、`failed`和`finished`。
- `local_pagewriter_stat`、`local_redo_stat`、`local_recovery_status`在多租场景下PDB内返回空列表。

### 回放、WLM / cgroup与连接

- `local_redo_stat`
- `local_recovery_status`
- `gs_wlm_node_recover`
- `gs_cgroup_map_ng_conf`
- `gs_wlm_switch_cgroup`
- `comm_client_info`
- `pg_get_flush_lsn`
- `pg_get_sync_flush_lsn`

关键边界：

- `gs_wlm_node_recover`的`isForce`不为0时会从内存清理TopSQL统计信息。
- `pg_get_flush_lsn`返回当前节点flush位置，`pg_get_sync_flush_lsn`返回多数派flush位置。

### 全局SQL与事务控制

- `dbe_perf.get_global_full_sql_by_timestamp`
- `dbe_perf.get_global_slow_sql_by_timestamp`
- `statement_detail_decode`
- `pgxc_get_csn`
- `pg_control_system`
- `pg_control_checkpoint`
- `get_prepared_pending_xid`
- `pg_clean_region_info`
- `pg_get_replication_slot_name`
- `pg_get_running_xacts`
- `pg_get_variable_info`
- `pg_get_xidlimit`

关键边界：

- Full / Slow SQL和detail解析只在系统库中可查询结果。
- `start_timestamp >= end_timestamp`时，Full / Slow SQL时间范围查询报错。
- `pgxc_get_csn(tid, bucketid)`在当前集中式版本不支持hashbucket表，调用报错。
- 事务相关接口在PDB / Non-PDB下的可见范围不同。

### 关系压缩、路径、实时信息与事务用户统计

- `pg_relation_compression_ratio`
- `pg_relation_with_compression`
- `pg_stat_file_recursive`
- `pg_stat_get_activity_for_temptable`
- `pg_stat_get_activity_ng`
- `pg_stat_get_cgroup_info`
- `pg_stat_get_realtime_info_internal`
- `pg_test_err_contain_err`
- `get_global_user_transaction`
- `pg_collation_for`
- `pgxc_unlock_for_sp_database`
- `pgxc_lock_for_sp_database`

关键边界：

- 表压缩率默认返回`1.0`。
- `pg_stat_file_recursive`仅初始用户可用，PDB内禁用。
- `pg_stat_get_realtime_info_internal`当前不可用，返回`FailedToGetSessionInfo`。
- `pg_collation_for`的常量入参必须显式类型转换。
- sp database锁与解锁接口当前版本暂不可用。

### COPY错误与汇总表

- `copy_error_log_create`
- `pgxc_copy_error_func`
- `gs_copy_error_insert`
- `gs_copy_summary_func`

关键边界：

- `copy_error_log_create()`当前始终返回`true`，仅保留兼容行为。
- `gs_copy_error_insert`仅供COPY内部调用，禁止用户主动调用。
- `pgxc_copy_error_func`与`gs_copy_summary_func`的`need_union`控制是否同时查询old表并`union_all`。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b11_oq_buffer_recovery_matrix` | pagewriter、dirty queue、buffer扩缩容、redo/recovery在不同负载、主备、PDB/Non-PDB模式下的输出矩阵 |
| `wave2b11_oq_sql_copy_evidence` | global Full/Slow SQL、statement_detail_decode以及COPY错误/汇总表在不同权限、系统库/用户库和时间边界下的输出与错误矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b11_v1.yaml
generated/core_system_admin_wave2b11_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b11.py
python scripts/build_core_system_admin_wave2b11.py --check
python -m pytest -q tests/test_core_system_admin_wave2b11.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行刷脏、Buffer扩缩容、TopSQL清理、全局SQL查询、COPY错误表写入或事务控制函数。
- 不宣称目标环境行为验证通过。
