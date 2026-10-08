# SQL Reference Wave 8-48 Extraction V1

## 目标

合并抽取 `CREATE SCHEMA`、`ALTER SCHEMA` 与 `DROP SCHEMA`，完成模式生命周期闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.43` | 4 | CREATE SCHEMA |
| `1.13.7.29` | 4 | ALTER SCHEMA |
| `1.13.10.36` | 2 | DROP SCHEMA |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 10 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- CREATE SCHEMA按名称/AUTHORIZATION创建，schema_element与AUTHORIZATION属主
- 模式命名规则、前缀访问和同名对象显式模式引用
- WITH BLOCKCHAIN、enable_ledger与防篡改用户表
- B/M模式默认字符集和字符序
- ALTER SCHEMA权限、owner成员关系、系统模式限制
- WITH/WITHOUT BLOCKCHAIN、空模式约束
- RENAME TO、OWNER TO、默认字符集/字符序
- DROP SCHEMA权限、系统模式、Public Schema限制
- `IF EXISTS`、多模式删除、CASCADE/RESTRICT
- pg_temp/pg_toast_temp与当前模式删除边界

## Open questions

| ID | 内容 |
|---|---|
| `sch_wave8_48_oq_runtime` | CREATE/ALTER/DROP SCHEMA在真实权限、防篡改属性、字符集、嵌套对象和CASCADE依赖组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_48_v1.yaml
generated/core_sql_reference_wave8_48_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_48.py
python scripts/build_core_sql_reference_wave8_48.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_48.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE/ALTER/DROP SCHEMA。
