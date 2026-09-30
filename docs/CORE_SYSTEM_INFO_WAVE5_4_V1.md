# Core System Information Functions Wave 5-4 Extraction V1

## 目标

细抽并完成 `1.6.26 系统信息函数` 最后一批：

```text
事务ID与快照
两阶段残留事务
系统控制状态
内置函数视图
线程 / 会话 / 共享内存
压缩、文件、GTM、WLM、WDR快照
内核内存态关键信息
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 586–592，共7页 |
| 结构化 facts | 31 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 31 / 31 |

## 覆盖内容

### 事务ID与快照

- `pgxc_is_committed`
- `txid_current`
- `gs_txid_oldestxmin`
- `txid_current_snapshot`
- `txid_snapshot_xip`
- `txid_snapshot_xmax`
- `txid_snapshot_xmin`
- `txid_visible_in_snapshot`

关键边界：

- `txid_snapshot`文本格式为`xmin:xmax:xip_list`。
- `xip_list`不包含子事务。
- `txid_visible_in_snapshot`判断不使用子事务ID。
- hashbucket重载在集中式不支持，调用报错。

### 两阶段残留事务与控制状态

- `get_local_prepared_xact`
- `get_remote_prepared_xacts`
- `global_clean_prepared_xacts`
- `gs_get_next_xid_csn`
- `pg_control_system`
- `pg_control_checkpoint`

关键边界：

- 本地和远程残留事务分别返回OID/名称版本信息。
- `global_clean_prepared_xacts`当前形态调用均返回`false`。

### 内置函数与内存

- `pv_builtin_functions`
- `pv_thread_memory_detail`
- `gs_session_memory_detail_tp`
- `gs_thread_memory_detail`
- `pg_shared_memory_detail`

关键边界：

- `pv_builtin_functions`输出内置函数签名、属主、语言、代价、参数、源码和ship/fenced属性。
- 线程内存函数在PDB内返回空列表或按多租可见性返回。
- 共享内存字段参考`GS_SHARED_MEMORY_DETAIL`。

### 压缩、文件与WLM

- `pg_relation_compression_ratio`
- `pg_relation_with_compression`
- `pg_stat_file_recursive`
- `gs_stat_get_wlm_plan_operator_info`
- `pg_stat_get_partition_tuples_hot_updated`
- `pg_stat_get_wlm_session_iostat_info`

关键边界：

- 压缩率默认返回1.0。
- `pg_stat_file_recursive`在PDB内禁用。
- WLM算子信息从内部哈希表获取。
- I/O统计输出当前/峰值IOPS、限制和优先级。

### GTM、WDR快照与内核信息

- `get_gtm_lite_status`
- `adm_hist_snapshot_func`
- `gs_get_current_version`
- `gs_get_kernel_info`

关键边界：

- `get_gtm_lite_status`集中式和GTM-FREE模式不支持。
- WDR快照函数需开启`enable_wdr_snapshot`并具备snapshot权限。
- `gs_get_current_version`当前返回`P`。
- `gs_get_kernel_info`覆盖XACT、STANDBY、UNDO、HOTPATH、FULL_SQL、LOCK和SQL模块。

## Open questions

| ID | 内容 |
|---|---|
| `sysinfo_wave5_4_oq_txid_snapshot_matrix` | 事务ID、快照可见性和两阶段残留事务在并发、主备、hashbucket和异常状态下的输出矩阵 |
| `sysinfo_wave5_4_oq_kernel_memory_wlm_evidence` | 内置函数、内存上下文、文件、WLM、WDR快照和内核信息在不同权限、负载、PDB/Non-PDB和模块状态下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_system_info_wave5_4_v1.yaml
generated/core_system_info_wave5_4_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_info_wave5_4.py
python scripts/build_core_system_info_wave5_4.py --check
python -m pytest -q tests/test_core_system_info_wave5_4.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不清理两阶段事务、不修改控制文件、不查询内存或WDR快照。
- 不宣称目标环境行为验证通过。
