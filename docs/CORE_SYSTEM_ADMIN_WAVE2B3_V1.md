# Core System Management Wave 2B-3 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.6 双数据库实例容灾查询函数
1.6.27.7 快照同步函数
1.6.27.8 数据库对象函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 618–629，共12页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### 双数据库实例容灾查询函数

- `gs_get_local_barrier_status`
- `gs_hadr_in_recovery`
- `gs_streaming_dr_get_switchover_barrier`
- `gs_streaming_dr_service_truncation_check`
- `gs_hadr_local_rto_and_rpo_stat`
- `gs_hadr_remote_rto_and_rpo_stat`
- `disaster_cluster_run_mode`
- `gs_hadr_create_recovery_pause_barrier`
- `gs_is_wal_truncate_complete`
- `gs_hadr_local_replay_delay_stat`
- `gs_change_dorado_state`
- `gs_get_dorado_state`

### 快照同步函数

- `pg_export_snapshot`
- `pg_export_snapshot_and_csn`

### 数据库对象函数

#### 对象尺寸

- `pg_column_size`
- `pg_database_size`
- `get_db_source_datasize`
- `pg_relation_size`
- `pg_partition_size`
- `pg_partition_indexes_size`
- `pg_indexes_size`
- `pg_size_pretty`
- `pg_table_size`
- `pg_tablespace_size`
- `pg_total_relation_size`
- `datalength`

#### 对象位置

- `pg_relation_filenode`
- `pg_relation_filepath`
- `pg_filenode_relation`
- `pg_partition_filenode`
- `pg_partition_filepath`

#### 回收站对象

- `gs_is_recycle_object`
- `gs_is_recycle_obj`

## 关键边界

- `pg_relation_filepath` / `pg_partition_filepath` 只适用于非段页式关系；段页式关系建议使用 `gs_seg_extents` 和 `gs_seg_datafiles` 等视图。
- `get_db_source_datasize()` 调用前需要 `ANALYZE`。
- `pg_database_size` 查询耗时与库中对象文件数基本呈线性关系。
- `xmlcast` 类似的 Oracle 兼容函数已在 XML 波次覆盖；本轮不展开。
- 容灾查询和 Dorado 状态函数依赖实际容灾部署、权限和 PDB / Non-PDB 模式。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b3_oq_dr_query_permission_matrix` | 容灾查询、Dorado 状态函数的角色、PDB / Non-PDB 和部署模式矩阵 |
| `wave2b3_oq_object_size_cost` | 大库上 `pg_database_size`、`pg_tablespace_size` 的耗时、权限和文件系统影响 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b3_v1.yaml
generated/core_system_admin_wave2b3_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b3.py
python scripts/build_core_system_admin_wave2b3.py --check
python -m pytest -q tests/test_core_system_admin_wave2b3.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行容灾查询、快照导出、对象尺寸或回收站函数。
- 不宣称目标环境行为验证通过。
