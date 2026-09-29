# Core Expression Batch Execution Plans V1

## 目标

为 4 个核心表达式 probe batch 建立统一的 authorized execution plan 和 receipt audit schema。它把 dry-run batch plan 升级为可授权执行计划，但不连接 GaussDB、不执行 SQL、不生成 receipt。

## 批次范围

| Batch | Steps | Plan artifact |
|---|---:|---|
| `batch_01_scalar_types_conditionals` | 23 | `batch_01_scalar_types_conditionals_execution_plan.json` |
| `batch_02_strings_and_conversion` | 20 | `batch_02_strings_and_conversion_execution_plan.json` |
| `batch_03_structured_types` | 31 | `batch_03_structured_types_execution_plan.json` |
| `batch_04_aggregates_windows_datetime` | 20 | `batch_04_aggregates_windows_datetime_execution_plan.json` |
| 合计 | **94** |  |

注意：Batch 01 保留了较早的专用模型与脚本；本通用模型也支持 Batch 01，用于后续统一管理。

## Execution plan

每个 execution plan 绑定：

- `batch_id`
- batch artifact SHA-256
- batch plan SHA-256
- 顺序化 steps
- 每 step 的 `candidate_id`
- `capability`
- `fact_refs`
- 单条只读 SQL
- `fixture_ref=no_fixture`
- `compatibility_mode=any`
- `oracle_status=needs_verification`

## 授权与失败策略

执行前必须满足：

1. 只读 preflight 成功，finding 为 0
2. Runtime gate 通过
3. CLI 与环境双重授权
4. 数据库启用
5. 单连接执行整个批次
6. 每步生成 success / failure receipt
7. 首个失败步骤后停止
8. receipt 独立 audit

## Receipt schema

Receipt 记录：

- `batch_id`
- `connected_database`
- `connected_user`
- `started_at` / `finished_at`
- authorization evidence
- preflight audit SHA-256
- `plan_sha256`
- `plan_step_ids`
- 每步 SQL、rows、notices、error、duration_ms
- `executed_steps`
- `runtime_verified_steps`
- `failed_steps`

约束：

- 成功步骤必须捕获 rows
- 失败步骤必须捕获 error
- 首个失败后不得继续执行
- 有失败时 receipt 状态为 `failed`
- 全部步骤成功才允许 `runtime_verified`

## 命令

构建 / 校验任一批次：

```bash
python scripts/build_core_expression_batch_execution_plan.py \
  --batch-id batch_02_strings_and_conversion

python scripts/build_core_expression_batch_execution_plan.py \
  --batch-id batch_02_strings_and_conversion --check
```

审计 receipt：

```bash
python scripts/audit_core_expression_batch_receipt.py \
  --batch-id batch_02_strings_and_conversion \
  --receipt generated/core_expression_probe_batches_v1/batch_02_strings_and_conversion_receipt.json \
  --output generated/core_expression_probe_batches_v1/batch_02_strings_and_conversion_receipt_audit.json
```

## 边界

- execution plan 不是执行授权。
- receipt schema 不是 runtime evidence。
- receipt audit 只验证计划身份、SQL 身份、授权声明和计数。
- 单批通过不自动授权其他批次。
