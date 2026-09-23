# PDF 质量抽取增量：STATIC COVERAGE CLOSURES III（2026-09-20）

## 范围

本轮继续 M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行ALTER SESSION、SELECT INTO、TABLE或TRUNCATE。

目标章节：

- `m_compat/ddl/alter_session.txt`
- `m_compat/dml/select_into.txt`
- `m_compat/utility/table.txt`
- `m_compat/ddl/truncate.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个只剩单一静态阻断的包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 处理方式 |
|---|---|
| `m_alter_session` | CURRENT_SCHEMA主语法与示例TO形式冲突；事务语法右花括号不配平。确认当前模型不生成这两个冲突分支。 |
| `m_select_into` | 跨页语法块两次列出INTO且未标选择关系。确认当前模型采用与本章示例一致的前置INTO。 |
| `m_table` | M模式不支持子查询结果包含多列。确认当前模型不生成多列子查询，不把该限制泛化到所有上下文。 |
| `m_truncate` | 主语法多余闭合花括号且依赖选项参数误写视图。确认当前模型不生成该括号、不推导级联规则。 |

本轮不新增 manifest，不新增候选 SQL，只把 open question 改为确认的建模限制，并让 source unit 从 `open_question` 变为 `mapped`。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| static coverage complete | 57 / 307 | 61 / 307 |
| 全库 manifest | 918 | 918 |
| 全库 candidate | 5,490 | 5,490 |
| 全库 distinct SQL | 5,400 | 5,400 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合静态覆盖，不证明：

- CURRENT_SCHEMA示例形式可执行
- 事务语法额外括号可执行
- 双INTO语法可执行
- 多列子查询错误身份
- TRUNCATE依赖级联行为

这些冲突分支均不进入当前生成域。

## 验证

- `tests.test_static_coverage_closures_20260920_iii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
