# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除角色对象、包、服务器或类型。

目标章节：

- `general/ddl/drop_owned.txt`
- `general/ddl/drop_package.txt`
- `general/ddl/drop_server.txt`
- `general/ddl/drop_type.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个 DDL 删除命令包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_owned` | 4个专用角色与RESTRICT形态语法代表 |
| `drop_package` | 4个包/包体与IF EXISTS语法代表 |
| `drop_server` | 6个SERVER删除语法代表 |
| `drop_type` | 9个类型删除语法代表 |

处理方式：

- 原 dependency / scope open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- dependency / scope feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_owned static coverage | false | true |
| drop_package static coverage | false | true |
| drop_server static coverage | false | true |
| drop_type static coverage | false | true |
| static coverage complete | 111 / 307 | 115 / 307 |
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

- 跨库、共享对象、依赖链或权限遗留清理
- 包体删除后函数失效、包头保留或缺失NOTICE
- SERVER映射或外表依赖下的RESTRICT/CASCADE行为
- 字段、函数、操作符依赖下的TYPE CASCADE/RESTRICT行为

## 验证

- `tests.test_static_coverage_closures_20260921_xv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
