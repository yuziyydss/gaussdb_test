# SQL Reference Wave 8-49 Extraction V1

## 目标

抽取 `1.13.9.40 CREATE ROLE`，补齐角色创建、权限属性、密码策略、有效期、资源限额和角色成员能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.40` | 9 | CREATE ROLE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CREATE ROLE权限与默认NOLOGIN语义
- 角色名称截断、大小写转换和合法字符规则
- 密码复杂度、密文密码和加密存储边界
- `EXPIRED`、`PASSWORD EXPIRE INTERVAL`和`DISABLE`
- SYSADMIN及MON/OPR/POL/AUDIT管理员属性
- CREATEDB、CREATEROLE、USEFT和三权分立创建边界
- INHERIT、REPLICATION、PERSISTENCE
- CONNECTION LIMIT统计方式
- VALID BEGIN/VALID UNTIL
- RESOURCE POOL、PERM/TEMP/SPILL SPACE
- IN ROLE、IN GROUP、ROLE、ADMIN、USER成员子句
- SYSID、DEFAULT TABLESPACE、PROFILE和PGUSER忽略/兼容行为
- CREATE ROLE与CREATE USER差异

## Open questions

| ID | 内容 |
|---|---|
| `role_wave8_49_oq_runtime` | CREATE ROLE在真实权限模型、三权分立、密码策略、资源限额和角色成员组合下的生效结果与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_49_v1.yaml
generated/core_sql_reference_wave8_49_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_49.py
python scripts/build_core_sql_reference_wave8_49.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_49.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE ROLE或DDL。
