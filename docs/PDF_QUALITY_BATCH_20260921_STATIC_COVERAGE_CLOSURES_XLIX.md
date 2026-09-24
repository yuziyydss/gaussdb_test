# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLIX（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建或修改存储过程、不创建函数、不执行M PREPARE、不执行VACUUM。

目标章节：

- `general/ddl/create_procedure.txt`
- M `PREPARE`
- `general/ddl/create_function.txt`
- `general/utility/vacuum.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_procedure` | 9个单IN参数、默认值、IS/AS与OR REPLACE代表 |
| `m_prepare` | 17个有限PREPARE body代表 |
| `create_function` | 20个SQL标量函数与OR REPLACE代表 |
| `vacuum` | 23个普通、ANALYZE与括号选项代表 |

处理方式：

- CREATE PROCEDURE OUT/INOUT/VARIADIC、高级属性、LEAKPROOF、定义者、COST/SET、间接类型、END过程名与嵌套调用，M PREPARE额外语句族，CREATE FUNCTION高级返回/属性/OUT/PACKAGE/替换冲突，VACUUM分区、在线、并行、追增、BUCKETS、全库与错误列等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域或profile从 `representative` 改为 `any`
- 复用现有有限值域或profile
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_procedure static coverage | false | true |
| m_prepare static coverage | false | true |
| create_function static coverage | false | true |
| vacuum static coverage | false | true |
| static coverage complete | 219 / 307 | 223 / 307 |
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

- CREATE PROCEDURE OUT/INOUT/VARIADIC、高级属性、LEAKPROOF、定义者、COST/SET、间接类型、END过程名或嵌套调用行为
- M PREPARE额外语句族的真实前置条件、有限代表或目标预期
- CREATE FUNCTION WINDOW/internal/LEAKPROOF/权限提升/OUT/复合返回/任意重复属性或替换冲突行为
- VACUUM分区、在线降级、并行、追增、BUCKETS、全库清理或错误列分阶段失败行为

## 验证

- `tests.test_static_coverage_closures_20260921_xlix`
- 既有批次守卫14项复测通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
