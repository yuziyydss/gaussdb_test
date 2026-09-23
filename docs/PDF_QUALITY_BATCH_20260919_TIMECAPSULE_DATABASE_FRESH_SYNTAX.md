# PDF 质量抽取增量：TIMECAPSULE DATABASE FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/timecapsule_database.txt`
- 章节：1.13.20.3 TIMECAPSULE DATABASE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_timecapsule_database_fresh_syntax
```

新增一个静态库名语法代表：

```sql
TIMECAPSULE DATABASE g_timecapsule_database TO BEFORE DROP;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| timecapsule_database manifest | 0 | 1 |
| timecapsule_database candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| runtime feature | needs_profile | needs_profile |
| 全库 manifest | 881 | 882 |
| 全库 candidate | 5,411 | 5,412 |
| 全库 distinct SQL | 5,324 | 5,325 |
| 有 manifest 的因子包 | 283 | 284 |
| 无 manifest 的因子包 | 34 | 33 |
| generation model complete | 266 / 283 | 267 / 284 |

## 保留边界

本轮只证明 `TIMECAPSULE DATABASE ... TO BEFORE DROP`
的一个静态语法候选存在，不证明：

- 库回收站对象存在
- 实际闪回行为
- 回收站身份
- 跨连接恢复
- `RENAME TO` 行为
- 多版本回收站对象检索
- 权限运行时回执

`timecapsule_database_feature_runtime` 仍为 `needs_profile`。

## 验证

- `tests.test_timecapsule_database_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有库回收站恢复，没有 Git 提交或推送。
