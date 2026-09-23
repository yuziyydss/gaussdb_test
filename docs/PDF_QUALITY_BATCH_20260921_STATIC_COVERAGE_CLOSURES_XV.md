# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XV（2026-09-21）

## 范围

本轮继续 M-Compatibility SQL PDF 质量抽取，不连接数据库、不执行闪回。

目标章节：

- `m_compat/utility/timecapsule_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `m_timecapsule_table` 从 `static_coverage_complete=false` 提升为 `true`。

处理对象：

```text
manifest_m_timecapsule_table_truncate_rename_negative
```

原文确认：

```text
RENAME TO仅支持DROP闪回操作为检索表指定新名称，不支持TRUNCATE闪回。
```

同一段原文给出目标错误：

```text
ERROR: recycle object %s desired does not exist.
```

新增事实：

```text
m_timecapsule_table_fact_rename_error
```

负向 manifest 从 `needs_verification` 提升为 `confirmed`：

- `error_category = rename_only_drop`
- `error_message_regex = recycle object .* desired does not exist`
- `scope = syntax_and_semantics`
- `fact_refs = m_timecapsule_table_fact_rename_error`

同时将携带该错误文本的 source unit 从 `out_of_scope` 改为 `mapped`。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| m_timecapsule_table static coverage | false | true |
| static coverage complete | 83 / 307 | 84 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,499 | 5,499 |
| 全库 distinct SQL | 5,409 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

`m_timecapsule_table` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只确认原文错误身份，不证明：

- 数据库实际报错文本
- TRUNCATE恢复成功行为
- 回收站对象生命周期
- RENAME恢复后的对象身份
- CSN/TIMESTAMP恢复点
- 统计信息、依赖对象或权限行为

## 验证

- `tests.test_m_timecapsule_table_truncate_ddl_negative`
- `tests.test_m_compat_recyclebin`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
