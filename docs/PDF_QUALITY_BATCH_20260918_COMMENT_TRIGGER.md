# PDF 质量抽取增量：COMMENT TRIGGER（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`TRIGGER trigger_name ON table_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_trigger
```

新增真实对象生命周期：

```sql
CREATE SCHEMA g_comment_trigger_ns;
CREATE TABLE g_comment_trigger_ns.base_table
  (col_1 INTEGER, col_2 INTEGER)
  WITH (storage_type=astore);
CREATE FUNCTION g_comment_trigger_ns.comment_trigger_fn()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 'BEGIN RETURN NEW; END;';
CREATE TRIGGER fp_comment_trigger
BEFORE INSERT ON g_comment_trigger_ns.base_table
FOR EACH ROW EXECUTE PROCEDURE g_comment_trigger_ns.comment_trigger_fn();
```

teardown 逆序：

```sql
DROP TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table RESTRICT;
DROP FUNCTION g_comment_trigger_ns.comment_trigger_fn() RESTRICT;
DROP TABLE g_comment_trigger_ns.base_table RESTRICT;
DROP SCHEMA g_comment_trigger_ns RESTRICT;
```

目标与四类注释文本交叉：

```sql
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table
IS 'factor note';
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table
IS '测试注释';
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table
IS 'owner''s note';
COMMENT ON TRIGGER fp_comment_trigger ON g_comment_trigger_ns.base_table
IS NULL;
```

候选数新增 4 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 11 | 12 |
| comment candidate | 72 | 76 |
| TRIGGER feature | needs_profile | covered / representative |
| 全库 manifest | 851 | 852 |
| 全库 candidate | 5,336 | 5,340 |
| 全库 distinct SQL | 5,249 | 5,253 |
| Planned scenario | 906 | 907 |

## 保留边界

本轮只证明一个普通表上的 BEFORE INSERT 行级触发器作为 COMMENT 目标存在，不证明：

- 触发器执行行为
- `NEW` / `OLD` 返回语义
- 其他 timing / event / level
- view trigger、constraint trigger
- 权限校验
- 目录身份查询结果
- 对象所有权运行时回执

`scenario_comment_trigger` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_trigger_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
