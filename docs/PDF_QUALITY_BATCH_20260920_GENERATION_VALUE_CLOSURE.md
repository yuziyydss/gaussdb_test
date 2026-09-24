# PDF 质量抽取增量：GENERATION VALUE CLOSURE（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改全局配置、不删除密钥或DBLink、不调用备份恢复工具。

目标章节：

- `general/ddl/alter_global_configuration.txt`
- `general/ddl/drop_global_configuration.txt`
- `general/ddl/drop_client_master_key.txt`
- `general/ddl/drop_column_encryption_key.txt`
- `general/ddl/drop_database_link.txt`
- `general/utility/impdp_table.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

不新增manifest数量，只把已有有限语法值补进既有 `syntax_only` manifest：

| 因子包 | 新增候选 | 覆盖语法 |
|---|---:|---|
| `alter_global_configuration` | 1 | 两组逗号分隔键值 |
| `drop_global_configuration` | 1 | 单键与逗号分隔双键 |
| `drop_client_master_key` | 5 | `IF EXISTS`、`CASCADE`、`RESTRICT` |
| `drop_column_encryption_key` | 5 | `IF EXISTS`、`CASCADE`、`RESTRICT` |
| `drop_database_link` | 3 | `PUBLIC`、`IF EXISTS` |
| `impdp_table` | 1 | 省略 `AS table_name` |
| 合计 | 16 |  |

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| 全库 manifest | 905 | 905 |
| 全库 candidate | 5,444 | 5,460 |
| 全库 distinct SQL | 5,356 | 5,372 |
| 有 manifest 的因子包 | 306 | 306 |
| 无 manifest 的因子包 | 11 | 11 |
| generation model complete | 285 / 306 | 291 / 306 |

本批 6 个包的 `generation_model_complete` 全部从 false 变为 true；
`static_coverage_complete` 与 `behavior_coverage_complete` 仍均为 false。

## 保留边界

本轮只闭合有限语法值选择，不证明：

- `gs_global_config` 插入、更新、删除或恢复行为
- 初始用户权限真实满足
- CMK/CEK存在、属主、依赖列或目录元数据删除行为
- `IF EXISTS` 实机错误或成功语义
- `CASCADE`/`RESTRICT` 依赖行为
- DBLink A模式、非初始用户、公共/私有对象生命周期
- 备份目录存在、表导入或恢复行为

对应 runtime/open question feature 继续保留为 `needs_profile`。

## 验证

- `tests.test_alter_global_configuration_fresh_syntax`
- `tests.test_drop_global_configuration_fresh_syntax`
- `tests.test_drop_client_master_key_fresh_syntax`
- `tests.test_drop_column_encryption_key_fresh_syntax`
- `tests.test_impdp_table_fresh_syntax`
- `tests.test_drop_database_link_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有全局配置修改，没有密钥或DBLink删除，没有备份工具调用，没有Git提交或推送。
