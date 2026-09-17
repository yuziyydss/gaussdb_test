# PDF 质量抽取增量：ALTER RESOURCE POOL IO_LIMITS（2026-09-17）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_resource_pool.txt`
- 章节：1.13.7.26 ALTER RESOURCE POOL
- 相关原文：`io_limits` 参数说明
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

在既有 `manifest_alter_resource_pool_ordinary` 中新增两个边界代表：

- `IO_LIMITS = 0`
- `IO_LIMITS = 2147483647`

候选数从 10 条增至 12 条。

新增环境门沿用：

```text
io_control_scope = complex_jobs_only
```

依据原文：`IO_LIMITS` / `IO_PRIORITY` 仅对复杂作业生效。

## 保留边界

原文给出 `io_limits` 数值范围：

```text
0 ~ 2147483647
```

其中 `0` 表示不限制 I/O 次数。

本轮只选择 0 和上界两个 representative，不宣称：

- 已穷尽所有整数
- I/O 限流行为
- 90% 阈值行为
- 复杂作业判定
- 多租冲突
- `MAX_DOP` 集中式支持冲突

因此：

- `alter_resource_pool_feature_io_limits_boundaries` 已 covered / representative
- `alter_resource_pool_feature_threshold_conflict` 仍为 needs_profile
- `alter_resource_pool_feature_dop_centralized` 仍为 needs_profile
- `options.alter_resource_pool_options_dop_one` 仍是唯一值域缺口
- 本包 `generation_model_complete` 仍为 false
- 本包 `behavior_coverage_complete` 仍为 false

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_resource_pool manifest | 1 | 1 |
| alter_resource_pool candidate | 10 | 12 |
| alter_resource_pool value gaps | 1 | 1 |
| IO_LIMITS feature | 未单独表示 | covered / representative |
| 全库 manifest | 847 | 847 |
| 全库 candidate | 5,306 | 5,308 |
| 全库 distinct SQL | 5,219 | 5,221 |

## 验证

- `tests.test_batch_09_packages`
- `tests.test_generation_diagnostics`
- `tests.test_target_create_cleanup_safety`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 Git 提交或推送。
