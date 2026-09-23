# PDF 质量抽取增量：CREATE TABLESPACE FRESH RELATIVE（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/create_tablespace.txt`
- 章节：1.13.9.52 CREATE TABLESPACE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_create_tablespace_fresh_relative
```

新增一个专用 `RELATIVE` 表空间静态代表：

```sql
CREATE TABLESPACE g_create_tbspc RELATIVE LOCATION 'g_create_tbspc';
```

清理：

```sql
DROP TABLESPACE g_create_tbspc;
```

候选数新增 1 条。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_tablespace manifest | 0 | 1 |
| create_tablespace candidate | 0 | 1 |
| create_tablespace feature | needs_profile | covered / representative |
| 全库 manifest | 862 | 863 |
| 全库 candidate | 5,388 | 5,389 |
| 全库 distinct SQL | 5,301 | 5,302 |
| 有 manifest 的因子包 | 264 | 265 |
| 无 manifest 的因子包 | 53 | 52 |
| generation model complete | 256 / 264 | 257 / 265 |

## 保留边界

本轮只证明一个专用 `RELATIVE` 表空间可作为静态语法候选存在，不证明：

- 磁盘容量或路径可用性
- `OWNER`
- `MAXSIZE`
- `WITH` 选项
- 表空间内对象行为
- 目录身份查询结果
- 失败残留清理
- IO 调度行为

## 验证

- `tests.test_create_tablespace_fresh_relative`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
