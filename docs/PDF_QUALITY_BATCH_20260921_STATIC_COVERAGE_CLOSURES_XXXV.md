# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXV（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不准备两阶段事务、不重置参数、不创建快照、不导入文件。

目标章节：

- `general/tcl/prepare_transaction.txt`
- `general/utility/reset.txt`
- `general/utility/snapshot.txt`
- `general/ddl/load_data.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `prepare_transaction` | 合法短ID和最大合法ID两个语法代表 |
| `reset` | 6个目标/参数语法代表 |
| `snapshot` | COMMENT开关与查询域共4个语法代表 |
| `load_data` | 默认/显式两列映射共2个语法代表 |

处理方式：

- 原 runtime / source-conflict open question 改为 confirmed environment 或 constraint 限制
- syntax feature 从 `representative` 改为 `any`
- runtime / dependency feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| prepare_transaction static coverage | false | true |
| reset static coverage | false | true |
| snapshot static coverage | false | true |
| load_data static coverage | false | true |
| static coverage complete | 163 / 307 | 167 / 307 |
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

- 200字节超限、多字节ID、冲突事务或两阶段失败清理
- 完整可重置GUC域、特殊参数限制或ALTER SESSION兼容行为
- 增量快照依赖图、FROM迭代、PUBLISH/ARCHIVE或失败归属清理
- 服务器文件部署、访问权限、传输协议或逐行导入错误

## 验证

- `tests.test_static_coverage_closures_20260921_xxviii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
