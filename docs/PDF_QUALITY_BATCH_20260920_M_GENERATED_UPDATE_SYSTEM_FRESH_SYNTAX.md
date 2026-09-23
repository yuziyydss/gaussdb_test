# PDF 质量抽取增量：M GENERATED UPDATE SYSTEM FRESH SYNTAX（2026-09-20）

## 范围

本轮继续 M-Compatibility PDF 质量抽取，不连接数据库、不执行OM升级。

目标章节：

- `m_compat/utility/generated_update_system.txt`
- 章节：2.4.2.11.1 GENERATED UPDATE SYSTEM
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_m_generated_update_system_fresh_syntax
```

新增一个固定命令静态语法代表：

```sql
GENERATED UPDATE SYSTEM;
```

该 manifest 不使用 planned OM fixture，不执行命令，不生成或验证回滚脚本文件。

环境门：

- `compatibility_mode = M`
- `upgrade_context = authoritative_OM_upgrade`
- `initial_user_identity = true`
- `command_usage = internal_static_review_only`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| m_generated_update_system manifest | 0 | 1 |
| m_generated_update_system candidate | 0 | 1 |
| 全库 manifest | 916 | 917 |
| 全库 candidate | 5,488 | 5,489 |
| 全库 distinct SQL | 5,399 | 5,400 |
| 有 manifest 的因子包 | 306 | 307 |
| 无 manifest 的因子包 | 11 | 10 |
| generation model complete | 295 / 306 | 296 / 307 |

`m_generated_update_system` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明固定SQL形态可以静态生成，不证明：

- OM升级上下文真实满足
- 初始用户身份真实满足
- 升级/回滚脚本生成
- 脚本路径、命名、归属或内容Oracle
- 部分失败清理
- 数据库执行通过

`m_generated_update_system_fact_om_contract` 与
`m_generated_update_system_fact_artifact_contract` 继续保留为未解决问题。

## 验证

- `tests.test_m_generated_update_system_fresh_syntax`
- `tests.test_no_manifest_disposition_inventory`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有OM升级，没有Git提交或推送。
