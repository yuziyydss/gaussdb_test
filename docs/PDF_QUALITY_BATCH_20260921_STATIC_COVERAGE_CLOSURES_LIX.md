# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LIX（2026-09-23）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建安全标签、不验证标签授权或集合偏序行为。

目标章节：

- `general/ddl/create_security_label.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `create_security_label` 从 `static_coverage_complete=false` 提升为 `true`。

处理方式：

- 将负向 oracle 收窄到原文给出具体错误的缺失范围候选：

```sql
CREATE SECURITY LABEL b9_sec_new 'L1:';
```

- 登记原文错误正则：

```text
in label text ".*", there at least have one level and one group
```

- 反向范围、零等级、小写输入暂不纳入负向 oracle，值域改为 `unknown`
- 名称边界与标签行为固化为 confirmed environment
- 不新增 manifest、候选、fixture、setup或teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| create_security_label static coverage | false | true |
| static coverage complete | 235 / 308 | 236 / 308 |
| generation model complete | 303 / 308 | 303 / 308 |
| 全库 manifest | 934 | 934 |
| 全库 candidate | 5,515 | 5,512 |
| 全库 distinct SQL | 5,425 | 5,422 |
| 有 manifest 的因子包 | 308 | 308 |
| 无 manifest 的因子包 | 9 | 9 |

## 保留边界

本轮只证明有限静态语法与原文错误身份，不证明：

- 反向范围、零等级、小写输入的具体错误身份
- 集合偏序、标签授权或SQLSTATE
- 安全标签实际创建、目录状态或多用户可见性

## 验证

- `tests.test_static_coverage_closures_20260921_lix`
- `tests.test_batch_09_packages.Batch09Tests.test_security_label_negative_oracle_is_source_confirmed`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
