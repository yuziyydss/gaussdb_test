# Core Expression Oracle Capture V1

## 目标

为 94 个核心表达式 SQL probe 建立标准 evidence capture registry。它定义将来真实执行时必须捕获的字段、canonical evidence hash 规则和失败关闭约束。

当前基线：

```text
pending_capture = 94
captured = 0
capture_failed = 0
```

不会伪造 rows、notices、SQLSTATE、server version 或 runtime evidence。

## Capture 字段

| 字段 | 类型 / 约束 |
|---|---|
| `rows` | `List[List[Any]]`，按数据库返回顺序 |
| `notices` | `List[str]`，按数据库发出顺序 |
| `error` | 失败时错误文本；成功时为空 |
| `sqlstate` | SQLSTATE 或 vendor status code |
| `duration_ms` | 非负整数 |
| `server_version` | `version()` 返回值 |
| `sql_compatibility` | `current_setting('sql_compatibility', true)` |
| `connected_database` | `current_database()` |
| `connected_user` | `current_user()` |

## Capture 状态

| Status | 约束 |
|---|---|
| `pending_capture` | 不能包含 rows / notices / error / SQLSTATE / duration / evidence hash / environment |
| `captured` | 必须有 rows、SQLSTATE、完整 environment、evidence hash；不能有 error |
| `capture_failed` | 必须有 error、SQLSTATE、evidence hash；不能有 rows |

## Evidence hash

Canonical payload 包含：

```text
sql
rows
notices
error
sqlstate
duration_ms
environment
```

Canonical JSON 规则：

```text
sort_keys = true
separators = (',', ':')
ensure_ascii = false
```

Hash：

```text
SHA-256(canonical JSON)
```

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Capture slots | 94 |
| Pending capture | 94 |
| Captured | 0 |
| Capture failed | 0 |
| Evidence count | 0 |
| 数据库执行 | false |
| Runtime verified | false |

## 输出

```text
generated/core_expression_oracle_capture_v1/captures.json
```

## 机器校验

```bash
python scripts/build_core_expression_oracle_capture.py
python scripts/build_core_expression_oracle_capture.py --check
python -m pytest -q tests/test_core_expression_oracle_capture.py
```

## 边界

- capture registry 不是 runtime receipt。
- captured result 也不代表 oracle review decision。
- evidence 必须经 oracle review 后才可能进入 executable oracle promotion。
