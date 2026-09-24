# PDF 质量抽取增量：ALTER TABLESPACE FRESH RENAME（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/alter_tablespace.txt`
- 章节：1.13.7.39 ALTER TABLESPACE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_alter_tablespace_fresh_rename
```

新增专用空 `RELATIVE` 表空间重命名生命周期：

```sql
CREATE TABLESPACE g_alter_tbspc
RELATIVE LOCATION 'g_alter_tbspc';

ALTER TABLESPACE g_alter_tbspc
RENAME TO g_alter_tbspc_renamed;

DROP TABLESPACE IF EXISTS g_alter_tbspc;
DROP TABLESPACE IF EXISTS g_alter_tbspc_renamed;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_tablespace manifest | 0 | 1 |
| alter_tablespace candidate | 0 | 1 |
| alter_tablespace feature | needs_profile | covered / representative |
| 全库 manifest | 866 | 867 |
| 全库 candidate | 5,394 | 5,395 |
| 全库 distinct SQL | 5,307 | 5,308 |
| 有 manifest 的因子包 | 268 | 269 |
| 无 manifest 的因子包 | 49 | 48 |
| generation model complete | 259 / 268 | 260 / 269 |

## 保留边界

本轮只证明一个专用空 `RELATIVE` 表空间可作为
`ALTER TABLESPACE ... RENAME TO ...` 语法候选存在，不证明：

- 属主变更
- 属性 `SET/RESET`
- 限额 `RESIZE MAXSIZE`
- 磁盘容量或路径可用性
- 表空间内对象行为
- 目录身份查询结果
- 文件生命周期或失败残留恢复

## 验证

- `tests.test_alter_tablespace_fresh_rename`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
