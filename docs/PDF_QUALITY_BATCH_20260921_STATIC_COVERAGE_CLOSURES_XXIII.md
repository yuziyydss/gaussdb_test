# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXIII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除资源标签、不清空弱口令字典、不刷新系统对象、不执行数据库闪回。

目标章节：

- `general/ddl/drop_resource_label.txt`
- `general/ddl/drop_weak_password_dictionary.txt`
- `general/utility/refresh_system_object.txt`
- `general/utility/timecapsule_database.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_resource_label` | 4个资源标签删除语法代表 |
| `drop_weak_password_dictionary` | 1个固定清空命令语法代表 |
| `refresh_system_object` | 1个固定刷新命令语法代表 |
| `timecapsule_database` | 1个库名闪回语法代表 |

处理方式：

- 原 runtime / dependency open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_resource_label static coverage | false | true |
| drop_weak_password_dictionary static coverage | false | true |
| refresh_system_object static coverage | false | true |
| timecapsule_database static coverage | false | true |
| static coverage complete | 115 / 307 | 119 / 307 |
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

- 审计或脱敏策略引用下的资源标签删除契约
- 全局弱口令字典清空与安全恢复
- 系统对象刷新、升级目录/文件快照或恢复
- 数据库回收站身份、跨连接恢复或清理行为

## 验证

- `tests.test_static_coverage_closures_20260921_xvi`
- `tests.test_drop_weak_password_dictionary_fresh_syntax`
- `tests.test_refresh_system_object_fresh_syntax`
- `tests.test_timecapsule_database_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
