-- generated_from: manifest_m_create_group_connection_below
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_create_group_connection_below_e2458505ad7a
-- expected: error
-- expected_error_category: connection_range
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"connection_limit": "m_create_group_connection_limit_below", "inherit": "m_create_group_inherit_yes", "password_keyword": "m_create_group_password_keyword_password", "with_keyword": "m_create_group_with_keyword_none"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_create_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}]
-- fixture_setup:
CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
CREATE GROUP m_create_group_new NOLOGIN NOSYSADMIN INHERIT IN ROLE m_create_group_parent CONNECTION LIMIT -2 PASSWORD DISABLE;
-- fixture_teardown:
DROP ROLE IF EXISTS m_create_group_new;
DROP ROLE m_create_group_parent;
