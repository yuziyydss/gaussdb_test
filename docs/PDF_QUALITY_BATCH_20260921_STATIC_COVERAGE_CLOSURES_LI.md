# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LI（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建角色、不授权、不执行REVOKE。

目标章节：

- `general/dcl/revoke.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `revoke` 从 `static_coverage_complete=false` 提升为 `true`：

| 静态代表 | 数量 |
|---|---:|
| 表权限回收代表 | 11 |
| 列权限回收代表 | 11 |
| 角色权限回收代表 | 6 |

处理方式：

- 多授权路径、PUBLIC、成员角色造成的有效权限行为固化为 confirmed environment
- 18个未生成的对象类别或特权分支固化为 confirmed environment
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有表、列、角色有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| revoke static coverage | false | true |
| static coverage complete | 227 / 307 | 228 / 307 |
| 全库 manifest | 929 | 929 |
| 全库 candidate | 5,502 | 5,502 |
| 全库 distinct SQL | 5,412 | 5,412 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 297 / 307 | 297 / 307 |

`revoke` 当前为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- 多授权路径、PUBLIC或成员角色下的有效权限变化
- 序列、数据库、域、CMK/CEK、DIRECTORY、FDW、SERVER、函数、过程、语言、模式、表空间、类型、PACKAGE、SYSADMIN、ANY、DATABASE LINK或PUBLIC SYNONYM分支行为

## 验证

- `tests.test_static_coverage_closures_20260921_li`
- `tests.test_batch_09_packages.Batch09Tests.test_column_revoke_is_not_masked_by_table_grant`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
