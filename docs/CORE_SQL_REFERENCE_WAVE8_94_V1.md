# SQL Reference Wave 8-94 Extraction V1

## 目标

抽取 A/B 族第一批：`ABORT`、`ALTER AGGREGATE`、`ALTER ASYNC ENCRYPTION KEY ROTATION`、`ALTER AUDIT POLICY`、`ALTER COLUMN ENCRYPTION KEY` 与 `ALTER DATABASE LINK`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.7.1` | 2 | ABORT |
| `1.13.7.2` | 2 | ALTER AGGREGATE |
| `1.13.7.3` | 2 | ALTER ASYNC ENCRYPTION KEY ROTATION |
| `1.13.7.4` | 4 | ALTER AUDIT POLICY |
| `1.13.7.5` | 1 | ALTER COLUMN ENCRYPTION KEY |
| `1.13.7.7` | 3 | ALTER DATABASE LINK |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 6 |
| 物理页 | 11 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 6 / 6 |
| chapter has facts | 6 / 6 |

## 覆盖能力

- ABORT与ROLLBACK等价性、WORK/TRANSACTION可读性关键字、事务外NOTICE行为、UPDATE撤销基线
- ALTER AGGREGATE三种形式与所有者/模式CREATE权限约束、零参数*写法、SQL标准不兼容说明
- TDE异步加密密钥轮转前提（enable_tde+enable_tde_async_encryption+SYSADMIN）、M兼容不支持、密钥轮转效果基线
- ALTER AUDIT POLICY五种修改形式（ADD/REMOVE、MODIFY、DROP FILTER、COMMENTS、ENABLE/DISABLE）
- 审计操作类型全集与ALL语义、IP/ROLES/APP过滤、注释修改行为基线
- CMK轮转语法、全密态开关前提、CEK明文不变/密文不可修改、国密算法配套约束
- DBLink仅支持改用户名密码（GaussDB目标）、PUBLIC默认PRIVATE、Oracle USING六参数及预置参数暂不生效说明
- public_dblink改用户与OCI dblink改time_out行为基线

## Open questions

| ID | 内容 |
|---|---|
| `abort_alter_wave8_94_oq_runtime` | 透明数据异步加密密钥轮转在真实TDE环境下的密钥轮转行为、CMK轮转与国密算法配套约束、DBLink连接Oracle的isolation_level/prefetch等参数实际生效行为在授权环境下的完整行为与错误矩阵需实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_94_v1.yaml
generated/core_sql_reference_wave8_94_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_94.py
python scripts/build_core_sql_reference_wave8_94.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_94.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行事务回滚/聚合函数/密钥轮转/审计策略/DBLink语句。
