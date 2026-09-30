# Core Statistics Functions Wave 4-3 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第三批：

```text
VACUUM进度
负载事务统计
实例/会话时间与内存
Unique SQL与等待事件
OS/线程统计
Paxos复制
WLM用户空间
全局算子与复杂查询统计
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 834–842，共9页 |
| 结构化 facts | 36 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 36 / 36 |

## 覆盖内容

### VACUUM进度

- `gs_stat_progress_vacuum`

关键边界：

- 仅统计Astore和Ustore页式表。
- 不支持hashbucket和段页式。
- `phase`覆盖启动、准备扫描、分区主表、堆表扫描、索引清理、堆表清理、分区缓存、收尾、截断空页、Ustore URQ和unknown。

### 负载、实例与会话统计

- `get_instr_workload_info`
- `pv_instance_time`
- `DBE_PERF.get_global_instance_time`
- `DBE_PERF.get_summary_workload_sql_count`
- `DBE_PERF.get_summary_workload_sql_elapse_time`
- `DBE_PERF.get_global_workload_transaction`
- `DBE_PERF.get_global_session_stat`
- `DBE_PERF.get_global_session_time`
- `DBE_PERF.get_global_session_memory`
- `DBE_PERF.get_global_session_memory_detail`

关键边界：

- `get_instr_workload_info`响应时间单位为微秒。
- 集中式分布式事务统计始终为0；只统计主事务，不统计子事务。
- `DBE_PERF`负载/会话/内存统计通常需要`MONADMIN`权限。
- 会话状态信息共14项，覆盖事务、SQL、扫描、块读写和排序等指标。

### Unique SQL与等待事件

- `get_instr_unique_sql`
- `reset_unique_sql`
- `get_instr_wait_event`
- `get_instr_user_login`
- `get_instr_rt_percentile`
- `get_node_stat_reset_time`

关键边界：

- `reset_unique_sql`需要sysadmin或monitor admin权限。
- 集中式下`GLOBAL`与`LOCAL`功能一致，且不支持`BY_CNID`。
- 节点统计重置时间覆盖重启、主备倒换和数据库删除。

### OS、线程与Paxos

- `DBE_PERF.get_global_os_runtime`
- `DBE_PERF.get_global_os_threads`
- `gs_paxos_stat_replication`

关键边界：

- OS runtime和线程统计需要`MONADMIN`权限。
- Paxos统计在主机端查询备机信息，输出本地/远端角色、DCF角色、读写/一致性/落盘/回放位置、同步百分比和信道信息。

### WLM与全局算子/复杂查询

- `gs_wlm_get_user_info`
- `gs_wlm_readjust_user_space`
- `gs_wlm_readjust_user_space_through_username`
- `gs_wlm_readjust_user_space_with_reset_flag`
- `gs_io_wait_status`
- `global_stat_get_hotkeys_info`
- `global_stat_clean_hotkeys`
- `DBE_PERF.get_global_session_stat_activity`
- `DBE_PERF.get_global_thread_wait_status`
- `DBE_PERF.get_global_operator_history_table`
- `DBE_PERF.get_global_operator_history`
- `DBE_PERF.get_global_operator_runtime`
- `DBE_PERF.get_global_statement_complex_history`
- `DBE_PERF.get_global_statement_complex_history_table`

关键边界：

- WLM用户空间修正函数在多租模式下禁用。
- 用户空间修正函数允许普通用户修正自己，管理员修正所有用户。
- I/O等待和热点key接口当前不支持单机和集中式，暂不可用。
- 算子历史/实时与复杂查询统计分别要求`MONADMIN`或`SYSADMIN + MONADMIN`权限。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_3_oq_vacuum_progress_matrix` | VACUUM进度在Astore、Ustore、分区表、全局索引、hashbucket和段页式对象上的阶段、detail输出与不支持边界 |
| `stats_wave4_3_oq_workload_paxos_wlm_matrix` | 负载/会话/Unique SQL/Paxos/WLM统计在不同节点角色、权限、PDB/Non-PDB、多租开关和真实负载下的输出矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_3_v1.yaml
generated/core_statistics_wave4_3_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_3.py
python scripts/build_core_statistics_wave4_3.py --check
python -m pytest -q tests/test_core_statistics_wave4_3.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不执行VACUUM、不清理Unique SQL、不调整用户空间、不查询Paxos状态。
- 不宣称目标环境行为验证通过。
