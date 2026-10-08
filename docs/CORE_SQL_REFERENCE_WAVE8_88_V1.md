# SQL Reference Wave 8-88 Extraction V1

## 目标

抽取 C 族第六批：`CREATE GLOBAL INDEX`、`CREATE GROUP`、`CREATE INCREMENTAL MATERIALIZED VIEW`、`CREATE LANGUAGE` 与 `CREATE LLM`。

## 当前范围

| Section | 页数 | 主题 |
|---|---:|---|
| `1.13.9.24` | 1 | CREATE GLOBAL INDEX |
| `1.13.9.25` | 4 | CREATE GROUP |
| `1.13.9.26` | 3 | CREATE INCREMENTAL MATERIALIZED VIEW |
| `1.13.9.28` | 1 | CREATE LANGUAGE |
| `1.13.9.29` | 2 | CREATE LLM |

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 5 |
| 物理页 | 8 |
| 结构化 facts | 20 |
| Open questions | 1 |
| source resolved | 5 / 5 |
| chapter has facts | 5 / 5 |

## 覆盖能力

- CREATE GLOBAL INDEX GSI定义与基表非分布列查询/约束价值（当前形态不支持）
- CREATE GROUP为CREATE ROLE别名（非SQL标准）、完整option子句、GROUP/ROLE/USER三者差异行为基线
- 增量物化视图持久化初始化查询、列/表空间指定
- 查询限制（仅简单过滤与UNION ALL）与表限制（DBLINK/临时表/Ustore）、DDL与IUD限制、REFRESH同步
- 增量刷新行为基线（INSERT后0 rows→REFRESH后1行）
- CREATE LANGUAGE当前形态暂不支持
- CREATE LLM三种模型（QUERY/EMBED/RERANK）语法与OpenAI/Jina API格式要求
- HTTPS/CA证书、API KEY加密（gs_guc generate obsserver）、63/64/256字节参数规则
- SYSTEM_PROMPT tokens限制、EXTRA_PARAMS透传与temperature/max_tokens校验
- 三类模型注册行为基线

## Open questions

| ID | 内容 |
|---|---|
| `create_llm_wave8_88_oq_runtime` | GSI能力、用户组/增量物化视图操作及LLM三类模型服务注册在真实外部服务、HTTPS证书和资源规格组合下的完整行为与错误矩阵需授权环境实机验证。 |

## 产物

```text
docs/compat_facts/core_sql_reference_wave8_88_v1.yaml
generated/core_sql_reference_wave8_88_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_sql_reference_wave8_88.py
python scripts/build_core_sql_reference_wave8_88.py --check
python -m pytest -q tests/test_core_sql_reference_wave8_88.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不宣称数据库行为验证通过。
- 不连接数据库、不执行GSI/用户组/物化视图/LLM语句。
