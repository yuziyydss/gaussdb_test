# GUC V2 Runtime Pilot

## 目标

`core.guc_runtime_pilot.py` 将 GUC Environment V2 的 19 个 `session_overlay` 参数转换为可授权执行的 runtime pilot 计划。它只包含 GUC overlay，不包含高级包候选。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| GUC overlay 单元 | 19 |
| SQL步骤 | 95 |
| 数据库执行 | `false` |
| 执行授权 | `false` |
| runtime_verified | `0` |

## 单元结构

每个单元固定执行：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

其中：

- `capture_original`、`verify_target`、`verify_restore` 使用 `current_setting` 行 Oracle
- `apply`、`restore` 使用会话级 `SET`
- 恢复使用捕获到的原值，不使用 `RESET`

## 浏览与 API

`/guc` 页面提供 Runtime Pilot 面板；API 可通过：

```text
GET /api/guc/v2/runtime-plan
```

## Dry run

```bash
python scripts/run_guc_v2_runtime_pilot.py \
  --output generated/guc_environment_v2/runtime_dry_run.json
```

当前输出：

- `profile=runtime_guc_v2_pilot_v1`
- 19 个 `guc_overlay` 单元
- 95 个执行步骤
- `database_executed=false`
- `execution_authorized=false`
- `runtime_verified=0`

## 授权执行

执行前会经过 [GUC V2 Execution Gate](GUC_V2_EXECUTION_GATE.md)。

真实执行必须同时满足：

1. `GAUSSDB_ENABLED=true`
2. `GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED=true`
3. CLI 传入 `--execute --authorized`
4. 提供有效 GaussDB 连接环境变量

示例：

```bash
GAUSSDB_ENABLED=true \
GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED=true \
GAUSSDB_HOST=... \
GAUSSDB_PORT=... \
GAUSSDB_DATABASE=... \
GAUSSDB_USER=... \
GAUSSDB_PASSWORD=... \
python scripts/run_guc_v2_runtime_pilot.py \
  --execute --authorized \
  --output generated/guc_environment_v2/runtime_receipt.json
```

## 执行边界

- 只允许 session 级 GUC
- 必须捕获原值
- 必须验证目标值
- 必须恢复原值
- 必须验证恢复值
- 禁止 `ALTER SYSTEM` / `ALTER DATABASE` / `ALTER ROLE`
- 禁止用 `RESET` 代替显式恢复原值
- 未捕获行证据不得标记 `runtime_verified`

## 回执审计

执行生成 receipt 后，使用独立审计器：

```bash
python scripts/audit_guc_v2_runtime_receipt.py \
  --receipt generated/guc_environment_v2/runtime_receipt.json \
  --plan generated/guc_environment_v2/runtime_dry_run.json \
  --output generated/guc_environment_v2/runtime_receipt_audit.json
```

详见 [GUC V2 Runtime Receipt Audit](GUC_V2_RUNTIME_RECEIPT_AUDIT.md)。

## Runtime 状态汇总

GUC V2 runtime pilot 已纳入 `core/runtime_status.py`，并出现在 `/runtime` 页面与 `/api/runtime/status`：

- `guc_v2_runtime_plan`
- `guc_v2_readiness`
- `guc_v2_static_ready`
- `guc_v2_preflight_ready`
- `guc_v2_ready_for_authorized_execution`
- `guc_v2_runtime_executed`
- `guc_v2_runtime_audit_valid`
- `guc_v2_all_modeled_runtime_evidence_complete`
- `all_modeled_runtime_evidence_complete` 也包含 GUC V2 证据链

## 边界

- 当前没有可用 GaussDB 连接
- 当前没有执行任何 SQL
- 当前没有 runtime receipt
- 当前不能宣称任何 GUC 行为验证通过
