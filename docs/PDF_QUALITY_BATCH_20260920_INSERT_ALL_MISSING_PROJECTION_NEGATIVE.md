# PDF 质量抽取增量：INSERT ALL MISSING PROJECTION NEGATIVE（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行INSERT ALL。

目标章节：

- `general/dml/insert_all.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_insert_all_missing_projection_negative
```

新增一个来源确认负向候选：

```sql
INSERT ALL
WHEN missing_col > 1 THEN
INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2)
WHEN col_1 > 1 THEN
INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2)
SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
```

目标错误来自原文：

```text
ERROR: Column "c1" does not exist.
```

模型中登记为：

- `error_category = missing_projection_column`
- `error_message_regex = Column "missing_col" does not exist`
- `oracle_status = confirmed`
- `scope = syntax_and_semantics`

同时新增规则：

```text
insert_all_rule_condition_projection_exists
```

并将 `insert_all_fact_negative_oracle` 收窄为：子查询仍需目标错误Oracle；聚集函数、多行VALUES和缺失投影列错误已有原文消息和负向清单，未执行数据库。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| insert_all manifest | 4 | 5 |
| insert_all candidate | 10 | 11 |
| 全库 manifest | 907 | 908 |
| 全库 candidate | 5,479 | 5,480 |
| 全库 distinct SQL | 5,391 | 5,392 |
| generation model complete | 295 / 306 | 295 / 306 |

`insert_all` 仍为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合“WHEN条件引用子查询不存在列”的错误身份，不证明：

- 数据库实际执行该错误
- VALUES内子查询错误
- ELSE语法是否正式支持
- INSERT ALL整体静态覆盖

`insert_all_fact_negative_oracle` 与
`insert_all_fact_else_not_formal` 继续保留为未解决问题。

## 验证

- `tests.test_insert_all_missing_projection_negative`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
