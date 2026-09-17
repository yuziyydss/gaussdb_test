# PDF 质量抽取增量：CREATE RESOURCE POOL MEMORY_LIMIT（2026-09-17）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_resource_pool.txt`
- 章节：1.13.9.39 CREATE RESOURCE POOL
- 相关原文：`memory_size` 参数说明
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

在既有 `manifest_create_resource_pool_ordinary` 中新增两个边界代表：

- `MEMORY_LIMIT = '1KB'`
- `MEMORY_LIMIT = '2047GB'`

保留既有中间代表：

- `MEMORY_LIMIT = '1MB'`

候选数从 15 条增至 17 条。

## 保留边界

原文给出 `memory_size` 范围：

```text
1KB ~ 2047GB
```

本轮只选择下界、上界与一个中间代表，不宣称：

- 已穷尽所有内存大小字符串
- 实际内存分配或限额行为
- `MEM_PERCENT` 与 `MEMORY_LIMIT` 同时设置时的运行时优先级
- 资源池容量或配额
- `MAX_DOP` 集中式支持冲突

因此：

- `create_resource_pool_feature_memory_limit_boundaries` 已 covered / representative
- `create_resource_pool_feature_dop_centralized` 仍为 needs_profile
- `options.create_resource_pool_options_dop_one` 仍是唯一值域缺口
- 本包 `generation_model_complete` 仍为 false
- 本包 `behavior_coverage_complete` 仍为 false

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_resource_pool manifest | 1 | 1 |
| create_resource_pool candidate | 15 | 17 |
| create_resource_pool value gaps | 1 | 1 |
| MEMORY_LIMIT feature | 仅普通选项代表 | covered / representative |
| 全库 manifest | 847 | 847 |
| 全库 candidate | 5,308 | 5,310 |
| 全库 distinct SQL | 5,221 | 5,223 |

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
