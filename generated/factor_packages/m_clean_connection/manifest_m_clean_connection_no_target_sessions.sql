-- generated_from: manifest_m_clean_connection_no_target_sessions
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_clean_connection_no_target_sessions_96d47bf97d59
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_clean_connection_check_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_clean_connection_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["dedicated_physical_m_database_and_new_no_login_user_no_other_sessions"], "fact_refs": ["m_clean_connection_fact_scope"], "key": "connection_scope"}]
-- fixture_setup:
SELECT 1 / CASE WHEN current_database() = 'm_factor_test' THEN 1 ELSE 0 END AS clean_physical_database_verified;
CREATE USER m_clean_connection_user NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CLEAN CONNECTION TO ALL FOR DATABASE m_factor_test TO USER m_clean_connection_user;
-- fixture_teardown:
DROP SCHEMA m_clean_connection_user;
DROP USER m_clean_connection_user RESTRICT;

-- case_id: manifest_m_clean_connection_no_target_sessions_767e31068251
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"check": "m_clean_connection_check_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_clean_connection_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["dedicated_physical_m_database_and_new_no_login_user_no_other_sessions"], "fact_refs": ["m_clean_connection_fact_scope"], "key": "connection_scope"}]
-- fixture_setup:
SELECT 1 / CASE WHEN current_database() = 'm_factor_test' THEN 1 ELSE 0 END AS clean_physical_database_verified;
CREATE USER m_clean_connection_user NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CLEAN CONNECTION TO ALL CHECK FOR DATABASE m_factor_test TO USER m_clean_connection_user;
-- fixture_teardown:
DROP SCHEMA m_clean_connection_user;
DROP USER m_clean_connection_user RESTRICT;
