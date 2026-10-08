# SQL Reference Wave 8-56 Extraction V1

## 目标

合并抽取 `CREATE SERVER`、`ALTER SERVER` 与 `DROP SERVER`，完成外部服务器创建、选项维护、属主变更和依赖删除闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.46` | 2 | CREATE SERVER |
| `1.13.7.31` | 3 | ALTER SERVER |
| `1.13.10.39` | 2 | DROP SERVER |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 7 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- 外部服务器语义和敏感OPTIONS脱敏边界
- `FOREIGN DATA WRAPPER`取值与语法兼容限制
- OPTIONS连接细节与`fdw_startup_cost`、`fdw_typle_cost`
- CREATE SERVER示例
- ALTER SERVER权限、owner角色成员要求
- OPTIONS的ADD/SET/DROP语义、唯一约束和FDW验证
- VERSION、OWNER TO、RENAME TO
- DROP SERVER权限、`IF EXISTS`、CASCADE/RESTRICT

## Open questions

| ID | 内容 |
|---|---|
| `server_wave8_56_oq_runtime` | CREATE/ALTER/DROP SERVER在真实FDW、连接选项、敏感信息脱敏、依赖对象和权限组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_56_v1.yaml
generated/core_sql_reference_wave8_56_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_56.py
python scripts/build_core_sql_reference_wave8_56.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_56.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE/ALTER/DROP SERVER。
