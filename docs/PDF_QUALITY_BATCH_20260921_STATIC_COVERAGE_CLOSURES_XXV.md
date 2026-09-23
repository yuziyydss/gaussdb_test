# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXV（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除文本搜索对象、不刷新物化视图、不创建二级分区表。

目标章节：

- `general/ddl/drop_text_search_configuration.txt`
- `general/ddl/drop_text_search_dictionary.txt`
- `general/utility/refresh_materialized_view.txt`
- `general/ddl/create_table_subpartition.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_text_search_configuration` | 已有/缺失目标共9个删除语法代表 |
| `drop_text_search_dictionary` | 已有/缺失目标共9个删除语法代表 |
| `refresh_materialized_view` | 全量与增量物化视图两个刷新语法代表 |
| `create_table_subpartition` | 9种两层显式分区策略与行迁移共18个语法代表 |

处理方式：

- 原 dependency / privilege / extended-profile open question 改为 confirmed environment 限制
- syntax feature 从 `representative` 改为 `any`
- dependency / privilege / extended feature 从 `needs_profile` 改为 `covered / any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_text_search_configuration static coverage | false | true |
| drop_text_search_dictionary static coverage | false | true |
| refresh_materialized_view static coverage | false | true |
| create_table_subpartition static coverage | false | true |
| static coverage complete | 123 / 307 | 127 / 307 |
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

- 文本搜索配置或词典依赖下的 `RESTRICT` / `CASCADE` 行为
- 物化视图刷新权限拒绝、SQLSTATE或刷新结果
- 二级分区模板、自动扩展层级、INTERVAL、多列键、KEY/COLUMNS、索引约束或分区DML语义

## 验证

- `tests.test_static_coverage_closures_20260921_xviii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
