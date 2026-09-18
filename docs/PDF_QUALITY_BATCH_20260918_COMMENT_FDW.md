# PDF 质量抽取增量：COMMENT 外部对象（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`FOREIGN TABLE object_name` 与 `SERVER object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_fdw_objects
```

新增两个有限对象代表：

- `FOREIGN TABLE g_comment_fdw_ns.foreign_table`
- `SERVER g_comment_fdw_server`

并与既有四类注释文本交叉：

- plain
- Unicode
- quote
- NULL

候选数新增 8 条。

真实 fixture 生命周期：

```text
CREATE SERVER g_comment_fdw_server FOREIGN DATA WRAPPER log_fdw;
CREATE SCHEMA g_comment_fdw_ns;
CREATE FOREIGN TABLE g_comment_fdw_ns.foreign_table
  (col1 TEXT)
  SERVER g_comment_fdw_server
  OPTIONS (logtype 'gs_log');
```

teardown 逆序：

```text
DROP FOREIGN TABLE g_comment_fdw_ns.foreign_table RESTRICT;
DROP SCHEMA g_comment_fdw_ns RESTRICT;
DROP SERVER g_comment_fdw_server RESTRICT;
```

目标 SQL 示例：

```sql
COMMENT ON FOREIGN TABLE g_comment_fdw_ns.foreign_table IS 'factor note';
COMMENT ON SERVER g_comment_fdw_server IS NULL;
```

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 7 | 8 |
| comment candidate | 52 | 60 |
| FOREIGN TABLE feature | needs_profile | covered / representative |
| SERVER feature | needs_profile | covered / representative |
| 全库 manifest | 847 | 848 |
| 全库 candidate | 5,316 | 5,324 |
| 全库 distinct SQL | 5,229 | 5,237 |
| Planned scenario | 902 | 903 |

## 保留边界

本轮只证明两个对象分支的 syntax-only 有限代表和真实 fresh 生命周期，不证明：

- FDW validator 行为
- log_fdw 数据读取
- 远端服务器连通性
- 注释目录查询结果
- 权限校验
- 对象所有权运行时回执
- 其他 COMMENT 对象类型

`scenario_comment_fdw_objects` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_fdw_profiles`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
