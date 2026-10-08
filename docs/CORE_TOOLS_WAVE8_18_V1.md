# Tools Wave 8-18 Extraction V1

## 目标

抽取 `5.4 数据库运维管理工具`，补齐信息收集、参数设置、实例维护、服务控制、ETCD/DCC切换、故障替换与数据抢救等运维能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `5.4` | 131 | 数据库运维管理工具 |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 131 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 运维工具总览：`gs_collector`、`gs_guc`、`gs_om`、`gs_ctl`、`gs_switch_ddb`、etcd/etcdctl、gaussdb等
- `gs_collector` OS/数据库/日志/配置收集与I/O限速
- `gs_guc` 配置检查、设置、reload、加密与参数边界
- `gs_om` 启停、状态、主备切换、模式切换、IP修改、证书替换与耗时评估
- `gs_ctl` 服务控制命令族和多数派一致性安全边界
- `gs_switch_ddb` ETCD/DCC拓扑切换前置条件
- `gs_controldata`与`gs_resetxlog`控制文件检查和高危事务文件重置
- `gs_ssh`节点命令执行与敏感命令保护
- etcd Raft一致性、磁盘I/O敏感性与etcdctl控制能力
- `gaussdb`主进程、多进程共存与单用户模式
- `gs_replace`故障主机/实例替换和`gs_rescue`极端数据抢救边界
- `gns_ctl`计划内无损透明维护与JDBC事务协调
- 统计信息导入导出、火焰图采集与DCF数据文件工具

## Open questions

| ID | 内容 |
|---|---|
| `tools_wave8_18_oq_runtime` | 真实集群下的运维切换、故障替换、数据抢救、统计导入导出、性能采集和DCF文件操作行为矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_tools_wave8_18_v1.yaml
generated/core_tools_wave8_18_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_tools_wave8_18.py
python scripts/build_core_tools_wave8_18.py --check
python -m pytest -q tests/test_core_tools_wave8_18.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行任何运维、抢救或DCF文件修改工具。
