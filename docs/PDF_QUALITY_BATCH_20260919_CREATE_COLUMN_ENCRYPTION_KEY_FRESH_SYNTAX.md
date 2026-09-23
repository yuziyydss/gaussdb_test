# PDF 质量抽取增量：CREATE COLUMN ENCRYPTION KEY FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_column_encryption_key.txt`
- 章节：1.13.9.14 CREATE COLUMN ENCRYPTION KEY
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_column_encryption_key_fresh_syntax
```

新增一个静态 CEK 语法代表：

```sql
CREATE COLUMN ENCRYPTION KEY g_create_column_encryption_key
WITH VALUES (
  CLIENT_MASTER_KEY = g_create_client_master_key,
  ALGORITHM = AEAD_AES_256_CBC_HMAC_SHA256
);
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_column_encryption_key manifest | 0 | 1 |
| create_column_encryption_key candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| driver feature | needs_profile | needs_profile |
| manager feature | needs_profile | needs_profile |
| length feature | needs_profile | needs_profile |
| 全库 manifest | 878 | 879 |
| 全库 candidate | 5,408 | 5,409 |
| 全库 distinct SQL | 5,321 | 5,322 |
| 有 manifest 的因子包 | 280 | 281 |
| 无 manifest 的因子包 | 37 | 36 |
| generation model complete | 265 / 280 | 265 / 281 |

## 保留边界

本轮只证明 `CREATE COLUMN ENCRYPTION KEY ... WITH VALUES (...)`
的一个静态语法候选存在，不证明：

- 真实 CEK 创建
- CMK 存在或可解密
- 驱动侧密态连接参数
- 管理器 × 算法兼容行为
- `ENCRYPTED_VALUE` 长度边界
- 外部密钥生命周期
- 目录身份
- 权限运行时回执

`create_column_encryption_key_feature_driver`、
`create_column_encryption_key_feature_manager` 与
`create_column_encryption_key_feature_length`
仍为 `needs_profile`。

## 验证

- `tests.test_create_column_encryption_key_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 CEK 创建，没有 Git 提交或推送。
