# SQL Reference Wave 8-32 Extraction V1

## 目标

抽取 `1.13.18.10 REVOKE`，补齐对象权限、角色权限、ANY权限、PUBLIC、DATABASE LINK和PUBLIC同义词的回收能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.18.10` | 5 | REVOKE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 非所有者REVOKE失败/警告/部分撤销规则
- PDB `ON DATABASE`回收限制
- 表/视图、列、序列、数据库、域权限回收
- CMK/CEK、DIRECTORY、FDW、Foreign Server回收
- 函数、存储过程、语言、模式、表空间回收
- TYPE和PACKAGE权限回收
- 角色`ADMIN OPTION FOR`、SYSADMIN、ANY权限回收
- DATABASE LINK和PUBLIC SYNONYM权限回收
- PUBLIC语义、GRANT OPTION FOR、CASCADE依赖性权限
- 只能撤销直接授权的规则与SET ROLE建议

## Open questions

| ID | 内容 |
|---|---|
| `revoke_wave8_32_oq_runtime` | REVOKE在真实角色继承、CASCADE依赖、PUBLIC、ANY权限、PDB和多层授权组合下的权限回收矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_32_v1.yaml
generated/core_sql_reference_wave8_32_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_32.py
python scripts/build_core_sql_reference_wave8_32.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_32.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行REVOKE或DCL。
