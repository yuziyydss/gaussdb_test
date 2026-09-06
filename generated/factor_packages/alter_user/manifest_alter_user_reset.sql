-- generated_from: manifest_alter_user_reset
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_user_reset_a124ad80a441
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_reset", "options": "alter_user_options_nologin", "reset_target": "alter_user_reset_target_one", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a RESET enable_seqscan;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;

-- case_id: manifest_alter_user_reset_e5aca0a814a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_user_assignment_to", "form": "alter_user_form_reset", "options": "alter_user_options_nologin", "reset_target": "alter_user_reset_target_all", "value": "alter_user_value_on", "with_keyword": "alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_privilege"], "key": "dedicated_user_admin"}, {"allowed_values": ["true"], "fact_refs": ["create_role::create_role_fact_disable_admin"], "key": "password_disable_admin"}]
-- fixture_setup:
CREATE USER b9_user_a NOLOGIN PASSWORD DISABLE;
CREATE USER b9_user_b NOLOGIN PASSWORD DISABLE;
-- test_sql:
ALTER USER b9_user_a RESET ALL;
-- fixture_teardown:
DROP USER IF EXISTS b9_user_b RESTRICT;
DROP USER IF EXISTS b9_user_a RESTRICT;
