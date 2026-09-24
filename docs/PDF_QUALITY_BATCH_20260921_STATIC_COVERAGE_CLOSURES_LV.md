# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LV（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建操作符、不创建函数、不创建操作符类。

目标章节：

- `general/ddl/create_operator_class.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `create_operator_class` 从 `generation_model_complete=false` 提升为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

不新增 manifest、候选、SQL、fixture、setup 或 teardown。

现有候选：

```sql
CREATE OPERATOR CLASS g_create_opclass_ns.g_create_opclass
FOR TYPE INTEGER USING btree AS FUNCTION 1
g_create_opclass_ns.compare_integer(INTEGER, INTEGER);
```

处理方式：

- 为 fresh 语法值登记 `original_value_ref`，用有限facet代表原条件值
- 索引方法契约固化为 confirmed environment
- OPERATOR项与省略操作数类型歧义固化为 confirmed constraint
- 不生成OPERATOR/STORAGE项
- 不宣称btree比较语义、索引目录行为或数据库执行通过

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_operator_class static coverage | false | true |
| static coverage complete | 231 / 308 | 232 / 308 |
| generation model complete | 299 / 308 | 300 / 308 |
| 全库 manifest | 932 | 932 |
| 全库 candidate | 5,509 | 5,509 |
| 全库 distinct SQL | 5,419 | 5,419 |

## 保留边界

本轮只证明有限静态语法，不证明：

- OPERATOR项、STORAGE项或省略操作数类型行为
- btree索引方法契约或比较语义
- 操作符类目录行为
- 支持函数在索引中的实际调用行为

## 验证

- `tests.test_static_coverage_closures_20260921_lv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
