# PDF 质量抽取增量：ALTER SYSTEM SET FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_system_set.txt`
- 章节：1.13.7.35 ALTER SYSTEM SET
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_alter_system_set_fresh_syntax
```

新增一个静态 `resource_manager_plan` 语法代表：

```sql
ALTER SYSTEM SET resource_manager_plan
TO 'g_alter_system_set_plan';
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_system_set manifest | 0 | 1 |
| alter_system_set candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| resource plan switch feature | needs_profile | needs_profile |
| 全库 manifest | 871 | 872 |
| 全库 candidate | 5,401 | 5,402 |
| 全库 distinct SQL | 5,314 | 5,315 |
| 有 manifest 的因子包 | 273 | 274 |
| 无 manifest 的因子包 | 44 | 43 |
| generation model complete | 263 / 273 | 264 / 274 |

## 保留边界

本轮只证明 `ALTER SYSTEM SET resource_manager_plan`
的一个静态语法候选存在，不证明：

- 资源计划存在
- 多租特性开启
- 实际切换资源计划
- 当前计划快照与恢复
- Non-PDB / 非 M 兼容运行时行为

`alter_system_set_feature_resource_plan_switch`
仍为 `needs_profile`。

## 验证

- `tests.test_alter_system_set_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有资源计划切换，没有 Git 提交或推送。
