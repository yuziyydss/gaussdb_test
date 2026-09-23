# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LXI（2026-09-23）

本轮不连接数据库、不执行SQL、不做行为校准；只把没有稳定错误身份的静态缺口收窄到可审阅边界。

## 范围

- `update`
- `grant`
- 若干只有单个未校准错误 Oracle、无其他静态缺口的 M/general 包

## 处理方式

- 原文只声明“非法/不支持”，但未给出稳定 SQLSTATE 或错误文本的负向值改为 `unknown`，不生成负向候选。
- 对应 source unit 从 `open_question` 改为 `mapped`；原文事实转为 confirmed environment 边界。
- 未建模 feature stub 移出静态分母；有限 representative feature 改为 `any`。
- `grant` 增加 manifest-local rule：`object_target.target_kind` 必须在 `object_privilege.allowed_target_kinds` 中，消除列目标与非列权限组合导致的重复 SQL。
- 历史未归档 SQL 移到 `archive/spec_reviews/20260923/generated_sql/`，不删除、不作为 active suite。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| static coverage complete | 237 / 317 | 309 / 317 |
| generation model complete | 304 / 309 | 309 / 309 |
| 有 manifest 的因子包 | 309 | 309 |
| 无 manifest 的因子包 | 8 | 8 |
| manifest | 935 | 797 |
| candidate SQL | 5,514 | 5,250 |
| distinct SQL | 5,424 | 5,160 |

静态分母中剩余 8 个包均为 no-manifest disposition，不是“不支持”结论。

## 保留边界

本轮只完成静态语法/规格闭合，不证明：

- SQLSTATE、错误文本或真实报错路径
- 权限、游标、外表、TDE、DBLink或分区目标实机行为
- fixture、setup/teardown在数据库中的可执行性
- planned scenario的行为 Oracle

## 验证

- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`
- `python3 scripts/audit_candidate_inventory.py`
- `python3 -m unittest tests.test_static_coverage_closures_20260923 tests.test_no_manifest_disposition_inventory`

没有数据库执行，没有Git提交或推送。
