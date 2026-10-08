# SQL Reference Wave 8-69 Extraction V1

## 目标

抽取 SET 家族剩余三种：`SET ROLE` 身份切换、`SET SESSION AUTHORIZATION` 会话身份切换与 `SET TRANSACTION` 事务特性。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.19.7` | 3 | SET ROLE |
| `1.13.19.8` | 2 | SET SESSION AUTHORIZATION |
| `1.13.19.9` | 3 | SET TRANSACTION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- SET ROLE语义、角色成员资格与系统管理员例外
- INHERITS/NOINHERITS权限模型差异
- LDAP认证用户排除
- 语法/SESSION/LOCAL/role_name/password、RESET ROLE
- 密文密码限制（管理员不可密文切换、gs_dump场景）
- SESSION_USER/CURRENT_USER行为基线
- SET SESSION AUTHORIZATION会话+当前用户标识双切换
- 初始会话用户系统管理员权限门槛
- DEFAULT/RESET重置
- 密文密码限制
- 行为基线（paul切换与重置）
- SET TRANSACTION LOCAL/SESSION/GLOBAL作用域
- 事务内执行要求、GLOBAL重连生效
- 语法（含SET SESSION CHARACTERISTICS AS TRANSACTION）
- B模式set_session_transaction门槛
- 隔离级别设置时机（首个DML后不可改、事务块内SESSION特性COMMIT后生效）
- 四种隔离级别语义（SERIALIZABLE等价RR）与读写模式
- LOCAL/SESSION/GLOBAL三级行为基线

## Open questions

| ID | 内容 |
|---|---|
| `set_transaction_wave8_69_oq_runtime` | SET ROLE/SET SESSION AUTHORIZATION身份切换权限边界与SET TRANSACTION各作用域在真实权限、认证方式和兼容模式组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_69_v1.yaml
generated/core_sql_reference_wave8_69_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_69.py
python scripts/build_core_sql_reference_wave8_69.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_69.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行身份切换/事务特性语句。
