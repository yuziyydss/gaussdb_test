# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XL（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行SAVEPOINT、不执行M SELECT、不修改文本搜索配置或字典。

目标章节：

- `general/tcl/savepoint.txt`
- M `SELECT` 及其聚合函数补充来源
- `general/ddl/alter_text_search_configuration.txt`
- `general/ddl/alter_text_search_dictionary.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `savepoint` | 1个事务内SAVEPOINT语法代表 |
| `m_select` | 50个有限SELECT、集合、聚合和COUNT代表 |
| `alter_text_search_configuration` | 12个映射维护与ngram选项代表 |
| `alter_text_search_dictionary` | 5个Simple ACCEPT维护代表 |

处理方式：

- 事务外错误、故障注入、聚合边界、近似类型、索引依赖、OWNER、计划缓存、额外模板和dummy等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| savepoint static coverage | false | true |
| m_select static coverage | false | true |
| alter_text_search_configuration static coverage | false | true |
| alter_text_search_dictionary static coverage | false | true |
| static coverage complete | 183 / 307 | 187 / 307 |
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

- 事务外SAVEPOINT错误身份、节点/通信故障或COPY FROM异常行为
- M SELECT多列子查询错误、全NULL、空表、DISTINCT、窗口、精度、溢出或驱动元数据
- 已引用文本搜索配置、OWNER变更或PBE计划缓存行为
- Simple之外的模板参数、重复参数、dummy字典或真实索引依赖行为

## 验证

- `tests.test_static_coverage_closures_20260921_xl`
- 既有M SELECT守卫模块复测，31个测试通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
