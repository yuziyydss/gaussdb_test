# PDF 质量抽取增量：CREATE PLUGGABLE DATABASE FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_pluggable_database.txt`
- 章节：1.13.9.36 CREATE PLUGGABLE DATABASE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_pluggable_database_fresh_syntax
```

新增一个专用 PDB 名且省略选项的静态语法代表：

```sql
CREATE PLUGGABLE DATABASE g_create_pluggable_database;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_pluggable_database manifest | 0 | 1 |
| create_pluggable_database candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| PDB runtime feature | needs_profile | needs_profile |
| option combinations feature | needs_profile | needs_profile |
| timezone environment feature | needs_profile | needs_profile |
| name and 128 boundaries feature | needs_profile | needs_profile |
| 全库 manifest | 884 | 885 |
| 全库 candidate | 5,414 | 5,415 |
| 全库 distinct SQL | 5,327 | 5,328 |
| 有 manifest 的因子包 | 286 | 287 |
| 无 manifest 的因子包 | 31 | 30 |
| generation model complete | 268 / 286 | 268 / 287 |

## 保留边界

本轮只证明 `CREATE PLUGGABLE DATABASE <name>` 的一个静态语法候选存在，不证明：

- 真实 PDB 创建
- 多租资源容量与资源指令生命周期
- `WITH` 选项组合
- 编码、兼容模式或时区行为
- 名称边界与 128 个 PDB 上限
- MTD 运行时状态
- 权限运行时回执

`create_pluggable_database_feature_pdb_create`、
`create_pluggable_database_feature_with_option_combinations`、
`create_pluggable_database_feature_timezone_environment` 与
`create_pluggable_database_feature_name_and_128_boundaries`
仍为 `needs_profile`。

## 验证

- `tests.test_create_pluggable_database_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 PDB 创建，没有 Git 提交或推送。
