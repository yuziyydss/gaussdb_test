# PDF 质量抽取增量：AUTOHINT STATIC SYNTAX（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不执行AUTOHINT探索、不执行SELECT、不删除历史模型。

目标章节：

- `general/utility/autohint.txt`
- `general/utility/autohint_drop_model.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 2 个 manifest：

```text
manifest_autohint_fresh_syntax
manifest_autohint_drop_model_fresh_syntax
```

新增 2 个静态语法代表：

```sql
AUTOHINT (ANALYZE FALSE) SELECT 1;
AUTOHINT DROP MODEL SELECT 1;
```

`AUTOHINT` 代表选择 `ANALYZE FALSE`，仅表示关闭探索的语法形态；
`SELECT 1` 是无表静态查询，不证明推荐算法、资源预算或历史写入行为。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| 本批 2 包 manifest | 0 / 2 | 2 / 2 |
| 本批 2 包 candidate | 0 | 2 |
| 全库 manifest | 902 | 904 |
| 全库 candidate | 5,439 | 5,441 |
| 全库 distinct SQL | 5,351 | 5,353 |
| 有 manifest 的因子包 | 303 | 305 |
| 无 manifest 的因子包 | 14 | 12 |
| generation model complete | 282 / 303 | 284 / 305 |

本批 2 个包的 `generation_model_complete` 均为 true；
`static_coverage_complete` 与 `behavior_coverage_complete` 均仍为 false。

## 保留边界

本轮只证明有限SQL形态可以静态生成，不证明：

- super或管理员权限真实满足
- AUTOHINT探索、TEST执行、VERBOSE输出或推荐结果行为
- CPU/内存/IO资源限额与耗时预算
- SQL身份、历史模型归属或删除计数
- `AUTOHINT DROP MODEL` 对同一SELECT历史的删除行为

`autohint_feature_runtime` 与
`autohint_drop_model_feature_runtime` 继续保留为 `needs_profile`。

## 验证

- `tests.test_autohint_static_syntax_batch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有AUTOHINT探索，没有查询执行，没有历史模型删除，没有Git提交或推送。
