# PDF 质量抽取增量：STATIC FIXED COMMANDS（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行破坏性命令。

目标章节：

- `general/ddl/alter_async_encryption_key_rotation.txt`
- `general/utility/autohint_purge.txt`
- `general/utility/generated_update_system_object.txt`
- `general/utility/impdp_pluggable_database_recover.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 4 个 manifest：

```text
manifest_alter_async_encryption_key_rotation_fresh_syntax
manifest_autohint_purge_fresh_syntax
manifest_generated_update_system_object_fresh_syntax
manifest_impdp_pluggable_database_recover_fresh_syntax
```

新增 4 个固定命令静态语法代表：

```sql
ALTER ASYNC ENCRYPTION KEY ROTATION;
AUTOHINT PURGE;
GENERATED UPDATE SYSTEM OBJECT;
IMPDP PLUGGABLE DATABASE RECOVER;
```

每个 manifest 均为 `syntax_only`，无 fixture、无 setup/teardown SQL，并保留环境门。全库候选新增 4 条；其中 `AUTOHINT PURGE;` 与 M 兼容包现有 SQL 重复，distinct SQL 新增 3 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| 本批 4 包 manifest | 0 / 4 | 4 / 4 |
| 本批 4 包 candidate | 0 | 4 |
| 全库 manifest | 892 | 896 |
| 全库 candidate | 5,422 | 5,426 |
| 全库 distinct SQL | 5,335 | 5,338 |
| 有 manifest 的因子包 | 294 | 298 |
| 无 manifest 的因子包 | 23 | 19 |
| generation model complete | 273 / 294 | 277 / 298 |

本批 4 个包的 `generation_model_complete` 均为 true；
`static_coverage_complete` 与 `behavior_coverage_complete` 均仍为 false。

## 保留边界

本轮只证明固定 SQL 形态可以静态生成，不证明：

- TDE 开关状态、KMS 可用性、异步密钥轮转或全局恢复行为
- AUTOHINT 历史归属、权限执行或删除计数行为
- OM 升级上下文、初始用户身份、升级/回滚脚本生成或系统目录恢复
- 备份工具调用、导入执行阶段、PDB 修复、打开或恢复行为

对应 runtime/open question feature 继续保留为 `needs_profile`。

## 验证

- `tests.test_no_manifest_static_syntax_batch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts/run_static_regression.py`（26个静态单测，OK）
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有 KMS、OM 升级、AUTOHINT 清理或备份恢复工具调用，没有 Git 提交或推送。
