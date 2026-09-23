# PDF 质量抽取增量：IMPDP TABLE PREPARE FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/impdp_table_prepare.txt`
- 章节：1.13.14.6 IMPDP TABLE PREPARE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_impdp_table_prepare_fresh_syntax
```

新增一个静态表导入准备语法代表：

```sql
IMPDP TABLE PREPARE
SOURCE = '/tmp/gaussdb_static_import'
OWNER = g_impdp_owner;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| impdp_table_prepare manifest | 0 | 1 |
| impdp_table_prepare candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| physical backup restore feature | needs_profile | needs_profile |
| 全库 manifest | 889 | 890 |
| 全库 candidate | 5,419 | 5,420 |
| 全库 distinct SQL | 5,332 | 5,333 |
| 有 manifest 的因子包 | 291 | 292 |
| 无 manifest 的因子包 | 26 | 25 |
| generation model complete | 270 / 291 | 271 / 292 |

## 保留边界

本轮只证明 `IMPDP TABLE PREPARE ... SOURCE = ... OWNER = ...`
的一个静态语法候选存在，不证明：

- 来源目录存在或可读
- 备份恢复工具可调用
- 物理备份完整性
- 表导入准备阶段成功
- 备份恢复或清理行为

`impdp_table_prepare_feature_physical_backup_restore`
仍为 `needs_profile`。

## 验证

- `tests.test_impdp_table_prepare_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有目录创建，没有备份工具调用，没有 Git 提交或推送。
