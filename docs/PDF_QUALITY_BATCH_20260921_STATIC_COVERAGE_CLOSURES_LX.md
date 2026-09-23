# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LX（2026-09-23）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不访问远端数据库、不注入DBLink凭据。

目标章节：

- `general/ddl/alter_database_link.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `alter_database_link` 从无普通manifest、生成模型未闭合提升为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

新增 1 个 manifest：

- `manifest_alter_database_link_using_timeout_syntax`

新增 2 个 `syntax_only` 候选：

```sql
ALTER DATABASE LINK g_alter_dblink_static USING (time_out '0');
ALTER PUBLIC DATABASE LINK g_alter_dblink_static USING (time_out '0');
```

处理方式：

- 只选择Oracle后端USING timeout语法分支
- 不生成CONNECT TO / IDENTIFIED BY凭据分支
- 环境门显式要求Oracle后端、已有DBLink和非初始主体
- ALTER DATABASE LINK的远端凭据运行时边界固化为 confirmed environment
- 不新增fixture、setup或teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_database_link static coverage | false | true |
| static coverage complete | 236 / 308 | 237 / 309 |
| generation model complete | 303 / 308 | 304 / 309 |
| 全库 manifest | 934 | 935 |
| 全库 candidate | 5,512 | 5,514 |
| 全库 distinct SQL | 5,422 | 5,424 |
| 有 manifest 的因子包 | 308 | 309 |
| 无 manifest 的因子包 | 9 | 8 |

## 保留边界

本轮只证明有限静态语法，不证明：

- DBLink对象实际存在或可连接
- 远端Oracle数据库连通性、认证或超时行为
- 非初始主体权限、属主状态或A模式环境
- `time_out`运行时生效

## 验证

- `tests.test_static_coverage_closures_20260921_lx`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
