# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LVI（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建资源池、不修改资源池、不验证扩容能力。

目标章节：

- `general/ddl/create_resource_pool.txt`
- 补充来源：`general/utility/pg_resource_pool.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `create_resource_pool` 从 `generation_model_complete=false` 提升为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

新增 1 个 manifest：

- `manifest_create_resource_pool_max_dop_syntax`

新增 1 个 `syntax_only` 候选：

```sql
CREATE RESOURCE POOL b9_pool WITH (MAX_DOP = 1);
```

处理方式：

- `MAX_DOP` 语法来自本章产生式
- 补充来源称 `max_dop` 仅扩容使用，不适用集中式
- 新候选使用环境门：`expansion_or_authoritative_contract`
- 不宣称集中式支持、扩容能力或数据库行为
- I/O阈值冲突、额外资源选项与MAX_DOP集中式冲突固化为 confirmed environment

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_resource_pool static coverage | false | true |
| static coverage complete | 232 / 308 | 233 / 308 |
| generation model complete | 300 / 308 | 301 / 308 |
| 全库 manifest | 932 | 933 |
| 全库 candidate | 5,509 | 5,510 |
| 全库 distinct SQL | 5,419 | 5,420 |
| 有 manifest 的因子包 | 308 | 308 |
| 无 manifest 的因子包 | 9 | 9 |

## 保留边界

本轮只证明有限静态语法，不证明：

- 集中式环境中 `MAX_DOP` 可用
- 扩容数据重分布、线程并发或资源调度行为
- I/O 50% / 90% 阈值差异
- IO、连接预算、动态/共享内存、扩容MAX_WORKER、自定义控制组或完整数字边界行为

## 验证

- `tests.test_static_coverage_closures_20260921_lvi`
- `tests.test_generation_diagnostics_views.GenerationDiagnosticsViewTests.test_actual_detail_renders_conditional_ids_and_separate_oracles`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
