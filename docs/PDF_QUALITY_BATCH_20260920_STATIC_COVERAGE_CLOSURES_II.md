# PDF 质量抽取增量：STATIC COVERAGE CLOSURES II（2026-09-20）

## 范围

本轮继续 M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行审计策略、扩展维护、REINDEX 或 PURGE。

目标章节：

- `m_compat/ddl/alter_audit_policy.txt`
- `m_compat/ddl/alter_extension.txt`
- `m_compat/ddl/reindex.txt`
- `m_compat/utility/purge.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 5 个只剩单一静态阻断的包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 处理方式 |
|---|---|
| `m_alter_audit_policy` | ROLES示例与主语法括号层级冲突；确认当前模型采用主语法，不生成示例括号形式。 |
| `m_alter_extension` | 参数说明列出更多成员类型，主产生式仅列较小集合；确认不扩充语法。 |
| `m_reindex` | partition_name参数说明与分区产生式冲突；确认不生成分区分支。 |
| `m_purge` | PURGE INDEX示例结果不可推广；确认不生成固定删除数量Oracle。 |
| `m_clean_connection` | 示例的M建库与物理datname映射不作为通用证据；确认绑定独立M建库计划物理名。 |

本轮不新增 manifest，不新增候选 SQL，只把 open question 改为确认的建模限制，并让 source unit 从 `open_question` 变为 `mapped`。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| static coverage complete | 52 / 307 | 57 / 307 |
| 全库 manifest | 918 | 918 |
| 全库 candidate | 5,490 | 5,490 |
| 全库 distinct SQL | 5,400 | 5,400 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

5 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合静态覆盖，不证明：

- ROLES示例括号语法可执行
- 扩展额外成员类型可维护
- REINDEX分区语义
- PURGE INDEX删除数量或空间释放行为

这些冲突分支均不进入当前生成域。

## 验证

- `tests.test_static_coverage_closures_20260920_ii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
