# PDF 质量抽取增量：COMMENT TEXT SEARCH CONFIGURATION（2026-09-18）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/comment.txt`
- 章节：1.13.9.6 COMMENT
- 相关原文：`TEXT SEARCH CONFIGURATION object_name`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_comment_tsc
```

新增真实对象生命周期：

```sql
CREATE SCHEMA g_comment_tsc_ns;
CREATE TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple
  (PARSER=default);
```

teardown 逆序：

```sql
DROP TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple RESTRICT;
DROP SCHEMA g_comment_tsc_ns RESTRICT;
```

目标与四类注释文本交叉：

```sql
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple
IS 'factor note';
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple
IS '测试注释';
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple
IS 'owner''s note';
COMMENT ON TEXT SEARCH CONFIGURATION g_comment_tsc_ns.simple
IS NULL;
```

候选数新增 4 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| comment manifest | 14 | 15 |
| comment candidate | 84 | 88 |
| TEXT SEARCH CONFIGURATION feature | needs_profile | covered / representative |
| 全库 manifest | 854 | 855 |
| 全库 candidate | 5,348 | 5,352 |
| 全库 distinct SQL | 5,261 | 5,265 |
| Planned scenario | 909 | 910 |

## 保留边界

本轮只证明一个使用 `default` 解析器的文本搜索配置作为 `COMMENT` 目标存在，不证明：

- 配置分词行为
- ngram 参数域
- COPY 分支
- 词典映射
- 权限校验
- 目录身份查询结果
- 对象所有权运行时回执

`scenario_comment_tsc` 仍为 planned，目录身份 Oracle
需要数据库执行后校准。

## 验证

- `tests.test_comment_tsc`
- 全部 comment 相关测试
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
