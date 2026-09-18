# PDF 质量抽取增量：COMMENT ROLE（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`ROLE object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_role
```

新增真实角色生命周期：

```sql
CREATE ROLE g_comment_role NOLOGIN PASSWORD DISABLE;
COMMENT ON ROLE g_comment_role IS ...
DROP ROLE g_comment_role;
```

目标与四类注释文本交叉：

```sql
COMMENT ON ROLE g_comment_role IS 'factor note';
COMMENT ON ROLE g_comment_role IS '测试注释';
COMMENT ON ROLE g_comment_role IS 'owner''s note';
COMMENT ON ROLE g_comment_role IS NULL;
```

候选数新增 4 条。

环境门来自 `CREATE ROLE` 章节：

- `role_create_privilege = true`
- `password_disable_admin = true`
- `separation_of_duty = off`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 13 | 14 |
| comment candidate | 80 | 84 |
| ROLE feature | needs_profile | covered / representative |
| 全库 manifest | 853 | 854 |
| 全库 candidate | 5,344 | 5,348 |
| 全库 distinct SQL | 5,257 | 5,261 |
| Planned scenario | 908 | 909 |

## 保留边界

本轮只证明一个 NOLOG、密码禁用的独占角色可作为 `COMMENT` 目标存在，不证明：

- 角色权限或成员关系行为
- 系统管理员角色注释
- 三权分立开启时的行为
- 目录身份查询结果
- 对象所有权运行时回执
- 其他角色形态

`scenario_comment_role` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_role_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
