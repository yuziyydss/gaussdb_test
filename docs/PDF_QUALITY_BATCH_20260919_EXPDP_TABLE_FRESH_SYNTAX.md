# PDF 质量抽取增量：EXPDP TABLE FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/expdp_table.txt`
- 章节：1.13.11.4 EXPDP TABLE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_expdp_table_fresh_syntax
```

新增一个静态表导出语法代表：

```sql
EXPDP TABLE g_expdp_table
LOCATION = '/tmp/gaussdb_static_export';
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| expdp_table manifest | 0 | 1 |
| expdp_table candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| physical backup restore feature | needs_profile | needs_profile |
| 全库 manifest | 887 | 888 |
| 全库 candidate | 5,417 | 5,418 |
| 全库 distinct SQL | 5,330 | 5,331 |
| 有 manifest 的因子包 | 289 | 290 |
| 无 manifest 的因子包 | 28 | 27 |
| generation model complete | 269 / 289 | 270 / 290 |

## 保留边界

本轮只证明 `EXPDP TABLE ... LOCATION = ...` 的一个静态语法候选存在，不证明：

- 目录存在或可写
- 备份恢复工具可调用
- 物理备份完整性
- 表、索引、分区、TOAST 文件导出行为
- 备份恢复或清理行为

`expdp_table_feature_physical_backup_restore` 仍为 `needs_profile`。

## 验证

- `tests.test_expdp_table_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有目录创建，没有备份工具调用，没有 Git 提交或推送。
