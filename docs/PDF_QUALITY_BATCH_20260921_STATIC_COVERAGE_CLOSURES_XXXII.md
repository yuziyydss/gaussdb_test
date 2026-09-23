# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改全局安全字典、不删除函数/资源池/角色。

目标章节：

- `general/ddl/create_weak_password_dictionary.txt`
- `general/ddl/drop_function.txt`
- `general/ddl/drop_resource_pool.txt`
- `general/ddl/drop_role.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_weak_password_dictionary` | 2个单值静态语法代表 |
| `drop_function` | 3类签名/行为共11个语法代表 |
| `drop_resource_pool` | 2个unbound pool语法代表 |
| `drop_role` | 4个空NOLOGIN角色语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_weak_password_dictionary static coverage | false | true |
| drop_function static coverage | false | true |
| drop_resource_pool static coverage | false | true |
| drop_role static coverage | false | true |
| static coverage complete | 151 / 307 | 155 / 307 |
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

- 全局弱口令字典运行时、安全恢复或多值歧义
- 临时表函数生命周期、CASCADE/RESTRICT依赖或精确错误
- 绑定角色的资源池拒绝、缺失池NOTICE或生命周期
- 角色对象依赖、跨库授权、缺失角色错误或权限清理

## 验证

- `tests.test_static_coverage_closures_20260921_xxv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
