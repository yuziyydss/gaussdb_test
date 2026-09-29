# Core Statistics Functions Wave 4-1 Extraction V1

## 目标

开始细抽 `1.6.29 统计信息函数`，本轮覆盖首批：

```text
恢复冲突统计
cgroup与数据库统计重置
事务/函数级统计
锁与轻量级锁
WAL sender、Paxos/DCF与主备复制
数据库、表、索引I/O与Tuple统计
Vacuum / Analyze统计
total autovac tuple统计
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 812–821，共10页 |
| 结构化 facts | 33 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 33 / 33 |

## 覆盖内容

### 恢复冲突与基础环境

- `pg_stat_get_db_conflict_*`
- `pg_control_group_config`
- `pg_stat_get_db_stat_reset_time`

关键边界：

- 表空间、truncate、极致RTO强制回收、极致RTO超时等恢复冲突统计在多租场景下PDB内仅可查询本PDB信息。
- `pg_control_group_config`需要`SYSADMIN`权限，多租下禁用。
- `pg_stat_get_db_stat_reset_time`会在`pg_stat_reset`或单表/索引计数器重置后更新。

### 锁与事务/函数统计

- `pg_lock_status`
- `gs_lwlock_status`
- `pg_stat_get_xact_*`
- `pg_stat_get_function_total_time`

关键边界：

- `pg_lock_status`对所有用户可执行；PDB内返回本PDB，Non-PDB返回全局信息。
- `gs_lwlock_status`返回所有轻量级锁的等锁和持锁信息。
- 函数总时间包含函数内部调用其它函数的时间；self time不包含。

### 复制统计

- `pg_stat_get_wal_senders`
- `get_paxos_replication_info`
- `pg_stat_get_stream_replications`

关键边界：

- WAL sender在主机端查询，PDB内返回为空。
- Paxos/DCF输出包含写入、提交、本地落盘/flush/replay位置以及JSON格式DCF信息。
- DCF角色包括`LEADER`、`FOLLOWER`、`LOGGER`、`PASSIVE`和`UNKNOW`。
- `run_mode=0/1/2`分别表示自动选举、手动选举和关闭选举。

### 数据库、表与索引统计

- `pg_stat_get_db_*`
- `pg_stat_get_numscans`
- `pg_stat_get_role_name`
- `pg_stat_get_tuples_*`
- `pg_stat_get_live_tuples`
- `pg_stat_get_dead_tuples`
- `pg_stat_get_blocks_*`
- `pg_stat_get_xact_tuples_*`

关键边界：

- 多数数据库级统计在PDB内仅可查询本PDB信息。
- `pg_stat_get_role_name`仅`SYSADMIN`和`MONADMIN`可访问。
- `tuples_changed`统计上次analyze或autoanalyze后插入、更新、删除行总数。
- `pg_stat_get_dead_tuples`在Ustore表中仅代表不活跃行指针数量。

### Vacuum / Analyze / Autovacuum

- `pg_stat_get_last_vacuum_time`
- `pg_stat_get_last_autovacuum_time`
- `pg_stat_get_vacuum_count`
- `pg_stat_get_autovacuum_count`
- `pg_stat_get_last_analyze_time`
- `pg_stat_get_last_autoanalyze_time`
- `pg_stat_get_analyze_count`
- `pg_stat_get_autoanalyze_count`
- `pg_total_autovac_tuples`
- `pg_total_gsi_autovac_tuples`

关键边界：

- `last_vacuum_time`和`last_analyze_time`可包含用户手动或autovacuum线程触发；`last_autovacuum_time`和`last_autoanalyze_time`仅对应autovacuum守护线程。
- `pg_total_autovac_tuples`的`n_dead_tuples`在Ustore表中仅代表不活跃行指针数量。
- `pg_total_gsi_autovac_tuples`在集中式不支持。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_1_oq_conflict_replication_matrix` | 恢复冲突、WAL sender、Paxos/DCF和主备复制统计在不同主备状态、PDB/Non-PDB、DCF角色和复制模式下的输出矩阵 |
| `stats_wave4_1_oq_reset_vacuum_evidence` | 统计重置时间、vacuum/analyze计数、autovac tuple输出以及Ustore死行语义在真实维护负载和不同表类型下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_1_v1.yaml
generated/core_statistics_wave4_1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_1.py
python scripts/build_core_statistics_wave4_1.py --check
python -m pytest -q tests/test_core_statistics_wave4_1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不重置统计、不执行vacuum/analyze、不查询主备或DCF状态。
- 不宣称目标环境行为验证通过。
