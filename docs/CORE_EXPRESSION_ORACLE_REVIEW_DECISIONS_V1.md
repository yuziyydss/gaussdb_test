# Core Expression Oracle Review Decisions V1

## 目标

为 94 个 oracle review item 建立明确的 decision registry。它定义人工确认结果的合法状态、必须提供的证据，以及未确认项的失败关闭边界。

当前基线是：

```text
pending = 94
confirmed = 0
needs_revision = 0
blocked = 0
```

也就是还没有任何人工确认结果，不会伪造 reviewer 或 captured evidence。

## Decision status

| Status | 用途 | 必须字段 |
|---|---|---|
| `pending` | 尚未人工确认 | 无 evidence、无 reason |
| `confirmed` | 实际结果与 facts 一致 | reviewer、reviewed_at、rows hash、notices hash、SQLSTATE、server version、sql compatibility、reviewer conclusion |
| `needs_revision` | SQL 或 oracle 需要修改 | reason |
| `blocked` | 目标环境或权限阻断 | reason |

## Evidence 要求

`confirmed` 必须提供：

- `reviewer`
- `reviewed_at`
- `rows_json_sha256`
- `notices_sha256`
- `sqlstate`
- `server_version`
- `sql_compatibility`
- reviewer conclusion

Hash 必须是 64 位十六进制；关键字段不能为空。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Review steps | 94 |
| Decisions | 94 |
| Pending | 94 |
| Confirmed | 0 |
| Needs revision | 0 |
| Blocked | 0 |
| Executable oracle candidates | 0 |
| 数据库执行 | false |
| Runtime verified | false |

## 输出

```text
generated/core_expression_oracle_review_decisions_v1/review_decisions.json
```

## 机器校验

```bash
python scripts/build_core_expression_oracle_review_decisions.py
python scripts/build_core_expression_oracle_review_decisions.py --check
python -m pytest -q tests/test_core_expression_oracle_review_decision.py
```

校验内容：

- decisions 必须覆盖 review sheet 全部 94 项
- 每个 decision 状态合法
- pending 不能携带 evidence 或 reason
- confirmed 必须携带完整 evidence 和 reason
- needs_revision / blocked 必须有 reason
- summary 状态计数自动对齐
- 不得声明 runtime executed / verified

## 边界

- 决策基线不执行 SQL。
- `confirmed` 仍不代表完整输入域覆盖。
- executable oracle assertions 需要单独 promotion artifact。
