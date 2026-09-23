# PDF 质量抽取增量：STATIC COVERAGE CLOSURES VIII（2026-09-21）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建角色、不切换会话身份。

目标章节：

- `general/utility/set_role.txt`
- `general/utility/set_session_authorization.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `set_role` 与 `set_session_authorization` 从
`static_coverage_complete=false` 提升为 `true`。

新增 manifest：

```text
manifest_set_role_fresh_switch
manifest_set_session_authorization_fresh_switch
```

新增 fixture：

```text
fixture_set_role_fresh_switch
fixture_set_session_authorization_fresh_switch
```

两个 fixture 均使用专用一次性 LOGIN 角色和非秘密静态密码字面量，只服务
syntax-only 生成，不进入生产或共享环境。`set_role` 另外显式授予当前会话用户
目标角色成员关系；`set_session_authorization` 显式要求专用初始系统管理员会话。

新增候选：

```sql
SET SESSION ROLE set_role_fresh PASSWORD 'SetRole_2026_Aa9';

SET SESSION SESSION AUTHORIZATION set_session_auth_fresh
PASSWORD 'SetSessionAuth_2026_Aa9';
```

两个包的角色切换 feature 均标记为 `covered / any` 的有限代表；
`switch_profile` 从 open question 改为已确认的静态语法合同，另增
`static_switch_environment` 环境事实，保留实机会员关系、密码策略、会话身份、
权限变化和 LDAP 限制的行为边界。

## 结果

| 指标 | 本轮前重算快照 | 当前 |
|---|---:|---:|
| set_role static coverage | false | true |
| set_session_authorization static coverage | false | true |
| static coverage complete | 69 / 307 | 71 / 307 |
| 全库 manifest | 918 | 920 |
| 全库 candidate | 5,490 | 5,492 |
| 全库 distinct SQL | 5,400 | 5,402 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 296 / 307 | 296 / 307 |

说明：本轮前基线取自当日重算的 `generation_report.json` 快照（69/307）。
历史VII文档保留其当时记录的68/307，不回改旧批次结论。

两个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限切换语法、专用fixture生命周期和环境门，不证明：

- 数据库实际创建角色或切换身份
- 普通用户成员关系或系统管理员授权
- 密码策略接受该静态字面量
- SESSION/LOCAL生命周期
- INHERITS/NOINHERITS权限变化
- LDAP认证目标限制
- 权限提升或恢复行为

## 验证

- `tests.test_set_role_fresh_switch`
- `tests.test_set_session_authorization_fresh_switch`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
