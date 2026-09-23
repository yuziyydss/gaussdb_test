# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLIV（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行匿名块或事务、不创建聚集、不创建PDB、不执行SELECT INTO。

目标章节：

- `general/tcl/begin.txt`
- `general/ddl/create_aggregate.txt`
- `general/ddl/create_pluggable_database.txt`
- `general/dml/select_into.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `begin` | 30个事务BEGIN与匿名块有限代表 |
| `create_aggregate` | 12个新旧聚集语法代表 |
| `create_pluggable_database` | 9个独立PDB选项语法代表 |
| `select_into` | 26个SELECT INTO有限查询代表 |

处理方式：

- BEGIN单条执行、事务特征重复、匿名块DML子语法、聚集零输入/SORTOP/IFUNC、PDB安装指南/选项重复/资源生命周期、SELECT INTO复杂查询/存储过程/全局会话等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域或profile从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| begin static coverage | false | true |
| create_aggregate static coverage | false | true |
| create_pluggable_database static coverage | false | true |
| select_into static coverage | false | true |
| static coverage complete | 199 / 307 | 203 / 307 |
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

- BEGIN单条执行、事务特征重复/冲突或匿名块DML行为
- 聚集零输入、SORTOP、IFUNC优先级或FINALFUNC行为
- PDB真实创建、选项重复、多租安装、资源容量或生命周期清理
- SELECT INTO递归CTE、集合、窗口、存储过程禁止用法或全局临时表跨会话行为

## 验证

- `tests.test_static_coverage_closures_20260921_xliv`
- `tests.test_create_pluggable_database_fresh_syntax`
- `tests.test_quality_round_02.QualityRound02Tests.test_select_into_expression_has_explicit_distinct_output_names`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
