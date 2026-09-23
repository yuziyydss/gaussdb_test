# PDF 质量抽取增量：DROP GLOBAL CONFIGURATION FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_global_configuration.txt`
- 章节：1.13.10.18 DROP GLOBAL CONFIGURATION
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_global_configuration_fresh_syntax
```

新增一个静态全局配置键语法代表：

```sql
DROP GLOBAL CONFIGURATION g_drop_global_config_syntax;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_global_configuration manifest | 0 | 1 |
| drop_global_configuration candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| drop existing keys feature | needs_profile | needs_profile |
| 全库 manifest | 873 | 874 |
| 全库 candidate | 5,403 | 5,404 |
| 全库 distinct SQL | 5,316 | 5,317 |
| 有 manifest 的因子包 | 275 | 276 |
| 无 manifest 的因子包 | 42 | 41 |
| generation model complete | 264 / 275 | 264 / 276 |

## 保留边界

本轮只证明 `DROP GLOBAL CONFIGURATION <name>`
的一个静态语法候选存在，不证明：

- `gs_global_config` 键存在
- 实际删除行为
- 不存在键报错行为
- 全局状态恢复
- 多键语法
- 初始用户权限运行时回执

`drop_global_configuration_feature_drop_existing_keys`
仍为 `needs_profile`。

## 验证

- `tests.test_drop_global_configuration_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有全局配置删除，没有 Git 提交或推送。
