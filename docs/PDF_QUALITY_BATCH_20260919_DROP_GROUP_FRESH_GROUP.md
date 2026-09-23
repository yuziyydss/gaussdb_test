# PDF 质量抽取增量：DROP GROUP FRESH GROUP（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_group.txt`
- 章节：1.13.10.19 DROP GROUP
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_group_fresh_group
```

新增专用组生命周期：

```sql
CREATE GROUP g_drop_group NOLOGIN PASSWORD DISABLE;

DROP GROUP g_drop_group;
DROP GROUP IF EXISTS g_drop_group;
```

候选数新增 2 条，分别覆盖：

- 省略 `IF EXISTS`
- 使用 `IF EXISTS`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_group manifest | 0 | 1 |
| drop_group candidate | 0 | 2 |
| drop_group feature | needs_profile | covered / representative |
| 全库 manifest | 865 | 866 |
| 全库 candidate | 5,392 | 5,394 |
| 全库 distinct SQL | 5,305 | 5,307 |
| 有 manifest 的因子包 | 267 | 268 |
| 无 manifest 的因子包 | 50 | 49 |
| generation model complete | 258 / 267 | 259 / 268 |

## 保留边界

本轮只证明一个专用 `NOLOGIN`、`PASSWORD DISABLE`
组可作为 `DROP GROUP` 语法候选存在，不证明：

- 管理工具接口运行时上下文
- 组权限或成员关系行为
- 多个组名删除
- 缺失组 `NOTICE` 行为
- 目录身份查询结果
- 全局状态变更
- 三权分立开启时的行为

## 验证

- `tests.test_drop_group_fresh_group`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
