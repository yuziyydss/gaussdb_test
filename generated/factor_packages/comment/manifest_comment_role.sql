-- generated_from: manifest_comment_role
-- static_only: true
-- case_count: 4

-- case_id: manifest_comment_role_d08af1e92a57
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_role_fresh", "text": "comment_text_plain"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_role_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_role"}]
-- fixture_setup:
CREATE ROLE g_comment_role NOLOGIN PASSWORD DISABLE;
-- test_sql:
COMMENT ON ROLE g_comment_role IS 'factor note';
-- fixture_teardown:
DROP ROLE g_comment_role;

-- case_id: manifest_comment_role_beb7b4df86b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_role_fresh", "text": "comment_text_unicode"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_role_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_role"}]
-- fixture_setup:
CREATE ROLE g_comment_role NOLOGIN PASSWORD DISABLE;
-- test_sql:
COMMENT ON ROLE g_comment_role IS '测试注释';
-- fixture_teardown:
DROP ROLE g_comment_role;

-- case_id: manifest_comment_role_c885b78098c8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_role_fresh", "text": "comment_text_quote"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_role_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_role"}]
-- fixture_setup:
CREATE ROLE g_comment_role NOLOGIN PASSWORD DISABLE;
-- test_sql:
COMMENT ON ROLE g_comment_role IS 'owner''s note';
-- fixture_teardown:
DROP ROLE g_comment_role;

-- case_id: manifest_comment_role_ec3c79bd6f03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "comment_target_role_fresh", "text": "comment_text_null"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "role_create_privilege"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}, {"allowed_values": ["off"], "fact_refs": ["create_role::create_role_fact_sysadmin_duty_off"], "key": "separation_of_duty"}, {"allowed_values": ["fixture_object_owner"], "fact_refs": ["comment_fact_authority"], "key": "comment_authority"}, {"allowed_values": ["actual_case_role_owner"], "fact_refs": ["comment_fact_authority"], "key": "cleanup_role"}]
-- fixture_setup:
CREATE ROLE g_comment_role NOLOGIN PASSWORD DISABLE;
-- test_sql:
COMMENT ON ROLE g_comment_role IS NULL;
-- fixture_teardown:
DROP ROLE g_comment_role;
