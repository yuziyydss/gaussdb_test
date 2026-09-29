# Core System Management Wave 2B-15 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖并完成：

```text
1.6.27.17 其它函数（第六批：GSTrace、主降备耗时与tcache清理，收尾）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 795–804，共10页 |
| 结构化 facts | 21 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 21 / 21 |

## 覆盖内容

### GSTrace注册与取消

- `gstrace_reg_sql`
- `gstrace_reg_func`
- `gstrace_unreg_sql`
- `gstrace_unreg_func`
- `gstrace_unreg_all_sql`
- `gstrace_unreg_all_func`

关键边界：

- 所有函数均需`MONADMIN`或`SYSADMIN`权限。
- `scope`当前仅支持`LOCAL`。
- 每个数据库实例最多跟踪1000个SQL语句。
- 每个数据库实例最多跟踪1000个函数。
- `function_name`仅支持系统函数名称。
- `gstrace_reg_func`和`gstrace_unreg_func`的`so_index`可选，但填入`so_index`时必须同时填`so_offset`。
- `level='0'`只跟踪函数本身；`level='1'`跟踪函数及其子函数。

### GSTrace列表与状态

- `gstrace_list_configured_sql`
- `gstrace_list_configured_func`
- `gstrace_show_traced_func`
- `gstrace_show_mangled_func`
- `gstrace_show_subfunc`

关键边界：

- `so_index=0`表示`gaussdb bin`，`so_index=1`表示`libgtmclient.so`。
- `gstrace_show_traced_func`输出函数名称、So信息、跟踪等级、申请模块、`if_traced`、`if_hp_conflict`、`if_blacklist`和`ref_count`。
- `if_hp_conflict=true`表示因热补丁冲突自动取消跟踪。
- `gstrace_show_mangled_func`用于查看mangle后的函数名称。
- `gstrace_show_subfunc`用于查看指定函数的全部子函数。

### 主降备耗时

- `gs_last_demote_spent_time`

关键边界：

- 输出步骤包括`thread_exit`、`checkpoint`、`shmem_exit`、`shmem_init`、`bufferpool_init`、`dw_init`和`thread_init`。
- 必须在执行主降备操作的数据库主节点上查询。
- 数据库间及数据库内switchover主降备成功后可查询。
- 信息保存在内存中，重启后重置。

### tcache清理

- `gs_tcache_memory_flush`

关键边界：

- 手动唤醒空闲业务线程和stream业务线程，并执行jemalloc的`tcache.flush`。
- 仅在开启线程池时生效。
- 仅`SYSADMIN`用户可用。
- 可降低`other memory`，但只消减jemalloc tcache；对大量硬解析导致内存碎片等其他原因无效。
- 成功返回`t`，失败返回`f`。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b15_oq_gstrace_runtime_matrix` | GSTrace在1000条上限、So参数组合、level、热补丁冲突、黑名单、权限和真实函数调用下的注册/取消/状态矩阵 |
| `wave2b15_oq_demote_tcache_evidence` | 主降备耗时在数据库间/库内switchover后的节点与内存重置边界，以及tcache flush在线程池和不同内存压力场景下的效果 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b15_v1.yaml
generated/core_system_admin_wave2b15_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b15.py
python scripts/build_core_system_admin_wave2b15.py --check
python -m pytest -q tests/test_core_system_admin_wave2b15.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不注册、取消、列出或查看GSTrace状态。
- 不执行主降备或tcache内存清理。
- 不宣称目标环境行为验证通过。
