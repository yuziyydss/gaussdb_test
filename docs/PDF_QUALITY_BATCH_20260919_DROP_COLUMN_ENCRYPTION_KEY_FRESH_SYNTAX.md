# PDF 质量抽取增量：DROP COLUMN ENCRYPTION KEY FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_column_encryption_key.txt`
- 章节：1.13.10.9 DROP COLUMN ENCRYPTION KEY
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_column_encryption_key_fresh_syntax
```

新增一个静态 CEK 名语法代表：

```sql
DROP COLUMN ENCRYPTION KEY g_drop_column_encryption_key;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_column_encryption_key manifest | 0 | 1 |
| drop_column_encryption_key candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| keys feature | needs_profile | needs_profile |
| 全库 manifest | 875 | 876 |
| 全库 candidate | 5,405 | 5,406 |
| 全库 distinct SQL | 5,318 | 5,319 |
| 有 manifest 的因子包 | 277 | 278 |
| 无 manifest 的因子包 | 40 | 39 |
| generation model complete | 264 / 277 | 264 / 278 |

## 保留边界

本轮只证明 `DROP COLUMN ENCRYPTION KEY <name>`
的一个静态语法候选存在，不证明：

- CEK 已存在
- 实际删除目录元数据
- `IF EXISTS` 行为
- `CASCADE` / `RESTRICT` 行为
- 依赖加密列状态
- 外部密钥实体状态
- 权限运行时回执

`drop_column_encryption_key_feature_keys` 仍为 `needs_profile`。

## 验证

- `tests.test_drop_column_encryption_key_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 CEK 删除，没有 Git 提交或推送。
