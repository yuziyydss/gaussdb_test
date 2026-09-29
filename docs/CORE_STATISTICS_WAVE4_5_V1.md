# Core Statistics Functions Wave 4-5 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第五批：

```text
本节点回放耗时统计
Xlog类型回放统计
共享/会话/历史内存上下文
线程调用栈
on-cpu / off-cpu / detail / all 火焰图采集与列表
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 853–864，共12页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### 回放耗时与Xlog统计

- `local_redo_time_count([operation])`
- `local_xlog_redo_statics()`

关键边界：

- 回放耗时仅在备机上有有效数据。
- `operation`无输入、`-1`、`0`、`1`、`2`分别表示查询、关闭、打开、查询和重置；默认关闭。
- 并行回放返回各回放线程流程耗时；极致RTO还返回日志类型流程耗时。
- 关闭统计开关后重新打开会清理之前统计信息。
- 极致RTO统计开关关闭时，日志类型统计会对回放日志抽样。
- `local_xlog_redo_statics`输出`xlog_type`、`rmid`、`info`、`num`和`extra`。
- `extra`只对page回放日志和xact日志有有效值。

### 内存上下文与线程栈

- `gs_get_shared_memctx_detail`
- `gs_get_session_memctx_detail`
- `gs_get_history_memory_detail`
- `gs_stack`

关键边界：

- 内存上下文明细包含`file`、`line`和`size`；同一文件同一行多次申请会累加。
- 会话内存上下文仅线程池模式生效。
- 历史`memory detail`入参`NULL`列出快照文件，入参合法文件名显示内容，其他入参报错。
- `gs_stack`需`SYSADMIN`或`MONADMIN`权限，不支持并发调用。

### 火焰图采集

- `gs_perf_start`
- `gs_perf_start_offcpu`
- `gs_perf_start_detail`
- `gs_perf_start_all`
- `gs_perf_list`

关键边界：

- 采集函数需要`gs_perf_service`正常运行。
- 环形buffer受`/proc/sys/kernel/perf_event_mlock_kb`影响。
- `gs_perf_start`采集1–60秒on-cpu数据。
- `gs_perf_start_offcpu`采集50–3000毫秒off-cpu数据。
- `gs_perf_start_detail`采集多核多线程详细信息，每次运行删除历史数据。
- `gs_perf_start_all`采集本机所有节点数据；DBUSER模式只能采集on-cpu。
- `gs_perf_list`不展示多核多线程火焰图记录。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_5_oq_redo_time_matrix` | 并行回放和极致RTO在不同线程类型、日志类型、统计开关和备机负载下的step耗时矩阵 |
| `stats_wave4_5_oq_memory_perf_evidence` | 内存上下文明细、历史快照、线程栈和gs_perf采集在不同权限、线程池模式、perf_service状态、内核buffer限制和采集时长下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_5_v1.yaml
generated/core_statistics_wave4_5_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_5.py
python scripts/build_core_statistics_wave4_5.py --check
python -m pytest -q tests/test_core_statistics_wave4_5.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不打开回放统计开关、不读取内存快照、不采集线程栈或火焰图。
- 不宣称目标环境行为验证通过。
