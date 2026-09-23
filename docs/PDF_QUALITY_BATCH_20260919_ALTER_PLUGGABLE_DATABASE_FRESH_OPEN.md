# PDF 质量抽取增量：ALTER PLUGGABLE DATABASE FRESH OPEN（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_pluggable_database.txt`
- 章节：1.13.7.23 ALTER PLUGGABLE DATABASE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_alter_pluggable_database_fresh_open
```

新增一个 OPEN 动作静态语法代表：

```sql
ALTER PLUGGABLE DATABASE g_alter_pluggable_database OPEN;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_pluggable_database manifest | 0 | 1 |
| alter_pluggable_database candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| PDB state machine feature | needs_profile | needs_profile |
| 全库 manifest | 886 | 887 |
| 全库 candidate | 5,416 | 5,417 |
| 全库 distinct SQL | 5,329 | 5,330 |
| 有 manifest 的因子包 | 288 | 289 |
| 无 manifest 的因子包 | 29 | 28 |
| generation model complete | 269 / 288 | 269 / 289 |

## 保留边界

本轮只证明 `ALTER PLUGGABLE DATABASE ... OPEN` 的一个静态语法候选存在，不证明：

- 真实 PDB 存在
- 实际打开或关闭行为
- PDB 状态机
- 业务连接控制
- 资源计划指令运行时状态
- MTD 运行时状态
- 权限运行时回执

`alter_pluggable_database_feature_pdb_state_machine`
仍为 `needs_profile`。

## 验证

- `tests.test_alter_pluggable_database_fresh_open`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 PDB 状态变更，没有 Git 提交或推送。
