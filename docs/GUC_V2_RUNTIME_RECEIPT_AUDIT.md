# GUC V2 Runtime Receipt Audit

## 目标

`scripts/audit_guc_v2_runtime_receipt.py` 将 GUC V2 runtime receipt 与原始 dry-run plan 做独立审计。它不信任 receipt 自身的 `runtime_verified` 声明，而是逐项核对：

- receipt schema
- plan SHA-256
- plan unit IDs
- plan step count
- runtime_verified / failed_units / executed_steps 计数
- 每个单元的步骤状态
- GUC overlay 是否恢复原值
- SQL 是否包含禁止操作
- 成功步骤是否误带错误、失败步骤是否缺少错误

## 使用

```bash
python scripts/audit_guc_v2_runtime_receipt.py \
  --receipt generated/guc_environment_v2/runtime_receipt.json \
  --plan generated/guc_environment_v2/runtime_dry_run.json \
  --output generated/guc_environment_v2/runtime_receipt_audit.json
```

默认 plan 路径：

```text
generated/guc_environment_v2/runtime_dry_run.json
```

## 当前状态

- 当前没有 GaussDB 连接
- 当前没有 runtime receipt
- 当前没有 runtime receipt audit
- 当前不能宣称任何 GUC V2 行为验证通过

## 边界

- 审计只验证 receipt 与 plan 的一致性和安全边界。
- 审计不重新执行 SQL。
- 审计不证明未测试的 GUC 参数、值或组合。
- 审计不替代数据库侧授权或连接安全审查。
