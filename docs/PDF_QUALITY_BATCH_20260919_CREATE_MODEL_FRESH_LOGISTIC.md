# PDF 质量抽取增量：CREATE MODEL FRESH LOGISTIC（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_model.txt`
- 章节：1.13.9.32 CREATE MODEL
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_model_fresh_logistic
```

新增一个静态 `logistic_regression` 语法代表，复用原文训练输入 fixture：

```sql
CREATE MODEL g_create_model_price
USING logistic_regression
FEATURES size, lot
TARGET mark
FROM fp_model_houses_input
WITH learning_rate=0.88, max_iterations=default;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_model manifest | 0 | 1 |
| create_model candidate | 0 | 1 |
| logistic 语法 feature | 未登记 | covered / representative |
| runtime feature | needs_profile | needs_profile |
| 全库 manifest | 867 | 868 |
| 全库 candidate | 5,395 | 5,396 |
| 全库 distinct SQL | 5,308 | 5,309 |
| 有 manifest 的因子包 | 269 | 270 |
| 无 manifest 的因子包 | 48 | 47 |

## 保留边界

本轮只证明 `CREATE MODEL` 的一个静态语法候选存在，不证明：

- 模型训练成功
- 训练时长或资源预算
- 模型质量或预测结果
- 模型所有权或清理
- `statement_timeout=0` 的实际设置
- 其他训练器
- 其他特征、目标或超参组合

`create_model_feature_runtime` 仍为 `needs_profile`。

## 验证

- `tests.test_create_model_fresh_logistic`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有模型训练，没有 Git 提交或推送。
