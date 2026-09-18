# PDF 质量抽取增量：COMMENT DOMAIN（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`DOMAIN object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_domain
```

新增真实对象：

```sql
DOMAIN g_comment_domain_ns.positive_integer
```

fixture 实际创建：

```sql
CREATE SCHEMA g_comment_domain_ns;
CREATE DOMAIN g_comment_domain_ns.positive_integer AS INTEGER CHECK (VALUE > 0);
```

teardown 逆序：

```sql
DROP DOMAIN g_comment_domain_ns.positive_integer RESTRICT;
DROP SCHEMA g_comment_domain_ns RESTRICT;
```

目标与四类注释文本交叉：

```sql
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS 'factor note';
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS '测试注释';
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS 'owner''s note';
COMMENT ON DOMAIN g_comment_domain_ns.positive_integer IS NULL;
```

候选数新增 4 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 8 | 9 |
| comment candidate | 60 | 64 |
| DOMAIN feature | needs_profile | covered / representative |
| 全库 manifest | 848 | 849 |
| 全库 candidate | 5,324 | 5,328 |
| 全库 distinct SQL | 5,237 | 5,241 |
| Planned scenario | 903 | 904 |

## 保留边界

本轮只证明一个带 CHECK 约束的 INTEGER DOMAIN 作为 COMMENT 目标存在，
不证明：

- DOMAIN 创建/删除的全部语法域
- 默认值与转换行为
- CHECK 约束执行行为
- 域名冲突和类型兼容性
- 注释目录查询结果
- 权限校验
- 对象所有权运行时回执

`scenario_comment_domain` 仍为 planned，目录身份 Oracle 需数据库执行后校准。

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
