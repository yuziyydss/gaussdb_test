# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXVIII（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改一级分区、不训练模型、不创建表空间、不执行两阶段回滚。

目标章节：

- `general/ddl/alter_table_partition.txt`
- `general/ddl/create_model.txt`
- `general/ddl/create_tablespace.txt`
- `general/tcl/rollback_prepared.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `alter_table_partition` | 8类一级分区操作共48个语法代表 |
| `create_model` | logistic/linear/svm/kmeans四个架构语法代表 |
| `create_tablespace` | 1个RELATIVE表空间语法代表 |
| `rollback_prepared` | 1个本case事务的ROLLBACK PREPARED语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- `create_model` 为原文支持的四个架构增加syntax-only代表
- 不新增 fixture、setup 或 teardown；不改变既有SQL

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_table_partition static coverage | false | true |
| create_model static coverage | false | true |
| create_tablespace static coverage | false | true |
| rollback_prepared static coverage | false | true |
| static coverage complete | 135 / 307 | 139 / 307 |
| 全库 manifest | 926 | 929 |
| 全库 candidate | 5,499 | 5,502 |
| 全库 distinct SQL | 5,409 | 5,412 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 297 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- GLOBAL索引失效、`UPDATE GLOBAL INDEX`、SET INTERVAL跨章冲突或分区行为
- 模型训练结果、资源预算、模型所有权或xgboost/pca/multiclass行为
- 表空间空目录、权限继承、磁盘上限或失败残留清理
- 两阶段事务真实回滚、prepared状态恢复或异常清理

## 验证

- `tests.test_static_coverage_closures_20260921_xxi`
- `tests.test_generation_gap_disposition_inventory`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
