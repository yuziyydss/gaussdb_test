# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLV（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改角色或用户、不创建CAST、不安装扩展。

目标章节：

- `general/ddl/alter_role.txt`
- `general/ddl/alter_user.txt`
- `general/ddl/create_cast.txt`
- `general/ddl/create_extension.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_role` | 20个普通ALTER ROLE形态代表 |
| `alter_user` | 17个普通ALTER USER形态代表 |
| `create_cast` | 3个函数转换上下文代表 |
| `create_extension` | 6个安装语法代表 |

处理方式：

- 角色剩余选项、IN DATABASE、密码/认证，用户剩余选项、改名/凭据/认证，CAST二进制/I/O/多参数/域，扩展支持文件、升级、特殊schema和对象冲突等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_role static coverage | false | true |
| alter_user static coverage | false | true |
| create_cast static coverage | false | true |
| create_extension static coverage | false | true |
| static coverage complete | 203 / 307 | 207 / 307 |
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

- 角色或用户成员、高权限、资源限额、有效期、IN DATABASE、密码、PGUSER或认证行为
- CAST二进制兼容、I/O兼容、2/3参数typmod或域类型行为
- 扩展支持文件、FROM升级、特殊schema宏或同名对象冲突行为

## 验证

- `tests.test_static_coverage_closures_20260921_xlv`
- 既有批次守卫5项复测通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
