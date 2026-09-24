# PDF 质量抽取增量：STATIC COVERAGE CLOSURES VII（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除用户组、不调用管理工具。

目标章节：

- `general/ddl/drop_group.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `drop_group` 从 `static_coverage_complete=false` 提升为 `true`。

处理方式：

- 管理工具上下文从 open question 改为确认的环境限制
- 环境门继续要求 `authorized_isolated_tool_session`
- 已建模的 3 个有限值全部选中
- `drop_group_feature_legacy_tool_drop` 从 representative 改为 all，表示当前有限值域完整

当前候选：

```sql
DROP GROUP g_drop_group;
DROP GROUP IF EXISTS g_drop_group;
```

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_group static coverage | false | true |
| static coverage complete | 67 / 307 | 68 / 307 |
| 全库 manifest | 918 | 918 |
| 全库 candidate | 5,490 | 5,490 |
| 全库 distinct SQL | 5,400 | 5,400 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

`drop_group` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限SQL形态和工具上下文环境门完整，不证明：

- 管理工具实际调用
- 组删除行为
- 多组删除
- 缺失组 NOTICE 行为
- 组权限或依赖清理

## 验证

- `tests.test_static_coverage_closures_20260920_vii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
