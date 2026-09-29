# GUC V2 Preflight Audit

## 目标

`core.guc_preflight_audit.py` 将 GUC V2 只读 Preflight 结果与原始 Preflight Plan 做独立审计。它不信任 result 自己的 `metadata_read` 声明，而是逐项核对：

- result schema
- environment id
- query count
- 每条 query 的 parameter id / name / SQL
- summary 中的 query / success / error / domain mismatch 计数
- `metadata_read` 与实际查询结果的一致性
- `connected` 与实际查询结果的一致性
- errors 列表与 error_count 的一致性
- 是否误声明执行目标 SQL、修改 GUC 或创建对象

## 自动生成

`scripts/run_guc_v2_preflight.py` 会在写出 result 后立即生成对应 audit：

```text
preflight_result.json
preflight_audit.json
```

也可以单独执行审计：

  --result generated/guc_environment_v2/preflight_result.json \
  --plan generated/guc_environment_v2/preflight_plan.json \
  --output generated/guc_environment_v2/preflight_audit.json
```

默认 plan 路径：

```text
generated/guc_environment_v2/preflight_plan.json
```

## 与 Readiness 的关系

`Guc V2 Readiness` 现在要求：

1. Preflight result 存在且有效
2. Preflight audit 存在、有效且 `plan_verified=true`

只有两者同时满足，才可能进入 `ready_for_authorized_execution=true`。

## 当前状态

- 当前没有 GaussDB 连接
- 当前没有 preflight result
- 当前没有 preflight audit
- 当前不能宣称 Preflight 完成

## 边界

- 审计不重新执行 SQL。
- 审计不证明目标数据库行为。
- 审计不授权 GUC 修改。
- 值域不匹配是发现项，不是数据库执行失败。
