# Runtime Validation Pilot V1

## 目标

`core/runtime_validation_pilot.py` 将 GUC session overlay 与高级包 runtime candidate 合并为一个可授权执行的最小试点。

当前试点包含：

- 2 个 GUC overlay
- 5 个高级包 runtime candidate
- 共 7 个执行单元
- 共 15 个执行步骤

## 单元

| Unit | 类型 | 目标 |
|---|---|---|
| `runtime_guc_enable_seqscan_off` | GUC overlay | `enable_seqscan` 从 `on` 改为 `off`，再恢复 `on` |
| `runtime_guc_default_transaction_read_only_on` | GUC overlay | `default_transaction_read_only` 从 `off` 改为 `on`，再恢复 `off` |
| `adv_case_dbe_output_direct_print` | Advanced package | `DBE_OUTPUT.PRINT` + `PRINT_LINE` |
| `adv_case_dbe_output_buffer_lifecycle` | Advanced package | `DBE_OUTPUT.ENABLE` + `PUT` + `NEW_LINE` |
| `adv_case_dbe_raw_varchar_roundtrip` | Advanced package | `DBE_RAW` VARCHAR2 ↔ RAW |
| `adv_case_dbe_raw_integer_roundtrip` | Advanced package | `DBE_RAW` INTEGER ↔ RAW |
| `adv_case_dbe_sql_select_lifecycle` | Advanced package | `DBE_SQL` 动态 SELECT 生命周期 |

## Dry run

默认命令只生成计划，不连接数据库：

```bash
python scripts/run_runtime_validation_pilot.py \
  --output generated/runtime_validation_pilot/dry_run.json
```

当前 dry-run 文件：

- `generated/runtime_validation_pilot/dry_run.json`
- `database_executed=false`
- `execution_authorized=false`
- `runtime_verified=0`

## 预检

在授权执行前，建议先运行只读预检：

```bash
python scripts/run_runtime_preflight.py \
  --output generated/runtime_validation_pilot/preflight.json
```

预检只读取数据库版本和关键 GUC，不执行 runtime pilot SQL，也不修改任何配置。

## 授权执行

真实执行必须同时满足：

1. `GAUSSDB_ENABLED=true`
2. `GAUSSDB_RUNTIME_PILOT_AUTHORIZED=true`
3. CLI 传入 `--execute --authorized`
4. 提供有效 GaussDB 连接环境变量

示例：

```bash
GAUSSDB_ENABLED=true \
GAUSSDB_RUNTIME_PILOT_AUTHORIZED=true \
GAUSSDB_HOST=... \
GAUSSDB_PORT=... \
GAUSSDB_DATABASE=... \
GAUSSDB_USER=... \
GAUSSDB_PASSWORD=... \
python scripts/run_runtime_validation_pilot.py \
  --execute --authorized \
  --output generated/runtime_validation_pilot/receipt.json
```

## 执行边界

- 只允许 session 级 GUC
- 必须捕获原值
- 必须验证目标值
- 必须恢复原值
- 必须验证恢复值
- 禁止 `ALTER SYSTEM` / `ALTER DATABASE` / `ALTER ROLE`
- 禁止用 `RESET` 代替显式恢复原值
- `DBE_SQL` 必须在正常与异常路径关闭上下文
- 输出、返回值或生命周期 Oracle 必须有实际 rows/notices 证据
- 未捕获证据不得标记 `runtime_verified`

## 回执审计

真实执行生成 receipt 后，必须用原始 dry-run plan 独立审计：

```bash
python scripts/audit_runtime_receipt.py \
  --receipt generated/runtime_validation_pilot/receipt.json \
  --plan generated/runtime_validation_pilot/dry_run.json \
  --output generated/runtime_validation_pilot/receipt_audit.json
```

审计器会检查：

- receipt schema
- plan SHA-256
- plan unit IDs
- plan step count
- runtime_verified / failed_units / executed_steps 计数
- 每个单元的步骤状态
- GUC overlay 是否恢复原值
- DBE_SQL 是否在正常与异常路径关闭上下文
- SQL 是否包含禁止操作
- 成功步骤是否误带错误、失败步骤是否缺少错误

没有提供原始 plan 时，审计不会通过。

## 不是已完成的事

- 当前没有可用 GaussDB 连接
- 当前没有执行任何 SQL
- 当前没有 runtime receipt
- 当前不能宣称任何 GUC 或高级包行为验证通过
