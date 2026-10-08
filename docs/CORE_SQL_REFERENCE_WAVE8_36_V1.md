# SQL Reference Wave 8-36 Extraction V1

## 目标

本批将信息量较小的 `DROP VIEW` 与相邻 `CREATE SYNONYM` 合并抽取，补齐同义词对象、PUBLIC同义词、解析规则和视图删除能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.47` | 4 | CREATE SYNONYM |
| `1.13.10.49` | 2 | DROP VIEW |

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

- 同义词别名映射、属主与Schema规则
- 表/视图/类型/PACKAGE/函数/存储过程/序列/同义词访问
- SELECT/INSERT/UPDATE/DELETE/EXPLAIN/CALL支持
- 存储过程、临时表、加密对象、敏感函数限制
- 原对象删除后的同义词失效行为
- `CREATE ANY SYNONYM`权限与PUBLIC同义词权限
- 嵌套同义词、search_path和PUBLIC搜索顺序
- gsql元命令与DDL访问边界
- `CREATE [OR REPLACE] [PUBLIC] SYNONYM`语法
- `DROP VIEW`权限、`IF EXISTS`、`CASCADE/RESTRICT`

## Open questions

| ID | 内容 |
|---|---|
| `syn_wave8_36_oq_runtime` | 同义词解析、嵌套映射、PUBLIC同义词、远程对象和失效同义词在真实Schema/search_path组合下的行为矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_36_v1.yaml
generated/core_sql_reference_wave8_36_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_36.py
python scripts/build_core_sql_reference_wave8_36.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_36.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE SYNONYM、DROP VIEW或DDL。
