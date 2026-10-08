# SQL Reference Wave 8-81 Extraction V1

## 目标

抽取 D 族第五批：`DROP OWNED`、`DROP PACKAGE`、`DROP PLUGGABLE DATABASE INCLUDING DATAFILES`、`DROP PROCEDURE` 与 `DROP RESOURCE LABEL`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.27` | 2 | DROP OWNED |
| `1.13.10.28` | 2 | DROP PACKAGE |
| `1.13.10.29` | 2 | DROP PLUGGABLE DATABASE INCLUDING DATAFILES |
| `1.13.10.30` | 1 | DROP PROCEDURE |
| `1.13.10.31` | 2 | DROP RESOURCE LABEL |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 6 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- DROP OWNED权限回收与共享对象、多库执行要求、CASCADE/RESTRICT、数据库表空间不移除、私有DBLINK需CASCADE
- DROP PACKAGE/BODY、BODY删除后存储过程函数失效、仅初始用户对初始用户PACKAGE
- DROP PLUGGABLE DATABASE INCLUDING DATAFILES：enable_mtd、非PDB执行、datdba/SYSADMIN、先关闭、模板PDB排除、资源计划指令不级联
- DROP PROCEDURE仅初始用户对初始用户存储过程、IF EXISTS
- DROP RESOURCE LABEL权限、五类标签创建与IF NOT EXISTS对比、删除行为基线

## Open questions

| ID | 内容 |
|---|---|
| `drop_owned_wave8_81_oq_runtime` | DROP OWNED权限回收、PACKAGE/PACKAGE BODY删除失效、PDB删除（含资源计划指令残留）和资源标签删除在真实权限、多租与依赖对象组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_81_v1.yaml
generated/core_sql_reference_wave8_81_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_81.py
python scripts/build_core_sql_reference_wave8_81.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_81.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DROP语句。
