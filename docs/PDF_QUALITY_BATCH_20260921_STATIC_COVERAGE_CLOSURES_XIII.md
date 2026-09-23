# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XIII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不修改资源标签、不删除存储过程。

目标章节：

- `general/ddl/alter_resource_label.txt`
- `general/ddl/drop_procedure.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `alter_resource_label` 与 `drop_procedure` 从
`static_coverage_complete=false` 提升为 `true`。

### ALTER RESOURCE LABEL

新增一个有限 `TABLE` 资源代表：

```text
alter_resource_label_items_table
```

新增候选：

```sql
ALTER RESOURCE LABEL b9_rl_change
REMOVE TABLE (b9_rl_source_two);
```

该候选复用现有 `before_remove` fixture。该 fixture 已创建包含
`COLUMN(...)` 与 `TABLE(b9_rl_source_two)` 的资源标签，因此静态生命周期
成立。

`alter_resource_label_feature_other_resource_changes` 从 `needs_profile`
改为 `covered / any`。静态域明确为：

- 已有 COLUMN 代表
- 新增 TABLE 代表
- SCHEMA/VIEW/FUNCTION、重复成员、缺失成员与策略关联场景不自动接入

### DROP PROCEDURE

将初始属主 open question 改为显式静态环境门：

```text
procedure_owner = initial_user
session_user = initial_user
```

现有已有过程候选保持不变，并要求目标过程由专用初始用户会话创建并拥有。
`drop_procedure_feature_initial_owner` 从 `needs_profile` 改为
`covered / any`。

本轮不创建高权限测试用户，不验证非初始用户拒绝行为或目标错误身份。

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_resource_label static coverage | false | true |
| drop_procedure static coverage | false | true |
| static coverage complete | 80 / 307 | 82 / 307 |
| 全库 manifest | 926 | 926 |
| 全库 candidate | 5,498 | 5,499 |
| 全库 distinct SQL | 5,408 | 5,409 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

两个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法、fixture生命周期与环境门，不证明：

- 资源标签实际修改或删除行为
- SCHEMA/VIEW/FUNCTION资源类型
- 重复成员、缺失成员或策略关联行为
- 存储过程实际删除行为
- 非初始用户拒绝行为
- 目标错误SQLSTATE

## 验证

- `tests.test_static_coverage_closures_20260921_vi`
- `tests.test_static_coverage_closures_20260921_vii`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
