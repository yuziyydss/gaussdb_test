# Core Statistics Functions Wave 4-8 Extraction V1

## 目标

继续细抽 `1.6.29 统计信息函数`，本轮覆盖第八批：

```text
WLM用户空间与会话I/O/内存
Unix Domain Socket应急运维通道
热备空间
极致RTO文件读取与回收
回放冲突信号
WAL回放统计
回放冲突等待事件
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 881–889，共9页 |
| 结构化 facts | 19 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 19 / 19 |

## 覆盖内容

### WLM空间与会话资源

- `gs_wlm_user_space_info`
- `gs_wlm_session_io_info`
- `gs_wlm_session_memory_info`
- `gs_emergency_operation_records`

关键边界：

- 用户存储空间在多租模式下禁用。
- session I/O在多租模式下禁用。
- session I/O的`io_limits=0`表示不控制，`io_priority=None`表示不控制。
- session I/O的`current_iops`可能因统计算法偶尔超过上限。
- session内存统计在PDB内仅返回本PDB数据，Non-PDB返回全局数据。
- 应急运维通道来源为`gsql`或`cm`。

### 热备空间与极致RTO

- `gs_hot_standby_space_info`
- `exrto_file_read_stat`
- `gs_exrto_recycle_info`

关键边界：

- 热备空间统计`base_page`、`block_info_meta`和`lsn_info_meta`三类文件的数量与大小。
- 极致RTO文件读取统计需连接备DN查询，其他情况结果为0。
- 极致RTO回收信息包括每个redo线程回收LSN、全局回收LSN和查询线程最旧快照LSN。

### 回放冲突与WAL回放

- `gs_stat_get_db_conflict_all`
- `gs_redo_stat_info`
- `gs_recovery_conflict_waitevent_info`

关键边界：

- 回放冲突信号统计覆盖`all`、tablespace、lock、snapshot、bufferpin、startup_deadlock、truncate、standby_query_timeout和force_recycle。
- WAL回放统计需连接备DN查询。
- `gs_redo_stat_info`无输入或`operation=1`查询统计，`operation=2`重置缓存命中率统计。
- 回放冲突等待事件覆盖lock、snapshot、tablespace、database、truncate、standby_query_timeout、force_recycle和bufferpin八类。
- 每类冲突等待事件输出counter、total、avg、min和max用时。

## Open questions

| ID | 内容 |
|---|---|
| `stats_wave4_8_oq_wlm_space_matrix` | WLM用户空间、session I/O和session内存在不同多租开关、限额配置、超限和PDB/Non-PDB模式下的输出矩阵 |
| `stats_wave4_8_oq_exrto_conflict_evidence` | 极致RTO文件读取/回收、WAL回放统计和八类回放冲突等待事件在真实备机负载、冲突压力和重置场景下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_statistics_wave4_8_v1.yaml
generated/core_statistics_wave4_8_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_statistics_wave4_8.py
python scripts/build_core_statistics_wave4_8.py --check
python -m pytest -q tests/test_core_statistics_wave4_8.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不调整WLM空间、不连接备DN、不重置回放统计。
- 不宣称目标环境行为验证通过。
