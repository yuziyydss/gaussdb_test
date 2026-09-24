# PDF 质量抽取增量：DROP CLIENT MASTER KEY FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_client_master_key.txt`
- 章节：1.13.10.8 DROP CLIENT MASTER KEY
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_client_master_key_fresh_syntax
```

新增一个静态 CMK 名语法代表：

```sql
DROP CLIENT MASTER KEY g_drop_client_master_key;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_client_master_key manifest | 0 | 1 |
| drop_client_master_key candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| keys feature | needs_profile | needs_profile |
| 全库 manifest | 874 | 875 |
| 全库 candidate | 5,404 | 5,405 |
| 全库 distinct SQL | 5,317 | 5,318 |
| 有 manifest 的因子包 | 276 | 277 |
| 无 manifest 的因子包 | 41 | 40 |
| generation model complete | 264 / 276 | 264 / 277 |

## 保留边界

本轮只证明 `DROP CLIENT MASTER KEY <name>`
的一个静态语法候选存在，不证明：

- CMK 已存在
- 实际删除目录元数据
- `IF EXISTS` 行为
- `CASCADE` / `RESTRICT` 行为
- 外部密钥实体状态
- 权限运行时回执

`drop_client_master_key_feature_keys` 仍为 `needs_profile`。

## 验证

- `tests.test_drop_client_master_key_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 CMK 删除，没有 Git 提交或推送。
