# PDF 质量抽取增量：COMMENT EXTENSION（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`EXTENSION object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_extension
```

新增事务内真实对象生命周期：

```sql
BEGIN;
CREATE SCHEMA g_comment_extension_ns;
CREATE EXTENSION ext_b7 SCHEMA g_comment_extension_ns;

COMMENT ON EXTENSION ext_b7 IS ...;

ROLLBACK;
```

目标与四类注释文本交叉：

```sql
COMMENT ON EXTENSION ext_b7 IS 'factor note';
COMMENT ON EXTENSION ext_b7 IS '测试注释';
COMMENT ON EXTENSION ext_b7 IS 'owner''s note';
COMMENT ON EXTENSION ext_b7 IS NULL;
```

候选数新增 4 条。

环境门来自 `CREATE EXTENSION` 章节：

- `isolated_internal_test = true`
- `enable_extension = true`
- `extension_support_contract = ext_b7:default,1.0,b7_version`
- `comment_authority = fixture_object_owner`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 17 | 18 |
| comment candidate | 100 | 104 |
| EXTENSION feature | needs_profile | covered / representative |
| 全库 manifest | 857 | 858 |
| 全库 candidate | 5,364 | 5,368 |
| 全库 distinct SQL | 5,277 | 5,281 |
| Planned scenario | 912 | 913 |

## 保留边界

本轮只证明一个事务内专用测试扩展可作为 `COMMENT` 目标存在，不证明：

- 任意环境中 `ext_b7` 支持文件已安装
- 扩展脚本或成员对象行为
- 扩展依赖、升级或降级行为
- `enable_extension` 开关之外的环境差异
- 目录身份查询结果
- 对象所有权运行时回执
- 其他扩展形态

`scenario_comment_extension` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_extension_profile`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
