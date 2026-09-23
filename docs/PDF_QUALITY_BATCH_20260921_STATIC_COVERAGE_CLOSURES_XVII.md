# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XVII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不轮转CMK/CEK、不修改全局配置、不切换资源计划、不打开或关闭PDB。

目标章节：

- `general/ddl/alter_column_encryption_key.txt`
- `general/ddl/alter_global_configuration.txt`
- `general/ddl/alter_pluggable_database.txt`
- `general/ddl/alter_system_set.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个参数化命令包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_column_encryption_key` | 1个CMK轮转语法代表 |
| `alter_global_configuration` | 1条与2条键值语法代表 |
| `alter_pluggable_database` | OPEN/CLOSE/IMMEDIATE三个动作语法代表 |
| `alter_system_set` | 1个resource_manager_plan语法代表 |

处理方式：

- 原 runtime open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域，不新增 manifest、候选或SQL
- 不新增 fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_column_encryption_key static coverage | false | true |
| alter_global_configuration static coverage | false | true |
| alter_pluggable_database static coverage | false | true |
| alter_system_set static coverage | false | true |
| static coverage complete | 88 / 307 | 92 / 307 |
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

- CMK/CEK实际轮转、密文或明文不变
- gs_global_config实际upsert或恢复
- PDB打开、关闭、强制关闭状态机
- resource_manager_plan实际切换、容量授权或恢复

## 验证

- `tests.test_static_coverage_closures_20260921_x`
- `tests.test_alter_system_set_fresh_syntax`
- `tests.test_alter_pluggable_database_fresh_open`
- `tests.test_alter_global_configuration_fresh_syntax`
- `tests.test_no_manifest_parameterized_batch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
