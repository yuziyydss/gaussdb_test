# PDF 质量抽取增量：ALTER RESOURCE POOL ACTIVE_STATEMENTS（2026-09-17）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_resource_pool.txt`
- 章节：1.13.7.26 ALTER RESOURCE POOL
- 相关原文：`stmt` 参数说明
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

在既有 `manifest_alter_resource_pool_ordinary` 中新增三个代表：

- `ACTIVE_STATEMENTS = -1`
- `ACTIVE_STATEMENTS = 0`
- `ACTIVE_STATEMENTS = 2147483647`

保留既有代表：

- `ACTIVE_STATEMENTS = 1`

候选数从 15 条增至 18 条。

## 保留边界

原文给出 `stmt` 范围：

```text
-1 ~ 2147483647
```

其中 `-1` 表示不限制并发数。

本轮只选择下界、0、1 与上界代表，不宣称：

- 已穷尽所有整数
- 并发控制行为
- 语句排队或拒绝行为
- 多租冲突
- `MAX_DOP` 集中式支持冲突

因此：

- `alter_resource_pool_feature_active_statements_boundaries` 已 covered / representative
- `alter_resource_pool_feature_dop_centralized` 仍为 needs_profile
- `options.alter_resource_pool_options_dop_one` 仍是唯一值域缺口
- 本包 `generation_model_complete` 仍为 false
- 本包 `behavior_coverage_complete` 仍为 false

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_resource_pool manifest | 1 | 1 |
| alter_resource_pool candidate | 15 | 18 |
| alter_resource_pool value gaps | 1 | 1 |
| ACTIVE_STATEMENTS feature | 仅1代表 | covered / representative |
| 全库 manifest | 847 | 847 |
| 全库 candidate | 5,313 | 5,316 |
| 全库 distinct SQL | 5,226 | 5,229 |

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
