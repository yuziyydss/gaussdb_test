# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XIV（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除任何表。

目标章节：

- `general/ddl/drop_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `drop_table` 从 `static_coverage_complete=false` 提升为 `true`。

处理方式：

- 将“PDF 表列表为 `[, ...]` 无界重复”的 open question 改为确认的模型限制
- 明确 V1 静态域只展开一表、模式限定和两表代表
- `dt_feature_unbounded_table_list` 从 `needs_profile` 改为 `covered / any`
- 该特性由现有 `dt_table_two` 有限 profile 代表
- 不宣称无界表列表全量枚举

现有两表候选继续由 `fixture_drop_table_multi` 提供生命周期：

```sql
DROP TABLE t_dt_one, t_dt_two;
```

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_table static coverage | false | true |
| static coverage complete | 82 / 307 | 83 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,499 | 5,499 |
| 全库 distinct SQL | 5,409 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

`drop_table` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合有限静态列表口径，不证明：

- 任意数量表的全量枚举
- 数据库实际删除表或依赖对象
- CASCADE/RESTRICT行为
- PURGE物理删除行为
- 权限或锁行为

## 验证

- `tests.test_static_coverage_closures_20260921_viii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
