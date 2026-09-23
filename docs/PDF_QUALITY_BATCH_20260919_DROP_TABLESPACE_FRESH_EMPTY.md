# PDF 质量抽取增量：DROP TABLESPACE FRESH EMPTY（2026-09-19）

## 范围

本轮继续 general SQL PDF 质量抽取，不新增目录、不执行数据库。

目标章节：

- `general/ddl/drop_tablespace.txt`
- 章节：1.13.10.42 DROP TABLESPACE
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 manifest：

```text
manifest_drop_tablespace_fresh_empty
```

新增专用空 `RELATIVE` 表空间生命周期：

```sql
CREATE TABLESPACE g_drop_tbspc RELATIVE LOCATION 'g_drop_tbspc';

DROP TABLESPACE g_drop_tbspc;
DROP TABLESPACE IF EXISTS g_drop_tbspc;
```

候选数新增 2 条，分别覆盖：

- 省略 `IF EXISTS`
- 使用 `IF EXISTS`

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_tablespace manifest | 0 | 1 |
| drop_tablespace candidate | 0 | 2 |
| drop_tablespace feature | needs_profile | covered / representative |
| 全库 manifest | 864 | 865 |
| 全库 candidate | 5,390 | 5,392 |
| 全库 distinct SQL | 5,303 | 5,305 |
| 有 manifest 的因子包 | 266 | 267 |
| 无 manifest 的因子包 | 51 | 50 |
| generation model complete | 257 / 266 | 258 / 267 |

## 保留边界

本轮只证明一个专用空 `RELATIVE` 表空间可作为 `DROP TABLESPACE`
语法候选存在，不证明：

- 磁盘容量或路径可用性
- 空表空间运行时证明
- 非空表空间报错行为
- 缺失对象 `NOTICE` 行为
- 目录身份查询结果
- 目录清理或失败残留恢复
- IO 调度行为

## 验证

- `tests.test_drop_tablespace_fresh_empty`
- `tests.test_cross_chapter_dependencies`
- `tests.test_generation_diagnostics`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py`
- `python3 scripts/audit_common_type_evidence.py`

没有数据库执行，没有文件部署，没有 Git 提交或推送。
