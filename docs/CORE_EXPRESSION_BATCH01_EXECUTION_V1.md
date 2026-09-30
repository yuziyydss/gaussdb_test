# Core Expression Batch 01 Execution Plan V1

## 目标

把 `batch_01_scalar_types_conditionals` 的 23 个只读 SQL probe 从 batch plan 升级为正式 authorized execution plan，并定义对应的 runtime receipt schema 与独立 audit。

本模块不连接 GaussDB，不执行 SQL，不生成 receipt。

## 执行计划规模

| 指标 | 当前值 |
|---|---:|
| Batch | `batch_01_scalar_types_conditionals` |
| Steps | 23 |
| Candidate | 23 |
| fixture | 无 |
| compatibility | `any` |
| Oracle status | `needs_verification` |

## 执行前置要求

1. 只读 preflight 成功且 `finding_count=0`
2. Runtime gate 通过
3. CLI 与环境双重授权
4. 数据库启用
5. 整个批次使用单连接
6. 每个步骤生成 success / failure receipt
7. 首个失败步骤后停止
8. receipt 需要独立 audit

## Receipt schema

Receipt 会记录：

- `batch_id`
- `connected_database`
- `connected_user`
- `started_at` / `finished_at`
- authorization evidence
- preflight audit SHA-256
- `plan_sha256`
- `plan_step_ids`
- 每个步骤的 SQL、rows、notices、error、duration_ms
- `executed_steps`
- `runtime_verified_steps`
- `failed_steps`

失败策略：

- 每个成功步骤必须捕获 rows
- 失败步骤必须捕获 error
- 首个失败步骤后停止
- 有失败时整体 receipt 状态为 `failed`
- 全部 23 步成功才允许 `runtime_verified`

## 产物

```text
generated/core_expression_probe_batches_v1/batch_01_execution_plan.json
```

包含：

```text
plan_sha256
```

## 命令

构建 / 校验执行计划：

```bash
python scripts/build_core_expression_batch01_execution_plan.py
python scripts/build_core_expression_batch01_execution_plan.py --check
```

执行后独立审计 receipt：

```bash
python scripts/audit_core_expression_batch01_receipt.py \
  --receipt generated/core_expression_probe_batches_v1/batch_01_receipt.json \
  --output generated/core_expression_probe_batches_v1/batch_01_receipt_audit.json
```

## 边界

- execution plan 不是执行授权。
- receipt 不是完整输入域证明。
- audit 只验证计划身份、SQL 身份、授权声明和计数。
- Batch 01 通过不自动授权其他批次。
