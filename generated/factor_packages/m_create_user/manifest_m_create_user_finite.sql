-- generated_from: manifest_m_create_user_finite
-- static_only: true
-- case_count: 7

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_user_finite_474b4dd568ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_default", "inherit": "m_create_user_inherit_yes", "password_keyword": "m_create_user_password_keyword_password", "with_keyword": "m_create_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_user_parent PASSWORD DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;

-- case_id: manifest_m_create_user_finite_09f73c1331dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_zero", "inherit": "m_create_user_inherit_no", "password_keyword": "m_create_user_password_keyword_identified", "with_keyword": "m_create_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new NOLOGIN NOSYSADMIN NOINHERIT IN ROLE m_create_user_parent CONNECTION LIMIT 0 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;

-- case_id: manifest_m_create_user_finite_3aa0a8a8669c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_unlimited", "inherit": "m_create_user_inherit_no", "password_keyword": "m_create_user_password_keyword_password", "with_keyword": "m_create_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new WITH NOLOGIN NOSYSADMIN NOINHERIT IN ROLE m_create_user_parent CONNECTION LIMIT -1 PASSWORD DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;

-- case_id: manifest_m_create_user_finite_b421964b2e17
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_default", "inherit": "m_create_user_inherit_yes", "password_keyword": "m_create_user_password_keyword_identified", "with_keyword": "m_create_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new WITH NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_user_parent IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;

-- case_id: manifest_m_create_user_finite_b6629ba8b7ac
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_unlimited", "inherit": "m_create_user_inherit_yes", "password_keyword": "m_create_user_password_keyword_identified", "with_keyword": "m_create_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_user_parent CONNECTION LIMIT -1 IDENTIFIED BY DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;

-- case_id: manifest_m_create_user_finite_12b1bc8e15bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_zero", "inherit": "m_create_user_inherit_yes", "password_keyword": "m_create_user_password_keyword_password", "with_keyword": "m_create_user_with_keyword_yes"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new WITH NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_user_parent CONNECTION LIMIT 0 PASSWORD DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;

-- case_id: manifest_m_create_user_finite_564635407b6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"connection_limit": "m_create_user_connection_limit_default", "inherit": "m_create_user_inherit_no", "password_keyword": "m_create_user_password_keyword_password", "with_keyword": "m_create_user_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE USER m_create_user_new NOLOGIN NOSYSADMIN NOINHERIT IN ROLE m_create_user_parent PASSWORD DISABLE;
-- fixture_teardown:
DROP SCHEMA IF EXISTS m_create_user_new;
DROP USER IF EXISTS m_create_user_new RESTRICT;
DROP ROLE m_create_user_parent;
