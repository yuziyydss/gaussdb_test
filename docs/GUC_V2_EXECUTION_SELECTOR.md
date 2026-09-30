# GUC V2 Execution Selector

## 目标

`core.guc_execution_selector.py` 将已解析的 GUC 环境门禁转换为一个具体的静态执行选择。

它只做两件事：

1. 选择一个具体的 GUC 值
2. 生成对应的五步 session overlay 计划

它不连接数据库，不执行 SQL，不授权运行。

## 选择规则

默认选择：

```text
allowed_values[0]
```

也可以显式指定：

```python
selections={
    "guc_track_procedure_sql": "off",
}
```

选择值必须位于 `allowed_values` 内，否则失败关闭。

## 输出

每个选择包含：

- `requirement_key`
- `parameter_name`
- `selected_value`
- `plan`

`plan` 固定为五步：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

## 与 prepare_unit 集成

`core.execution_preparation.prepare_unit` 会在 GUC 门禁全部解析成功后：

1. 调用 Requirement Resolver
2. 调用 Execution Selector
3. 将结果写入 `guc_execution_plan`

如果存在 unsupported 或 invalid values，则不会生成执行选择计划。

## 边界

- 不连接数据库。
- 不执行 SQL。
- 不修改 GUC。
- 不授权运行。
- 不生成 runtime receipt。
- 静态选择不等于数据库行为验证。
