# PDF 质量抽取增量：CREATE DATABASE LINK FRESH SYNTAX（2026-09-20）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接远端数据库、不验证DBLink连通性。

目标章节：

- `general/ddl/create_database_link.txt`
- 章节：1.13.9.10 CREATE DATABASE LINK
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

新增 2 个 manifest：

```text
manifest_create_database_link_fresh_syntax
manifest_create_database_link_backend_mismatch_negative
```

新增 4 个无秘密正向静态语法代表：

```sql
CREATE DATABASE LINK g_create_database_link
CONNECT TO CURRENT_USER
USING (host 'gaussdb-static-syntax.invalid');

CREATE PUBLIC DATABASE LINK g_create_database_link
CONNECT TO CURRENT_USER
USING (host 'gaussdb-static-syntax.invalid');

CREATE DATABASE LINK g_create_database_link
CONNECT TO CURRENT_USER OCI
USING (dbserver 'oracle-static-syntax.invalid');

CREATE PUBLIC DATABASE LINK g_create_database_link
CONNECT TO CURRENT_USER OCI
USING (dbserver 'oracle-static-syntax.invalid');
```

新增 1 个负向规则代表：

```sql
CREATE DATABASE LINK g_create_database_link
CONNECT TO CURRENT_USER OCI
USING (host 'gaussdb-static-syntax.invalid');
```

该负向候选显式违反
`create_database_link_rule_backend_using_match`，用于证明OCI后端不能搭配GaussDB `HOST`选项；错误身份仍为 `needs_verification`，不在静态阶段冒充实机错误码。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_database_link manifest | 0 | 2 |
| create_database_link candidate | 0 | 5 |
| syntax feature | 未登记 | covered / representative |
| backend/using mismatch rule | 未登记 | positive 4 + negative 1 |
| 全库 manifest | 900 | 902 |
| 全库 candidate | 5,434 | 5,439 |
| 全库 distinct SQL | 5,346 | 5,351 |
| 有 manifest 的因子包 | 302 | 303 |
| 无 manifest 的因子包 | 15 | 14 |
| generation model complete | 281 / 302 | 282 / 303 |

`create_database_link` 当前：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = false`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限SQL形态与后端匹配规则可静态生成，不证明：

- `.invalid` 主机可解析或远端可连接
- CURRENT_USER凭据语义在目标环境可用
- A兼容模式、非初始用户和授权环境真实满足
- PUBLIC/PRIVATE对象生命周期与DROP清理行为
- GaussDB多选项逗号分隔语法冲突
- Oracle SSL/TNS/wallet配置
- 实机错误码或错误消息

`create_database_link_feature_runtime`、
`create_database_link_feature_syntax_conflict`、
`create_database_link_feature_visibility` 继续保留为 `needs_profile`。

## 验证

- `tests.test_create_database_link_fresh_syntax`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `scripts.run_static_regression.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有远端连接，没有秘密注入，没有Git提交或推送。
