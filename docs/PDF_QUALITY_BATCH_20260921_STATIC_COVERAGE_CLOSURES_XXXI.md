# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXI（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接外部LLM服务、不执行游标或匿名块、不删除聚集、不删除外表。

目标章节：

- `general/ddl/create_llm.txt`
- `general/utility/declare.txt`
- `general/ddl/drop_aggregate.txt`
- `general/ddl/drop_foreign_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_llm` | QUERY/EMBED/RERANK三个非秘密语法代表 |
| `declare` | 游标与匿名块共8个语法代表 |
| `drop_aggregate` | 已有/缺失目标共9个语法代表 |
| `drop_foreign_table` | log_fdw目录目标共6个语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_llm static coverage | false | true |
| declare static coverage | false | true |
| drop_aggregate static coverage | false | true |
| drop_foreign_table static coverage | false | true |
| static coverage complete | 147 / 307 | 151 / 307 |
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

- LLM外部服务、密钥注入、CA或模型登记行为
- 游标通用查询域、匿名块完整结构或反向失败行为
- 聚集全签名域或CASCADE/RESTRICT依赖行为
- log_fdw数据访问、实机归属、清理或其他封装器行为

## 验证

- `tests.test_static_coverage_closures_20260921_xxiv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
