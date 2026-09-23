# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建用户组、不删除操作符。

目标章节：

- `general/ddl/create_group.txt`
- `general/ddl/drop_operator.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `create_group` 与 `drop_operator` 从
`static_coverage_complete=false` 提升为 `true`。

### CREATE GROUP

将原本固定渲染的 `NOLOGIN` 提升为显式有限维度：

```text
create_group_legacy_option_nologin
```

现有四个候选保持不变：

```sql
CREATE GROUP b9_group_new NOLOGIN PASSWORD DISABLE;
CREATE GROUP b9_group_new NOLOGIN IDENTIFIED BY DISABLE;
CREATE GROUP b9_group_new WITH NOLOGIN PASSWORD DISABLE;
CREATE GROUP b9_group_new WITH NOLOGIN IDENTIFIED BY DISABLE;
```

`create_group_feature_legacy_options` 从 `needs_profile` 改为
`covered / any`。legacy options 的静态域明确只包含 `NOLOGIN` 代表；
其他权限、时间、成员和资源子句不因 `CREATE GROUP` 别名自动接入。

### DROP OPERATOR

`drop_operator_feature_behavior` 从 `needs_profile` 改为
`covered / any`，只表示默认、`CASCADE`、`RESTRICT` 三种语法形态已被
现有有限 manifest 覆盖。

原文未解释 CASCADE/RESTRICT 依赖行为或缺失操作符错误身份；
本轮将该限制从 open question 改为确认的来源限制，不从其他产品补规则。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_group static coverage | false | true |
| drop_operator static coverage | false | true |
| static coverage complete | 78 / 307 | 80 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,498 | 5,498 |
| 全库 distinct SQL | 5,408 | 5,408 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

两个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法形态，不证明：

- 用户组实际创建或密码禁用行为
- CREATE ROLE其他权限/时间/成员/资源子句
- 操作符实际删除行为
- CASCADE/RESTRICT依赖语义
- 缺失操作符NOTICE或错误SQLSTATE

## 验证

- `tests.test_static_coverage_closures_20260921_v`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
