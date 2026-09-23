# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXIII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除规则/触发器/用户/用户映射。

目标章节：

- `general/ddl/drop_rule.txt`
- `general/ddl/drop_trigger.txt`
- `general/ddl/drop_user.txt`
- `general/ddl/drop_user_mapping.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_rule` | 6个已有规则删除语法代表 |
| `drop_trigger` | 6个已有触发器删除语法代表 |
| `drop_user` | 4个空NOLOGIN用户删除语法代表 |
| `drop_user_mapping` | 6个专用映射删除语法代表 |

处理方式：

- 原 runtime / dependency / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_rule static coverage | false | true |
| drop_trigger static coverage | false | true |
| drop_user static coverage | false | true |
| drop_user_mapping static coverage | false | true |
| static coverage complete | 155 / 307 | 159 / 307 |
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

- 规则或触发器依赖对象删除、RESTRICT错误、缺失NOTICE或视图规则生命周期
- CASCADE用户删除、锁等待、多库依赖、权限链或缺失用户错误
- 具名用户映射授权、角色隔离或CREATE USER MAPPING IF EXISTS错误身份

## 验证

- `tests.test_static_coverage_closures_20260921_xxvi`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
