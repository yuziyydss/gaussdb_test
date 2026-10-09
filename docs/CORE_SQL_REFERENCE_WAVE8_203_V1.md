# SQL Reference Wave 8-203 Extraction V1

## 目标

抽取 GUC文件位置/连接设置：`7.3.2 文件位置` + `7.3.3.1 连接设置`（页 4170–4181）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2（完整节合并） |
| 物理页 | 11 |
| 结构化 facts | 12 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 文件位置（7.3.2）：data_directory/config_file/hba_file/ident_file/external_pid_file参数
- 连接设置（7.3.3.1）：light_comm/listen_addresses（动态侦听/高危操作）/port/max_connections（资源限制/管理员预留）/max_inner_tool_connections（计算公式）/sysadmin_reserved_connections（主端口+1逃生）/service_reserved_connections/unix_socket三参数/application_name/connection_info/check_disconnect_query/plat_compat_server_port/plat_compat_default_database
