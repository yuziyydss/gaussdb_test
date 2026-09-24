# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XI（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除类型转换或RLS策略。

目标章节：

- `general/ddl/drop_cast.txt`
- `general/ddl/drop_row_level_security_policy.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `drop_cast` 与 `drop_row_level_security_policy` 从
`static_coverage_complete=false` 提升为 `true`。

新增 2 个 manifest：

```text
manifest_drop_cast_missing_if_exists
manifest_drop_row_level_security_policy_missing_if_exists
```

新增 2 个确认缺失目标的静态候选：

```sql
DROP CAST IF EXISTS
(drop_cast_missing_source AS drop_cast_missing_target);

DROP POLICY IF EXISTS b10_rls_missing ON b10_rls_source;
```

`DROP CAST` 将固定类型对扩展为有限 conversion 维度：

- 已有专用转换：`(double precision AS timestamp with time zone)`
- 确认缺失类型对：
  `(drop_cast_missing_source AS drop_cast_missing_target)`

`DROP ROW LEVEL SECURITY POLICY` 将固定策略名扩展为有限 policy_name 维度：

- 已有专用策略：`b10_rls_existing`
- 确认缺失策略：`b10_rls_missing`

缺失对象事实从 open question 改为 confirmed behavior oracle；
只确认文档级结论，不验证 NOTICE 文本、无 `IF EXISTS` 错误 SQLSTATE
或实际删除行为。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_cast static coverage | false | true |
| drop_row_level_security_policy static coverage | false | true |
| static coverage complete | 76 / 307 | 78 / 307 |
| 全库 manifest | 924 | 926 |
| 全库 candidate | 5,496 | 5,498 |
| 全库 distinct SQL | 5,406 | 5,408 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

两个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明缺失目标与 `IF EXISTS` 的有限静态语法，不证明：

- 数据库实际 NOTICE 文本
- 无 `IF EXISTS` 时目标错误的 SQLSTATE
- 类型转换或RLS策略实际删除行为
- 权限拒绝行为
- CASCADE/RESTRICT在依赖场景下的语义

## 验证

- `tests.test_static_coverage_closures_20260921_iv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
