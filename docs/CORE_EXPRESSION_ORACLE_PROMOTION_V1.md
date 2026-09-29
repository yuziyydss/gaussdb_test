# Core Expression Executable Oracle Promotion V1

## 目标

把 oracle review decision 中 `confirmed` 且证据完整的项提升为 executable oracle candidate。未确认项不能进入执行链。

当前基线没有任何 `confirmed` 决策，因此提升产物为空。

## 状态过滤

| Decision | 是否提升 |
|---|---:|
| `confirmed` | 是 |
| `pending` | 否 |
| `needs_revision` | 否 |
| `blocked` | 否 |

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Oracle decisions | 94 |
| Confirmed | 0 |
| Pending | 94 |
| Needs revision | 0 |
| Blocked | 0 |
| Promoted | 0 |
| Excluded | 94 |
| 数据库执行 | false |
| Runtime verified | false |

## Promoted item fields

每个 promoted item 保留：

- `oracle_id`
- `candidate_id`
- `batch_id`
- `capability`
- `fact_refs`
- `sql`
- `planned_assertions`
- reviewer evidence:
  - `reviewer`
  - `reviewed_at`
  - `rows_json_sha256`
  - `notices_sha256`
  - `sqlstate`
  - `server_version`
  - `sql_compatibility`
  - `notes`
- `reviewer_conclusion`
- `promotion_status=ready_for_assertion_authoring`
- `exact_literal_claims=[]`
- `runtime_verified=false`

## 输出

```text
generated/core_expression_oracle_promotion_v1/executable_oracles.json
```

包含：

```text
promotion_sha256
```

## 机器校验

```bash
python scripts/build_core_expression_oracle_promotion.py
python scripts/build_core_expression_oracle_promotion.py --check
python -m pytest -q tests/test_core_expression_oracle_promotion.py
```

## 边界

- promotion 不执行 SQL。
- promotion 不生成 runtime receipt。
- confirmed review 仍不等于完整输入域覆盖。
- promoted item 还需要单独撰写 executable assertions。
