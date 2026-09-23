# PDF 质量抽取增量：COMMENT OPERATOR CLASS/FAMILY（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：
  - `OPERATOR CLASS object_name USING index_method`
  - `OPERATOR FAMILY object_name USING index_method`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_operator_class_family
```

新增事务内真实对象生命周期：

```sql
BEGIN;
CREATE SCHEMA g_comment_opclass_ns;
CREATE FUNCTION g_comment_opclass_ns.compare_integer(INTEGER, INTEGER)
  RETURNS INTEGER LANGUAGE SQL IMMUTABLE
  AS 'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;';
CREATE OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass
  FOR TYPE INTEGER USING btree
  AS FUNCTION 1 g_comment_opclass_ns.compare_integer(INTEGER, INTEGER);

COMMENT ON OPERATOR CLASS g_comment_opclass_ns.g_comment_opclass USING btree IS ...;
COMMENT ON OPERATOR FAMILY g_comment_opclass_ns.g_comment_opclass USING btree IS ...;

ROLLBACK;
```

省略 `FAMILY` 时，`CREATE OPERATOR CLASS` 会自动创建同名操作符族；本代表不使用
`DEFAULT` 修饰符。

两个目标分别与四类注释文本交叉，候选数新增 8 条。

环境门来自 `CREATE OPERATOR CLASS` 与 `COMMENT` 章节：

- `internal_operator_class_test = true`
- `operator_class_create_privilege = sysadmin`
- `comment_authority = sysadmin`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 21 | 22 |
| comment candidate | 116 | 124 |
| OPERATOR CLASS feature | needs_profile | covered / representative |
| OPERATOR FAMILY feature | needs_profile | covered / representative |
| 全库 manifest | 861 | 862 |
| 全库 candidate | 5,380 | 5,388 |
| 全库 distinct SQL | 5,293 | 5,301 |
| Planned scenario | 916 | 917 |

## 保留边界

本轮只证明一个事务内非默认 `btree` 操作符类及其自动同名操作符族可作为
`COMMENT` 目标存在，不证明：

- btree 索引比较契约
- 操作符类完整性
- 索引行为或执行计划
- 其他索引方法
- `DEFAULT` 操作符类
- 显式已有 `FAMILY`
- 目录身份查询结果
- 系统管理员权限运行时回执

`scenario_comment_operator_class_family` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_operator_class_family`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
