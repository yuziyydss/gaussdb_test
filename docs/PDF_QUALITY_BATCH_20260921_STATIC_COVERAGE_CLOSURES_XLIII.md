# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLIII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建FDW、不执行SHOW、不修改函数、不修改用户映射。

目标章节：

- `general/ddl/create_foreign_data_wrapper.txt`
- `general/utility/show.txt`
- `general/ddl/alter_function.txt`
- `general/ddl/alter_user_mapping.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_foreign_data_wrapper` | 6个无handler/无validator有限语法代表 |
| `show` | 8个参数、LIKE与特殊SHOW代表 |
| `alter_function` | 39个属性、重命名、模式和COMPILE代表 |
| `alter_user_mapping` | 6个非秘密mapped_user/options代表 |

处理方式：

- FDW handler/validator回调、SHOW完整GUC与模式域、ALTER FUNCTION签名冲突/GUC/SETOF、USER MAPPING ADD/密码/具名角色等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_foreign_data_wrapper static coverage | false | true |
| show static coverage | false | true |
| alter_function static coverage | false | true |
| alter_user_mapping static coverage | false | true |
| static coverage complete | 195 / 307 | 199 / 307 |
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

- 真实FDW handler注册、回调、验证器合法/非法选项或错误身份
- SHOW完整GUC域、引号/通配符模式或目标环境可用性
- ALTER FUNCTION示例签名、GUC行为、SETOF/ROWS、权限提升或所有者变更
- USER MAPPING ADD初始状态、密码密钥文件或具名角色隔离行为

## 验证

- `tests.test_static_coverage_closures_20260921_xliii`
- `tests.test_batch_07_packages.Batch07Tests.test_mapping_user_option_exists_before_set_drop`
- `tests.test_batch_04_settings_packages.Batch04SettingsTests.test_show_branches_do_not_leak_default_slots`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
