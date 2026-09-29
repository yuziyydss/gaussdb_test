# GUC V2 Requirement Resolver

## 目标

`core.guc_requirement_resolver.py` 将 Factor Package 场景中的 `guc_*` 环境门禁解析为 GUC V2 Capability Matrix 中的已审能力。

它只做静态解析，不执行 SQL，不修改 GUC，不授权数据库运行。

## 输入

Resolver 接收场景聚合后的环境门禁，例如：

```yaml
guc_track_procedure_sql:
  - "off"
```

非 `guc_` 前缀的门禁会被忽略，继续由原有环境逻辑处理。

## 输出

### supported

当门禁满足以下条件时进入 `supported`：

1. key 存在于 GUC V2 Requirement Adapter
2. requested values 是 capability allowed_values 的子集
3. 对应 GUC V2 capability 存在

每项包含：

- `requirement_key`
- `parameter_name`
- `allowed_values`
- `fact_refs`
- `plan`

`plan` 是该 GUC 的五步静态计划：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

### unsupported

当 `guc_*` key 不在 Requirement Adapter 中时进入 `unsupported`。

### invalid_values

当 requested values 不在 capability allowed_values 内时进入 `invalid_values`。

## 与 prepare_unit 集成

`core.execution_preparation.prepare_unit` 现在会：

1. 聚合场景 cases 的 `environment_requirements`
2. 提取所有 `guc_*` 门禁
3. 调用 GUC V2 Requirement Resolver
4. 将结果写入 `guc_environment_plan`
5. 对 unsupported / invalid values 添加静态 blocker

新增静态 blocker：

```text
guc_requirement_unsupported:<key>
guc_requirement_invalid_values:<key>
```

如果存在已解析 GUC 门禁，`required_runtime_evidence` 会追加：

```text
guc_overlay_capture_apply_verify_restore_verify
```

## 后续消费

Requirement Resolver 已由 [GUC V2 Execution Selector](GUC_V2_EXECUTION_SELECTOR.md) 消费，用于选择具体执行值并生成五步 overlay 计划。

## 边界

- Resolver 只验证静态绑定。
- 不执行 SQL。
- 不修改 GUC。
- 不选择多个 allowed values 中的具体执行值。
- 不授权数据库执行。
- 多值门禁在执行选择器确定具体值之前保持歧义。
