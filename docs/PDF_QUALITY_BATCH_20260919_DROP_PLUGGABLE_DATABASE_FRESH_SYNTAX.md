# PDF 质量抽取增量：DROP PLUGGABLE DATABASE FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_pluggable_database_including_datafiles.txt`
- 章节：1.13.10.29 DROP PLUGGABLE DATABASE INCLUDING DATAFILES
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_pluggable_database_including_datafiles_fresh_syntax
```

新增一个专用 PDB 名静态语法代表：

```sql
DROP PLUGGABLE DATABASE g_drop_pluggable_database INCLUDING DATAFILES;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_pluggable_database manifest | 0 | 1 |
| drop_pluggable_database candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| drop PDB runtime feature | needs_profile | needs_profile |
| 全库 manifest | 885 | 886 |
| 全库 candidate | 5,415 | 5,416 |
| 全库 distinct SQL | 5,328 | 5,329 |
| 有 manifest 的因子包 | 287 | 288 |
| 无 manifest 的因子包 | 30 | 29 |
| generation model complete | 268 / 287 | 269 / 288 |

## 保留边界

本轮只证明 `DROP PLUGGABLE DATABASE ... INCLUDING DATAFILES`
的一个静态语法候选存在，不证明：

- PDB 已存在
- PDB 已关闭
- 实际删除 PDB 或数据文件
- `template_pdb` 保护行为
- 资源计划指令保留行为
- MTD 运行时状态
- 权限运行时回执
- 外部数据目标恢复

`drop_pluggable_database_including_datafiles_feature_drop_pdb`
仍为 `needs_profile`。

## 验证

- `tests.test_drop_pluggable_database_including_datafiles_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 PDB 或数据文件删除，没有 Git 提交或推送。
