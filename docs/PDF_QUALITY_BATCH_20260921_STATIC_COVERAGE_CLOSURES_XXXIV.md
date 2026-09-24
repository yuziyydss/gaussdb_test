# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXIV（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改聚集、不创建包体、不提交两阶段事务、不重命名表。

目标章节：

- `general/ddl/alter_aggregate.txt`
- `general/ddl/create_package.txt`
- `general/tcl/commit_prepared.txt`
- `general/ddl/rename_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_aggregate` | RENAME和SET SCHEMA两个语法代表 |
| `create_package` | 包头/包体共10个静态语法代表 |
| `commit_prepared` | 1个本case事务的COMMIT PREPARED语法代表 |
| `rename_table` | 4个普通表重命名语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_aggregate static coverage | false | true |
| create_package static coverage | false | true |
| commit_prepared static coverage | false | true |
| rename_table static coverage | false | true |
| static coverage complete | 159 / 307 | 163 / 307 |
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

- 聚集OWNER变更或零参数/多输入签名行为
- 包声明全协议、多会话状态、重编译初始化或依赖失效
- 两阶段事务真实提交、CSN来源、异常恢复或prepared残留清理
- 临时表混合重命名、B/5.7/s2兼容行为

## 验证

- `tests.test_static_coverage_closures_20260921_xxvii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
