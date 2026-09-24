# PDF 质量抽取增量：COMMENT TEXT SEARCH PARSER/TEMPLATE（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：
  - `TEXT SEARCH PARSER object_name`
  - `TEXT SEARCH TEMPLATE object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_ts_parser
manifest_comment_ts_template
```

新增事务内内置对象注释生命周期：

```sql
BEGIN;

COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS ...;
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS ...;

ROLLBACK;
```

两个目标分别与四类注释文本交叉：

```sql
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS 'factor note';
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS '测试注释';
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS 'owner''s note';
COMMENT ON TEXT SEARCH PARSER pg_catalog.default IS NULL;

COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS 'factor note';
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS '测试注释';
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS 'owner''s note';
COMMENT ON TEXT SEARCH TEMPLATE pg_catalog.simple IS NULL;
```

候选数新增 8 条。

环境门来自 `CREATE TEXT SEARCH CONFIGURATION`、`CREATE TEXT SEARCH DICTIONARY` 与 `COMMENT` 章节：

- `internal_text_search_test = true`
- `comment_authority = sysadmin`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 19 | 21 |
| comment candidate | 108 | 116 |
| TEXT SEARCH PARSER feature | needs_profile | covered / representative |
| TEXT SEARCH TEMPLATE feature | needs_profile | covered / representative |
| 全库 manifest | 859 | 861 |
| 全库 candidate | 5,372 | 5,380 |
| 全库 distinct SQL | 5,285 | 5,293 |
| Planned scenario | 914 | 916 |

## 保留边界

本轮只证明两个内置文本搜索对象可作为 `COMMENT` 目标存在，不证明：

- 解析器分词行为
- 模板或词典行为
- 其他解析器或模板
- 自定义解析器/模板创建或删除
- 目录身份查询结果
- 系统管理员权限运行时回执
- 其他文本搜索对象形态

`scenario_comment_ts_parser` 与 `scenario_comment_ts_template`
仍为 planned，目录身份 Oracle 需要数据库执行后校准。

## 验证

- `tests.test_comment_ts_builtin_profiles`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
