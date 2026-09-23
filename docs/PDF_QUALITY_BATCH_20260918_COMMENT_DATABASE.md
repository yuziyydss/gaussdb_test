# PDF 质量抽取增量：COMMENT DATABASE（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`DATABASE object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_database
```

新增真实对象生命周期：

```sql
CREATE DATABASE g_comment_database;
COMMENT ON DATABASE g_comment_database IS ...;
DROP DATABASE g_comment_database;
```

目标与四类注释文本交叉：

```sql
COMMENT ON DATABASE g_comment_database IS 'factor note';
COMMENT ON DATABASE g_comment_database IS '测试注释';
COMMENT ON DATABASE g_comment_database IS 'owner''s note';
COMMENT ON DATABASE g_comment_database IS NULL;
```

候选数新增 4 条。

环境门来自 `COMMENT`、`CREATE DATABASE` 与 `DROP DATABASE` 章节：

- `database_scope = non_pdb`
- `database_create_privilege = true`
- `create_database_autocommit = true`
- `drop_database_autocommit = true`
- `database_has_connections = false`
- `enable_db_recyclebin = off`
- `comment_authority = fixture_object_owner`
- `cleanup_database = actual_case_database_owner`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 16 | 17 |
| comment candidate | 96 | 100 |
| DATABASE feature | needs_profile | covered / representative |
| 全库 manifest | 856 | 857 |
| 全库 candidate | 5,360 | 5,364 |
| 全库 distinct SQL | 5,273 | 5,277 |
| Planned scenario | 911 | 912 |

## 保留边界

本轮只证明一个独占新建数据库可作为 `COMMENT` 目标存在，不证明：

- 模板复制行为
- 编码、locale、兼容模式或连接限制
- 数据库连接行为
- PDB 内执行行为
- 库级回收站开启后的行为
- 目录身份查询结果
- 对象所有权运行时回执
- 其他数据库形态

`scenario_comment_database` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_database_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
