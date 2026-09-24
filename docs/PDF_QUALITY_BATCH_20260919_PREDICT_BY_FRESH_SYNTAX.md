# PDF 质量抽取增量：PREDICT BY FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/predict_by.txt`
- 章节：1.13.17.1 PREDICT BY
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_predict_by_fresh_syntax
```

新增一个静态 `PREDICT BY` 语法代表，复用原文训练输入表：

```sql
SELECT PREDICT BY g_predict_by_model
  (FEATURES size, lot)
FROM fp_model_houses_input;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| predict_by manifest | 0 | 1 |
| predict_by candidate | 0 | 1 |
| 语法 feature | 未登记 | covered / representative |
| model feature | needs_profile | needs_profile |
| 全库 manifest | 868 | 869 |
| 全库 candidate | 5,396 | 5,397 |
| 全库 distinct SQL | 5,309 | 5,310 |
| 有 manifest 的因子包 | 270 | 271 |
| 无 manifest 的因子包 | 47 | 46 |
| generation model complete | 260 / 270 | 261 / 271 |

## 保留边界

本轮只证明 `PREDICT BY` 的一个静态语法候选存在，不证明：

- 模型已训练
- 模型可从 `gs_model_warehouse` 查询
- 特征顺序、数量或类型契约
- 预测结果
- 模型所有权
- 预测执行行为

`predict_by_feature_model` 仍为 `needs_profile`。

## 验证

- `tests.test_predict_by_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有模型训练，没有预测执行，没有 Git 提交或推送。
