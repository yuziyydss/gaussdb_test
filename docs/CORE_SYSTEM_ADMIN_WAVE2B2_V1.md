# Core System Management Wave 2B-2 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖两个高影响子族：

```text
1.6.27.4 备份恢复控制函数
1.6.27.5 双数据库实例容灾控制函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 597–617，共21页 |
| 结构化 facts | 30 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 30 / 30 |

## 覆盖内容

### 备份恢复控制函数

- 命名恢复点：`pg_create_restore_point`
- WAL位置查询：
  - `pg_current_xlog_location`
  - `pg_current_xlog_insert_location`
  - `gs_current_xlog_insert_end_location`
  - `pg_xlog_location_diff`
- 在线备份生命周期：
  - `pg_start_backup`
  - `pg_stop_backup`
- WAL切换与文件定位：
  - `pg_switch_xlog`
  - `pg_xlogfile_name`
  - `pg_xlogfile_name_offset`
- CBM函数：
  - `pg_cbm_start_tracked_location`
  - `pg_cbm_tracked_location`
  - `pg_cbm_get_merged_file`
  - `pg_cbm_get_changed_block`
  - `gs_cbm_get_changed_block`
  - `pg_cbm_recycle_file`
  - `pg_cbm_force_track`
  - `pg_cbm_rotate_file`
- 延迟DDL/Xlog回收控制
- `gs_roach_backup`系列接口
- DW IO阻断控制
- PITR barrier / manual archive / archive status函数
- 外部物理复制槽
- OBS delete location
- global barrier状态
- 恢复信息与pause / resume
- OBS media file查询、上传、下载

### 双数据库实例容灾控制函数

- `gs_streaming_dr_in_switchover`
- GaussStor参数、统计、性能和模式切换
- DR destination name设置与查询
- HADR链路信息设置、查询和版本
- replication limit查询

## 关键边界

- `pg_start_backup`必须与`pg_stop_backup`配合使用。
- 单独调用`pg_start_backup`可能导致`backup_label`残留。
- `setval`类序列相关操作不可回滚。
- 备份、CBM、PITR、OBS、复制槽和容灾控制函数多需要SYSADMIN / OPRADMIN / REPLICATION等权限。
- GaussStor和DR控制函数依赖实际容灾部署。
- 暂停恢复可能导致WAL持续堆积。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b2_oq_backup_permission_matrix` | 备份、CBM、PITR、OBS、复制槽函数的角色 / 权限 / PDB矩阵 |
| `wave2b2_oq_dr_gaussstor_environment` | GaussStor / DR控制函数需隔离容灾环境验证 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b2_v1.yaml
generated/core_system_admin_wave2b2_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b2.py
python scripts/build_core_system_admin_wave2b2.py --check
python -m pytest -q tests/test_core_system_admin_wave2b2.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行备份、恢复、容灾、OBS或复制槽操作。
- 不宣称目标环境行为验证通过。
