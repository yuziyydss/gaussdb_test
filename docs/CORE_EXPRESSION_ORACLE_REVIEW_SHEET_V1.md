# Core Expression Oracle Review Sheet V1

## 目标

把 94 个 SQL probe 的 expected oracle 草案按能力域整理成人工确认清单。review sheet 用于逐项确认：

- 实际执行是否成功
- rows / notices / SQLSTATE 是否完整捕获
- 结果语义是否与 Wave 1A / 1B facts 一致
- 是否存在兼容模式、编码或版本限制
- 是否可以升级为 executable oracle assertion

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Oracle draft steps | 94 |
| Review steps | 94 |
| Capability groups | 14 |
| Pending review | 94 |
| Verified | 0 |
| Exact value claims | 0 |
| 数据库执行 | false |
| Runtime verified | false |

## Capability groups

| Capability | Steps |
|---|---:|
| `aggregate_domain` | 8 |
| `array_domain` | 9 |
| `boolean_and_bit` | 5 |
| `conditional_domain` | 3 |
| `datetime_functions` | 4 |
| `expression_semantics` | 6 |
| `hll_domain` | 6 |
| `json_domain` | 9 |
| `numeric_functions` | 6 |
| `numeric_type_domain` | 3 |
| `range_domain` | 7 |
| `string_domain` | 11 |
| `type_conversion` | 9 |
| `window_domain` | 8 |

## Review questions

每个步骤都要回答：

1. 实际执行是否成功且无非预期错误？
2. 结果行与字段是否已完整捕获？
3. SQLSTATE 是否已记录？
4. 结果语义是否与引用 facts 一致？
5. 是否存在兼容模式、编码或版本限制？

## 输出

```text
generated/core_expression_oracle_review_sheet_v1/review_sheet.json
generated/core_expression_oracle_review_sheet_v1/review_sheet.md
```

JSON 产物包含：

```text
sheet_sha256
```

Markdown 是按 capability 分组的人工复核表；JSON 是机器对账产物。

## 机器校验

```bash
python scripts/build_core_expression_oracle_review_sheet.py
python scripts/build_core_expression_oracle_review_sheet.py --check
python -m pytest -q tests/test_core_expression_oracle_review_sheet.py
```

## 边界

- pending review 不代表数据库行为已验证。
- 完成 review 必须记录实际 rows、notices、SQLSTATE 和 reviewer 结论。
- 不得在未捕获目标数据库证据时填写 expected value。
- review sheet 不是 runtime receipt。
