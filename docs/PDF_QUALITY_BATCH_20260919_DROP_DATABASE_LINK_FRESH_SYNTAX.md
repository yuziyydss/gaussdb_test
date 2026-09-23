# PDF 质量抽取增量：DROP DATABASE LINK FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_database_link.txt`
- 章节：1.13.10.11 DROP DATABASE LINK
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_database_link_fresh_syntax
```

新增一个静态私有 DBLink 名语法代表：

```sql
DROP DATABASE LINK g_drop_database_link;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_database_link manifest | 0 | 1 |
| drop_database_link candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| runtime feature | needs_profile | needs_profile |
| 全库 manifest | 879 | 880 |
| 全库 candidate | 5,409 | 5,410 |
| 全库 distinct SQL | 5,322 | 5,323 |
| 有 manifest 的因子包 | 281 | 282 |
| 无 manifest 的因子包 | 36 | 35 |
| generation model complete | 265 / 281 | 265 / 282 |

## 保留边界

本轮只证明 `DROP DATABASE LINK <name>` 的一个静态语法候选存在，不证明：

- DBLink 已存在
- 实际删除行为
- `IF EXISTS` 行为
- 公共 / 私有连接行为
- A 兼容模式运行时行为
- 非初始用户权限运行时回执

`drop_database_link_feature_runtime` 仍为 `needs_profile`。

## 验证

- `tests.test_drop_database_link_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 DBLink 删除，没有 Git 提交或推送。
