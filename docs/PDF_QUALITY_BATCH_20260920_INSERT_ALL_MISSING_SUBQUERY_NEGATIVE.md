# PDF 质量抽取增量：INSERT ALL MISSING SUBQUERY NEGATIVE（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行INSERT ALL。

目标章节：

- `general/dml/insert_all.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_insert_all_missing_subquery_negative
```

新增一个来源确认负向候选：

```sql
INSERT ALL
INTO fp_cs_one.b11_ia_a (col_1,col_2)
VALUES (col_1,col_2);
```

目标错误来自原文：

```text
ERROR: syntax error at or near ";"
```

模型中登记为：

- `error_category = missing_subquery`
- `error_message_regex = syntax error at or near ";"`
- `oracle_status = confirmed`
- `scope = syntax_and_semantics`

同时新增规则：

```text
insert_all_rule_subquery_required
```

为表达该分支，语法模型新增 `subquery_presence` 维度：

- `present`：保留现有尾部 `SELECT ...`
- `absent`：省略尾部子查询，用于负向代表

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| insert_all manifest | 7 | 8 |
| insert_all candidate | 13 | 14 |
| 全库 manifest | 910 | 911 |
| 全库 candidate | 5,482 | 5,483 |
| 全库 distinct SQL | 5,394 | 5,395 |
| generation model complete | 295 / 306 | 295 / 306 |

`insert_all` 仍为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合“INSERT ALL缺少尾部子查询”的错误身份，不证明：

- 数据库实际执行该错误
- VALUES内子查询错误
- ELSE语法是否正式支持
- INSERT ALL整体静态覆盖

`insert_all_fact_negative_oracle` 与
`insert_all_fact_else_not_formal` 继续保留为未解决问题。

## 验证

- `tests.test_insert_all_missing_subquery_negative`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
