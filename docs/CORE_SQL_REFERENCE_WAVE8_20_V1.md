# SQL Reference Wave 8-20 Extraction V1

## 目标

抽取 `1.13.9.48 CREATE TABLE`，补齐建表主语法、权限与对象边界、临时/UNLOGGED表、LIKE复制、存储参数、TDE、ILM压缩和约束体系。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.48` | 27 | CREATE TABLE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 27 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CREATE TABLE主语法、CREATE ANY TABLE权限和serial依赖
- 表约束数量、XML主外键和rowid/rowno外键限制
- UNLOGGED表、全局/本地临时表与ON COMMIT行为
- IF NOT EXISTS和保留表名前缀风险
- COMMENT、AUTO_INCREMENT、字符集/字符序与ENGINE的B模式边界
- CREATE TABLE ... LIKE与INCLUDING/EXCLUDING复制语义
- ORIENTATION、STORAGE_TYPE、FILLFACTOR与segment段页式
- TDE加密表和自动生成的密钥参数
- ILM ADVANCED/TURBO压缩与白名单行级表达式
- CHECK、DEFAULT、ON UPDATE、生成列约束
- IDENTITY、AUTO_INCREMENT、PRIMARY KEY、UNIQUE和外键

## Open questions

| ID | 内容 |
|---|---|
| `ddl_wave8_20_oq_runtime` | CREATE TABLE在真实存储引擎、临时表、TDE、HTAP、ILM压缩和约束组合下的DDL结果与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_20_v1.yaml
generated/core_sql_reference_wave8_20_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_20.py
python scripts/build_core_sql_reference_wave8_20.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_20.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE TABLE或DDL。
