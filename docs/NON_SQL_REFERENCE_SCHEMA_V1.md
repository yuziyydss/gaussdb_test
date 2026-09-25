# Non-SQL Reference Schema V1

## 目标

`core/non_sql_reference.py` 将当前 `docs/compat_facts/*.yaml` 中的非 SQL 参考事实纳入一个严格 Schema。它解决的是“这些 facts 是否结构一致、来源可追溯、状态可审计”的问题，不宣称生成器已经消费这些 facts，也不宣称数据库行为验证完成。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| YAML 文件 | 67 |
| facts | 885 |
| confirmed | 882 |
| needs_verification | 3 |
| 裸 ID 重名 | 8 |
| 全局身份格式 | `file::fact_id` |

## fact 基础字段

每个 fact 必须包含：

- `id`
- `type`
- `statement`
- `status`
- `source_anchor`

可选：

- `verification_method`
- `properties`

其中 `properties` 保留领域专属字段，例如：

- `compatibility_mode`
- `source_physical_pages`
- `evaluation_phase`
- `applicability_conditions`

## 顶级分类

| 分类 | 文件数 | facts 数 |
|---|---:|---:|
| compatibility | 26 | 375 |
| stored_procedure | 16 | 220 |
| runtime_parameters | 12 | 174 |
| system_catalog | 6 | 53 |
| tool_reference | 3 | 21 |
| schema | 2 | 30 |
| log_reference | 1 | 6 |
| report | 1 | 6 |

## fact 类型分布

| 类型 | 数量 |
|---|---:|
| behavior_oracle | 277 |
| environment | 203 |
| syntax | 189 |
| metadata_oracle | 103 |
| constraint | 111 |
| lifecycle | 2 |

## 未决事实

1. `runtime_params_connection_resource.yaml::guc_max_wal_size`
2. `runtime_params_lock_transaction.yaml::guc_td_compatible_truncation`
3. `tool_reference_monitoring.yaml::tool_gs_cgroup`

## 输出

构建类型化 inventory：

```bash
python scripts/build_non_sql_reference_inventory.py
```

输出：

```text
generated/non_sql_reference_inventory/inventory.json
```

## 边界

- confirmed 表示来源评审结论，不是运行时证据。
- inventory 不表示这些 facts 已接入生成器。
- 非 SQL 专用模型仍需分领域继续扩展，例如 GUC、系统表/视图、工具、Schema、WDR/ASP。
- 裸 ID 允许跨文件重复，全局引用必须使用 `file::fact_id`。
