# SQL Reference Wave 8-51 Extraction V1

## 目标

合并抽取 `ALTER USER` 与 `DROP USER`，完成用户属性修改、会话参数、账户锁定、用户删除和依赖处理闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.44` | 4 | ALTER USER |
| `1.13.10.47` | 2 | DROP USER |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 2 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 2 / 2 |
| chapter has facts | 2 / 2 |

## 覆盖能力

- ALTER USER用途、会话参数用户隔离与下一次会话生效
- PDB中`IN DATABASE`和初始用户密码限制
- 权限属性、密码、有效期、资源池、空间限额和ACCOUNT语法
- RENAME TO
- SET/RESET用户会话参数
- 大写用户名双引号、redisuser重命名限制
- 新密码复杂度和当前密码限制
- ACCOUNT LOCK/UNLOCK
- PGUSER不可修改
- `IN DATABASE` SET/RESET示例
- DROP USER权限、同名Schema删除
- CASCADE锁定对象、跨数据库级联限制
- 跨数据库同名Schema前置条件
- 删除前置条件、CASCADE/RESTRICT、enable_kill_query

## Open questions

| ID | 内容 |
|---|---|
| `user_wave8_51_oq_runtime` | ALTER/DROP USER在真实权限、会话参数、账户锁定、CASCADE依赖和跨数据库对象组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_51_v1.yaml
generated/core_sql_reference_wave8_51_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_51.py
python scripts/build_core_sql_reference_wave8_51.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_51.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行ALTER/DROP USER。
