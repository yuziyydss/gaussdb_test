# PDF 质量抽取增量：CREATE WEAK PASSWORD DICTIONARY FRESH SINGLE（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_weak_password_dictionary.txt`
- 章节：1.13.9.61 CREATE WEAK PASSWORD DICTIONARY
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_weak_password_dictionary_fresh_single
```

新增一个单值静态语法代表：

```sql
CREATE WEAK PASSWORD DICTIONARY ('static_only');
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_weak_password_dictionary manifest | 0 | 1 |
| create_weak_password_dictionary candidate | 0 | 1 |
| single-value syntax feature | 未登记 | covered / representative |
| dictionary runtime feature | needs_profile | needs_profile |
| multiple-values ambiguity feature | needs_profile | needs_profile |
| 全库 manifest | 883 | 884 |
| 全库 candidate | 5,413 | 5,414 |
| 全库 distinct SQL | 5,326 | 5,327 |
| 有 manifest 的因子包 | 285 | 286 |
| 无 manifest 的因子包 | 32 | 31 |
| generation model complete | 268 / 285 | 268 / 286 |

## 保留边界

本轮只证明 `CREATE WEAK PASSWORD DICTIONARY (<single_string>)`
的一个静态语法候选存在，不证明：

- 实际写入 `gs_global_config`
- 弱口令去重行为
- 全局安全策略恢复
- 多值语法
- `WITH VALUES` 行为
- 权限运行时回执

`create_weak_password_dictionary_feature_dictionary_runtime` 与
`create_weak_password_dictionary_feature_multiple_values_ambiguity`
仍为 `needs_profile`。

## 验证

- `tests.test_create_weak_password_dictionary_fresh_single`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有弱口令字典写入，没有 Git 提交或推送。
