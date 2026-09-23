# PDF 质量抽取增量：SET TRANSACTION COMBINED EXAMPLES（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改会话或数据库默认事务特性。

目标章节：

- `general/utility/set_transaction.txt`
- 章节：1.13.19.9 SET TRANSACTION
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 3 个 manifest：

```text
manifest_set_transaction_combined_local
manifest_set_transaction_combined_session
manifest_set_transaction_combined_global
```

新增 3 个示例确认组合候选：

```sql
SET LOCAL TRANSACTION
ISOLATION LEVEL READ COMMITTED READ ONLY;

SET SESSION TRANSACTION
ISOLATION LEVEL READ COMMITTED READ ONLY;

SET GLOBAL TRANSACTION
ISOLATION LEVEL READ COMMITTED READ ONLY;
```

这些组合来自原文第 67、73、77 行。模型新增 `access_mode` 维度：

- 省略第二属性
- ` READ ONLY`

本轮只覆盖示例确认的 `READ COMMITTED + READ ONLY`，不推广为所有隔离级别与访问模式的组合矩阵。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| set_transaction manifest | 4 | 7 |
| set_transaction candidate | 30 | 33 |
| set_transaction static coverage | false | true |
| 全库 manifest | 913 | 916 |
| 全库 candidate | 5,485 | 5,488 |
| 全库 distinct SQL | 5,396 | 5,399 |
| static coverage complete | 46 | 47 |

`set_transaction` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明原文示例确认的有限组合形态可以静态生成，不证明：

- 会话或数据库默认事务特性实际改变
- B模式/GUC切换行为
- 事务隔离行为
- 读写限制行为
- GLOBAL重连后生效行为
- 所有隔离级别×访问模式组合

SESSION 候选保留 B模式和
`b_format_behavior_compat_options=set_session_transaction` 环境门；
GLOBAL候选保留B模式环境门。

## 验证

- `tests.test_set_transaction_combined_examples`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有会话或全局默认值修改，没有Git提交或推送。
