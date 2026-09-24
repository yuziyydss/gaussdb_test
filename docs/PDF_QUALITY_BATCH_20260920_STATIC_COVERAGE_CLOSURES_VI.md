# PDF 质量抽取增量：STATIC COVERAGE CLOSURES VI（2026-09-20）

## 范围

本轮继续 general / M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行CHECKPOINT或SHOW。

目标章节：

- `general/utility/checkpoint.txt`
- `m_compat/utility/show.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 2 个只剩单一静态阻断的包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 处理方式 |
|---|---|
| `checkpoint` | 本章仅列出checkpoint参数名，未提供完整边界。确认当前模型不修改实例参数、不生成GUC分支。 |
| `m_show` | 当前模型不接入SHOW TABLE STATUS完整目录字段、版本和精度开关Oracle，不宣称元数据结果。 |

本轮不新增 manifest，不新增候选 SQL，只把 open question 改为确认的建模限制，并让 source unit 从 `open_question` 变为 `mapped`。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| static coverage complete | 65 / 307 | 67 / 307 |
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

- checkpoint参数完整边界
- 实例参数修改或恢复行为
- SHOW TABLE STATUS完整目录字段映射
- 版本和精度开关行为
- 元数据查询结果

这些分支均不进入当前生成域。

## 验证

- `tests.test_static_coverage_closures_20260920_vi`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
