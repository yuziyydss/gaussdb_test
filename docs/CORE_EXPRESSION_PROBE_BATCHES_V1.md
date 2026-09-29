# Core Expression Probe Batches V1

## 目标

把 `Core Expression Static SQL Probe Plan V1` 的 94 个只读 probe 拆成 4 个可授权审查批次。每个批次都有独立步骤、独立候选集合与完整 dry-run 边界。

当前不连接 GaussDB，不执行 SQL，不生成 runtime receipt。

## 批次规模

| Batch | 能力域 | Steps |
|---|---|---:|
| `batch_01_scalar_types_conditionals` | numeric types、boolean/bit、numeric functions、conditionals、expression semantics | 23 |
| `batch_02_strings_and_conversion` | string functions、pattern matching、encoding、hash、type conversion | 20 |
| `batch_03_structured_types` | JSON/JSONB、array、range、HLL | 31 |
| `batch_04_aggregates_windows_datetime` | deterministic datetime、aggregate、window | 20 |
| 合计 |  | **94** |

## 每个 step 的边界

每个 step 保留：

- 原probe plan order
- batch order
- candidate id
- capability
- fact_refs
- 单条只读 SQL
- `fixture_ref=no_fixture`
- `compatibility_mode=any`
- `oracle_status=needs_verification`
- `execution_status=not_executed`

## 执行要求

授权执行前必须满足：

1. 只读 preflight 成功且 finding 为 0
2. Runtime gate 通过
3. CLI 与环境双重授权
4. 每个批次单独连接
5. 每个步骤生成成功/失败 receipt
6. receipt 需要独立 audit

## 输出

```text
generated/core_expression_probe_batches_v1/batches.json
```

产物包含：

```text
plan_sha256
```

用于检测 probe plan 或批次切分规则漂移。

## 机器校验

```bash
python scripts/build_core_expression_probe_batches.py
python scripts/build_core_expression_probe_batches.py --check
python -m pytest -q tests/test_core_expression_probe_batches.py
```

## 边界

- Batch plan 不是执行授权。
- Batch plan 不是 runtime receipt。
- Representative SQL 不等于完整输入域覆盖。
- 执行后仍需独立 receipt audit 才能声称 runtime verified。
