# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XLVI（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建角色、不修改索引、不执行游标、不修改类型。

目标章节：

- `general/ddl/create_role.txt`
- `general/ddl/alter_index.txt`
- `general/utility/cursor.txt`
- `general/ddl/alter_type.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `create_role` | 12个NOLOGIN/禁用密码/非提升权限代表 |
| `alter_index` | 27个普通、分区、重建、可见性与存储参数代表 |
| `cursor` | 7个BINARY/SCROLL/HOLD/VALUES/SELECT代表 |
| `alter_type` | 20个属性、枚举、属主、模式与重命名代表 |

处理方式：

- CREATE ROLE剩余选项、秘密策略、密文例外和命名边界，ALTER INDEX rowid/存储/并行/内部语法/错误身份，CURSOR带参与PL/SQL SCROLL，ALTER TYPE排序规则、依赖和具名属主等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_role static coverage | false | true |
| alter_index static coverage | false | true |
| cursor static coverage | false | true |
| alter_type static coverage | false | true |
| static coverage complete | 207 / 307 | 211 / 307 |
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

- CREATE ROLE高权限、成员关系、时间/空间/池/扩容参数、真实密码、EXPIRED、UNENCRYPTED或命名边界行为
- ALTER INDEX rowid系统对象、ACTIVE_PAGES、并行重建、GSIVALID/GSIUSABLE内部能力或缺失索引错误身份
- CURSOR PACKAGE默认参数或PL/SQL SCROLL行为
- ALTER TYPE排序规则转换、依赖联动RESTRICT错误或具名属主行为

## 验证

- `tests.test_static_coverage_closures_20260921_xlvi`
- 既有批次守卫3项复测通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
