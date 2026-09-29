# GUC V2 Capability Adapter

## 目标

`core.guc_capability.py` 将 GUC Environment V2 中的 19 个 `session_overlay` 参数转换为未来可接入 Factor Package 的环境能力描述。

它当前**不直接修改 Factor Package**，也不自动生成 manifest。它先解决三个问题：

1. 每个GUC使用什么环境门禁 key
2. 允许哪些值
3. 是否已有 runtime fact 绑定

## 当前规模

| 指标 | 当前值 |
|---|---:|
| 能力数量 | 19 |
| runtime fact 绑定 | 11 |
| 待补 runtime fact | 8 |
| 允许值总数 | 38 |
| SQL步骤总数 | 95 |

## 构建

```bash
python scripts/build_guc_capability_matrix.py
```

输出：

```text
generated/guc_environment_v2/capability_matrix.json
```

## 结构

每个能力包含：

- `requirement_key`
- `parameter_id`
- `parameter_name`
- `category`
- `integration_status`
- `allowed_values`
- `fact_refs`
- `source_anchor`
- `plan`

`plan` 保留五步：

1. `capture_original`
2. `apply`
3. `verify_target`
4. `restore`
5. `verify_restore`

## integration_status

| 状态 | 含义 |
|---|---|
| `runtime_fact_bound` | 已有 runtime parameter fact |
| `needs_runtime_fact` | 尚无 runtime fact，不能直接进入 Factor Package 环境门禁 |

当前 11 个参数为 `runtime_fact_bound`：

- `behavior_compat_options`
- `b_format_behavior_compat_options`
- `default_transaction_isolation`
- `default_transaction_read_only`
- `plan_cache_mode`
- `sql_beta_feature`
- `a_format_enable_copy_empty_lobs`
- `enable_copy_case_sensitive`
- `enable_copy_when_filler`
- `enable_log_copy_illegal_chars`
- `track_procedure_sql`

当前 8 个参数为 `needs_runtime_fact`：

- `enable_hashjoin`
- `enable_indexscan`
- `enable_indexonlyscan`
- `enable_material`
- `enable_nestloop`
- `enable_seqscan`
- `enable_sort`
- `enable_tidscan`

## 为什么不直接写入 Factor Package

Factor Package V1 的 `EnvironmentRequirementDef` 要求：

1. `fact_refs` 非空
2. 引用 confirmed environment fact
3. fact 必须存在于对应 Factor Package 或跨包提供者

GUC V2 的 19 个 session overlay 参数中：

- 11 个已有 runtime fact
- 8 个没有 runtime fact

因此直接写入会造成悬空引用或伪造事实。Capability Adapter 先显式区分：

- 可绑定
- 待补 fact

后续接入 Factor Package 时，应只允许 `runtime_fact_bound` 参数进入，或先为剩余 8 个参数建立 confirmed environment facts。

## SQL 边界

Capability Matrix 保留的 SQL 只允许：

```sql
SELECT current_setting('<parameter>', true) AS value;
SET <parameter> = '<value>';
```

不允许：

```sql
ALTER SYSTEM ...
ALTER DATABASE ...
ALTER ROLE ...
RESET <parameter>;
```

## 后续消费

Capability Matrix 已由 [GUC V2 Requirement Adapter](GUC_V2_REQUIREMENT_ADAPTER.md) 消费：

- 9 个能力转换为 `EnvironmentRequirementDef`
- 10 个能力显式阻断

## 与静态链的关系

Capability Matrix 已纳入 `scripts/build_guc_v2_chain.py`，位于：

```text
GUC Overlay Plan Export V1
  ↓
GUC V2 Capability Matrix
  ↓
GUC V2 Preflight Plan
```

## 边界

- 不是 Factor Package manifest。
- 不修改现有 specs。
- 不连接数据库。
- 不执行任何 GUC。
- `runtime_fact_bound` 不等于数据库行为验证。
- 空字符串是合法 option-set 值，未来接入 Factor Package 时需要显式映射。
