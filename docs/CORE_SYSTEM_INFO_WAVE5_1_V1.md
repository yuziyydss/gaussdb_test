# Core System Information Functions Wave 5-1 Extraction V1

## 目标

开始细抽 `1.6.26 系统信息函数`，本轮覆盖首批：

```text
上下文与USERENV
当前数据库 / Schema / 用户 / 查询
会话ID、用户ID与连接线程
客户端 / 服务端地址和端口
临时Schema、监听信道、服务器时间
规则定义与会话上下文
版本、部署形态、节点信息、编码
会话内存上下文明细
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 560–571，共12页 |
| 结构化 facts | 37 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 37 / 37 |

## 覆盖内容

### 上下文与会话身份

- `SYS_CONTEXT`
- `USERENV`
- `current_catalog`
- `current_database`
- `current_query`
- `current_schema`
- `current_schemas`
- `current_user`
- `session_user`
- `user`
- `definer_current_user`
- `getpgusername`

关键边界：

- `SYS_CONTEXT`和`USERENV`在第一入参为`userenv`时功能一致。
- `USERENV`当前不支持的一些入参返回`NULL`；非法入参报错。
- `current_user`用于权限检查，可受`SET ROLE`和`SECURITY DEFINER`影响。
- `session_user`可通过`SET SESSION AUTHORIZATION`由系统管理员修改。
- A兼容下设置`a_format_func_col_name='user'`后，`user`投影列名为`user`。

### Schema、数据库与连接

- `database`
- `get_schema_oid`
- `inet_client_addr`
- `inet_client_port`
- `inet_server_addr`
- `inet_server_port`
- `pg_backend_pid`
- `pg_listening_channels`

关键边界：

- `database()`仅在B兼容`5.7`和`s1`条件下生效。
- inet地址/端口函数只在远程连接模式下有效；Unix-domain socket下返回`NULL`。

### 会话、版本与节点

- `pg_current_sessionid`
- `pg_current_sessid`
- `pg_current_userid`
- `working_version_num`
- `version`
- `opengauss_version`
- `gs_deployment`
- `get_hostname`
- `get_nodename`
- `get_nodeinfo`

关键边界：

- 会话ID格式为`时间戳.会话ID`。
- 线程池开启时使用SessionID，关闭时使用ThreadID。
- `get_nodeinfo`当前支持`node_name`和`node_type`。

### 临时Schema、规则与会话上下文

- `pg_my_temp_schema`
- `pg_is_other_temp_schema`
- `pg_conf_load_time`
- `pg_postmaster_start_time`
- `pg_get_ruledef`
- `sessionid2pid`
- `session_context`
- `pg_trigger_depth`

关键边界：

- 当前会话没有临时模式时，`pg_my_temp_schema`返回0。
- `session_context`当前支持`current_user`、`current_schema`、`client_info`、`ip_address`、`sessionid`和`sid`。

### 内存明细

- `pv_session_memory_detail`

关键边界：

- 以MemoryContext节点统计会话内存。
- Non-PDB返回全局统计，PDB仅返回本PDB统计。
- 输出`totalsize`、`freesize`、`usedsize`等字段。
- `TempSmallContextGroup`的`usedsize`含义为统计计数。

## Open questions

| ID | 内容 |
|---|---|
| `sysinfo_wave5_1_oq_context_parameter_matrix` | 上下文函数在不同兼容模式、入参、线程池和PDB/Non-PDB下的输出矩阵 |
| `sysinfo_wave5_1_oq_connection_memory_evidence` | 连接、临时Schema和内存明细在socket/远程、线程池、内存压力和多租下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_system_info_wave5_1_v1.yaml
generated/core_system_info_wave5_1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_info_wave5_1.py
python scripts/build_core_system_info_wave5_1.py --check
python -m pytest -q tests/test_core_system_info_wave5_1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不修改会话上下文、不查询内存上下文、不修改线程池或兼容参数。
- 不宣称目标环境行为验证通过。
