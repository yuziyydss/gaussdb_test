# Core Statistics Functions Wave 4-4 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第四批：

```text
DBE_PERF全局/汇总统计
TOAST映射
索引、序列、系统表、用户表统计
数据库/事务/函数统计
文件I/O、锁、复制槽、并行解码
bgwriter与复制状态
运行/预备事务
语句、GUC、等待事件、登录与重置时间
备机FULL SQL
本地/全局关系I/O与线程池
临时文件、远程状态、用户资源和按需读队列
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 843–852，共10页 |
| 结构化 facts | 55 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 55 / 55 |

## 覆盖内容

### DBE_PERF全局/汇总统计

覆盖：

- `get_global_statement_complex_runtime`
- `get_global_memory_node_detail`
- `get_global_shared_memory_detail`
- `get_global_stat_*`
- `get_summary_stat_*`
- `get_global_statio_*`
- `get_summary_statio_*`
- TOAST映射与用户函数统计

关键边界：

- 大部分全局/汇总统计需要`MONADMIN`权限。
- 复杂查询实时信息需要`SYSADMIN`和`MONADMIN`权限。
- 系统表统计覆盖`pg_catalog`和`information_schema`模式。
- 用户表/索引统计覆盖用户自定义对象。

### 数据库、事务与语句

- 全局和汇总数据库统计、冲突统计
- 全部/系统/用户表的事务状态统计
- 用户函数及函数事务统计
- 运行事务与两阶段预备事务
- 历史语句、语句响应时间、登录登出、统计重置时间

关键边界：

- 多数语句和事务统计在Non-PDB返回全部信息，PDB仅返回本PDB信息。
- P80/P95查询在PDB中返回当前PDB信息。

### 文件I/O、锁与复制

- `get_global_stat_bad_block`
- `get_global_file_redo_iostat`
- `get_global_file_iostat`
- `get_global_locks`
- `get_global_replication_slots`
- `GET_GLOBAL_PARALLEL_DECODE_STATUS`
- `GET_GLOBAL_PARALLEL_DECODE_THREAD_INFO`
- `get_global_bgwriter_stat`
- `get_global_replication_stat`

关键边界：

- `get_global_file_iostat`的PDB结果未持久化，重启清零。
- 当前不支持PDB级日志同步，`get_global_replication_stat`在PDB内返回空列表。
- 并行解码函数返回值分别与对应DBE_PERF视图一致。

### 本地/全局运行状态

- `pg_stat_get_file_stat`
- `pg_stat_get_redo_stat`
- `pg_stat_get_status`
- `get_local_rel_iostat`
- `DBE_PERF.get_global_rel_iostat`
- `DBE_PERF.global_threadpool_status`
- `pg_catalog.gs_plancache_stat`
- `pv_os_run_info`
- `pv_session_stat`
- `pv_session_time`

关键边界：

- `get_local_rel_iostat`和`get_global_rel_iostat`的PDB结果持久化，重启不清零。
- 线程池状态在备节点PDB内查询返回空。
- `gs_plancache_stat`需要`MONITORADMIN`权限。

### 备机SQL、临时文件与按需读

- `DBE_PERF.standby_statement_history`
- `pg_stat_get_mem_mbytes_reserved`
- `pg_stat_get_db_temp_bytes`
- `pg_stat_get_db_temp_files`
- remote状态函数
- `DBE_PERF.gs_stat_activity_timeout`
- `gs_wlm_user_resource_info`
- `gs_stat_ondemand_waiting_queue`

关键边界：

- 备机Full/Slow SQL异步下盘，查询时间范围建议适当扩大。
- `time1 >= time2`时`standby_statement_history`报错。
- 临时文件统计不受`log_temp_files`设置影响。
- remote检查点、双写、恢复、回放状态函数集中式不支持。
- `gs_stat_activity_timeout`需要`track_activities=on`。
- `gs_stat_ondemand_waiting_queue`仅在按需读阶段支持，否则报错。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_4_oq_dbe_perf_permission_matrix` | DBE_PERF全局/汇总统计在权限、PDB/Non-PDB和不同负载下的输出、空列表与默认值矩阵 |
| `stats_wave4_4_oq_io_replication_evidence` | 文件I/O持久化差异、复制槽/并行解码、备机FULL SQL异步下盘和按需读队列在真实负载与故障场景下的行为 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_4_v1.yaml
generated/core_statistics_wave4_4_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_4.py
python scripts/build_core_statistics_wave4_4.py --check
python -m pytest -q tests/test_core_statistics_wave4_4.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不查询DBE_PERF视图、不清理复制槽、不执行并行解码、不导出备机SQL或修改用户资源。
- 不宣称目标环境行为验证通过。
