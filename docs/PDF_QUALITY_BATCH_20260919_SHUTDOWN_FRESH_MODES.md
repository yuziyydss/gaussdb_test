# PDF 质量抽取增量：SHUTDOWN FRESH MODES（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/utility/shutdown.txt`
- 章节：1.13.19.12 SHUTDOWN
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_shutdown_fresh_modes
```

新增三个静态语法代表：

```sql
SHUTDOWN;
SHUTDOWN FAST;
SHUTDOWN IMMEDIATE;
```

候选数新增 3 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| shutdown manifest | 0 | 1 |
| shutdown candidate | 0 | 3 |
| shutdown syntax feature | 未登记 | covered / representative |
| node shutdown feature | needs_profile | needs_profile |
| 全库 manifest | 869 | 870 |
| 全库 candidate | 5,397 | 5,400 |
| 全库 distinct SQL | 5,310 | 5,313 |
| 有 manifest 的因子包 | 271 | 272 |
| 无 manifest 的因子包 | 46 | 45 |
| generation model complete | 261 / 271 | 262 / 272 |

## 保留边界

本轮只证明 `SHUTDOWN` 的三个静态语法候选存在，不证明：

- 实际关闭节点
- FAST 回滚与断连行为
- IMMEDIATE 故障恢复行为
- 管理员权限运行时回执
- 一次性节点或带外重启控制

`shutdown_feature_node_shutdown` 仍为 `needs_profile`。

## 验证

- `tests.test_shutdown_fresh_default`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有节点关闭，没有 Git 提交或推送。
