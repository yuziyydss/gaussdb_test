# PDF 质量抽取增量：STATIC COVERAGE CLOSURES X（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建或删除审计策略、目录对象或定时任务。

目标章节：

- `general/ddl/drop_audit_policy.txt`
- `general/ddl/drop_directory.txt`
- `general/ddl/drop_event.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `drop_audit_policy`、`drop_directory` 与 `drop_event` 从
`static_coverage_complete=false` 提升为 `true`。

新增 3 个 manifest：

```text
manifest_drop_audit_policy_missing_if_exists
manifest_drop_directory_missing_if_exists
manifest_drop_event_missing_if_exists
```

新增 3 个确认缺失目标的静态候选：

```sql
DROP AUDIT POLICY IF EXISTS b10_audit_missing;

DROP DIRECTORY IF EXISTS dir_b7_missing;

DROP EVENT IF EXISTS fp_cs_one.b10_event_missing;
```

三个包均把固定目标名扩展为有限目标名维度：

- 已有专用对象
- 确认未创建的专用缺失对象

原有已有对象候选保持不变。缺失对象事实从 open question 改为
confirmed behavior oracle，但只确认文档级结论：

- `IF EXISTS` 缺失目标只产生 NOTICE
- `DROP AUDIT POLICY` 无 `IF EXISTS` 且目标缺失时报错

具体 NOTICE 文本、SQLSTATE、操作系统路径、自动删除任务和运行中任务行为
仍保留在 planned 行为场景，不计入静态覆盖。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_audit_policy static coverage | false | true |
| drop_directory static coverage | false | true |
| drop_event static coverage | false | true |
| static coverage complete | 73 / 307 | 76 / 307 |
| 全库 manifest | 921 | 924 |
| 全库 candidate | 5,493 | 5,496 |
| 全库 distinct SQL | 5,403 | 5,406 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

三个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明缺失目标名与 `IF EXISTS` 的有限静态语法，不证明：

- 数据库实际 NOTICE 文本
- 无 `IF EXISTS` 时目标错误的 SQLSTATE
- 操作系统路径是否删除
- 已执行自动删除任务或运行中任务的删除语义
- 审计策略、目录对象或定时任务的实际删除行为

## 验证

- `tests.test_static_coverage_closures_20260921_iii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
