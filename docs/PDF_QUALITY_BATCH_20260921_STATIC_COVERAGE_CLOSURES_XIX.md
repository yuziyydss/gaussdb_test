# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XIX（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建目录、不调用备份恢复工具、不执行导入导出。

目标章节：

- `general/utility/expdp_database.txt`
- `general/utility/expdp_pluggable_database.txt`
- `general/utility/expdp_table.txt`
- `general/utility/impdp_database_create.txt`
- `general/utility/impdp_recover.txt`
- `general/utility/impdp_table.txt`
- `general/utility/impdp_table_prepare.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 7 个 EXPDP/IMPDP 包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `expdp_database` | 1个数据库导出语法代表 |
| `expdp_pluggable_database` | 1个PDB导出语法代表 |
| `expdp_table` | 1个表导出语法代表 |
| `impdp_database_create` | 4个数据库导入准备语法代表 |
| `impdp_recover` | 2个数据库导入执行语法代表 |
| `impdp_table` | 2个表导入语法代表 |
| `impdp_table_prepare` | 1个表导入准备语法代表 |

处理方式：

- 原 runtime open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- runtime feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| 本批 7 包 static coverage | 0 / 7 | 7 / 7 |
| static coverage complete | 96 / 307 | 103 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,499 | 5,499 |
| 全库 distinct SQL | 5,409 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

7 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- 备份恢复工具调用
- 目录创建、读取、归属或哈希校验
- 数据库/PDB/表导出行为
- 数据库/PDB/表导入、准备或恢复行为
- 异常重启、部分失败或清理结果

## 验证

- `tests.test_static_coverage_closures_20260921_xii`
- `tests.test_expdp_database_fresh_syntax`
- `tests.test_expdp_pluggable_database_fresh_syntax`
- `tests.test_expdp_table_fresh_syntax`
- `tests.test_impdp_table_fresh_syntax`
- `tests.test_impdp_table_prepare_fresh_syntax`
- `tests.test_no_manifest_parameterized_batch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
