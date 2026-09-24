# PDF 质量抽取增量：INSERT ALL SUBQUERY ALIAS NEGATIVE（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行INSERT ALL。

目标章节：

- `general/dml/insert_all.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_insert_all_subquery_alias_negative
```

新增一个来源确认负向候选：

```sql
INSERT ALL
INTO fp_cs_one.b11_ia_a (col_1,col_2)
VALUES (source_alias.col_1,'a')
SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source source_alias;
```

目标错误来自原文：

```text
ERROR: Missing FROM-clause entry for table "t1"
```

模型中登记为：

- `error_category = subquery_alias_reference`
- `error_message_regex = Missing FROM-clause entry for table "source_alias"`
- `oracle_status = confirmed`
- `scope = syntax_and_semantics`

同时新增规则：

```text
insert_all_rule_no_subquery_alias_reference
```

为保持有限值域闭合，正向 unconditional manifest 也选择“子查询带别名但INTO不引用别名”的合法形态。该正向候选只证明别名可出现在源查询中，不证明别名可在INTO中引用。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| insert_all manifest | 5 | 6 |
| insert_all candidate | 11 | 12 |
| 全库 manifest | 908 | 909 |
| 全库 candidate | 5,480 | 5,481 |
| 全库 distinct SQL | 5,392 | 5,393 |
| generation model complete | 295 / 306 | 295 / 306 |

`insert_all` 仍为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合“INTO引用子查询表别名”的错误身份，不证明：

- 数据库实际执行该错误
- VALUES内子查询错误
- 视图目标错误
- 缺失子查询错误
- ELSE语法是否正式支持
- INSERT ALL整体静态覆盖

`insert_all_fact_negative_oracle` 与
`insert_all_fact_else_not_formal` 继续保留为未解决问题。

## 验证

- `tests.test_insert_all_subquery_alias_negative`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
