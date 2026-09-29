# Core System Management Wave 2B-13 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.17 其它函数（第四批：系统表属性、目录文件、AntiCache/Vlog、UStore统计、页面重放与GIN清理）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 777–788，共12页 |
| 结构化 facts | 25 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 25 / 25 |

## 覆盖内容

### 系统表属性、通信与目录文件

- `gs_catalog_attribute_records`
- `gs_comm_proxy_thread_status`
- `pg_ls_tmpdir`
- `pg_ls_tmpdir(oid)`
- `pg_ls_waldir`

关键边界：

- `gs_catalog_attribute_records`仅支持oid小于10000的普通系统表，不支持索引、toast表等。
- `comm_proxy`统计仅在部署用户态网络且`comm_proxy_attr.enable_dfx=true`时显示；其他场景报错。
- 临时目录和WAL目录函数需系统管理员或监控管理员执行。

### AntiCache与Vlog

- `gs_stat_anti_cache`
- `gs_stat_vlog_buffer`
- `gs_stat_vlog_related_io`
- `gs_stat_vlog_file`
- `pause_anti_cache_recycle`
- `gs_write_term_log`

关键边界：

- `pause_anti_cache_recycle`仅供内部使用；正式版本不支持设置。
- `pause=true`暂停AntiCache回收，`false`恢复正常回收。
- `gs_write_term_log`在备DN返回false，主DN写入成功返回true。

### UStore扩展页与索引dump

- `gs_stat_space`
- `gs_index_dump_read`

关键边界：

- `gs_stat_space(init)`用于查询UStore Insert扩展页面状态；`init`重置统计数据。
- `cache_succ`较小提示系统缓存失效；`prune_space`较小提示页面清理机制可能存在问题；`con_extend_time`过高提示并发拓页耗时较高。
- `gs_index_dump_read`仅支持USTORE索引表，PDB内禁用。
- `reset=0`重新统计，`reset=1`显示当前统计；`out_type`支持`urq`、`ubtree`和`all`。

### 页面重放、Xlog与共享盘

- `gs_redo_upage`
- `gs_xlogdump_bylastlsn`
- `gs_shared_storage_flush_stat`

关键边界：

- `gs_redo_upage`需系统管理员或运维管理员执行，PDB内禁用。
- `gs_redo_upage`会在重放期间校验页面，检测到坏块时落盘并返回受损信息。
- `gs_xlogdump_bylastlsn`需系统管理员或运维管理员执行，不支持备机调用。
- 共享盘刷盘统计默认打开；`operation=-1/0/1/2`分别关闭、打开、查询和重置；重新打开会清理旧统计。
- 共享盘刷盘统计在PDB内调用报错。

### SQL与GIN维护

- `dbe_perf.get_full_sql_by_parent_id_and_timestamp`
- `gin_clean_pending_list`

关键边界：

- 存储过程及其子语句的全量SQL查询只在系统库中可查询结果。
- `gin_clean_pending_list`可能需要多次执行直到返回0。
- 索引未开启`fastupdate`时不发生清理，结果为0。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b13_oq_file_cache_runtime_matrix` | 目录文件列表、AntiCache、Vlog和UStore扩展页统计在不同权限、部署形态、PDB/Non-PDB与负载下的输出矩阵 |
| `wave2b13_oq_replay_gin_evidence` | `gs_redo_upage`、`gs_xlogdump_bylastlsn`、共享盘刷盘统计和GIN pending list清理在真实备份/WAL/索引状态、权限与开关状态下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b13_v1.yaml
generated/core_system_admin_wave2b13_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b13.py
python scripts/build_core_system_admin_wave2b13.py --check
python -m pytest -q tests/test_core_system_admin_wave2b13.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行目录读取、AntiCache/Vlog开关、页面重放、Xlog dump、共享盘统计或GIN pending list清理。
- 不宣称目标环境行为验证通过。
