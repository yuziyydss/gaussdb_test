# Core System Management Wave 2B-5B Extraction V1

## 目标

抽取并闭合 `1.6.27.10 逻辑复制函数` 的剩余部分，覆盖 replication origin、分布式解码状态、逻辑字典、SQL apply 和逻辑回放跳过函数。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 661–674，共14页 |
| 结构化 facts | 29 |
| Open questions | 3 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 29 / 29 |

## 覆盖内容

### Replication origin

- `pg_replication_origin_create`
- `pg_replication_origin_drop`
- `pg_replication_origin_oid`
- `pg_replication_origin_session_setup`
- `pg_replication_origin_session_reset`
- `pg_replication_origin_session_is_setup`
- `pg_replication_origin_session_progress`
- `pg_replication_origin_xact_setup`
- `pg_replication_origin_xact_reset`
- `pg_replication_origin_advance`
- `pg_replication_origin_progress`
- `pg_show_replication_origin_status`

关键边界：

- 均需 SYSADMIN。
- `advance`使用不当可能导致复制数据不一致。
- origin名称仅支持字母、数字和`_`、`?`、`-`、`.`。

### 分布式解码与逻辑字典

- `gs_get_distribute_decode_status`
- `gs_get_distribute_decode_status_detail`
- `gs_logical_dictionary_baseline`
- `gs_logical_dictionary_disabled`
- `gs_logical_decode_lock`
- `gs_logical_decode_unlock`
- `gs_logical_decode_gaussdb_version`

关键边界：

- 分布式解码状态函数当前版本暂不支持。
- 关闭逻辑字典后，已有数据字典模式复制槽不能继续解码。
- 需重新baseline并重建逻辑复制槽。

### 逻辑备与 SQL apply

- `gs_get_inter_cluster_version_info`
- `gs_get_logical_decoding_version`
- `gs_add_logical_decoding_position_xlog`
- `gs_prepare_logical_standby_on_primary`
- `gs_get_logical_standby_meta_for_switchover`
- `gs_get_logical_standby_info`
- `gs_get_logical_data_dictionary_column_num`
- `gs_get_current_lgc_state`
- `gs_stop_sqlapply`
- `gs_start_sqlapply`
- `gs_get_sqlapply_replaying_status`
- `gs_get_sqlapply_playback_progress`

关键边界：

- 多个内部/高危函数 PDB 禁用。
- `gs_get_logical_standby_meta_for_switchover`为高危操作，非逻辑容灾 switchover 执行可能导致实例状态异常。
- `gs_stop_sqlapply`需配合`sql_apply_autorun=off`，否则逻辑备机会自动重启。
- failover阶段包括 INIT、NOTICE_KILL、CHECK_SQL_APPLY_END、COPY_XLOG、SUCCESS。

### 复制槽插件与回放跳过

- `gs_change_replication_slot_plugin`
- `gs_logicalstandby_skip`
- `gs_logicalstandby_unskip`
- `gs_logicalstandby_skip_txn`
- `gs_logicalstandby_unskip_txn`
- `gs_logicalstandby_skip_err`
- `gs_logicalstandby_unskip_err`

关键边界：

- 插件支持 `mppdb_decoding`、`sql_decoding`、`parallel_binary_decoding`、`parallel_json_decoding`、`parallel_text_decoding`。
- skip规则仅管理员在容灾备库主机执行，PDB禁用。
- 对象规则支持 `dml` / `insert` / `update` / `delete`。
- 事务规则按 CSN/XID，CSN范围1~2^63-1，XID范围3~2^63-1。
- dump支持 `all`、`no`、`skip`；事务规则中`all`与`skip`等价。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b5b_oq_replication_origin_matrix` | replication origin会话/事务状态组合、advance错误和权限矩阵 |
| `wave2b5b_oq_sqlapply_failover_matrix` | SQL apply启停、failover状态迁移和回放进度需容灾环境验证 |
| `wave2b5b_oq_skip_rule_matrix` | 对象/事务/报错跳过规则优先级、重复规则更新和PDB边界需专项测试 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b5b_v1.yaml
generated/core_system_admin_wave2b5b_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b5b.py
python scripts/build_core_system_admin_wave2b5b.py --check
python -m pytest -q tests/test_core_system_admin_wave2b5b.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行replication origin、SQL apply或回放跳过函数。
- 不宣称目标环境行为验证通过。
- Wave 2B-5B 完成后，`1.6.27.10` 逻辑复制函数原文子族已闭合。
