# GUC V2 Cross-Layer Audit

## 目标

`core.guc_audit` 将 GUC V2 的八层本地产物放在同一个静态审计里：

1. `GUC Reference Schema V2`
2. `GUC Candidate Matrix V1`
3. `GUC Environment V2`
4. `GUC Overlay Plan Export V1`
5. `GUC V2 Capability Matrix`
6. `GUC V2 Requirement Adapter`
7. `GUC V2 Runtime Pilot`
8. `GUC V2 Preflight Plan`

它校验身份、计数、策略、来源绑定和 SQL 边界，但不连接数据库，也不执行任何 GUC。

## 输入

- `generated/guc_reference_catalog/catalog.json`
- `generated/guc_candidate_matrix/matrix.json`
- `environments/guc_parameters_v2.yaml`
- `generated/guc_environment_v2/overlay_plans.json`
- `generated/guc_environment_v2/overlay_plans.sql`
- `generated/guc_environment_v2/capability_matrix.json`
- `generated/guc_environment_v2/requirement_adapter.json`
- `generated/guc_environment_v2/runtime_dry_run.json`
- `generated/guc_environment_v2/preflight_plan.json`

## 核心检查

当前共 25 项检查。

- Reference 与 Candidate 的参数身份集合一致
- Candidate 绑定 Reference catalog
- Environment V2 绑定计划导出
- 7个 next batch 候选全部进入 Environment V2
- 5个候选为 `session_overlay`
- 2个候选为 `manual_review`
- 19个 `session_overlay` 参数全部有且只有一个计划
- `manual_review` / `read_only` / `blocked` 不进入计划
- 每个计划保持五步顺序
- SQL 不包含 `ALTER SYSTEM`、`ALTER DATABASE`、`ALTER ROLE`、`RESET`
- Capability Matrix 包含 19 个能力、11 个 runtime fact 绑定和 8 个待补 fact 项
- Capability Matrix 与 overlay plan 参数一一对应
- Requirement Adapter 转换 9 个能力并显式阻断 10 个能力
- Requirement Adapter 与 Capability Matrix key 一一绑定且不转换 blocked 项
- Runtime pilot 包含 19 个 GUC overlay 单元和 95 个步骤
- Runtime pilot 与 overlay plan 参数一一对应
- Runtime pilot 保持五步恢复顺序
- Preflight 计划覆盖全部 27 个参数
- Preflight 查询全部为只读 `current_setting`
- `needs_verification` 候选不进入 next batch

## 命令

```bash
python scripts/audit_guc_v2.py
```

输出：

```text
generated/guc_environment_v2/audit.json
```

API：

```text
GET /api/guc/v2/audit
```

页面：

```text
/guc
```

## 边界

- 静态审计不证明数据库行为。
- 有效计划不是执行回执。
- `confirmed fact` 仍是来源评审证据，不是运行时证据。
- 任何 GUC 修改仍需显式数据库授权。
