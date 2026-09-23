# PDF 质量抽取增量：STATIC COVERAGE CLOSURES L（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建类型、不修改扩展、不添加COMMENT、不创建表。

目标章节：

- `general/ddl/create_type.txt`
- `general/ddl/alter_extension.txt`
- `general/ddl/comment.txt`
- `general/ddl/create_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_type` | 9个复合/枚举/壳/集合类型代表 |
| `alter_extension` | 5个UPDATE/SET SCHEMA/ADD/DROP成员代表 |
| `comment` | 124个有限对象与注释文本代表 |
| `create_table` | 8个永久/UNLOGGED/临时两列代表 |

处理方式：

- CREATE TYPE基本类型回调、间接类型、排序规则、Unicode边界和构造器，ALTER EXTENSION脚本审核与非TABLE成员，COMMENT其他对象与可见性，CREATE TABLE无界元素、约束重复、LIKE组合、存储/加密/ILM/TDE/错误身份等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`；原本有限完整的`all`域保持`all`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_type static coverage | false | true |
| alter_extension static coverage | false | true |
| comment static coverage | false | true |
| create_table static coverage | false | true |
| static coverage complete | 223 / 307 | 227 / 307 |
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

- CREATE TYPE基本类型回调、间接类型、排序规则、Unicode边界或构造器行为
- ALTER EXTENSION版本脚本、非TABLE成员或成员签名行为
- COMMENT其他对象、权限、目录身份、多用户可见性或共享对象范围
- CREATE TABLE无界元素、约束组合、LIKE组合、存储/加密/ILM/TDE/ON COMMIT或错误身份行为

## 验证

- `tests.test_static_coverage_closures_20260921_l`
- 既有批次与COMMENT守卫复测通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
