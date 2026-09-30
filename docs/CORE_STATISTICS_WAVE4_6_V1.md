# Core Statistics Functions Wave 4-6 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第六批：

```text
on-cpu / off-cpu火焰图数据查询
函数调用占比查询
火焰图report与废弃clean接口
性能抖动监控的开启、落盘、关闭、历史和状态
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 864–874，共11页 |
| 结构化 facts | 23 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 23 / 23 |

## 覆盖内容

### 火焰图数据查询

- `gs_perf_query`
- `gs_perf_query_general`
- `gs_perf_query_detail`
- `gs_perf_report`
- `gs_perf_clean`

关键边界：

- 查询函数需要`SYSADMIN`或`MONADMIN`权限。
- `filename`不指定时默认使用最近一次手动采集的火焰图。
- `gs_perf_query`输出堆栈、执行时间、层级、顺序、线程名和占比。
- `gs_perf_query_general`输出函数名和调用占比。
- `gs_perf_query_detail`输出函数名、函数占比、调用栈和调用栈占比。
- 占比总和因计算精度可能不等于1。
- 当前版本默认落盘；`gs_perf_report`展示上一次手动oncpu文件地址。
- `gs_perf_clean`当前版本提示废弃，后续版本会移除。

### 性能抖动监控

- `gs_perf_start_shaking_collect`
- `gs_perf_do_shaking_collect`
- `gs_perf_close_shaking_collect`
- `gs_perf_get_shaking_collect_result`
- `gs_perf_get_shaking_collect_status`

关键边界：

- `scope`仅支持`local`，`NULL`等效`local`。
- 监控的唯一SQL ID列表长度为0–32。
- 监控时长为5–6000分钟，默认60分钟。
- 最大快照保存次数为1–10，默认3。
- 环形buffer大小为1–32MB，默认8MB；实际buffer还受CPU核心数影响。
- do快照两次落盘最小间隔1分钟。
- `gs_perf_service`超过10分钟未完成或异常退出会返回超时消息。
- 前端SQL中止或超时不会终止后台`gs_perf_service`任务。
- `gs_perf_service`重启后监控解除，需要重新开启。
- 每次开启性能抖动监控会清空历史快照列表。
- 状态可为未监控、监控中、`NO PERF SERVICE`或查询失败。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_6_oq_perf_query_matrix` | 火焰图查询在不同采集类型、文件名、权限、ROOT/DBUSER模式和高负载数据下的输出与占比精度矩阵 |
| `stats_wave4_6_oq_shaking_evidence` | 性能抖动监控在SQL列表、时长、快照次数、buffer、时间间隔、超时和`perf_service`重启/异常退出下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_6_v1.yaml
generated/core_statistics_wave4_6_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_6.py
python scripts/build_core_statistics_wave4_6.py --check
python -m pytest -q tests/test_core_statistics_wave4_6.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不查询火焰图数据、不清理perf文件、不开启或关闭性能抖动监控。
- 不宣称目标环境行为验证通过。
