# Core Statistics Functions Wave 4-10 Extraction V1

## 目标

细抽 `1.6.29 统计信息函数` 最后一批，完成该章静态抽取收尾：

```text
单字段分区统计
事务内单字段分区统计
ALT会话恢复状态
jeprof内存采集
jemalloc统计报告
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 897–900，共4页 |
| 结构化 facts | 21 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 21 / 21 |

## 覆盖内容

### 分区统计

- `gs_stat_get_partition_analyze_count`
- `gs_stat_get_partition_autoanalyze_count`
- `gs_stat_get_partition_autovacuum_count`
- `gs_stat_get_partition_last_analyze_time`
- `gs_stat_get_partition_last_autoanalyze_time`
- `gs_stat_get_partition_last_autovacuum_time`
- `gs_stat_get_partition_last_data_changed_time`
- `gs_stat_get_partition_last_vacuum_time`
- `gs_stat_get_partition_numscans`
- `gs_stat_get_partition_tuples_returned`
- `gs_stat_get_partition_tuples_fetched`
- `gs_stat_get_partition_vacuum_count`
- `gs_stat_get_xact_partition_tuples_fetched`
- `gs_stat_get_xact_partition_numscans`
- `gs_stat_get_xact_partition_tuples_returned`
- `gs_stat_get_partition_blocks_fetched`
- `gs_stat_get_partition_blocks_hit`
- `pg_stat_get_partition_tuples_inserted`
- `pg_stat_get_partition_tuples_updated`
- `pg_stat_get_partition_tuples_deleted`
- `pg_stat_get_partition_tuples_changed`
- `pg_stat_get_partition_live_tuples`
- `pg_stat_get_partition_dead_tuples`
- `pg_stat_get_xact_partition_tuples_inserted`
- `pg_stat_get_xact_partition_tuples_deleted`
- `pg_stat_get_xact_partition_tuples_hot_updated`
- `pg_stat_get_xact_partition_tuples_updated`
- `pg_stat_get_partition_tuples_hot_updated`

关键边界：

- `last_data_changed_time`当前暂不支持。
- 手动/autovacuum时间与auto/autoanalyze专用时间区分明确。
- `dead_tuples`在Ustore表中仅代表不活跃行指针数量。
- 事务内统计只覆盖活跃子事务相关tuple操作。

### ALT会话状态

- `gs_session_alt_status`

关键边界：

- 查询计划外ALT会话可恢复状态。
- 不包括不支持的驱动接口调用导致的会话状态变更。
- `sessionreplaystatus`和`xactreplaystatus`可为`enable`或`disable`。
- `reason`仅提供不可恢复原因基本类别。
- 不支持的GUC、SQL或系统函数需另行查询ALT支持列表。

### 内存分析

- `gs_memory_profiling`
- `gs_jemalloc_info_details`

关键边界：

- `gs_memory_profiling`的`0/1/2`分别关闭、开启和dump；其他输入非法。
- jeprof报告位于`mem_log`，命名格式为`jeprof-YYYY-mm-dd_HHMMSS`。
- `gs_jemalloc_info_details`生成`memory_stat_report-YY-mm-dd_HHMMSS.log`。
- 两个内存分析函数均仅`SYSADMIN`可用。
- 内存采集影响性能，仅推荐在非性能敏感的内存问题分析场景使用。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_10_oq_partition_field_matrix` | 单字段分区统计在分区、子分区、Astore/Ustore、vacuum/analyze和事务内负载下的输出矩阵 |
| `stats_wave4_10_oq_alt_memory_evidence` | ALT可恢复状态、jeprof内存采集和jemalloc统计在不同会话/事务、权限、内存压力和采集开关下的行为与性能影响 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_10_v1.yaml
generated/core_statistics_wave4_10_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_10.py
python scripts/build_core_statistics_wave4_10.py --check
python -m pytest -q tests/test_core_statistics_wave4_10.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不查询分区统计、不改变ALT状态、不开启内存采集或生成报告。
- 不宣称目标环境行为验证通过。
