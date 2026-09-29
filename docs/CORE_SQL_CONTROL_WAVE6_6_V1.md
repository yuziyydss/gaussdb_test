# Core SQL Control and Tools Wave 6-6 Extraction V1

## 目标

细抽并一次性完成两个相邻章节：

```text
1.6.49 SQL限流函数
1.6.50 SQL工具函数
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapters | 2 |
| 物理页并集 | 991–1005，共15页 |
| 结构化 facts | 28 |
| Open questions | 2 |
| Source resolved | 2 / 2 |
| Facts bound to scope | 28 / 28 |

## 覆盖内容

### SQL限流

- `gs_add_workload_rule`
- `gs_update_workload_rule`
- `gs_delete_workload_rule`
- `gs_get_workload_rule_stat`
- `gs_refresh_workload_rule_cache`
- `add_abnormal_sql`
- `clean_abnormal_sql`
- `abnormal_sql_manage_allowlist`
- `abnormal_sql_cpu_limit`

关键边界：

- 规则类型包括`sqlid`、查询类型、`resource`和`client`。
- 生效优先级为`client > resource > sqlid > 查询类型规则`。
- `databases=NULL`表示所有数据库；`start_time=NULL`表示当前时间生效；`end_time=NULL`表示一直生效。
- 查询类型与client规则使用数据库列表；resource规则对整个DN进程生效。
- 创建时间建议使用`now()`而不是`sysdate`。
- 限流规则缓存不支持感知事务回滚，回滚后需手动刷新。
- 异常SQL管控和CPU上限函数需要管理员权限；多租开启时部分函数失效或不适用。

### SQL PATCH

- `DBE_SQL_UTIL.create_hint_sql_patch`
- `DBE_SQL_UTIL.create_abort_sql_patch`
- `DBE_SQL_UTIL.drop_sql_patch`
- `DBE_SQL_UTIL.enable_sql_patch`
- `DBE_SQL_UTIL.disable_sql_patch`
- `DBE_SQL_UTIL.show_sql_patch`
- `DBE_SQL_UTIL.sqlpatch_query_hash`
- `DBE_SQL_UTIL.gs_show_plan_by_hash`

关键边界：

- SQL PATCH管理函数通常仅初始用户、sysadmin、opradmin和monadmin可调用。
- Hint与Abort PATCH均支持基础重载；Hint和Abort还支持通过`parent_unique_sql_id`限制生效范围。
- `parent_unique_sql_id=0`表示仅外层SQL生效，非0表示特定存储过程生效。
- `query_string`传入EXECUTE语句时依赖当前会话的PREPARE语句。
- `show_sql_patch`的status为`d`表示Unique SQL ID，`h`表示SQL HASH。
- `cursor_sharing=force`时应传入参数化SQL并设置`need_validate=false`。
- 计划还原要求sql_hash/plan_hash存在于SPM系统表，并且SQL可执行；不支持存储过程带变量查询。

## Open questions

| ID | 内容 |
|---|---|
| `sqlcontrol_wave6_6_oq_rule_matrix` | 限流规则在五类rule_type、多库、时间边界、资源阈值、客户端组合、事务回滚和PDB/Non-PDB下的拦截矩阵 |
| `sqlcontrol_wave6_6_oq_patch_plan_matrix` | SQL PATCH与计划还原在Unique SQL ID、SQL HASH、PREPARE、cursor_sharing和权限边界下的行为矩阵 |

## 产物

```text
docs/compat_facts/core_sql_control_wave6_6_v1.yaml
generated/core_sql_control_wave6_6_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_control_wave6_6.py
python scripts/build_core_sql_control_wave6_6.py --check
python -m pytest -q tests/test_core_sql_control_wave6_6.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不创建或删除限流规则、不管控异常SQL、不创建或删除SQL PATCH、不还原计划。
- 不宣称目标环境行为验证通过。
