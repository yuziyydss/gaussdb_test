# PDF 质量抽取增量：DROP WEAK PASSWORD DICTIONARY FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_weak_password_dictionary.txt`
- 章节：1.13.10.50 DROP WEAK PASSWORD DICTIONARY
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_weak_password_dictionary_fresh_syntax
```

新增一个固定命令静态语法代表：

```sql
DROP WEAK PASSWORD DICTIONARY;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_weak_password_dictionary manifest | 0 | 1 |
| drop_weak_password_dictionary candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| global dictionary clear feature | needs_profile | needs_profile |
| 全库 manifest | 882 | 883 |
| 全库 candidate | 5,412 | 5,413 |
| 全库 distinct SQL | 5,325 | 5,326 |
| 有 manifest 的因子包 | 284 | 285 |
| 无 manifest 的因子包 | 33 | 32 |
| generation model complete | 267 / 284 | 268 / 285 |

## 保留边界

本轮只证明 `DROP WEAK PASSWORD DICTIONARY` 的一个静态语法候选存在，不证明：

- 实际清空 `gs_global_config`
- 全部弱口令删除行为
- 全局安全策略恢复
- 权限运行时回执

`drop_weak_password_dictionary_feature_global_dictionary_clear`
仍为 `needs_profile`。

## 验证

- `tests.test_drop_weak_password_dictionary_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有弱口令字典清空，没有 Git 提交或推送。
