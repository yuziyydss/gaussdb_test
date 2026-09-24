# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XX（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除LLM或模型、不执行预测、不关闭节点。

目标章节：

- `general/ddl/drop_llm.txt`
- `general/ddl/drop_model.txt`
- `general/dml/predict_by.txt`
- `general/utility/shutdown.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个已有 `syntax_only` 代表的包从
`static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_llm` | 1个LLM名语法代表 |
| `drop_model` | 1个模型名语法代表 |
| `predict_by` | 1个预测表达式语法代表 |
| `shutdown` | 默认、FAST、IMMEDIATE三个模式语法代表 |

处理方式：

- 原 runtime open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_llm static coverage | false | true |
| drop_model static coverage | false | true |
| predict_by static coverage | false | true |
| shutdown static coverage | false | true |
| static coverage complete | 103 / 307 | 107 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,499 | 5,499 |
| 全库 distinct SQL | 5,409 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- LLM模型存在、所有权或删除行为
- 训练模型存在、精确名称或删除行为
- PREDICT BY特征顺序、数量、类型契约或预测结果
- 节点关闭、连接中断、重启或故障恢复

## 验证

- `tests.test_static_coverage_closures_20260921_xiii`
- `tests.test_drop_llm_fresh_syntax`
- `tests.test_drop_model_fresh_syntax`
- `tests.test_predict_by_fresh_syntax`
- `tests.test_shutdown_fresh_default`
- `tests.test_batch_11_packages`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
