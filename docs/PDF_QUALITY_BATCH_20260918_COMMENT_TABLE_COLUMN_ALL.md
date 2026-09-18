# PDF 质量抽取增量：COMMENT TABLE/COLUMN 域闭合（2026-09-18）

## 范围

本轮继续收敛高缺口包 `comment`，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`TABLE object_name` 与 `COLUMN table_name.column_name | view_name.column_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

`comment_feature_table_and_column` 的已声明有限值域为：

- `TABLE t_comment_source`
- `COLUMN t_comment_source.col_1`
- `COLUMN t_comment_source.col_2`

三个目标已经全部被既有 manifests 选中。本轮将 feature 从：

```text
covered / representative
```

升级为：

```text
covered / all
```

这是对已声明有限 TABLE/COLUMN 值域的完整覆盖确认，不新增候选 SQL。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| TABLE/COLUMN feature | covered / representative | covered / all |
| comment feature gap 数 | 32 | 31 |
| 全库 manifest | 853 | 853 |
| 全库 candidate | 5,344 | 5,344 |
| 全库 distinct SQL | 5,257 | 5,257 |

该包仍保持：

```text
generation_model_complete = true
static_coverage_complete = false
behavior_coverage_complete = false
```

因为其他对象类型、目录身份和数据库行为仍未全部闭合。

## 保留边界

本项闭合只覆盖已声明的三个 TABLE/COLUMN 目标，不证明：

- 视图列、外部表、分区表或子分区表的所有 COLUMN 形态
- 其他 COMMENT 对象类型
- 权限校验
- 目录身份查询结果
- 对象所有权运行时回执
- 注释替换或删除行为

相关 scenario 仍为 planned。

## 验证

- `tests.test_comment_relation_profiles`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
