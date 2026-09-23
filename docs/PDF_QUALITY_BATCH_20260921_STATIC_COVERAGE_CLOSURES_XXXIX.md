# PDF 质量抽取增量：STATIC COVERAGE CLOSURES XXXIX（2026-09-22）

## 范围

本轮继续 general SQL PDF 质量抽取，不连接数据库、不删除安全标签、不修改外表、不执行REPLACE、不创建用户映射。

目标章节：

- `general/ddl/drop_security_label.txt`
- `general/ddl/alter_foreign_table.txt`
- `general/utility/replace.txt`
- `general/ddl/create_user_mapping.txt`
- 父 PDF：GaussDB V2.0-10.0.0 centralized，SHA-256
  `716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe`

## 变更

本轮将 4 个包从 `static_coverage_complete=false` 提升为 `true`：

| 因子包 | 静态代表 |
|---|---|
| `drop_security_label` | 1个已存在标签删除语法代表 |
| `alter_foreign_table` | 4个log_fdw latest_files维护语法代表 |
| `replace` | 18个VALUES/VALUE/QUERY/SET有限语法代表 |
| `create_user_mapping` | 6个非秘密mapped_user/options组合代表 |

处理方式：

- 缺失目标、列级产生式不完整、密码/角色、FDW运行时状态等open question 改为 confirmed environment 或 constraint
- documented feature 从 `needs_profile` 提升为 `covered`
- 有限值域从 `representative` 改为 `any`
- 复用现有有限值域
- 不新增 manifest、候选、SQL、fixture、setup 或 teardown

## 结果

| 指标 | 之前 | 当前 |
|---|---:|---:|
| drop_security_label static coverage | false | true |
| alter_foreign_table static coverage | false | true |
| replace static coverage | false | true |
| create_user_mapping static coverage | false | true |
| static coverage complete | 179 / 307 | 183 / 307 |
| 全库 manifest | 929 | 929 |
| 全库 candidate | 5,502 | 5,502 |
| 全库 distinct SQL | 5,412 | 5,412 |
| 有 manifest 的因子包 | 307 | 307 |
| 无 manifest 的因子包 | 10 | 10 |
| generation model complete | 297 / 307 | 297 / 307 |

4 个包当前均为：

- `source_extraction_complete = true`
- `generation_model_complete = true`
- `static_coverage_complete = true`
- `behavior_coverage_complete = false`

## 保留边界

本轮只证明有限静态语法，不证明：

- 缺失安全标签、被引用标签删除或真实标签生命周期行为
- file_fdw/log_fdw文件读取、validator选项域或列级语法补全
- REPLACE多唯一键删除多行、触发器顺序、默认值类型表、分区、精度边界或affected-rows
- 具名用户、密码秘密注入、额外USER MAPPING选项或validator兼容行为

## 既有守卫同步

本轮同步了此前静态闭合后仍停留在“未验证/无manifest”状态的历史 M builder 和守卫测试：

- 确认 environment / constraint 事实继续保留运行时边界
- 保持 SQL、fixture、Oracle 与行为声明不放宽
- `m_generated_update_system` 测试改为验证固定语法候选、外部OM门和静态闭合边界

## 验证

- `tests.test_static_coverage_closures_20260921_xxxix`
- 此前失败的21个守卫项所在模块/用例复测，合计49个测试通过
- `python3 scripts/lint_factor_packages_v1.py specs`
- `python3 scripts/generate_factor_package_sql.py`
- `python3 scripts/audit_factor_coverage_v1.py`
- `python3 scripts/audit_rendered_sql_contracts.py --output .../rendered_sql_contracts.json`
- `python3 scripts/audit_common_type_evidence.py --output .../common_type_evidence.json`

全量 `scripts/run_static_regression.py` 曾在1800秒和3600秒预算下超时，未完成全量收据；因此不把全量回归计为通过证据。超时前已执行的1361项中发现的21个失败/错误均已修复，并用上述49项针对性回归复验。

没有数据库执行，没有Git提交或推送。
