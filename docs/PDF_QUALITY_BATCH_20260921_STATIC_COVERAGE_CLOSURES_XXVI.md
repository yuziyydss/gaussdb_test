# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXVI（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改二级分区或表空间、不执行AUTOHINT、不调用PDB导入工具。

目标章节：

- `general/ddl/alter_table_subpartition.txt`
- `general/ddl/alter_tablespace.txt`
- `general/utility/autohint.txt`
- `general/utility/impdp_pluggable_database_create.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_table_subpartition` | 11类二级分区操作共66个语法代表 |
| `alter_tablespace` | 1个专用RELATIVE表空间重命名语法代表 |
| `autohint` | 1个ANALYZE FALSE静态查询语法代表 |
| `impdp_pluggable_database_create` | 1个显式PDB名导入语法代表 |

处理方式：

- 原 runtime / dependency / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_table_subpartition static coverage | false | true |
| alter_tablespace static coverage | false | true |
| autohint static coverage | false | true |
| impdp_pluggable_database_create static coverage | false | true |
| static coverage complete | 127 / 307 | 131 / 307 |
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

- GLOBAL索引失效、UPDATE GLOBAL INDEX、交换列契约、在线DDL、ILM或并发行为
- 真实表空间属主、限额或文件生命周期
- AUTOHINT执行计划探索、TEST执行、历史写入、资源预算或恢复
- 备份恢复工具调用、PDB导入、异常重启恢复或省略PDB名行为

## 验证

- `tests.test_static_coverage_closures_20260921_xix`
- `tests.test_alter_tablespace_fresh_rename`
- `tests.test_autohint_static_syntax_batch`
- `tests.test_no_manifest_parameterized_batch`
- `tests.test_batch_08_packages`
- `tests.test_tool_upgrade_plans`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
