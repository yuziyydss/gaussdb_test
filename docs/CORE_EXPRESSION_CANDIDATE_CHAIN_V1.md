# Core Expression Candidate Chain V1

## 目标

把 Wave 1A / Wave 1B 抽取出的 201 条 facts 绑定到 fixture 和静态 SQL candidate，形成可审计的表达式候选链路。

它解决的是：**fact 只是文档陈述，如何进入可审查、可追踪、后续可执行的 SQL 候选计划。**

它不连接 GaussDB，不执行 SQL，不生成 runtime receipt。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 输入 facts | 246 |
| 静态 SQL candidates | 171 |
| fixture | 3 |
| candidate 中引用 fact 次数 | 247 |
| 覆盖 facts | 246 / 246 |
| 未覆盖 facts | 0 |
| candidate SQL 全部只读 | true |
| 数据库执行 | false |

## 输入

```text
docs/compat_facts/core_type_expression_domain_v1.yaml
docs/compat_facts/core_function_operator_domain_v1.yaml
docs/compat_facts/core_function_operator_wave2a_v1.yaml
```

## fixture

| Fixture | 用途 |
|---|---|
| `no_fixture` | 字面量、内联 VALUES、函数表达式候选 |
| `core_expr_fixture` | 一行多类型临时对象：integer、numeric、varchar、timestamp、text[]、int4range、jsonb |
| `rownum_fixture` | 10行临时对象，用于 ROWNUM 分页和赋值边界 |

## 覆盖能力

候选按 capability 分组：

- `numeric_type_domain`
- `boolean_and_bit`
- `string_domain`
- `numeric_functions`
- `datetime_functions`
- `type_conversion`
- `special_types`
- `json_domain`
- `hll_domain`
- `array_domain`
- `range_domain`
- `aggregate_domain`
- `window_domain`
- `conditional_domain`
- `expression_semantics`
- `geometry_domain`
- `network_domain`
- `textsearch_domain`
- `sequence_metadata`
- `security_metadata`
- `srf_domain`
- `overload_metadata`
- `system_info_domain`
- `hash_domain`
- `xml_domain`
- `xmltype_domain`
- `sqltool_metadata`
- `rowid_metadata`

覆盖代表：

- 整数边界、NUMERIC精度、money、浮点
- 字符长度、pad、substr、regex、encoding、hash、bpchar比较
- 当前时间、extract、add_months、B模式date函数、timezone
- JSON访问、谓词、变更、聚合、类型
- HLL哈希、聚合、元数据
- 数组构造、集合运算、元数据、`unnest`
- range构造、包含、重叠、边界、集合运算
- 聚集、KEEP、CHECKSUM、统计函数
- 窗口排名、LAG/LEAD、FIRST/LAST_VALUE、NTH_VALUE、过滤下推
- CASE/DECODE/NVL/IF等条件表达式
- ROWNUM、NULL比较、类型推导和数组NULL语义

## 输出

```text
generated/core_expression_candidate_chain_v1/candidates.json
```

每个 candidate 包含：

- `id`
- `capability`
- `fact_refs`
- `fixture_ref`
- `fixture_setup_sql`
- `fixture_teardown_sql`
- `sql`
- `expected_kind`
- `compatibility_mode`
- `oracle_status=needs_verification`
- `execution_status=not_executed`

## 机器校验

```bash
python scripts/build_core_expression_candidate_chain.py
python scripts/build_core_expression_candidate_chain.py --check
python -m pytest -q tests/test_core_expression_candidate_chain.py
```

校验内容：

- Wave 1A / 1B 的 201 个 fact 全部存在
- 每个 candidate 的 `fact_refs` 都能解析
- 150 个 candidate ID 和 SQL 均唯一
- 所有 candidate SQL 都是单条 `SELECT` / `WITH`
- 禁止 DML、DDL、GRANT / REVOKE、DBMS 包
- fixture 的 setup / teardown 成对
- fact 覆盖 201 / 201
- 产物与当前输入无漂移

## 边界

- `coverage_mode=representative`：候选代表事实语义，不等于完整输入域。
- 生成 SQL 不等于执行 SQL。
- 执行候选必须另行授权、捕获 receipt 并做独立 audit。
- 兼容模式敏感候选标有 A / B / C / PG / M；未标明时仍需确认目标环境。
