# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXVII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建文本搜索配置、不创建分区表、不执行INSERT ALL或COPY。

目标章节：

- `general/ddl/create_text_search_configuration.txt`
- `general/ddl/create_table_partition.txt`
- `general/dml/insert_all.txt`
- `general/dml/copy.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_text_search_configuration` | 12个parser/source/NGRAM选项语法代表 |
| `create_table_partition` | 15个有限分区族/fillfactor/行移动语法代表 |
| `insert_all` | 正向与原文确认负向共14个语法代表 |
| `copy` | text/csv正向与服务器文件负向共21个语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_text_search_configuration static coverage | false | true |
| create_table_partition static coverage | false | true |
| insert_all static coverage | false | true |
| copy static coverage | false | true |
| static coverage complete | 171 / 307 | 175 / 307 |
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

- 文本搜索配置的内部分词、Unicode类别或越界错误
- 1048575分区、16列键、整数INTERVAL、ILM/HTAP、TDE或并发移动
- INSERT ALL数据库错误身份、ELSE语法或子查询分支行为
- COPY流协议、FREEZE语义、边界/编码/日志拒绝或TRANSFORM行为

## 验证

- `tests.test_static_coverage_closures_20260921_xxxvii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
