# PDF 质量抽取增量：PARAMETERIZED STATIC COMMANDS（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建目录、不调用备份恢复工具。

目标章节：

- `general/ddl/alter_column_encryption_key.txt`
- `general/utility/impdp_database_create.txt`
- `general/utility/impdp_pluggable_database_create.txt`
- `general/utility/impdp_recover.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 4 个 manifest：

```text
manifest_alter_column_encryption_key_fresh_syntax
manifest_impdp_database_create_fresh_syntax
manifest_impdp_pluggable_database_create_fresh_syntax
manifest_impdp_recover_fresh_syntax
```

新增 8 个有限静态语法候选：

```sql
ALTER COLUMN ENCRYPTION KEY g_alter_column_encryption_key
WITH VALUES (CLIENT_MASTER_KEY = g_new_client_master_key);

IMPDP DATABASE CREATE
SOURCE = '/tmp/gaussdb_b8/export_database'
OWNER = b8_import_owner;

IMPDP DATABASE b8_import_db CREATE
SOURCE = '/tmp/gaussdb_b8/export_database'
OWNER = b8_import_owner LOCAL;

IMPDP DATABASE CREATE
SOURCE = '/tmp/gaussdb_b8/export_database'
OWNER = b8_import_owner LOCAL;

IMPDP DATABASE b8_import_db CREATE
SOURCE = '/tmp/gaussdb_b8/export_database'
OWNER = b8_import_owner;

IMPDP PLUGGABLE DATABASE b8_import_pdb CREATE
SOURCE = '/tmp/gaussdb_b8/export_pdb'
OWNER = b8_import_owner;

IMPDP DATABASE RECOVER
SOURCE = '/tmp/gaussdb_b8/export_database'
OWNER = b8_import_owner;

IMPDP DATABASE RECOVER
SOURCE = '/tmp/gaussdb_b8/export_database'
OWNER = b8_import_owner LOCAL;
```

其中 `IMPDP DATABASE CREATE` 覆盖数据库名省略/重命名与 `LOCAL` 省略/存在四个有限组合；
`IMPDP RECOVER` 覆盖 `LOCAL` 省略/存在两个有限组合。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| 本批 4 包 manifest | 0 / 4 | 4 / 4 |
| 本批 4 包 candidate | 0 | 8 |
| 全库 manifest | 896 | 900 |
| 全库 candidate | 5,426 | 5,434 |
| 全库 distinct SQL | 5,338 | 5,346 |
| 有 manifest 的因子包 | 298 | 302 |
| 无 manifest 的因子包 | 19 | 15 |
| generation model complete | 277 / 298 | 281 / 302 |

本批 4 个包的 `generation_model_complete` 均为 true；
`static_coverage_complete` 与 `behavior_coverage_complete` 均仍为 false。

## 保留边界

本轮只证明有限 SQL 形态可以静态生成，不证明：

- 全密态驱动可用、CEK/CMK 已存在、二者不同或国密兼容
- CEK 明文与加密列密文不变
- 导入目录存在、可读或归属正确
- 备份恢复工具可调用
- 数据库/PDB导入、恢复、异常重启或部分失败回滚行为

对应 runtime/open question feature 继续保留为 `needs_profile`。

## 验证

- `tests.test_no_manifest_parameterized_batch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts/run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有密钥创建，没有目录创建，没有备份恢复工具调用，没有 Git 提交或推送。
