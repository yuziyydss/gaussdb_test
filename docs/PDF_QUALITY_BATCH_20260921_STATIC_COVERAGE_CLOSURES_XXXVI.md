# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXVI（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改FDW/SERVER、不创建审计策略、不应用安全标签。

目标章节：

- `general/ddl/alter_foreign_data_wrapper.txt`
- `general/ddl/alter_server.txt`
- `general/ddl/create_audit_policy.txt`
- `general/ddl/security_label_on.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_foreign_data_wrapper` | 10个OPTIONS语法代表 |
| `alter_server` | VERSION/RENAME共3个语法代表 |
| `create_audit_policy` | 63个有限审计策略语法代表 |
| `security_label_on` | 6个TABLE/COLUMN安全标签语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_foreign_data_wrapper static coverage | false | true |
| alter_server static coverage | false | true |
| create_audit_policy static coverage | false | true |
| security_label_on static coverage | false | true |
| static coverage complete | 167 / 307 | 171 / 307 |
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

- FDW handler/validator替换、已有外表重验证或引号差异兼容
- SERVER选项与FDW验证器匹配、所有权转移或目录行为
- 重复审计动作、ACCESS/ALL、资源标签组合、ROLES过滤或日志行为
- 安全标签逐身份授权、强制访问效果或ROLE/USER清理

## 验证

- `tests.test_static_coverage_closures_20260921_xxxvi`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
