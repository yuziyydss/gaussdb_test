# PDF 质量抽取增量：IMPDP TABLE FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/impdp_table.txt`
- 章节：1.13.14.5 IMPDP TABLE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_impdp_table_fresh_syntax
```

新增一个静态表导入语法代表：

```sql
IMPDP TABLE AS g_impdp_table
SOURCE = '/tmp/gaussdb_static_import'
OWNER = g_impdp_owner;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| impdp_table manifest | 0 | 1 |
| impdp_table candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| physical backup restore feature | needs_profile | needs_profile |
| 全库 manifest | 888 | 889 |
| 全库 candidate | 5,418 | 5,419 |
| 全库 distinct SQL | 5,331 | 5,332 |
| 有 manifest 的因子包 | 290 | 291 |
| 无 manifest 的因子包 | 27 | 26 |
| generation model complete | 270 / 290 | 270 / 291 |

## 保留边界

本轮只证明 `IMPDP TABLE ... SOURCE = ... OWNER = ...`
的一个静态语法候选存在，不证明：

- 来源目录存在或可读
- 备份恢复工具可调用
- 物理备份完整性
- 表、索引、分区、TOAST 文件导入行为
- 备份恢复或清理行为

`impdp_table_feature_physical_backup_restore`
仍为 `needs_profile`。

## 验证

- `tests.test_impdp_table_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有目录创建，没有备份工具调用，没有 Git 提交或推送。
