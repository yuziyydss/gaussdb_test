# SQL Reference Wave 8-132 Extraction V1

## 目标

抽取 M 兼容语句章收尾批：`ANALYZE`（M版）、`AUTOHINT` 系列（M版）、`GENERATED UPDATE SYSTEM`、`GRANT` 与 `REVOKE`。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 7 |
| 物理页 | 19 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 7 / 7 |
| chapter has facts | 7 / 7 |

## 覆盖能力

- ANALYZE（M版）：pg_statistic体系、VERIFY校验矩阵、历史表三表、事务块/PREPARE支持、cursor列不收集
- AUTOHINT（M版）：五选项缺省TRUE、无视已有Hint、管理员权限
- AUTOHINT DROP/PURGE的MODEL REMOVED输出基线
- GENERATED UPDATE SYSTEM升级回滚脚本（OM调用、内部语法）
- GRANT四类授权场景（系统权限/对象/角色传递/ANY权限）
- PUBLIC语义（CONNECT/CREATE TEMP TABLE/语言与类型USAGE默认授予）
- WITH GRANT OPTION不能赋予PUBLIC（M特有）、WITH ADMIN OPTION
- ANY权限14种清单与数据库内限定、CREATE ANY TABLE属主规则、PUBLIC禁授
- REVOKE非所有者三规则、grant_database_nomapping开关对REVOKE ON DATABASE的映射
- GRANT/REVOKE表/字段/序列/数据库/模式语法基线

## Open questions

| ID | 内容 |
|---|---|
| `m_grant_revoke_wave8_132_oq_runtime` | M兼容ANY权限在跨数据库场景的实际限制、grant_database_nomapping开启前后REVOKE ON DATABASE的行为差异矩阵、WITH GRANT OPTION不能赋予PUBLIC的 enforcement 细节需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_132_v1.yaml
generated/core_sql_reference_wave8_132_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_132.py
python scripts/build_core_sql_reference_wave8_132.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_132.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行M兼容授权语句。
