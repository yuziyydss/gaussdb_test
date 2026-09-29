# Core Function & Operator Domain Extraction V1

## 目标

这是核心函数与操作符细抽取第一阶段（Wave 1B）。范围覆盖 16 个高价值章节：

```text
1.6.1 逻辑操作符
1.6.2 比较操作符
1.6.3 字符处理函数和操作符
1.6.4 二进制字符串函数和操作符
1.6.5 位串函数和操作符
1.6.6 模式匹配操作符
1.6.7 数字操作函数和操作符
1.6.8 时间和日期处理函数和操作符
1.6.9 类型转换函数
1.6.13 JSON/JSONB函数和操作符
1.6.14 HLL函数和操作符
1.6.16 数组函数和操作符
1.6.17 范围函数和操作符
1.6.18 聚集函数
1.6.19 窗口函数
1.6.25 条件表达式函数
```

当前不包含 `1.6.10`–`1.6.12`、`1.6.15`、`1.6.20` 以后非 P0/P1 子集。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 章节 | 16 |
| 物理页 | 312 |
| 结构化 facts | 102 |
| open questions | 4 |
| source resolved | 16 / 16 |
| chapter has facts | 16 / 16 |

## 抽取产物

```text
docs/compat_facts/core_function_operator_domain_v1.yaml
generated/core_function_operator_domain_v1/manifest.json
```

manifest 记录每个章节的 outline path、页码、catalog relpath、resolved relpath、chapter SHA、resolved file SHA、行数和 fact 数。

## 机器校验

```bash
python scripts/build_core_function_operator_domain.py
python scripts/build_core_function_operator_domain.py --check
python -m pytest -q tests/test_core_function_operator_domain.py
```

## 覆盖能力

- 逻辑与比较操作符，包括三值逻辑和 `!=` 空格陷阱
- 二进制字符串与位串函数
- 字符函数核心清单、B模式辅助函数、正则族、编码转换、hash函数、bpchar比较GUC
- 数字操作符与常用数学函数
- 日期/时间操作符、当前时间函数、Oracle风格函数、B风格函数、格式化函数
- 类型转换：`to_char/to_nchar/to_date/to_number/to_timestamp`、interval转换、内部转换器
- JSON/JSONB操作符、GIN索引、访问/遍历/构造/record映射/变更/搜索/聚合/谓词
- HLL哈希、元数据、构造、基数、聚合、比较
- 数组操作符、集合运算、元数据、排序、变更、`string_to_array`、`unnest`
- 范围操作符、比较规则、空范围行为、范围函数、DATEA限制
- 聚集函数、KEEP、median/default、array/string聚合、统计聚集、CHECKSUM
- 窗口函数：排序、过滤下推、排名、LAG/LEAD、FIRST/LAST_VALUE、DELTA、RATIO_TO_REPORT、NTH_VALUE、KEEP
- 条件表达式：COALESCE、DECODE、NULLIF、NVL/NVL2、GREATEST/LEAST、LNNVL、ISNULL、IF/IFNULL

## Open questions

| ID | 内容 |
|---|---|
| `fo_oq_string_full_signatures` | `1.6.3` 有276个函数条目，后续需展开完整签名与参数矩阵 |
| `fo_oq_datetime_full_signature_matrix` | 日期函数需拆分A/B/PG模式签名矩阵 |
| `fo_oq_json_function_output_matrix` | JSON修改、搜索、路径和NULL边界需实机Oracle矩阵 |
| `fo_oq_range_boundary_matrix` | 范围运算、空范围和DATEA限制需边界对测试 |

## 边界

- 当前只做原文事实抽取，不生成 SQL。
- 不宣称数据库行为验证通过。
- 未覆盖的函数/操作符子集需后续专项推进。
