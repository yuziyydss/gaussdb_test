-- generated_from: manifest_alter_system_set_fresh_syntax
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_system_set_fresh_syntax_6aa259ad0569
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"plan_name": "alter_system_set_plan_name_dedicated"}
-- environment_requirements: [{"allowed_values": ["initial_user_or_sysadmin"], "fact_refs": ["alter_system_set_fact_privilege"], "key": "alter_system_privilege"}, {"allowed_values": ["non_pdb"], "fact_refs": ["alter_system_set_fact_non_pdb"], "key": "database_scope"}, {"allowed_values": ["non_m"], "fact_refs": ["alter_system_set_fact_not_m"], "key": "compatibility_mode"}]
-- test_sql:
ALTER SYSTEM SET resource_manager_plan TO 'g_alter_system_set_plan';
