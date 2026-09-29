# Core Integration and Tools Wave 6-7 Extraction V1

## 目标

细抽并一次性完成6个集成与工具型章节：

```text
1.6.53 DATABASE LINK函数
1.6.54 GSMonitor系统资源统计函数
1.6.55 自治事务特性函数
1.6.56 DSL规则管理函数
1.6.57 消息队列函数
1.6.58 ROWID类型函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 6 |
| 物理页并集 | 1039–1056，共18页 |
| 结构化 facts | 25 |
| Open questions | 2 |
| Source resolved | 6 / 6 |
| Facts bound to scope | 25 / 25 |

## 覆盖内容

### DATABASE LINK

- `close_database_link`
- `gs_ora_diag`
- `gs_ora_get_handle_alloc`
- `gs_ora_get_handle_alloc_all`
- `gs_ora_connection_status`
- `gs_ora_fdw_handler`
- `gs_ora_fdw_validator`
- `is_dblink_in_use`
- `dblink_has_updatasent`
- `is_dblink_in_transaction`

关键边界：

- 不能关闭存在活跃事务的DBLink。
- `gs_ora_diag`仅针对Oracle DBLink；无参且管理员查询时返回环境变量，普通用户不显示。
- OCI内存单位为字节。
- 连接状态返回`CONNECTED`或`LOST`。

### GSMonitor资源统计

- `gs_get_cpustat`
- `gs_get_procstat`
- `gs_get_iostat`
- `gs_get_memstat`
- `gs_get_netstat`

关键边界：

- 全部需要`MONADMIN`或`SYSADMIN`权限。
- 时间参数必选；进程统计的排序支持`IO_R`、`IO_W`、`CPU`、`MEM`。
- `pretty`是当前支持的展示方式。
- 输出覆盖CPU、进程、磁盘I/O、内存和网络指标。

### 自治事务

- `gs_autonomous_transaction_detail`
- `gs_get_autonomous_transaction_count`
- `gs_reset_autonomous_transaction_count`

关键边界：

- 管理员可查看所有自治事务会话及父子关系。
- reset函数需`MONADMIN`或`SYSADMIN`权限，并返回恢复后的正确计数。

### DSL规则

- `dsl_add_rule`
- `dsl_del_rule`
- `dsl_set_rule`
- `dsl_reload_rule`

关键边界：

- `dsl_add_rule`仅初始用户可调用。
- 删除/修改需要系统管理员或初始用户。
- 规则名以字母开头且不超过64字节；优先级1–9999，数字越大优先级越低。
- `dsl_set_rule`只能修改单个属性，不能修改规则文本。

### 消息队列

- `mq_register_pull`
- `mq_unregister`
- `mq_send_message`
- `mq_query`
- `mq_transaction_processing`
- `mq_get_queue`
- `mq_clear`
- `mq_sync_ccn`
- `mq_sync`

关键边界：

- 仅主节点使用；实例异常会丢失全部数据。
- 发布后需提交事务或主动COMMIT；回滚会清除未提交消息。
- 同一会话同一group/topic只能有一个订阅。
- 消息最大4096字节；group/topic最大127字节；队列最大499。
- `mq_get_queue`和`mq_clear`需`SYSADMIN`权限。
- `mq_sync_ccn`和`mq_sync`当前版本不可用。

### ROWID

- `rowid_tableoid`
- `rowid_sequence`

关键边界：

- 分别返回rowid中的table_oid和row_no。

## Open questions

| ID | 内容 |
|---|---|
| `integration_wave6_7_oq_dblink_monitor_matrix` | DBLink诊断/状态/OCI内存和GSMonitor资源统计在真实Oracle链路、权限、时间窗口和负载下的输出矩阵 |
| `integration_wave6_7_oq_dsl_mq_rowid_evidence` | DSL规则生命周期、消息队列事务边界、自治事务计数和ROWID解析在主备、异常恢复和并发场景下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_integration_tools_wave6_7_v1.yaml
generated/core_integration_tools_wave6_7_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_integration_tools_wave6_7.py
python scripts/build_core_integration_tools_wave6_7.py --check
python -m pytest -q tests/test_core_integration_tools_wave6_7.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接外部Oracle、不关闭DBLink、不采集系统资源、不修改DSL规则、不发送/消费消息、不解析ROWID。
- 不宣称目标环境行为验证通过。
