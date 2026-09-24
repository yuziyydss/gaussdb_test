# PDF 质量抽取增量：COMMENT TABLESPACE（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`TABLESPACE object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_tablespace
```

新增真实对象生命周期：

```sql
CREATE TABLESPACE g_comment_tbspc RELATIVE LOCATION 'g_comment_tbspc';

COMMENT ON TABLESPACE g_comment_tbspc IS ...;

DROP TABLESPACE g_comment_tbspc;
```

目标与四类注释文本交叉：

```sql
COMMENT ON TABLESPACE g_comment_tbspc IS 'factor note';
COMMENT ON TABLESPACE g_comment_tbspc IS '测试注释';
COMMENT ON TABLESPACE g_comment_tbspc IS 'owner''s note';
COMMENT ON TABLESPACE g_comment_tbspc IS NULL;
```

候选数新增 4 条。

环境门来自 `CREATE TABLESPACE` 与 `DROP TABLESPACE` 章节：

- `tablespace_create_privilege = true`
- `tablespace_drop_privilege = actual_case_tablespace_owner`
- `comment_authority = fixture_object_owner`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 18 | 19 |
| comment candidate | 104 | 108 |
| TABLESPACE feature | needs_profile | covered / representative |
| 全库 manifest | 858 | 859 |
| 全库 candidate | 5,368 | 5,372 |
| 全库 distinct SQL | 5,281 | 5,285 |
| Planned scenario | 913 | 914 |

## 保留边界

本轮只证明一个空 `RELATIVE` 表空间可作为 `COMMENT` 目标存在，不证明：

- 磁盘容量或路径可用性
- 绝对路径表空间
- `MAXSIZE` 或 IO 参数
- 表空间内对象行为
- 删除前非空表空间行为
- 目录身份查询结果
- 对象所有权运行时回执
- 其他表空间形态

`scenario_comment_tablespace` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_tablespace_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
