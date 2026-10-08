# SQL Reference Wave 8-59 Extraction V1

## 目标

合并抽取 `CREATE/ALTER/DROP FOREIGN TABLE`，完成外表定义、OPTIONS维护、敏感字段边界和依赖删除闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.22` | 4 | CREATE FOREIGN TABLE |
| `1.13.7.13` | 3 | ALTER FOREIGN TABLE |
| `1.13.10.16` | 1 | DROP FOREIGN TABLE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- 外表创建、系统列限制、Private/Shared权限和PDB边界
- OPTIONS敏感字段脱敏边界
- 列定义、COLLATE、SERVER和外表级OPTIONS
- file_fdw选项：filename、format、header、delimiter、quote、escape、null、encoding、force_not_null
- 列约束NOT NULL/NULL/DEFAULT
- ALTER外表OPTIONS和列选项
- OPTIONS ADD/SET/DROP语义与FDW校验
- DROP FOREIGN TABLE强制删除、依赖索引级联和函数/存储过程失效
- `IF EXISTS`、多表删除、CASCADE/RESTRICT

## Open questions

| ID | 内容 |
|---|---|
| `ftable_wave8_59_oq_runtime` | CREATE/ALTER/DROP FOREIGN TABLE在真实FDW、文件路径、OPTIONS校验、依赖对象和PDB权限组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_59_v1.yaml
generated/core_sql_reference_wave8_59_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_59.py
python scripts/build_core_sql_reference_wave8_59.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_59.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行外表DDL。
