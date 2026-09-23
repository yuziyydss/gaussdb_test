# PDF 质量抽取增量：GENERATION VALUE CLOSURE II（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建或关闭PDB、不修改弱口令字典、不创建CEK。

目标章节：

- `general/ddl/alter_pluggable_database.txt`
- `general/ddl/create_weak_password_dictionary.txt`
- `general/ddl/create_column_encryption_key.txt`
- `general/ddl/create_pluggable_database.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

不新增manifest数量，只把已有有限语法值补进既有 `syntax_only` manifest：

| 因子包 | 新增候选 | 覆盖语法 |
|---|---:|---|
| `alter_pluggable_database` | 2 | `CLOSE`、`CLOSE IMMEDIATE` |
| `create_weak_password_dictionary` | 1 | `WITH VALUES` |
| `create_column_encryption_key` | 6 | 其余6个来源算法 |
| `create_pluggable_database` | 8 | ENCODING、DBCOMPATIBILITY、LC_COLLATE、LC_CTYPE、DBTIMEZONE |
| 合计 | 17 |  |

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| 全库 manifest | 905 | 905 |
| 全库 candidate | 5,460 | 5,477 |
| 全库 distinct SQL | 5,372 | 5,389 |
| 有 manifest 的因子包 | 306 | 306 |
| 无 manifest 的因子包 | 11 | 11 |
| generation model complete | 291 / 306 | 295 / 306 |

本批 4 个包的 `generation_model_complete` 全部从 false 变为 true；
`static_coverage_complete` 与 `behavior_coverage_complete` 仍均为 false。

## 保留边界

本轮只闭合有限语法值选择，不证明：

- PDB状态机、资源计划、连接状态或关闭/立即关闭行为
- 弱口令字典写入、去重、多值语义或恢复
- 全密态驱动、CMK存在、算法兼容或密钥长度边界
- PDB创建、选项组合、时区环境、名称/数量边界或资源生命周期

对应 runtime/open question feature 继续保留为 `needs_profile`。

## 验证

- `tests.test_alter_pluggable_database_fresh_open`
- `tests.test_create_weak_password_dictionary_fresh_single`
- `tests.test_create_column_encryption_key_fresh_syntax`
- `tests.test_create_pluggable_database_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有PDB创建或关闭，没有弱口令字典修改，没有CEK创建，没有Git提交或推送。
