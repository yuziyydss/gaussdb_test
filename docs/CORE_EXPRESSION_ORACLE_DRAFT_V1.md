# Core Expression Expected Oracle Draft V1

## 目标

为 94 个核心表达式 SQL probe 建立 expected oracle 草案。它回答：

- 每个步骤要捕获哪些数据库证据？
- 每个步骤应该对照哪些 Wave 1A / 1B facts 复核？
- 哪些输出还没有具体 expected value？

它不连接 GaussDB，不执行 SQL，也不伪造结果。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| SQL probe steps | 94 |
| Expected oracle drafts | 94 |
| Batch | 4 |
| 引用 fact 次数 | 128 |
| 唯一 fact 引用 | 102 |
| 具体 expected value claims | **0** |
| Oracle status | `needs_verification` |
| Draft status | `ready_for_review` |
| 数据库执行 | false |
| Runtime verified | false |

## 每个 draft step

记录：

- `oracle_id`
- `batch_id`
- `batch_order`
- `plan_order`
- `candidate_id`
- `capability`
- `fact_refs`
- `sql`
- `expected_shape=to_be_captured`
- `expected_literal_claims=[]`
- planned assertions
- capture spec
- `oracle_status=needs_verification`

## Planned assertions

每个步骤捕获后复核：

1. `no_unexpected_error`
2. `rows_are_captured`
3. `sqlstate_is_captured`
4. `result_semantics_are_reviewed_against_fact_refs`

## Capture spec

每个步骤要求捕获：

- rows
- notices
- error
- SQLSTATE
- duration_ms
- server version
- `sql_compatibility`

## 输出

```text
generated/core_expression_oracle_draft_v1/oracle_draft.json
```

产物包含：

```text
draft_sha256
```

## 机器校验

```bash
python scripts/build_core_expression_oracle_draft.py
python scripts/build_core_expression_oracle_draft.py --check
python -m pytest -q tests/test_core_expression_oracle_draft.py
```

## 边界

- Oracle draft 不是 runtime receipt。
- 没有具体 expected value 不等于行为已验证。
- fact reference 不等于目标数据库行为证明。
- 后续必须用真实捕获结果把 draft 升级为 executable oracle。
