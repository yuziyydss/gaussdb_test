# Core System Management Wave 2B-1 Extraction V1

## 目标

开始细抽 `1.6.27 系统管理函数`。Wave 2B-1 只覆盖三个高影响子族：

```text
1.6.27.1 配置设置函数
1.6.27.2 通用文件访问函数
1.6.27.3 服务器信号函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 592–596，共5页 |
| 结构化 facts | 20 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 20 / 20 |

## 覆盖内容

### 配置设置函数

- `current_setting(setting_name)`
- `set_config(setting_name, new_value, is_local)`
- `set_working_grand_version_num_manually`
- `shell_in`
- `shell_out`

关键语义：

- `current_setting` 等价于 `SHOW`
- `set_config` 的 `is_local=true` 只作用于当前事务
- `set_config` 的 `is_local=false` 等价于 `SET`
- 不允许设置 `ROLE`

### 通用文件访问函数

- `pg_ls_dir`
- `pg_read_file`
- `pg_read_binary_file`
- `pg_read_binary_file_blocks`
- `pg_stat_file`

关键边界：

- 只能访问数据库目录和 `log_directory` 中的文件
- 仅数据库初始化用户可使用
- `pg_read_binary_file_blocks` 只用于跨页透明压缩文件内容
- 旧签名不支持

### 服务器信号函数

- `pg_cancel_backend`
- `pg_cancel_session`
- `pg_reload_conf`
- `pg_rotate_logfile`
- `pg_terminate_backend`
- `pg_terminate_session`
- `pg_terminate_active_session_socket`
- `terminate_session_has_temp_file`

关键边界：

- 需要 SYSADMIN 或 `gs_role_signal_backend` 等权限
- 线程池 / PDB / Non-PDB 行为不同
- `pg_terminate_backend` 不支持非活跃线程池线程
- 锁等待、硬件异常、网络 I/O 阻塞时可能无法立即终止
- `terminate_session_has_temp_file` 主要由 CM 调用，不建议手动执行

## Open questions

| ID | 内容 |
|---|---|
| `wave2b1_oq_file_access_permission_matrix` | 文件访问在 PDB/non-PDB、missing_ok、路径边界下的权限与报错矩阵 |
| `wave2b1_oq_signal_thread_pool_matrix` | 线程池、PDB/non-PDB、pid/sessionid 组合下的 cancel / terminate 结果矩阵 |

## 产物

```text
docs/compat_facts/core_system_admin_wave2b1_v1.yaml
generated/core_system_admin_wave2b1_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_system_admin_wave2b1.py
python scripts/build_core_system_admin_wave2b1.py --check
python -m pytest -q tests/test_core_system_admin_wave2b1.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不执行服务器信号函数。
- 不宣称目标环境行为验证通过。
- `1.6.27.4` 之后的备份恢复、容灾、快照、对象、锁、复制、存储、HTAP等子族后续拆抽。
