# SQL Reference Wave 8-78 Extraction V1

## 目标

抽取 D 族第二批：`DROP DATABASE LINK`、`DROP DIRECTORY`、`DROP EVENT` 与 `DROP EXTENSION`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.10.11` | 2 | DROP DATABASE LINK |
| `1.13.10.12` | 2 | DROP DIRECTORY |
| `1.13.10.13` | 2 | DROP EVENT |
| `1.13.10.14` | 2 | DROP EXTENSION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 4 |
| 物理页 | 5 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 4 / 4 |
| chapter has facts | 4 / 4 |

## 覆盖能力

- DROP DATABASE LINK语法、PUBLIC/PRIVATE语义、IF EXISTS
- 私有/公共/OCI/SSL四类DBLink创建删除行为基线
- DROP DIRECTORY语法、IF EXISTS
- enable_access_server_directory开关下的权限矩阵、PDB排除
- 目录对象创建删除行为基线
- DROP EVENT语法与IF EXISTS、B模式限制
- 一次性/周期定时任务行为基线
- DROP EXTENSION内部功能定位、拥有者/初始用户、组件级联
- 语法与CASCADE/RESTRICT语义（成员对象同语句删除例外）

## Open questions

| ID | 内容 |
|---|---|
| `drop_d_family_wave8_78_oq_runtime` | DBLink（含OCI/SSL）删除、目录对象权限模式切换、定时任务删除和扩展级联删除在真实兼容模式、权限和依赖对象组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_78_v1.yaml
generated/core_sql_reference_wave8_78_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_78.py
python scripts/build_core_sql_reference_wave8_78.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_78.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行DROP语句。
