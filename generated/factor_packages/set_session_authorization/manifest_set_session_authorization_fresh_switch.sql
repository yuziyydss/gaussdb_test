-- generated_from: manifest_set_session_authorization_fresh_switch
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_session_authorization_fresh_switch_9532f826fdec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_session_authorization_form_session_switch"}
-- environment_requirements: [{"allowed_values": ["dedicated_non_production_initial_admin_session"], "fact_refs": ["set_session_authorization_fact_static_switch_environment"], "key": "isolated_session"}, {"allowed_values": ["sysadmin"], "fact_refs": ["set_session_authorization_fact_membership"], "key": "initial_session_user"}, {"allowed_values": ["fixture_created_login_role"], "fact_refs": ["set_session_authorization_fact_role"], "key": "target_role_identity"}, {"allowed_values": ["static_non_secret_fixture_literal"], "fact_refs": ["set_session_authorization_fact_static_switch_environment"], "key": "password_contract"}]
-- fixture_setup:
CREATE ROLE set_session_auth_fresh LOGIN PASSWORD 'SetSessionAuth_2026_Aa9';
-- test_sql:
SET SESSION SESSION AUTHORIZATION set_session_auth_fresh PASSWORD 'SetSessionAuth_2026_Aa9';
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
DROP ROLE IF EXISTS set_session_auth_fresh;
