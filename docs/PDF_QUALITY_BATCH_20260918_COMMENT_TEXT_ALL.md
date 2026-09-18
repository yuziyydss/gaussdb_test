# PDF 质量抽取增量：COMMENT 文本域闭合（2026-09-18）

## 范围

本轮继续收敛高缺口包 `comment`，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`IS 'text'` 与删除注释时写 `NULL`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

`comment` 包的注释文本维度是有限四值域：

- 普通文本：`'factor note'`
- Unicode 文本：`'测试注释'`
- 双单引号转义：`'owner''s note'`
- 删除注释：`NULL`

四个值已经全部被既有 manifests 选中。本轮将
`comment_feature_comment_values` 从 `covered / representative`
升级为：

```text
covered / all
```

这是对已声明有限文本域的完整覆盖确认，不新增候选 SQL。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| COMMENT 文本 feature | covered / representative | covered / all |
| comment feature gap 数 | 33 | 32 |
| 全库 manifest | 849 | 849 |
| 全库 candidate | 5,328 | 5,328 |
| 全库 distinct SQL | 5,241 | 5,241 |

该包仍保持：

```text
generation_model_complete = true
static_coverage_complete = false
behavior_coverage_complete = false
```

因为对象类型、目录身份和数据库行为仍未全部闭合。

## 保留边界

文本域闭合不证明：

- 数据库目录查询结果
- 权限校验
- 对象所有权运行时回执
- 注释替换或删除行为
- 共享对象的全局可见性

相关 scenario 仍为 planned。

## 验证

- `tests.test_comment_function_profile`
- `tests.test_comment_fdw_profiles`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
