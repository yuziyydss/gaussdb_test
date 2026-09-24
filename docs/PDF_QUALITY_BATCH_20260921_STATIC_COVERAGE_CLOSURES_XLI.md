# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLI（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不调用函数或过程、不创建密钥、不启用事件调度、不创建脱敏策略。

目标章节：

- `general/dml/call.txt`
- `general/ddl/create_column_encryption_key.txt`
- `general/ddl/create_event.txt`
- `general/ddl/create_masking_policy.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `call` | 4个本例函数IN参数调用代表 |
| `create_column_encryption_key` | 7个有限算法语法代表 |
| `create_event` | 8个禁用事件语法代表 |
| `create_masking_policy` | 21个脱敏函数、标签与过滤代表 |

处理方式：

- OUT参数、远端调用、存储过程/包调用、密态驱动、third_kms冲突、密钥长度、事件调度、DEFINER、regexpmasking、运行时过滤与重复子句等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| call static coverage | false | true |
| create_column_encryption_key static coverage | false | true |
| create_event static coverage | false | true |
| create_masking_policy static coverage | false | true |
| static coverage complete | 187 / 307 | 191 / 307 |
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

- OUT参数、远端DATABASE LINK调用、存储过程或包调用行为
- 密态驱动连接、CMK秘密、third_kms支持或密钥长度边界
- 事件实际触发、完成删除、后台失败或跨身份DEFINER行为
- regexpmasking算法、真实会话过滤交集、重复脱敏子句或同列策略冲突行为

## 验证

- `tests.test_static_coverage_closures_20260921_xli`
- `tests.test_create_column_encryption_key_fresh_syntax`
- `tests.test_batch_10_packages.Batch10Tests.test_key_manager_conflict_and_external_key_retention`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
