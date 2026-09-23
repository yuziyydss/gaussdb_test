# PDF 质量抽取增量：REFRESH SYSTEM OBJECT FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/refresh_system_object.txt`
- 章节：1.13.18.4 REFRESH SYSTEM OBJECT
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_refresh_system_object_fresh_syntax
```

新增一个固定命令静态语法代表：

```sql
REFRESH SYSTEM OBJECT;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| refresh_system_object manifest | 0 | 1 |
| refresh_system_object candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| internal upgrade feature | needs_profile | needs_profile |
| 全库 manifest | 880 | 881 |
| 全库 candidate | 5,410 | 5,411 |
| 全库 distinct SQL | 5,323 | 5,324 |
| 有 manifest 的因子包 | 282 | 283 |
| 无 manifest 的因子包 | 35 | 34 |
| generation model complete | 265 / 282 | 266 / 283 |

## 保留边界

本轮只证明 `REFRESH SYSTEM OBJECT` 的一个静态语法候选存在，不证明：

- 实际刷新系统对象版本
- `GS_SYSTEM_OBJECTS_VERSION` 变更
- 从 507 之前版本升级的真实上下文
- `upgrade_mode` 运行时状态
- 初始用户身份
- 升级前后目录快照与恢复

`refresh_system_object_feature_internal_upgrade`
仍为 `needs_profile`。

## 验证

- `tests.test_refresh_system_object_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有系统对象刷新，没有 Git 提交或推送。
