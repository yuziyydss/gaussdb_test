# PDF 质量抽取增量：DROP FOREIGN TABLE CASCADE（2026-09-17）

## 范围

本轮回到 general SQL PDF 质量抽取，不新增目录、不执行数据库。
目标章节为：

- `general/ddl/drop_foreign_table.txt`
- 章节：1.13.10.16 DROP FOREIGN TABLE
- 章节哈希：`4714f064aa0e7c0f642629e743ba921f5b50e3e4dcf5cdb8898798804be60755`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

原有 `manifest_drop_foreign_table_log_catalog` 只包含：

- 省略依赖子句
- `RESTRICT`

本轮新增有限值：

- `drop_foreign_table_cascade_log_fresh`
- 渲染为 `CASCADE`

清单仍绑定同一个真实 fresh log_fdw 目录外表生命周期：

```text
CREATE SERVER
CREATE SCHEMA
CREATE FOREIGN TABLE
DROP FOREIGN TABLE [IF EXISTS] [RESTRICT|CASCADE|<omitted>]
DROP SCHEMA RESTRICT
DROP SERVER RESTRICT
```

候选数从 4 条增至 6 条：

- 无 `IF EXISTS` × 省略 / `RESTRICT` / `CASCADE`
- 有 `IF EXISTS` × 省略 / `RESTRICT` / `CASCADE`

## 明确不宣称的内容

新增 `CASCADE` 候选只证明该语法分支在无下游依赖的有限 fresh 生命周期中被渲染和消费；
它不证明：

- 依赖视图会被级联删除
- 依赖索引会被级联删除
- 函数/存储过程后续无法执行
- `RESTRICT` 遇依赖对象时的目标错误
- 任意重复表名列表
- file_fdw 或其他 wrapper

因此 `drop_foreign_table_feature_dependencies` 与
`drop_foreign_table_feature_runtime` 继续保留为 feature gap。
本包 `behavior_coverage_complete` 仍为 false。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_foreign_table manifest | 1 | 1 |
| drop_foreign_table candidate | 4 | 6 |
| drop_foreign_table value gaps | 1 | 0 |
| drop_foreign_table generation_model_complete | false | true |
| 全库 manifest | 846 | 846 |
| 全库 candidate | 5,295 | 5,297 |
| 全库 generation_model_complete | 255 / 317 | 256 / 317 |
| 全库 static_coverage_complete | 46 / 317 | 46 / 317 |
| 全库 behavior_coverage_complete | 0 / 317 | 0 / 317 |

渲染写合同当前结果：

```text
cases=5297
checked=334
needs_review=20
rejected=26
not_applicable=4917
positive_rejected=0
```

## 验证

- `tests.test_log_fdw_catalog`
- `tests.test_batch_10_packages`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
