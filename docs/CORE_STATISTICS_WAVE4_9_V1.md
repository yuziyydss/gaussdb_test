# Core Statistics Functions Wave 4-9 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第九批：

```text
备机延迟DDL信息
存储过程内存统计
存储过程计划缓存语句统计
分区汇总运行时/事务/I/O统计
分区统计异步上报边界
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 889–896，共8页 |
| 结构化 facts | 14 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 14 / 14 |

## 覆盖内容

### 延迟DDL信息

- `gs_display_delay_ddl_info`

关键边界：

- 查看备机中延迟删除的文件信息。
- Non-PDB返回全部信息，PDB仅返回本PDB相关信息。
- 输出删除对象类型、LSN、tablespace、database、relation、bucketid、opt和forknum。

### 存储过程内存与计划缓存

- `gs_plsql_statements`
- `gs_plsql_statements_details`

关键边界：

- 初始用户或系统管理员可查询所有会话，普通用户只能查看自己的会话信息。
- `gs_plsql_statements`输出编译产物总内存和计划总内存。
- `gs_plsql_statements_details`输出语句行号、计划缓存语句、usedsize和totalsize。
- 两个函数均可按sessionid、pkg_id和function_id过滤；示例支持传入`NULL,NULL,function_id`。

### 分区汇总统计

- `gs_stat_get_partition_stats`
- `gs_stat_get_xact_partition_stats`
- `gs_stat_get_all_partitions_stats`
- `gs_stat_get_xact_all_partitions_stats`
- `gs_statio_get_all_partitions_stats`

关键边界：

- 特定分区接口返回`record`，全部分区接口返回`setof record`。
- 运行时统计上报是异步且基于UDP协议，可能存在延迟和丢包。
- 示例输出覆盖扫描、索引扫描、tuple增删改/热更新、live/dead tuple、vacuum/analyze时间和计数。
- 事务内统计示例覆盖事务中的扫描、tuple操作和热更新信息。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_9_oq_plsql_memory_matrix` | 存储过程内存和计划缓存语句统计在不同权限、PACKAGE/函数过滤、重编译和并发调用下的输出矩阵 |
| `stats_wave4_9_oq_partition_async_evidence` | 分区运行时/事务/I/O统计在UDP上报延迟、丢包、分区/子分区和真实DML负载下的准确性 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_9_v1.yaml
generated/core_statistics_wave4_9_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_9.py
python scripts/build_core_statistics_wave4_9.py --check
python -m pytest -q tests/test_core_statistics_wave4_9.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不删除延迟DDL文件、不查询存储过程内存或分区统计。
- 不宣称目标环境行为验证通过。
