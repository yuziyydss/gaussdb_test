# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXVII（2026-09-21）

## 范围

本轮继续 general / M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行OM升级、不执行匿名块、不创建分区投影、不删除脱敏策略。

目标章节：

- `m_compat/utility/generated_update_system.txt`
- `general/utility/do.txt`
- `general/ddl/create_table_partition_subpartition_as.txt`
- `general/ddl/drop_masking_policy.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `m_generated_update_system` | 1个固定M命令语法代表 |
| `do` | 4个PL/pgSQL匿名块语法代表 |
| `create_table_partition_subpartition_as` | 7个分区投影语法代表 |
| `drop_masking_policy` | 2个单策略删除语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / source-conflict feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown
- `m_generated_update_system` 增加显式固定命令维度并绑定现有manifest

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| m_generated_update_system static coverage | false | true |
| do static coverage | false | true |
| create_table_partition_subpartition_as static coverage | false | true |
| drop_masking_policy static coverage | false | true |
| static coverage complete | 131 / 307 | 135 / 307 |
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

- OM升级阶段准备、初始身份核验、回滚脚本产物或部分失败清理
- 非默认语言安装、授权或动态代码安全
- ENGINE、存储参数、ILM、表空间或任意查询投影行为
- 多策略删除、缺失策略NOTICE/错误或脱敏策略删除行为

## 验证

- `tests.test_static_coverage_closures_20260921_xx`
- `tests.test_m_generated_update_system_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
