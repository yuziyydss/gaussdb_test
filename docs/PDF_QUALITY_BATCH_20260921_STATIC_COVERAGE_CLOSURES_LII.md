# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建或聚簇表。

目标章节：

- `general/utility/cluster.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `cluster` 从 `static_coverage_complete=false` 提升为 `true`。

处理方式：

- 为首次省略 `USING` 的负向候选登记原文确认错误：
  `ERROR: there is no previously clustered index for table "test"`
- 目标正则泛化为：
  `there is no previously clustered index for table ".*"`
- 分区目标、无目标全库维护、非B-Tree/非行存目标负向固化为 confirmed environment
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| cluster static coverage | false | true |
| static coverage complete | 228 / 307 | 229 / 307 |
| 全库 manifest | 929 | 929 |
| 全库 candidate | 5,502 | 5,502 |
| 全库 distinct SQL | 5,412 | 5,412 |
| generation model complete | 297 / 307 | 297 / 307 |

`cluster` 当前为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法和原文错误身份，不证明：

- 实际聚簇重排、锁行为或磁盘容量影响
- 分区目标与索引对齐行为
- 无目标全库维护行为
- 非B-Tree、非行存或表达式索引权限负向

## 验证

- `tests.test_static_coverage_closures_20260921_lii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
