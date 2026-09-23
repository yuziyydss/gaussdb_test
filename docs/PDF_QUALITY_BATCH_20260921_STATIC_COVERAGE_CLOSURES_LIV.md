# PDF 质量抽取增量：STATIC COVERAGE CLOSURES LIV（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不创建PACKAGE、不修改包所有者、不执行COMPILE。

目标章节：

- `general/ddl/alter_package.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 `alter_package` 从 `generation_model_complete=false` 提升为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

新增 1 个 manifest：

- `manifest_alter_package_compile_syntax`

新增 4 个 `syntax_only` 候选：

```sql
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE;
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE PACKAGE;
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE BODY;
ALTER PACKAGE fp_cs_one.b10_package_existing COMPILE SPECIFICATION;
```

处理方式：

- COMPILE四种拼写仅证明原文语法
- “注意事项仅支持OWNER”与COMPILE语法/示例的冲突保留为 confirmed environment
- 不宣称COMPILE产品支持、重编译行为或执行通过
- OWNER权限边界保留为 confirmed environment
- 不新增fixture、setup或teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| alter_package static coverage | false | true |
| static coverage complete | 230 / 308 | 231 / 308 |
| generation model complete | 298 / 308 | 299 / 308 |
| 全库 manifest | 931 | 932 |
| 全库 candidate | 5,505 | 5,509 |
| 全库 distinct SQL | 5,415 | 5,419 |
| 有 manifest 的因子包 | 308 | 308 |
| 无 manifest 的因子包 | 9 | 9 |

## 保留边界

本轮只证明有限静态语法，不证明：

- COMPILE是否获得产品支持
- PACKAGE重编译行为、依赖失效或编译错误
- 三权分立、DEFINER、初始/运维管理员或角色成员权限负向
- 包所有者变更后的实际权限行为

## 验证

- `tests.test_static_coverage_closures_20260921_liv`
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

没有数据库执行，没有Git提交或推送。
