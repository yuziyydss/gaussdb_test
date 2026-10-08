# SQL Reference Wave 8-54 Extraction V1

## 目标

合并抽取 `CREATE/ALTER/DROP TEXT SEARCH CONFIGURATION`，完成全文检索配置的解析器、映射、元数据修改、计划缓存和删除依赖闭环。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.54` | 2 | CREATE TEXT SEARCH CONFIGURATION |
| `1.13.7.40` | 5 | ALTER TEXT SEARCH CONFIGURATION |
| `1.13.10.43` | 2 | DROP TEXT SEARCH CONFIGURATION |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 3 |
| 物理页 | 9 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 3 / 3 |
| chapter has facts | 3 / 3 |

## 覆盖能力

- 文本搜索配置语义与内部功能边界
- PARSER-only、COPY复制和PARSER/COPY互斥
- 模式/属主规则
- default与ngram解析器配置参数
- 已引用配置修改限制和owner要求
- ADD/ALTER/REPLACE/DROP MAPPING语义
- `pg_ts_config_map`替换条件
- 计划缓存与PBE/自动参数化风险
- OWNER TO、RENAME TO、SET SCHEMA、SET/RESET
- DROP的`IF EXISTS`、CASCADE/RESTRICT

## Open questions

| ID | 内容 |
|---|---|
| `tsconf_wave8_54_oq_runtime` | 文本搜索配置在真实解析器、映射、计划缓存、依赖索引和DROP级联组合下的行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_54_v1.yaml
generated/core_sql_reference_wave8_54_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_54.py
python scripts/build_core_sql_reference_wave8_54.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_54.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行文本搜索配置DDL。
