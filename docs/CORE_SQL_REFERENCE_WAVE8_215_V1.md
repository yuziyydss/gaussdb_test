# SQL Reference Wave 8-215 Extraction V1

## 目标

抽取 GUC审计：`7.3.23 审计`（审计开关/用户和权限审计/操作审计，页 4679–4696）。

## 当前产出

| 指标 | 当前值 |
|---|---:|
| 章节 | 1（完整节） |
| 物理页 | 17 |
| 结构化 facts | 7 |
| Open questions | 1 |
| source resolved | 1 / 1 |
| chapter has facts | 1 / 1 |

## 覆盖能力

- 审计开关（7.3.23.1）：audit_enabled/audit_directory（om部署路径）/audit_data_format（binary）/audit_rotation_interval/audit_rotation_size/audit_resource_policy（空间优先vs时间优先）/audit_file_remain_time/audit_space_limit/audit_file_remain_threshold/audit_thread_num
- 用户和权限审计（7.3.23.2）：audit_login_logout（0~7共8种模式）/audit_database_process/audit_user_locked/audit_user_violation/audit_grant_revoke/audit_security_label/audit_internal_event（内部工具cm_agent/gs_clean/WDRXdb）/full_audit_users/no_audit_client
- 操作审计（7.3.23.3）：audit_system_object（30个二进制位30类对象DDL审计/默认67121159=DATABASE+SCHEMA+USER+SQLPatch）表7-48/audit_dml_state/audit_dml_state_select/audit_function_exec/audit_system_function_exec（白名单系统函数）/audit_copy_exec/audit_set_parameter/audit_xid_info/enableSeparationOfDuty（三权分立）/enable_nonsysadmin_execute_direct
