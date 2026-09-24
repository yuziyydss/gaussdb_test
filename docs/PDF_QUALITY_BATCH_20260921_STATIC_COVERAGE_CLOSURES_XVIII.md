# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XVIII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除AUTOHINT历史、不删除CMK/CEK、不修改gs_global_config。

目标章节：

- `general/utility/autohint_drop_model.txt`
- `general/ddl/drop_client_master_key.txt`
- `general/ddl/drop_column_encryption_key.txt`
- `general/ddl/drop_global_configuration.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个已有 `syntax_only` 代表的包从
`static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `autohint_drop_model` | 1个指定SELECT语法代表 |
| `drop_client_master_key` | 6个CMK语法代表 |
| `drop_column_encryption_key` | 6个CEK语法代表 |
| `drop_global_configuration` | 单键与双键两个语法代表 |

处理方式：

- 原 runtime open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| autohint_drop_model static coverage | false | true |
| drop_client_master_key static coverage | false | true |
| drop_column_encryption_key static coverage | false | true |
| drop_global_configuration static coverage | false | true |
| static coverage complete | 92 / 307 | 96 / 307 |
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

- AUTOHINT指定SQL历史存在、删除计数或失败身份
- CMK/CEK目录元数据删除、依赖列或外部密钥实体恢复
- gs_global_config键存在、删除或原值恢复

## 验证

- `tests.test_static_coverage_closures_20260921_xi`
- `tests.test_drop_client_master_key_fresh_syntax`
- `tests.test_drop_column_encryption_key_fresh_syntax`
- `tests.test_drop_global_configuration_fresh_syntax`
- `tests.test_autohint_static_syntax_batch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
