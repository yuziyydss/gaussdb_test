# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XVI（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不轮转TDE密钥、不清理AUTOHINT历史、不执行OM升级、不调用备份恢复工具。

目标章节：

- `general/ddl/alter_async_encryption_key_rotation.txt`
- `general/utility/autohint_purge.txt`
- `general/utility/generated_update_system_object.txt`
- `general/utility/impdp_pluggable_database_recover.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个固定命令包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 固定命令 |
|---|---|
| `alter_async_encryption_key_rotation` | `ALTER ASYNC ENCRYPTION KEY ROTATION;` |
| `autohint_purge` | `AUTOHINT PURGE;` |
| `generated_update_system_object` | `GENERATED UPDATE SYSTEM OBJECT;` |
| `impdp_pluggable_database_recover` | `IMPDP PLUGGABLE DATABASE RECOVER;` |

处理方式：

- 为每个固定命令增加显式 `command` 维度和固定值
- syntax 从固定 production 改为 `{command}`
- 现有 manifest 绑定该固定值
- 原运行时 open question 改为 confirmed environment 限制
- 文档 feature 从 `needs_profile` 改为 `covered / any`
- 不新增 manifest，不新增候选，不改变SQL文本

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_async_encryption_key_rotation static coverage | false | true |
| autohint_purge static coverage | false | true |
| generated_update_system_object static coverage | false | true |
| impdp_pluggable_database_recover static coverage | false | true |
| static coverage complete | 84 / 307 | 88 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,499 | 5,499 |
| 全库 distinct SQL | 5,409 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明固定命令静态形态，不证明：

- TDE密钥实际轮转、KMS状态或全局恢复
- AUTOHINT历史清理、权限或结果计数
- OM升级脚本生成、系统目录/文件快照或恢复
- 备份工具调用、PDB修复、打开或恢复验证

## 验证

- `tests.test_static_coverage_closures_20260921_ix`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
