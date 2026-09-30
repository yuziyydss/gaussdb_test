# Core System Management Wave 2B-12 Extraction V1

## 目标

继续细抽 `1.6.27 系统管理函数`，本轮覆盖：

```text
1.6.27.17 其它函数（第三批：功能开关、页面解析、Xlog dump、共享盘、UBTree与WAL统计）
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 765–777，共13页 |
| 结构化 facts | 26 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 26 / 26 |

## 覆盖内容

### dynamic_func_control

- `dynamic_func_control`

关键边界：

- 当前`scope`仅支持`LOCAL`。
- `function_name`仅支持`STMT`和`GSTRACE`。
- `STMT`支持`TRACK / UNTRACK / LIST / CLEAN`；`LIST`对所有用户可用，其他action需系统管理员或`MONADMIN`权限。
- `GSTRACE`支持SQL/函数注册、取消注册、批量取消、列表、跟踪状态、mangled名称和子函数查看。

### 页面解析

- `gs_parse_page_bypath`

关键边界：

- 需系统管理员或运维管理员执行。
- `blocknum=-1`解析所有block并强制从磁盘解析；`0`到`MaxBlockNumber`解析对应页面。
- `read_memory=false`从磁盘解析；`true`优先从共享缓冲区解析。
- 未落盘页面解析结果自然为空，且`relation_type`不生效。
- 支持heap、uheap、BTree/UBTree、VM、FSM、clog、csnlog、undo、多种索引和跨页压缩类型。
- blocknum越界的示例错误为`Blocknum should be between -1 and 4294967294`。

### Xlog dump与共享盘

- `gs_xlogdump_lsn`
- `gs_xlogdump_xid`
- `gs_xlogdump_tablepath`
- `gs_xlogdump_parsepage_tablepath`
- `gs_shared_storage_xlogdump_lsn`
- `gs_shared_storage_ctlinfo`

关键边界：

- Xlog dump类函数需系统管理员或运维管理员执行。
- 表日志解析在多租场景下PDB内部禁用。
- `gs_xlogdump_parsepage_tablepath`可视为一次执行页面解析和表日志解析。
- 查看已删除表日志应直接使用`gs_xlogdump_tablepath`。
- 共享盘Xlog dump未指定路径时解析当前DN所有Xlog日志共享盘。

### UBTree与WAL诊断

- `gs_index_verify`
- `gs_index_recycle_queue`
- `gs_stat_wal_entrytable`
- `gs_walwriter_flush_position`
- `gs_walwriter_flush_stat`

关键边界：

- `gs_index_verify`的`blkno=0`校验整个UBtree索引树。
- 回收队列`type=0/1/2`分别解析待回收队列、空页队列和单个页面；`blkno`仅在`type=2`时有效。
- WAL entrytable的`endlsn=0`表示未完全复制到wal buffer，非0表示`COPIED`。
- `gs_walwriter_flush_stat`的`operation=-1/0/1/2`分别关闭、打开、查询和重置统计。

## Open questions

| ID | 内容 |
|---|---|
| `wave2b12_oq_page_xlogdump_matrix` | 页面解析、Xlog dump和共享盘dump在不同relation_type、blocknum、read_memory、路径、PDB/Non-PDB与权限下的输出和错误矩阵 |
| `wave2b12_oq_wal_index_runtime_evidence` | dynamic_func_control、UBTree索引校验/回收队列、WAL entrytable和walwriter统计在真实负载、权限与开关状态下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b12_v1.yaml
generated/core_system_admin_wave2b12_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b12.py
python scripts/build_core_system_admin_wave2b12.py --check
python -m pytest -q tests/test_core_system_admin_wave2b12.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行页面解析、Xlog dump、索引校验、WAL统计开关或dynamic_func_control。
- 不宣称目标环境行为验证通过。
