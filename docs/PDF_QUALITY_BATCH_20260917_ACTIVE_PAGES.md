# PDF 质量抽取增量：CREATE INDEX ACTIVE_PAGES（2026-09-17）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_index.txt`
- 章节：1.13.9.27 CREATE INDEX
- 相关原文：`ACTIVE_PAGES` 参数说明
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_index_active_pages_manual
```

它复用已有的真实 USTORE RANGE 两分区 fixture：

```sql
CREATE TABLE g_ci_ustore_local (id INTEGER) WITH (storage_type=ustore)
PARTITION BY RANGE (id) (
  PARTITION p1 VALUES LESS THAN (10),
  PARTITION p2 VALUES LESS THAN (20)
);
```

目标候选为：

```sql
CREATE INDEX idx_ci_ap_<hash>
ON g_ci_ustore_local USING ubtree (id)
LOCAL WITH (active_pages = 16);
```

该候选是单独的 syntax-only 有限代表，不并入原有
`manifest_create_index_ustore_local_fresh`。原清单仍保持“不手设 ACTIVE_PAGES”，
用于表示自动 LOCAL 索引基线。

## 诚实边界

原文说明：

- `ACTIVE_PAGES` 仅 USTORE 分区表 LOCAL 索引生效
- 会被 `VACUUM` / `ANALYZE` 更新
- 不建议手工设置

因此新增候选只证明：

- 分区 USTORE
- UB-Tree
- LOCAL
- `WITH (active_pages = 16)`
- fresh 表生命周期
- 语法分支被实际渲染和消费

不证明：

- 统计信息更新行为
- 手工值后续是否被维护
- 执行计划效果
- 其它 ACTIVE_PAGES 数值域
- TDE 环境画像
- 数据路由或运行时行为

新增环境门：

```text
active_pages_manual_profile = syntax_only_not_recommended
```

该门是声明性前置条件，不是观察到的数据库状态。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_index manifest | 30 | 31 |
| create_index candidate | 345 | 346 |
| create_index success candidate | 315 | 316 |
| create_index value gaps | 2 | 1 |
| 剩余 create_index value gap | ACTIVE_PAGES、TDE | 仅 TDE |
| create_index generation_model_complete | false | false |
| 全库 manifest | 846 | 847 |
| 全库 candidate | 5,297 | 5,298 |
| 全库 distinct SQL | 5,210 | 5,211 |

`ci_feature_active_pages_execution_profile` 继续保留为 feature gap；
本轮只关闭 `ci_active_pages_manual` 值域缺口，不把 syntax-only 代表提升为
统计行为或执行画像。

## 验证

- `tests.test_index_ustore_generation`
- `tests.test_index_ustore_partition`
- `tests.test_factor_package_v1.test_create_index_source_audit_and_generation_quality`
- `tests.test_factor_package_v1.test_all_pdf_pilot_sql_is_fully_rendered_unique_and_traceable`
- `tests.test_factor_package_v1.test_five_packages_are_bound_to_exact_pdf_chapter_artifacts`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 Git 提交或推送。
