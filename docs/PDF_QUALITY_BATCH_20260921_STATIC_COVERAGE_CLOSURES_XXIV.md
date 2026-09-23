# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXIV（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不清理回收站、不转移对象所有权、不查询后台任务、不执行表闪回。

目标章节：

- `general/utility/purge.txt`
- `general/utility/reassign_owned.txt`
- `general/utility/show_events.txt`
- `general/utility/timecapsule_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `purge` | 单表与单索引两个PURGE语法代表 |
| `reassign_owned` | 两个专用角色REASSIGN OWNED语法代表 |
| `show_events` | 9个空Schema查询语法代表 |
| `timecapsule_table` | DROP、DROP RENAME、TRUNCATE三个表闪回语法代表 |

处理方式：

- 原 runtime / scope open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / scope feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| purge static coverage | false | true |
| reassign_owned static coverage | false | true |
| show_events static coverage | false | true |
| timecapsule_table static coverage | false | true |
| static coverage complete | 119 / 307 | 123 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,499 | 5,499 |
| 全库 distinct SQL | 5,409 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- 全局或用户全部对象清理、权限矩阵或ACL行为
- 跨库、共享对象、依赖链或权限遗留的所有权转移
- 后台任务创建、列类型、权限、失败状态或过滤结果
- CSN/TIMESTAMP真实恢复点、UNDO保留、状态统计或依赖对象恢复

## 验证

- `tests.test_static_coverage_closures_20260921_xvii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
