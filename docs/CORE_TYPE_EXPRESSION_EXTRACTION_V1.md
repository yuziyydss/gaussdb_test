# Core Type & Expression Domain Extraction V1

## 目标

这是“核心表达式与类型域”细抽取的第一阶段（Wave 1A）。范围覆盖：

```text
1.3 数据类型
1.5 常量和宏
1.7 表达式
1.8 伪列
1.9 类型转换
```

目标是把这些章节从“全书章节目录化”推进为“可用于 value domain、fixture、表达式能力和类型转换 Oracle 的结构化事实”。

当前不包含 `1.6 函数和操作符`；该部分作为 Wave 1B 单独推进。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 章节 | 38 |
| 物理页 | 122 |
| 结构化 facts | 99 |
| open questions | 3 |
| source resolved | 38 / 38 |
| chapter has facts | 38 / 38 |

## 覆盖章节

- `1.3.1`–`1.3.25`：数值、货币、布尔、字符、二进制、日期时间、几何、网络、位串、UUID、文本检索、JSON/JSONB、HLL、范围、OID、伪类型、账本 HASH、XML、XMLTYPE、SET、aclitem、数组、向量、向量化引擎类型、ROWID
- `1.5`：常量和宏
- `1.7.1`–`1.7.6`：简单表达式、条件表达式、子查询表达式、数组表达式、行表达式、interval 表达式
- `1.8`：ROWNUM 伪列
- `1.9.1`–`1.9.5`：类型转换概述、操作符解析、函数转换、值存储、UNION/CASE 类型推导

## 抽取产物

```text
docs/compat_facts/core_type_expression_domain_v1.yaml
generated/core_type_expression_domain_v1/manifest.json
```

YAML 中每个 fact 都有：

- `id`
- `type`：syntax / constraint / environment / behavior_oracle
- `statement`
- `source_anchor`
- `source_refs`
- `status`

manifest 会记录每个章节的：

- outline path
- physical / printed page range
- catalog source relpath
- resolved corpus relpath
- `chapter_sha256`
- resolved file SHA-256
- 行数
- 该章节被引用的 fact 数

## 机器校验

```bash
python scripts/build_core_type_expression_domain.py
python scripts/build_core_type_expression_domain.py --check
python -m pytest -q tests/test_core_type_expression_domain.py
```

## 关键事实类别

### 类型域

- 整数/UNSIGNED/ZEROFILL边界
- NUMERIC / DECIMAL / NUMBER精度与B模式默认值
- SERIAL语义与临时表限制
- 浮点精度风险
- CHAR / VARCHAR / TEXT / CLOB长度与截断
- BYTEA / RAW / BLOB / 密态二进制
- DATE / TIME / TIMESTAMP / TIMESTAMPTZ / SMALLDATETIME / INTERVAL / DATEA
- JSON / JSONB、HLL、range、array、vector、ROWID
- XML / XMLTYPE的操作禁用矩阵

### 表达式与类型转换

- `BETWEEN`
- `IS NULL`
- `IS DISTINCT FROM`
- `<=>`
- CASE / NULLIF / GREATEST / LEAST / NVL
- EXISTS / IN / ANY / SOME / ALL
- 数组表达式 NULL 语义
- 行比较
- B模式 interval 表达式
- 操作符与函数类型解析
- `pg_cast`
- 值存储长度转换
- UNION / CASE / ARRAY / VALUES / GREATEST / LEAST类型推导
- A/C模式特殊类型推导

## Open questions

| ID | 内容 |
|---|---|
| `cte_oq_vector_engine_full_type_table` | `1.3.24` 的向量化引擎支持类型表需要逐行展开为机器可判定集合 |
| `cte_oq_locale_money_format` | money 的 locale 输入输出矩阵需实机确认 |
| `cte_oq_xml_full_disable_matrix` | XML / XMLTYPE 的完整禁用矩阵建议后续生成独立兼容矩阵 |

## 边界

- 当前只做原文事实抽取，不生成 SQL。
- 不宣称数据库行为验证通过。
- `1.6 函数和操作符` 留待 Wave 1B。
- locale、驱动、向量化引擎和 XML 完整矩阵需要后续专项验证。
