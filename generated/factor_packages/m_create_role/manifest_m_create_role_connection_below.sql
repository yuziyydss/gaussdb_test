-- generated_from: manifest_m_create_role_connection_below
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_role_connection_below_1b7dc7f18f58
-- expected: error
-- expected_error_category: connection_range
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "m_create_role_connection_limit_below", "membership_keyword": "m_create_role_membership_keyword_role", "name": "m_create_role_name_plain", "password_keyword": "m_create_role_password_keyword_password", "with_keyword": "m_create_role_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_role_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_b04_role_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE ROLE m_create_role_new NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE IN ROLE m_b04_role_parent CONNECTION LIMIT -2 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_role_new;
DROP ROLE m_b04_role_parent;
