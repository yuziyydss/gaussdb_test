# GUC V2 Requirement Adapter

## 目标

`core.guc_requirement_adapter.py` 将 GUC V2 Capability Matrix 中**可安全转换**的能力转换为 Factor Package V1 的 `EnvironmentRequirementDef` 结构。

它当前不修改 `specs/`，只生成可审计的适配产物。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 输入能力 | 19 |
| 可转换 requirement | 9 |
| 显式阻断 | 10 |
| 因缺少 runtime fact 阻断 | 8 |
| 因空字符串值阻断 | 2 |

## 构建

```bash
python scripts/build_guc_requirement_adapter.py
```

输出：

```text
generated/guc_environment_v2/requirement_adapter.json
```

## 转换规则

一个能力只有在同时满足以下条件时才会转换：

1. `integration_status = runtime_fact_bound`
2. `allowed_values` 中没有空字符串
3. 能通过 `EnvironmentRequirementDef` 的严格校验

转换结果包含：

- `key`
- `allowed_values`
- `fact_refs`
- 对应 GUC 参数名

## 显式阻断

### 1. 缺少 runtime fact

以下 8 个参数被阻断：

- `enable_hashjoin`
- `enable_indexscan`
- `enable_indexonlyscan`
- `enable_material`
- `enable_nestloop`
- `enable_seqscan`
- `enable_sort`
- `enable_tidscan`

原因：

```text
missing_runtime_fact
```

### 2. 空字符串值

以下 2 个参数被阻断：

- `behavior_compat_options`
- `b_format_behavior_compat_options`

原因：

```text
empty_value_not_supported
```

Factor Package V1 的 `EnvironmentRequirementDef` 当前不允许空字符串。空字符串在 GUC option-set 中是合法值，因此不能静默丢弃或伪造，必须显式阻断。

## 后续消费

Requirement Adapter 已由 [GUC V2 Requirement Resolver](GUC_V2_REQUIREMENT_RESOLVER.md) 消费，用于解析场景中的 `guc_*` 环境门禁。

## API 与页面

API：

```text
GET /api/guc/v2/requirement-adapter
```

页面：

```text
/guc
```

## 边界

- 不修改 Factor Package specs。
- 不证明 fact refs 已在某个 `FactorPackageRegistry` 中可解析。
- 不授权数据库执行。
- 不执行 GUC。
- 空字符串值需要后续显式建模，不能用占位符伪装。
