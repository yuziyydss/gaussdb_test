# GUC Candidate Matrix V1

## 目标

`core/guc_candidate.py` 将 [GUC Reference Schema V2](GUC_REFERENCE_SCHEMA_V2.md) 中的 1,175 个唯一参数转换为候选准入矩阵。它解决的问题是：**下一步哪些参数可以安全进入人工评审，哪些必须先阻断**。

它不是执行策略，不会自动扩大 `environments/guc_parameters_v1.yaml` 中的 20 个 pilot 参数。

## 输入

- `generated/guc_reference_catalog/catalog.json`
- `docs/compat_facts/runtime_params*.yaml`
- 12 个 runtime parameter fact 文件，共 174 条 facts

矩阵加载时会重新校验：

- GUC Reference V2 catalog 哈希；
- V2 参数数量、occurrence 数量、context、类型、锚点；
- runtime fact 文件集合、哈希和 fact 数量；
- 每个候选条目的 confirmed / needs_verification fact 引用。

任一漂移都会失败关闭。

## 分类结果

| 处置 | 数量 | 含义 |
|---|---:|---|
| `pilot_already_modeled` | 20 | 已在V1 pilot中建模 |
| `reserved_or_deprecated` | 4 | 7.3.59显式预留/废弃且已有完整定义 |
| `duplicate_definition_requires_review` | 2 | 同名参数在7.3中多次定义，先人工裁决 |
| `context_not_user_set` | 753 | 唯一USERSET不成立，或context未指定 |
| `boolean_session_candidate` | 158 | 唯一USERSET且原文布尔值域含on/off |
| `value_domain_model_required` | 238 | 唯一USERSET，但值域仍需结构化建模 |

总口径：

- 唯一参数：1,175
- 定义出现：1,177
- 布尔USERSET候选：158
- 有 confirmed fact 的候选：7
- 仅 needs_verification fact 的候选：1
- 下一批人工评审：7

## 下一批人工评审

以下7个参数满足：

1. 非V1 pilot；
2. 非预留/废弃；
3. 非重复定义；
4. 唯一USERSET；
5. 布尔型且原文值域包含on/off；
6. 有 `confirmed` runtime parameter fact；
7. 没有绑定的 `needs_verification` fact。

| 参数 | 默认值 | confirmed fact |
|---|---|---|
| `a_format_enable_copy_empty_lobs` | on | `runtime_params_data_import_export.yaml::guc_a_format_enable_copy_empty_lobs` |
| `enable_copy_case_sensitive` | off | `runtime_params_data_import_export.yaml::guc_enable_copy_case_sensitive` |
| `enable_copy_when_filler` | on | `runtime_params_data_import_export.yaml::guc_enable_copy_when_filler` |
| `enable_log_copy_illegal_chars` | on | `runtime_params_data_import_export.yaml::guc_enable_log_copy_illegal_chars` |
| `enable_plan_trace` | off | `runtime_params_statistics.yaml::guc_enable_plan_trace` |
| `enable_save_datachanged_timestamp` | on | `runtime_params_statistics.yaml::guc_enable_save_datachanged_timestamp` |
| `track_procedure_sql` | on | `runtime_params_statistics.yaml::guc_track_procedure_sql` |

`td_compatible_truncation` 虽然满足布尔USERSET候选条件，但其直接 fact 为 `needs_verification`，因此只进入 `deferred_unverified_facts`，不进入下一批。

## 评审结果

[GUC Environment V2](GUC_ENVIRONMENT_V2.md) 已消费本矩阵的7个下一批候选：5个进入session overlay，2个因DML/系统表副作用保留manual review。

## 为什么不自动扩容 pilot

`boolean_session_candidate` 只证明文档层面具备有限布尔值域和USERSET context，不证明：

- 参数没有联动前置；
- 默认值在目标环境一定可恢复；
- on/off 两个值都适合当前测试会话；
- 修改不会影响计划缓存、视图重写或存储过程编译产物；
- 参数在目标GaussDB版本的实际context与文档一致。

因此下一批必须先人工评审，再单独进入安全执行模型。

## 输出与命令

构建：

```bash
python scripts/build_guc_candidate_matrix.py
```

输出：

```text
generated/guc_candidate_matrix/matrix.json
```

测试：

```bash
python -m unittest tests.test_guc_candidate_matrix -q
```

## 边界

- 矩阵不连接数据库，不执行任何GUC。
- `confirmed fact` 是来源评审状态，不是运行时证据。
- `context_not_user_set` 中包含 INTERNAL、POSTMASTER、SIGHUP、SUSET、BACKEND、未指定和条件context，不能统一理解为可设置。
- 重复定义、预留/废弃定义的处置优先于候选资格。
- 矩阵只筛选评审队列，不改变V1 pilot的执行策略。
