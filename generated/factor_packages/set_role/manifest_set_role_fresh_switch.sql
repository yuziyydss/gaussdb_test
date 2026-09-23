-- generated_from: manifest_set_role_fresh_switch
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_role_fresh_switch_4dea82de98e6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_role_form_session_switch"}
-- environment_requirements: [{"allowed_values": ["dedicated_non_production_session"], "fact_refs": ["set_role_fact_static_switch_environment"], "key": "isolated_session"}, {"allowed_values": ["current_session_user_is_member"], "fact_refs": ["set_role_fact_membership"], "key": "target_role_membership"}, {"allowed_values": ["fixture_created_login_role"], "fact_refs": ["set_role_fact_role"], "key": "target_role_identity"}, {"allowed_values": ["static_non_secret_fixture_literal"], "fact_refs": ["set_role_fact_static_switch_environment"], "key": "password_contract"}]
-- fixture_setup:
CREATE ROLE set_role_fresh LOGIN PASSWORD 'SetRole_2026_Aa9';
GRANT set_role_fresh TO CURRENT_USER;
-- test_sql:
SET SESSION ROLE set_role_fresh PASSWORD 'SetRole_2026_Aa9';
-- fixture_teardown:
RESET ROLE;
REVOKE set_role_fresh FROM CURRENT_USER;
DROP ROLE IF EXISTS set_role_fresh;
