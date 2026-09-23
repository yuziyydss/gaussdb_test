# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建资源标签、不创建RLS策略、不创建用户、不删除数据库。

目标章节：

- `general/ddl/create_resource_label.txt`
- `general/ddl/create_row_level_security_policy.txt`
- `general/ddl/create_user.txt`
- `general/ddl/drop_database.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_resource_label` | 16个表/列/模式/视图/函数资源标签代表 |
| `create_row_level_security_policy` | 20个有限RLS形态代表 |
| `create_user` | 4个NOLOGIN/DISABLE安全子集代表 |
| `drop_database` | 4个已有库IF EXISTS/PURGE代表 |

处理方式：

- 同名资源标签、命名边界、函数签名、复杂RLS表达式、多策略组合、CREATE USER剩余选项、同名模式归属、凭据策略、回收站、缺失库和系统保护库等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_resource_label static coverage | false | true |
| create_row_level_security_policy static coverage | false | true |
| create_user static coverage | false | true |
| drop_database static coverage | false | true |
| static coverage complete | 191 / 307 | 195 / 307 |
| 全库 manifest | 929 | 929 |
| 全库 candidate | 5,502 | 5,502 |
| 全库 distinct SQL | 5,412 | 5,412 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 297 / 307 | 297 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- 同名资源标签NOTICE/错误、命名截断、大小写碰撞或函数重载消歧
- 复杂RLS表达式、分区/unlogged/hash表、多策略OR/AND或真实角色读取行为
- CREATE USER默认LOGIN、密码期限、权限、成员关系、资源参数或外部认证
- 回收站开启状态、缺失库NOTICE/错误或系统保护库负向行为

## 验证

- `tests.test_static_coverage_closures_20260921_xlii`
- `tests.test_batch_10_packages.Batch10Tests.test_rls_is_boolean_and_read_semantics_not_insert_rejection`
- `tests.test_batch_08_packages.Batch08Tests.test_drop_database_is_gated_to_no_recyclebin`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
