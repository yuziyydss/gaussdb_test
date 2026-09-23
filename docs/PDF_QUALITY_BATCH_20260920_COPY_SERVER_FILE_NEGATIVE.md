# PDF 质量抽取增量：COPY SERVER FILE NEGATIVE（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不执行COPY、不读取服务器文件。

目标章节：

- `general/dml/copy.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_copy_server_file_negative
```

新增一个来源确认负向候选：

```sql
COPY fp_cs_one.b11_copy_source
FROM '/tmp/gaussdb_copy_static_input.csv';
```

目标错误来自原文：

```text
ERROR: COPY to or from a file is prohibited for security concerns
```

模型中登记为：

- `error_category = server_file_copy_prohibited`
- `error_message_regex = COPY to or from a file is prohibited for security concerns`
- `oracle_status = confirmed`
- `scope = syntax_and_semantics`

同时新增规则：

```text
copy_rule_server_file_requires_authority
```

并新增 `direction` 维度：

- `stdout`：保留现有 `TO STDOUT` 正向分支
- `server_file`：从服务器文件导入，用于未授权负向代表

环境门显式要求：

```text
disabled_for_non_initial_user_without_role
```

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| copy manifest | 2 | 3 |
| copy candidate | 20 | 21 |
| 全库 manifest | 911 | 912 |
| 全库 candidate | 5,483 | 5,484 |
| 全库 distinct SQL | 5,395 | 5,396 |
| generation model complete | 295 / 306 | 295 / 306 |

`copy` 仍为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只闭合“未授权服务器文件COPY”的错误身份，不证明：

- 数据库实际执行该错误
- `/tmp/gaussdb_copy_static_input.csv` 存在或可读
- 授权用户或GUC开启后的成功行为
- COPY文件边界协议
- TEXT/CSV冻结冲突
- STDIN/STREAM导入行为

`copy_fact_boundary_protocol`、
`copy_fact_freeze_text_conflict` 和
`copy_fact_stream_contract` 继续保留为未解决问题。

## 验证

- `tests.test_copy_server_file_negative`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有服务器文件读取，没有Git提交或推送。
