# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXVIII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改默认权限、事件、脱敏策略或会话。

目标章节：

- `general/ddl/alter_default_privileges.txt`
- `general/ddl/alter_event.txt`
- `general/ddl/alter_masking_policy.txt`
- `general/utility/alter_session.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_default_privileges` | 52个表/序列/函数/类型授权语法代表 |
| `alter_event` | 7个事件维护语法代表 |
| `alter_masking_policy` | 7个脱敏策略维护语法代表 |
| `alter_session` | 26个会话设置语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_default_privileges static coverage | false | true |
| alter_event static coverage | false | true |
| alter_masking_policy static coverage | false | true |
| alter_session static coverage | false | true |
| static coverage complete | 175 / 307 | 179 / 307 |
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

- 默认权限的未来对象有效权限、多角色/多模式作用域或密态对象行为
- 事件DEFINER、组合ALTER、INTERVAL边界或调度执行行为
- 脱敏函数拼写、MODIFY FILTER括号或多策略组合
- 会话角色凭据、RESET歧义或并发隔离行为

## 验证

- `tests.test_static_coverage_closures_20260921_xxxviii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
