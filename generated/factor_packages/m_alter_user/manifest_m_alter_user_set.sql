-- generated_from: manifest_m_alter_user_set
-- static_only: true
-- case_count: 3

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_user_set_1d99d96d420d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_set", "option": "m_alter_user_option_no_login", "parameter_change": "m_alter_user_parameter_change_default", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing SET TimeZone TO DEFAULT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_set_56f6d3fd4e3b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_set", "option": "m_alter_user_option_no_login", "parameter_change": "m_alter_user_parameter_change_equals", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing SET TimeZone = DEFAULT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;

-- case_id: manifest_m_alter_user_set_8e3f0fbc2a66
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "m_alter_user_form_set", "option": "m_alter_user_option_no_login", "parameter_change": "m_alter_user_parameter_change_current", "with_keyword": "m_alter_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER USER m_b04_user_existing SET TimeZone FROM CURRENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_b04_user_existing;
DROP USER IF EXISTS m_b04_user_existing RESTRICT;
