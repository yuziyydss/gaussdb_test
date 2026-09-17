# PDF 质量抽取增量：ALTER RESOURCE POOL IO_PRIORITY（2026-09-17）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_resource_pool.txt`
- 章节：1.13.7.26 ALTER RESOURCE POOL
- 相关原文：`io_priority` 参数说明
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

在既有 `manifest_alter_resource_pool_ordinary` 中新增四个有限值：

- `IO_PRIORITY = 'Low'`
- `IO_PRIORITY = 'Medium'`
- `IO_PRIORITY = 'High'`
- `IO_PRIORITY = 'None'`

候选数从 6 条增至 10 条。

新增环境门：

```text
io_control_scope = complex_jobs_only
```

依据原文：`io_limits` / `io_priority` 仅对复杂作业生效，包括批量导入、
单 DN 数据量超过 500MB 的复杂查询和 `VACUUM FULL` 等。

## 保留边界

ALTER RESOURCE POOL 原文称 I/O 利用率达到 **90%** 时生效；
CREATE RESOURCE POOL 原文称为 **50%**。两者不能合并为统一阈值行为。

本轮只覆盖 `IO_PRIORITY` 字面量域，不证明：

- I/O 调度行为
- 90% 阈值行为
- `IO_LIMITS` 完整数值域
- 复杂作业判定
- 多租冲突
- `MAX_DOP` 集中式支持冲突

因此：

- `alter_resource_pool_feature_io_priority_values` 已 covered / all
- `alter_resource_pool_feature_threshold_conflict` 仍为 needs_profile
- `alter_resource_pool_feature_dop_centralized` 仍为 needs_profile
- `options.alter_resource_pool_options_dop_one` 仍是唯一值域缺口
- 本包 `generation_model_complete` 仍为 false
- 本包 `behavior_coverage_complete` 仍为 false

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_resource_pool manifest | 1 | 1 |
| alter_resource_pool candidate | 6 | 10 |
| alter_resource_pool value gaps | 1 | 1 |
| 剩余 value gap | MAX_DOP | MAX_DOP |
| IO_PRIORITY feature | needs_profile | covered / all |
| 全库 manifest | 847 | 847 |
| 全库 candidate | 5,302 | 5,306 |
| 全库 distinct SQL | 5,215 | 5,219 |

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
