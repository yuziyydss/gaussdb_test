# PDF 质量抽取增量：COMMENT OPERATOR（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`OPERATOR operator_name (left_type, right_type)`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_operator
```

新增真实对象生命周期：

```sql
CREATE SCHEMA g_comment_operator_ns;
CREATE FUNCTION g_comment_operator_ns.plus_one(INTEGER)
RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS 'SELECT $1 + 1;';
CREATE OPERATOR @#@
(
  PROCEDURE = g_comment_operator_ns.plus_one,
  LEFTARG = INTEGER,
  RIGHTARG = INTEGER
);
```

teardown 逆序：

```sql
DROP OPERATOR @#@ (INTEGER, INTEGER) RESTRICT;
DROP FUNCTION g_comment_operator_ns.plus_one(INTEGER);
DROP SCHEMA g_comment_operator_ns RESTRICT;
```

目标与四类注释文本交叉：

```sql
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS 'factor note';
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS '测试注释';
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS 'owner''s note';
COMMENT ON OPERATOR @#@ (INTEGER, INTEGER) IS NULL;
```

候选数新增 4 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 9 | 10 |
| comment candidate | 64 | 68 |
| OPERATOR feature | needs_profile | covered / representative |
| 全库 manifest | 849 | 850 |
| 全库 candidate | 5,328 | 5,332 |
| 全库 distinct SQL | 5,241 | 5,245 |
| Planned scenario | 904 | 905 |

## 保留边界

本轮只证明一个双目 INTEGER 操作符作为 COMMENT 目标存在，不证明：

- 操作符执行行为
- prefix / postfix arity
- 其他 operator 数据类型
- OPERATOR CLASS / OPERATOR FAMILY
- 权限校验
- 目录身份查询结果
- 对象所有权运行时回执

`scenario_comment_operator` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_operator_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
