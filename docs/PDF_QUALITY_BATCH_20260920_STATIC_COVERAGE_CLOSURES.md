# PDF 质量抽取增量：STATIC COVERAGE CLOSURES（2026-09-20）

## 范围

本轮继续 general / M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行事务、建库/建模式或 OM 升级。

目标章节：

- `general/tcl/commit_end.txt`
- `m_compat/utility/execute.txt`
- `m_compat/ddl/create_database.txt`
- `m_compat/ddl/create_schema.txt`
- `m_compat/utility/set_transaction.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 5 个只剩单一静态阻断的包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 处理方式 |
|---|---|
| `commit_end` | 将“本章未提供跨会话机制”改为确认的来源限制，不伪造跨会话接管机制。 |
| `m_execute` | 将“本章语法未给参数列表”改为确认的来源限制，不推断 `USING`。 |
| `m_create_database` | 将字符集/字符序说明改为确认的来源限制，不猜测 COLLATE 取值域。 |
| `m_create_schema` | 同上，不收录 COLLATE 选项。 |
| `m_set_transaction` | 根据原文示例新增 `LOCAL + READ COMMITTED + READ ONLY` 组合代表，不推广全组合矩阵。 |

其中 `m_set_transaction` 新增 manifest：

```text
manifest_m_set_transaction_combined_local
```

新增候选：

```sql
SET LOCAL TRANSACTION
ISOLATION LEVEL READ COMMITTED READ ONLY;
```

其余 4 个包不新增 manifest，只把原本的 open question 改为确认的来源限制，并让 source unit 从 `open_question` 变为 `mapped`。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| static coverage complete | 47 / 307 | 52 / 307 |
| 全库 manifest | 917 | 918 |
| 全库 candidate | 5,489 | 5,490 |
| 全库 distinct SQL | 5,400 | 5,400 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

`m_set_transaction` 的候选从 12 增至 13；其余包候选数不变。

5 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合静态覆盖，不证明：

- COMMIT跨会话接管机制
- EXECUTE参数传递
- CREATE DATABASE / SCHEMA的COLLATE取值域
- SET TRANSACTION隔离级别或读写限制行为
- 任何数据库执行结果

这些行为仍保留在 planned 场景中。

## 验证

- `tests.test_static_coverage_closures_20260920`
- `tests.test_m_set_transaction_combined_local`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
