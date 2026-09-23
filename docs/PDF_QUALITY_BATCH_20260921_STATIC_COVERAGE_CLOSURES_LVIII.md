# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LVIII（2026-09-23）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建真实CMK、不注入驱动凭据或访问外部密钥管理器。

目标章节：

- `general/ddl/create_client_master_key.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `create_client_master_key` 从 `generation_model_complete=false` 提升为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

不新增 manifest；现有 `manifest_create_client_master_key_fresh_syntax` 扩展为 5 个 `syntax_only` 候选：

```sql
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = AES_256_CBC);
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = AES_256_GCM);
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = SM4);
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = SM4_HMAC_SM3);
CREATE CLIENT MASTER KEY g_create_client_master_key WITH (KEY_STORE = user_token, ALGORITHM = SM4_CTR_HMAC_SM3);
```

处理方式：

- 只扩展原文确认的 `user_token` 无KEY_PATH分支和五种算法
- `hcs_kms`、`sdf_kms`与仅支持外部管理器的`AES_256`保持 `unknown`，不伪造KEY_PATH或密钥
- 运行时凭据、外部密钥生命周期、恢复契约和管理器×算法×KEY_PATH兼容性固化为 confirmed environment
- 不新增fixture、setup或teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_client_master_key static coverage | false | true |
| static coverage complete | 234 / 308 | 235 / 308 |
| generation model complete | 302 / 308 | 303 / 308 |
| 全库 manifest | 934 | 934 |
| 全库 candidate | 5,511 | 5,515 |
| 全库 distinct SQL | 5,421 | 5,425 |
| 有 manifest 的因子包 | 308 | 308 |
| 无 manifest 的因子包 | 9 | 9 |

## 保留边界

本轮只证明有限静态语法，不证明：

- 受控驱动`-C`连接、用户密码/key_token交互或秘密注入
- hcs_kms/sdf_kms的KEY_PATH与外部管理器兼容组合
- CMK生命周期、恢复或真实加密列行为
- SQL执行成功或数据库对象创建通过

## 验证

- `tests.test_static_coverage_closures_20260921_lviii`
- `tests.test_create_client_master_key_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
