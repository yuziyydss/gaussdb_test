# PDF 质量抽取增量：COMMENT CAST（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`CAST (source_type AS target_type)`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_cast
```

新增真实对象生命周期：

```sql
CREATE SCHEMA g_comment_cast_ns;
CREATE FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision)
RETURNS timestamp with time zone
LANGUAGE SQL STRICT
AS 'SELECT to_timestamp($1);';
CREATE CAST (double precision AS timestamp with time zone)
WITH FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
```

teardown 逆序：

```sql
DROP CAST (double precision AS timestamp with time zone) RESTRICT;
DROP FUNCTION g_comment_cast_ns.double_to_timestamptz(double precision);
DROP SCHEMA g_comment_cast_ns RESTRICT;
```

目标与四类注释文本交叉：

```sql
COMMENT ON CAST (double precision AS timestamp with time zone)
IS 'factor note';
COMMENT ON CAST (double precision AS timestamp with time zone)
IS '测试注释';
COMMENT ON CAST (double precision AS timestamp with time zone)
IS 'owner''s note';
COMMENT ON CAST (double precision AS timestamp with time zone)
IS NULL;
```

候选数新增 4 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 10 | 11 |
| comment candidate | 68 | 72 |
| CAST feature | needs_profile | covered / representative |
| 全库 manifest | 850 | 851 |
| 全库 candidate | 5,332 | 5,336 |
| 全库 distinct SQL | 5,245 | 5,249 |
| Planned scenario | 905 | 906 |

## 保留边界

本轮只证明一个由真实底层函数支撑的 CAST 作为 COMMENT 目标存在，不证明：

- CAST 转换执行结果
- WITHOUT FUNCTION / INOUT 分支
- DOMAIN 目标转换
- 类型修饰符和第三参数行为
- 权限校验
- 目录身份查询结果
- 对象所有权运行时回执

`scenario_comment_cast` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_cast_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
