# SQL Reference Wave 8-50 Extraction V1

## 目标

抽取 `1.13.9.58 CREATE USER`，补齐用户创建、默认登录、同名SCHEMA、密码策略、角色属性和三权分立能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.58` | 6 | CREATE USER |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CREATE USER目的与认证模型
- 默认LOGIN权限和自动同名SCHEMA
- 系统管理员同名SCHEMA对象属主规则
- 主语法与CREATE ROLE复用选项
- 用户名截断、大小写和redisuser保留名
- 密码复杂度、密文密码和引号包裹
- CREATEDB权限
- `TOM`大小写行为
- ALTER USER密码、CREATEROLE、参数和ACCOUNT LOCK/UNLOCK示例
- OPRADMIN/SYSADMIN创建
- ADMIN成员关系
- enableSeparationOfDuty三权分立

## Open questions

| ID | 内容 |
|---|---|
| `user_wave8_50_oq_runtime` | CREATE USER在真实密码策略、同名SCHEMA、角色属性和三权分立组合下的认证、权限与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_50_v1.yaml
generated/core_sql_reference_wave8_50_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_50.py
python scripts/build_core_sql_reference_wave8_50.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_50.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE USER或DDL。
