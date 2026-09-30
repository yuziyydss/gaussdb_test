# Core System Management Wave 2B-10 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.17 其它函数（首批：计划缓存、会话线程、WDR/ASP与I/O诊断）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 746–755，共10页 |
| 结构化 facts | 29 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 29 / 29 |

## 覆盖内容

### 计划缓存

- `plan_seed`
- `pg_catalog.plancache_clean`
- `DBE_PERF.global_plancache_clean`
- `pg_catalog.plancache_status`
- `DBE_PERF.global_plancache_status`
- `pg_catalog.global_plancache_set_invalid`
- `pg_catalog.global_plancache_show_plan`

关键边界：

- 计划缓存清理、状态、手动失效和单计划查看默认需要`MONADMIN`权限。
- 计划缓存相关函数多租不支持。
- `is_with_plan=true`且计划较多时可能产生性能劣化。
- `global_plancache_set_invalid`不建议常用，会带来硬解析次数增加。
- `unique_sql_id=0`的计划不支持手动失效或单计划显示。

### 会话、线程与语句计数

- `textlen`
- `threadpool_status`
- `get_local_active_session`
- `pg_stat_get_thread`
- `pg_stat_get_sql_count`
- `pg_stat_get_data_senders`
- `get_wait_event_info`

关键边界：

- 管理员与普通用户可见范围不同。
- 多租场景下PDB / Non-PDB的数据可见范围不同。
- 备节点PDB内`threadpool_status`返回空，PDB内`pg_stat_get_data_senders`返回空。

### WDR / ASP / Unique SQL / 跨库诊断

- `generate_wdr_report`
- `generate_wdr_db_report`
- `create_wdr_snapshot`
- `kill_snapshot`
- `generate_asp_report`
- `dbe_perf.get_active_session_profile`
- `capture_view_to_json`
- `reset_unique_sql`
- `wdr_xdb_query`

关键边界：

- WDR报告只能用于系统库。
- `generate_asp_report`只能在主DN上使用。
- `reset_unique_sql`的`GLOBAL`范围只能由主节点执行。
- `wdr_xdb_query`仅初始化用户可用；PDB内调用报错。

### 工作负载、内存上下文与I/O / Buffer诊断

- `pg_wlm_jump_queue`
- `gs_wlm_switch_cgroup`
- `pv_session_memctx_detail`
- `pg_shared_memctx_detail`
- `local_aio_completer_stat`
- `local_aio_slot_usage_status`
- `gs_get_io_type`
- `local_bgwriter_stat`
- `local_candidate_stat`
- `gs_buffer_manager_info`
- `local_ckpt_stat`
- `local_double_write_stat`

关键边界：

- `pv_session_memctx_detail`在正式发布版本仅接受空串内存上下文名。
- `pg_shared_memctx_detail`仅DEBUG版本有效，正式发布版本为no-op。
- `gs_get_io_type`返回`BIO`、`DIO`或`BIO->DIO (In progress)`。
- 检查点与双写统计在PDB内部返回空列表。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b10_oq_plancache_runtime_matrix` | GPC清理、状态、手动失效和单计划查看在不同权限、计划数量、`unique_sql_id=0`与多租模式下的行为矩阵 |
| `wave2b10_oq_diagnostics_permission_matrix` | WDR、ASP、Unique SQL、内存上下文dump和I/O诊断函数在系统库、用户库、主备DN、PDB/Non-PDB及不同管理员权限下的输出与错误矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b10_v1.yaml
generated/core_system_admin_wave2b10_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b10.py
python scripts/build_core_system_admin_wave2b10.py --check
python -m pytest -q tests/test_core_system_admin_wave2b10.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行计划缓存清理、Unique SQL清理、跨库查询、WDR/ASP生成、内存dump或工作负载调整函数。
- 不宣称目标环境行为验证通过。
