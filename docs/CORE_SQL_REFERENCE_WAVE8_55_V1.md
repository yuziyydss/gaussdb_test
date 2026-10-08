# SQL Reference Wave 8-55 Extraction V1

## 目标

合并抽取 `CREATE/ALTER/DROP TEXT SEARCH DICTIONARY`，完成全文检索词典模板、参数、路径、元数据修改和删除依赖闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.55` | 7 | CREATE TEXT SEARCH DICTIONARY |
| `1.13.7.41` | 3 | ALTER TEXT SEARCH DICTIONARY |
| `1.13.10.44` | 2 | DROP TEXT SEARCH DICTIONARY |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 12 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- SYSADMIN创建权限、pg_temp限制和FILEPATH刷新要求
- Simple、Synonym、Thesaurus、Ispell、Snowball、Tokenweight模板
- 各模板参数、定义文件、停用词、大小写和匹配规则
- 词典名称长度、字符串参数引号和定义文件名规则
- 全文检索配置、词典映射与`ts_debug`测试流程
- ALTER参数、TEMPLATE限制、FILEPATH刷新与计划缓存风险
- RENAME TO、SET SCHEMA、OWNER TO
- DROP的权限、预定义模板限制、`IF EXISTS`、CASCADE/RESTRICT

## Open questions

| ID | 内容 |
|---|---|
| `tsdict_wave8_55_oq_runtime` | 全文检索词典在真实模板、自定义文件路径、词典链、计划缓存和DROP级联组合下的解析与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_55_v1.yaml
generated/core_sql_reference_wave8_55_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_55.py
python scripts/build_core_sql_reference_wave8_55.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_55.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行词典DDL。
