# PDF 质量抽取增量：STATIC COVERAGE CLOSURES IX（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建目录、不创建角色、不修改操作符。

目标章节：

- `general/ddl/alter_directory.txt`
- `general/ddl/alter_operator.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `alter_directory` 与 `alter_operator` 从
`static_coverage_complete=false` 提升为 `true`。

### ALTER DIRECTORY

新增 fixture：

```text
fixture_alter_directory_owner_role
```

该 fixture 在静态生命周期内创建：

```sql
CREATE ROLE b7_directory_owner NOLOGIN PASSWORD DISABLE;
GRANT b7_directory_owner TO CURRENT_USER;
```

现有候选保持不变：

```sql
ALTER DIRECTORY dir_b7 OWNER TO b7_directory_owner;
```

`alter_directory_feature_roles` 从 `needs_profile` 改为
`covered / any`；角色供给从 open question 改为确认的静态环境事实。
不验证目录属主变化、权限矩阵、目录对象行为或角色生命周期。

### ALTER OPERATOR

新增 manifest：

```text
manifest_alter_operator_owner
```

新增 fixture：

```text
fixture_alter_operator_owner_role
```

新增候选：

```sql
ALTER OPERATOR @#@ (INTEGER, INTEGER) OWNER TO b7_operator_owner;
```

fixture 在静态生命周期内创建：

```sql
CREATE ROLE b7_operator_owner NOLOGIN PASSWORD DISABLE;
GRANT b7_operator_owner TO CURRENT_USER;
```

语法从固定 `SET SCHEMA` 扩展为有限 `action` 维度：

- `SET SCHEMA op_b7_target`
- `OWNER TO b7_operator_owner`

原有三个签名迁移候选保持不变。`alter_operator_feature_owner` 从
`needs_profile` 改为 `covered / any`；角色供给从 open question 改为确认的静态环境事实。
不验证操作符所有权变化、权限失败矩阵、索引契约或角色生命周期。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_directory static coverage | false | true |
| alter_operator static coverage | false | true |
| static coverage complete | 71 / 307 | 73 / 307 |
| 全库 manifest | 920 | 921 |
| 全库 candidate | 5,492 | 5,493 |
| 全库 distinct SQL | 5,402 | 5,403 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

两个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限语法、专用角色fixture和环境门，不证明：

- 数据库实际创建角色、目录或操作符
- 目录属主或操作符属主变化
- 当前用户成员关系与权限矩阵
- 新属主模式CREATE权限
- 目录对象、操作符或底层函数行为
- 角色生命周期与清理副作用

## 验证

- `tests.test_static_coverage_closures_20260921_ii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
