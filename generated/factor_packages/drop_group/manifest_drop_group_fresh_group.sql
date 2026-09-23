-- generated_from: manifest_drop_group_fresh_group
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_group_fresh_group_7f1853f0187d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_names": "drop_group_group_names_fresh", "if_exists": "drop_group_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["authorized_isolated_tool_session"], "fact_refs": ["drop_group_fact_tool_interface", "drop_group_fact_not_recommended"], "key": "management_tool_context"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
CREATE GROUP g_drop_group NOLOGIN PASSWORD DISABLE;
-- test_sql:
DROP GROUP g_drop_group;
-- fixture_teardown:
DROP ROLE IF EXISTS g_drop_group;

-- case_id: manifest_drop_group_fresh_group_8c16d92fc4a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_names": "drop_group_group_names_fresh", "if_exists": "drop_group_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["authorized_isolated_tool_session"], "fact_refs": ["drop_group_fact_tool_interface", "drop_group_fact_not_recommended"], "key": "management_tool_context"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_creator_authorized"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}]
-- fixture_setup:
CREATE GROUP g_drop_group NOLOGIN PASSWORD DISABLE;
-- test_sql:
DROP GROUP IF EXISTS g_drop_group;
-- fixture_teardown:
DROP ROLE IF EXISTS g_drop_group;
