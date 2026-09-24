# PDF 质量抽取增量：DROP MODEL FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_model.txt`
- 章节：1.13.10.25 DROP MODEL
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_model_fresh_syntax
```

新增一个静态语法代表：

```sql
DROP MODEL g_drop_model;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_model manifest | 0 | 1 |
| drop_model candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| model feature | needs_profile | needs_profile |
| 全库 manifest | 870 | 871 |
| 全库 candidate | 5,400 | 5,401 |
| 全库 distinct SQL | 5,313 | 5,314 |
| 有 manifest 的因子包 | 272 | 273 |
| 无 manifest 的因子包 | 45 | 44 |
| generation model complete | 262 / 272 | 263 / 273 |

## 保留边界

本轮只证明 `DROP MODEL` 的一个静态语法候选存在，不证明：

- 模型已训练
- 模型可从 `gs_model_warehouse` 查询
- 模型所有权
- 实际删除行为
- 缺失模型错误行为

`drop_model_feature_model` 仍为 `needs_profile`。

## 验证

- `tests.test_drop_model_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有模型训练，没有模型删除，没有 Git 提交或推送。
