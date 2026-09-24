# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXI（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除DBLink、扩展、FDW或PDB。

目标章节：

- `general/ddl/drop_database_link.txt`
- `general/ddl/drop_extension.txt`
- `general/ddl/drop_foreign_data_wrapper.txt`
- `general/ddl/drop_pluggable_database_including_datafiles.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个 DDL 删除命令包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_database_link` | 4个公共/私有与IF EXISTS语法代表 |
| `drop_extension` | 6个扩展删除语法代表 |
| `drop_foreign_data_wrapper` | 6个FDW删除语法代表 |
| `drop_pluggable_database_including_datafiles` | 1个PDB删除语法代表 |

处理方式：

- 原 runtime / dependency open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_database_link static coverage | false | true |
| drop_extension static coverage | false | true |
| drop_foreign_data_wrapper static coverage | false | true |
| drop_pluggable_database_including_datafiles static coverage | false | true |
| static coverage complete | 107 / 307 | 111 / 307 |
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

- DBLink实际存在、公共/私有类型、IF EXISTS或清理行为
- 扩展依赖、RESTRICT例外或成员删除行为
- FDW依赖、RESTRICT错误或CASCADE目录行为
- PDB关闭、模板、数据文件删除或资源指令清理

## 验证

- `tests.test_static_coverage_closures_20260921_xiv`
- `tests.test_drop_database_link_fresh_syntax`
- `tests.test_drop_pluggable_database_including_datafiles_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
