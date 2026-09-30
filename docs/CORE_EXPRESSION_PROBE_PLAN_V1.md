# Core Expression Static SQL Probe Plan V1

## 目标

从 `Core Expression Candidate Chain V1` 的 150 个静态候选中，筛选出第一批可进入授权执行审查的 SQL probe。

筛选目标是：

- 兼容模式无关
- 无 fixture / 无对象依赖
- 无状态、无副作用
- 单条只读 SQL
- 保留完整排除审计

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 候选总数 | 150 |
| 第一批入选 | 94 |
| 排除候选 | 56 |
| dry-run 步骤 | 94 |
| fixture-free 步骤 | 94 |
| 兼容模式无关步骤 | 94 |
| 只读步骤 | 94 |
| 数据库执行 | false |
| 执行授权 | false |
| runtime verified | false |

## 选择规则

入选必须满足：

1. `compatibility_mode=any`
2. `fixture_ref=no_fixture`
3. `expected_kind=value`
4. capability 属于第一批 allowlist
5. 不包含 stateful time/user 函数
6. 不包含兼容模式专用函数
7. 不包含 resource-heavy 或 mode-dependent token

排除示例：

- `CURRENT_TIMESTAMP` / `LOCALTIMESTAMP`
- `LPAD_S`
- `SHA2`
- `DECODE`
- `NVL` / `NVL2`
- `IF` / `IFNULL`
- `EMPTY_BLOB` / `EMPTY_CLOB`
- `KEEP`
- `ROWID` / `HASH16` / `HASH32`
- `GROUP_CONCAT`
- `TO_JSONB('')`

## 覆盖 capability

| Capability | 入选数 |
|---|---:|
| `string_domain` | 13 |
| `json_domain` | 10 |
| `type_conversion` | 9 |
| `array_domain` | 9 |
| `aggregate_domain` | 8 |
| `window_domain` | 8 |
| `range_domain` | 7 |
| `numeric_functions` | 6 |
| `hll_domain` | 6 |
| `expression_semantics` | 6 |
| `boolean_and_bit` | 5 |
| `datetime_functions` | 4 |
| `numeric_type_domain` | 3 |
| `conditional_domain` | 3 |

## 输出

```text
generated/core_expression_probe_plan_v1/dry_run.json
```

每个 step 包含：

- `plan_order`
- `candidate_id`
- `capability`
- `fact_refs`
- `sql`
- `expected_kind=value`
- `compatibility_mode=any`
- `fixture_ref=no_fixture`
- `oracle_status=needs_verification`
- `execution_status=not_executed`

同时记录：

```text
plan_sha256
```

## 机器校验

```bash
python scripts/build_core_expression_probe_plan.py
python scripts/build_core_expression_probe_plan.py --check
python -m pytest -q tests/test_core_expression_probe_plan.py
```

## 边界

- 本产物是 dry-run plan，不是执行授权。
- plan 中的 SQL 不执行，也不产生 runtime receipt。
- 代表性 SQL 不等于完整输入域覆盖。
- 实际执行必须先完成 Advanced Package/Preflight gate 要求，并单独授权。
