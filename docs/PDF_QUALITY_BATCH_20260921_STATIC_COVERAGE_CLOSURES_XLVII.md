# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLVII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不清理连接、不修改数据库、不创建规则、不执行M SET。

目标章节：

- `general/utility/clean_connection.txt`
- `general/ddl/alter_database.txt`
- `general/ddl/create_rule.txt`
- M `SET` 用户变量与模式分支
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `clean_connection` | 4个显式库/用户范围的TO ALL代表 |
| `alter_database` | 18个LIMIT、RENAME、SET、FROM CURRENT与RESET代表 |
| `create_rule` | 19个INSERT/UPDATE/DELETE规则行为代表 |
| `m_set` | 42个模式与用户变量有限代表 |

处理方式：

- CLEAN CONNECTION省略库/用户、不支持NODE，ALTER DATABASE OWNER/表空间/私有对象/时区/ILM/措辞冲突，CREATE RULE SELECT/REPLACE/RETURNING/WHERE，M SET通用参数、扩展用户变量域和模式扩展域等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| clean_connection static coverage | false | true |
| alter_database static coverage | false | true |
| create_rule static coverage | false | true |
| m_set static coverage | false | true |
| static coverage complete | 211 / 307 | 215 / 307 |
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

- 省略数据库/用户的CLEAN CONNECTION影响范围或不支持NODE负向行为
- ALTER DATABASE OWNER、表空间、私有对象隔离、DBTIMEZONE、ILM或templatem保护行为
- CREATE RULE SELECT规则、OR REPLACE、视图RETURNING或WHERE表达式行为
- M SET更长列表/赋值链、多行/关联子查询、其他类型、缺失模式、交错scope或实际读回行为

## 验证

- `tests.test_static_coverage_closures_20260921_xlvii`
- 既有M SET守卫21项复测通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
