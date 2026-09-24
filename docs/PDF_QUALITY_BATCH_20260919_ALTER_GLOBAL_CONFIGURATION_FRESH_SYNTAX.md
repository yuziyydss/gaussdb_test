# PDF 质量抽取增量：ALTER GLOBAL CONFIGURATION FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_global_configuration.txt`
- 章节：1.13.7.15 ALTER GLOBAL CONFIGURATION
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_alter_global_configuration_fresh_syntax
```

新增一个静态全局配置键值语法代表：

```sql
ALTER GLOBAL CONFIGURATION WITH
  (g_alter_global_config_syntax = 'static_only');
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_global_configuration manifest | 0 | 1 |
| alter_global_configuration candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| global upsert feature | needs_profile | needs_profile |
| 全库 manifest | 872 | 873 |
| 全库 candidate | 5,402 | 5,403 |
| 全库 distinct SQL | 5,315 | 5,316 |
| 有 manifest 的因子包 | 274 | 275 |
| 无 manifest 的因子包 | 43 | 42 |
| generation model complete | 264 / 274 | 264 / 275 |

## 保留边界

本轮只证明 `ALTER GLOBAL CONFIGURATION WITH (...)`
的一个静态语法候选存在，不证明：

- `gs_global_config` 实际新增或修改
- 全局状态快照与恢复
- 受保护键 `weak_password` / `undostoragetype`
- 多键语法
- 初始用户权限运行时回执

`alter_global_configuration_feature_global_upsert`
仍为 `needs_profile`。

## 验证

- `tests.test_alter_global_configuration_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有全局配置修改，没有 Git 提交或推送。
