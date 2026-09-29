# Core Multi-tenant Database Wave 7-3 Extraction V1

## 目标

细抽 `1.6.52 多租数据库函数`，覆盖PDB配置、CGroup、资源计划、用户、SQL统计、登录统计和共享内存统计。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 1029–1039，共11页 |
| 结构化 facts | 19 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 19 / 19 |

## 覆盖内容

### 配置与CGroup

- `gs_reload_pdb_conf`
- `gs_resplan_cgroup_info`

关键边界：

- `gs_reload_pdb_conf`需sysadmin及以上权限。
- CDB可查看所有CGroup数据，PDB只能查看本PDB范围。
- `gs_resplan_cgroup_info`在备机执行报错。

### 资源计划统计

- `gs_resplan_stat_info`

关键边界：

- `view_type=0/1/2`分别返回实时、最近一次和最近一小时历史。
- CDB可查看所有数据，PDB只能查看本PDB范围；备机执行报错。
- 输出CPU、内存、I/O、连接数和逻辑解码内存等指标。
- 资源变更时共享缓存统计可能从0重新计数，期间对性能无影响。

### PDB路径与用户

- `gs_get_pdb_tablespace_location`
- `get_mtd_user`

关键边界：

- 表空间路径函数仅供内核功能实现使用。
- PDB id超出范围返回NULL；其他PDB id、无SYSADMIN权限返回空字符串；PDB下无对应表空间报错。
- `get_mtd_user`管理员可查看全部用户，普通用户仅查看自己；PDB仅返回本PDB信息。

### SQL、登录与共享内存统计

- `get_instr_sql_count_info`
- `get_instr_db_rt_percentile`
- `get_instr_user_login_info`
- `gs_resplan_shared_memory_info`

关键边界：

- SQL计数和响应时间分布在PDB内仅返回本PDB数据。
- 登录/登出统计需要`SYSADMIN`或`MONADMIN`权限。
- 共享内存统计仅在`enable_mtd=on`、主机CDB和系统管理员条件下有效。

## Open questions

| ID | 内容 |
|---|---|
| `mtd_wave7_3_oq_resource_matrix` | CGroup、资源计划CPU/内存/I/O和共享缓存在不同资源计划、PDB负载、资源变更和主备状态下的输出矩阵 |
| `mtd_wave7_3_oq_user_sql_evidence` | 多租用户信息、SQL计数、响应时间P80/P95、登录登出和表空间路径在不同权限、CDB/PDB和时间边界下需实机验证 |

## 产物

```text
docs/compat_facts/core_multitenant_wave7_3_v1.yaml
generated/core_multitenant_wave7_3_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_multitenant_wave7_3.py
python scripts/build_core_multitenant_wave7_3.py --check
python -m pytest -q tests/test_core_multitenant_wave7_3.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不重载PDB配置、不调整资源计划、不查询CGroup/共享内存、不修改用户。
- 不宣称目标环境行为验证通过。
