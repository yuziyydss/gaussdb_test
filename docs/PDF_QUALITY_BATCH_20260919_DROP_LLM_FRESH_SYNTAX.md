# PDF 质量抽取增量：DROP LLM FRESH SYNTAX（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_llm.txt`
- 章节：1.13.10.22 DROP LLM
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_llm_fresh_syntax
```

新增一个静态 LLM 名语法代表：

```sql
DROP LLM MODEL g_drop_llm;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_llm manifest | 0 | 1 |
| drop_llm candidate | 0 | 1 |
| syntax feature | 未登记 | covered / representative |
| runtime feature | needs_profile | needs_profile |
| 全库 manifest | 876 | 877 |
| 全库 candidate | 5,406 | 5,407 |
| 全库 distinct SQL | 5,319 | 5,320 |
| 有 manifest 的因子包 | 278 | 279 |
| 无 manifest 的因子包 | 39 | 38 |
| generation model complete | 264 / 278 | 265 / 279 |

## 保留边界

本轮只证明 `DROP LLM MODEL <name>` 的一个静态语法候选存在，不证明：

- LLM 已注册
- 实际删除模型服务
- 模型所有权
- 目录身份
- sysadmin 权限运行时回执
- 非 M 兼容运行时行为

`drop_llm_feature_runtime` 仍为 `needs_profile`。

## 验证

- `tests.test_drop_llm_fresh_syntax`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有 LLM 删除，没有 Git 提交或推送。
