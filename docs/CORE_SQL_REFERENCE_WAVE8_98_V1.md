# SQL Reference Wave 8-98 Extraction V1

## 目标

抽取 A/B 族第五批：`ALTER RESOURCE LABEL`、`ALTER ROLE`、`ALTER ROW LEVEL SECURITY POLICY`、`ALTER SESSION`、`ALTER SYSTEM KILL SESSION` 与 `ALTER SYSTEM SET`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.25` | 2 | ALTER RESOURCE LABEL |
| `1.13.7.27` | 5 | ALTER ROLE |
| `1.13.7.28` | 2 | ALTER ROW LEVEL SECURITY POLICY |
| `1.13.7.32` | 4 | ALTER SESSION |
| `1.13.7.34` | 2 | ALTER SYSTEM KILL SESSION |
| `1.13.7.35` | 2 | ALTER SYSTEM SET |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 16 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- ALTER RESOURCE LABEL五类资源ADD/REMOVE、poladmin/sysadmin/初始用户权限
- ALTER ROLE五种形式与22项option权限全集
- PDB内IN DATABASE禁用、redisuser保留名不可重命名
- IN DATABASE会话参数、SET/RESET/FROM CURRENT语义
- ACCOUNT LOCK/UNLOCK、PGUSER不可改、密码修改/重置权限矩阵
- EXPIRED密码失效（可登录不可查询）与初始用户豁免
- ALTER RLS POLICY改名/改用户/改表达式三能力与\d+策略展示基线
- ALTER SESSION事务参数与运行时参数全集（TIME ZONE/CURRENT_SCHEMA/NAMES/XML OPTION）
- SET TRANSACTION需先START TRANSACTION否则立即结束
- ISOLATION LEVEL READ UNCOMMITTED与READ COMMITTED行为一致
- KILL SESSION dv_sessions/pg_stat_activity定位、强制结束回滚基线
- ALTER SYSTEM SET资源计划切换、初始用户/sysadmin限定、PDB与M兼容不支持

## Open questions

| ID | 内容 |
|---|---|
| `alter_arl_role_sess_sys_wave8_98_oq_runtime` | 角色密码失效后的查询阻断行为矩阵、IN DATABASE会话参数跨库生效、KILL SESSION对长事务回滚的实际耗时、资源计划切换对运行中PDB负载的影响在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_98_v1.yaml
generated/core_sql_reference_wave8_98_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_98.py
python scripts/build_core_sql_reference_wave8_98.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_98.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行资源标签/角色/会话语句。
