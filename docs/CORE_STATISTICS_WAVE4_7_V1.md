# Core Statistics Functions Wave 4-7 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第七批：

```text
线程内存上下文明细
线程池语句/槽位运行统计
会话全量GUC配置
WAL预解析统计
资源池CPU/连接/内存/并发/I/O统计
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 874–880，共7页 |
| 结构化 facts | 24 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 24 / 24 |

## 覆盖内容

### 线程内存与线程池统计

- `gs_get_thread_memctx_detail`
- `gs_tpworker_execstmt_stat`
- `gs_tpworker_execslot_stat`

关键边界：

- 线程内存上下文需`SYSADMIN`或`MONADMIN`权限；PDB内返回空列表。
- 线程池语句统计中管理员可见全部语句，普通用户只可见自己的SQL。
- 线程池槽位统计中普通用户只可见自己SQL所在线程。
- 语句状态包括`Waiting`、`Running`、`Control`和`Downgraded`。
- 线程状态包括`Waiting`、`Running`和`Control`。
- I/O管控字段格式为`curVal/maxVal`；memory/cpu/network状态字段当前预留且暂不支持。

### 会话GUC与WAL预解析

- `gs_session_all_settings(sessionid bigint)`
- `gs_session_all_settings()`
- `gs_local_wal_preparse_statistics`

关键边界：

- 会话GUC查询需要`SYSADMIN`或`MONADMIN`权限。
- PDB内仅返回本PDB数据，Non-PDB返回全局数据。
- WAL预解析需要`SYSADMIN`权限。
- WAL预解析线程通常由CM在备DN双机复制链路断开时启动。
- 线程未启动时返回默认值：term为0、位置为`00000000/00000000`、字节数和速度为0、`is_valid=f`。

### 资源池统计

- `gs_wlm_respool_cpu_info`
- `gs_wlm_respool_connection_info`
- `gs_wlm_respool_memory_info`
- `gs_wlm_respool_concurrency_info`
- `gs_wlm_respool_io_info`

关键边界：

- 这些资源池统计函数在多租模式下禁用。
- CPU使用率在未管控时显示0。
- 内存命中率字段当前保留且恒为0。
- 动态内存查询结果可能超过最大值；文档说明属于正常现象，实际并未申请内存。
- 无并发限制时`running_concurrency`显示0。
- I/O的`io_limits=0`表示不控制；`io_priority=None`表示不控制。
- `current_iops`可能因统计算法偶尔超过上限；计数单位由`io_control_unit`定义。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_7_oq_tpworker_status_matrix` | 线程池语句和槽位统计在不同权限、负载、等待、资源管控和CPU降级状态下的输出矩阵 |
| `stats_wave4_7_oq_respool_limits_matrix` | 资源池CPU、连接、内存、并发和I/O限制在多租开关、无限制配置、超限场景和`io_control_unit`变化下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_7_v1.yaml
generated/core_statistics_wave4_7_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_7.py
python scripts/build_core_statistics_wave4_7.py --check
python -m pytest -q tests/test_core_statistics_wave4_7.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不读取线程内存上下文、不修改会话GUC、不启动WAL预解析、不调整资源池。
- 不宣称目标环境行为验证通过。
