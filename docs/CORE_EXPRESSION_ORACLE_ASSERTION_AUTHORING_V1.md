# Core Expression Oracle Assertion Authoring V1

## 目标

从 executable oracle promotion 中生成断言编写清单。只有 promoted confirmed oracle 才会进入本清单；pending、needs_revision、blocked 一律排除。

当前 promotion 为空，因此 authoring sheet 也为空。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Promoted items | 0 |
| Authoring items | 0 |
| Pending authoring | 0 |
| Assertion drafts | 0 |
| Exact literal claims | 0 |
| Runtime verified | 0 |
| 数据库执行 | false |
| Execution authorized | false |

## 允许的 assertion types

当前 schema 只允许四类：

- `no_error`
- `row_count`
- `result_shape`
- `documented_semantics`

明确不支持：

```text
literal_equality
```

如需 literal equality，必须在后续 schema 中引入 captured actual value hash、actual value 和独立人工确认结论。

## 每个 promoted item 的 authoring fields

- `oracle_id`
- `candidate_id`
- `batch_id`
- `capability`
- `fact_refs`
- `sql`
- captured evidence
- `reviewer_conclusion`
- `authoring_status=pending_authoring`
- `assertion_drafts`
- `exact_literal_claims=[]`
- `runtime_verified=false`

每个 assertion draft 绑定：

- `assertion_id`
- `oracle_id`
- `candidate_id`
- `assertion_type`
- `fact_refs`
- `evidence_sha256`
- `status=pending_authoring`
- `expected_literal=null`
- `expected_literal_claim=null`

## 输出

```text
generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.json
generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.md
```

JSON 包含：

```text
authoring_sha256
```

## 机器校验

```bash
python scripts/build_core_expression_oracle_assertion_authoring.py
python scripts/build_core_expression_oracle_assertion_authoring.py --check
python -m pytest -q tests/test_core_expression_oracle_assertion_authoring.py
```

## 边界

- authoring sheet 不是 runtime receipt。
- pending authoring 不代表行为已验证。
- 本阶段不生成 SQL，不连接数据库。
- literal equality 需要未来 schema 与额外 review。
