# SQL Reference Wave 8-31 Extraction V1

## 目标

抽取 `1.13.13.2 GRANT`，补齐系统权限、对象权限、角色继承、ANY权限、PUBLIC默认权限和加密/外部对象授权能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.13.2` | 13 | GRANT |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 13 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- GRANT四类授权场景
- 系统权限与PUBLIC继承边界
- 对象权限追加语义、WITH GRANT OPTION和PUBLIC默认权限
- 角色授权、WITH ADMIN OPTION与三权分立管理范围
- ANY权限数据库范围、继承、PUBLIC限制和对象属主
- 安全风险与PDB `ON DATABASE`限制
- 表/视图、列、序列、数据库授权
- 域和类型授权暂不支持
- CMK/CEK、FDW、Foreign Server、函数/存储过程/语言
- 模式、表空间、DIRECTORY、PACKAGE、DATABASE LINK
- 非所有者授权规则与GRANT/ADMIN OPTION

## Open questions

| ID | 内容 |
|---|---|
| `grant_wave8_31_oq_runtime` | GRANT在真实角色继承、ANY权限、PDB、加密对象、DATABASE LINK和PUBLIC默认权限组合下的权限判定与继承矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_31_v1.yaml
generated/core_sql_reference_wave8_31_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_31.py
python scripts/build_core_sql_reference_wave8_31.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_31.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行GRANT或DCL。
