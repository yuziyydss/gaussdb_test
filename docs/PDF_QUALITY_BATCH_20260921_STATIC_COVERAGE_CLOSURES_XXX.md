# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXX（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改审计或行安全策略、不创建SERVER或DIRECTORY。

目标章节：

- `general/ddl/alter_audit_policy.txt`
- `general/ddl/alter_row_level_security_policy.txt`
- `general/ddl/create_server.txt`
- `general/ddl/create_directory.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_audit_policy` | 6个操作共12个语法代表 |
| `alter_row_level_security_policy` | 4个操作共8个语法代表 |
| `create_server` | 3个文档FDW声明语法代表 |
| `create_directory` | NEW/REPLACE两个语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_audit_policy static coverage | false | true |
| alter_row_level_security_policy static coverage | false | true |
| create_server static coverage | false | true |
| create_directory static coverage | false | true |
| static coverage complete | 143 / 307 | 147 / 307 |
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

- MODIFIER FILTER、ACCESS/ALL、资源标签组合或审计日志行为
- 多角色RLS、PUBLIC语义或行可见性行为
- SERVER连接选项、密钥注入、FDW兼容性或tuple cost行为
- DIRECTORY特殊字符、文件系统状态、权限或多节点一致性

## 验证

- `tests.test_static_coverage_closures_20260921_xxiii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
