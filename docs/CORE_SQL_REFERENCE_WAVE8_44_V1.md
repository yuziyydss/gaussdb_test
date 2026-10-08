# SQL Reference Wave 8-44 Extraction V1

## 目标

抽取 `1.13.9.16 CREATE DATABASE`，补齐数据库创建、模板、编码、locale、兼容模式、表空间、连接限制和时区能力。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.16` | 12 | CREATE DATABASE |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1 |
| 物理页 | 12 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- CREATE DATABASE主语法与templatea默认模板
- CREATEDB权限、事务块限制和模板升级限制
- templatem名称限制与非A/M模式系统对象差异
- 数据库名称截断、大小写转换
- OWNER、TEMPLATE、ENCODING
- M模式默认UTF8、模板编码和template1限制
- SQL_ASCII行为、编码/locale兼容性
- GBK生僻字对象名、客户端/服务器编码转换
- GB18030_2022和ZHS16GBK边界
- LC_COLLATE、LC_CTYPE
- DBCOMPATIBILITY A/B/C/PG/M
- TABLESPACE、CONNECTION LIMIT、DBTIMEZONE

## Open questions

| ID | 内容 |
|---|---|
| `db_wave8_44_oq_runtime` | CREATE DATABASE在真实模板、编码、locale、兼容模式、表空间、连接限制和时区组合下的创建结果与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_44_v1.yaml
generated/core_sql_reference_wave8_44_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_44.py
python scripts/build_core_sql_reference_wave8_44.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_44.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行CREATE DATABASE或DDL。
