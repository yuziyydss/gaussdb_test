# PDF 质量抽取增量：M TIMECAPSULE TABLE DDL NEGATIVE（2026-09-20）

## 范围

本轮继续 M-Compatibility PDF 质量抽取，不连接数据库、不执行TIMECAPSULE TABLE。

目标章节：

- `m_compat/utility/timecapsule_table.txt`
- 章节：2.4.2.17.2 TIMECAPSULE TABLE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_m_timecapsule_table_truncate_ddl_negative
```

新增 fixture：

```text
fixture_m_timecapsule_table_truncate_ddl
```

该 fixture 在同一生命周期内执行：

```sql
CREATE SCHEMA m_timecapsule_namespace;
CREATE TABLE m_timecapsule_namespace.source (id INTEGER, qty INTEGER);
INSERT INTO m_timecapsule_namespace.source VALUES (1,10),(2,20);
TRUNCATE TABLE m_timecapsule_namespace.source;
ALTER TABLE m_timecapsule_namespace.source
  ADD COLUMN ddl_marker INTEGER;
```

新增一个来源确认负向候选：

```sql
TIMECAPSULE TABLE m_timecapsule_namespace.source TO BEFORE TRUNCATE;
```

目标错误来自原文：

```text
ERROR: The table definition of %s has been modified.
```

模型中登记为：

- `error_category = intervening_ddl_modified_table`
- `error_message_regex = The table definition of .* has been modified`
- `oracle_status = confirmed`
- `scope = syntax_and_semantics`

同时新增规则：

```text
m_timecapsule_table_rule_no_intervening_ddl
```

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| m_timecapsule_table manifest | 3 | 4 |
| m_timecapsule_table candidate | 4 | 5 |
| 全库 manifest | 912 | 913 |
| 全库 candidate | 5,484 | 5,485 |
| 全库 distinct SQL | 5,396 | 5,396 |
| generation model complete | 295 / 306 | 295 / 306 |

distinct SQL 不变，因为该负向候选与正向 `BEFORE TRUNCATE` 语句文本相同；
差异在fixture生命周期、参数和错误Oracle，不在SQL文本。

`m_timecapsule_table` 仍为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合“TRUNCATE与闪回间发生DDL”的错误身份，不证明：

- 数据库实际执行该错误
- TRUNCATE恢复成功行为
- DDL种类全矩阵
- 回收站对象生命周期
- 现有TRUNCATE+RENAME负向错误身份

`manifest_m_timecapsule_table_truncate_rename_negative` 仍为
`needs_verification`。

## 验证

- `tests.test_m_timecapsule_table_truncate_ddl_negative`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
