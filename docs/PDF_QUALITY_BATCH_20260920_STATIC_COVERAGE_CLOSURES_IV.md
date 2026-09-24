# PDF 质量抽取增量：STATIC COVERAGE CLOSURES IV（2026-09-20）

## 范围

本轮继续 M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行COPY或CREATE AUDIT POLICY。

目标章节：

- `m_compat/dml/copy.txt`
- `m_compat/ddl/create_audit_policy.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 2 个只剩单一静态阻断的包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 处理方式 |
|---|---|
| `m_copy` | 注意事项、TEXT默认空值写法与原生参数对`\N`描述冲突；确认当前模型不生成NULL输入。 |
| `m_create_audit_policy` | 多操作示例未重复ACCESS且DELETE未指定标签；前置开关段落称脱敏策略生效。确认当前模型只生成单操作、不推导脱敏能力。 |

本轮不新增 manifest，不新增候选 SQL，只把 open question 改为确认的建模限制，并让 source unit 从 `open_question` 变为 `mapped`。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| static coverage complete | 61 / 307 | 63 / 307 |
| 全库 manifest | 918 | 918 |
| 全库 candidate | 5,490 | 5,490 |
| 全库 distinct SQL | 5,400 | 5,400 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

2 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合静态覆盖，不证明：

- `\N`空值语义
- COPY NULL输入或输出行为
- 多操作审计策略语法
- 审计策略与脱敏策略的关系

这些冲突分支均不进入当前生成域。

## 验证

- `tests.test_static_coverage_closures_20260920_iv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
