-- generated_from: manifest_m_alter_group_drop
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_group_drop_042b790f5ee6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_group_action_drop", "members": "m_alter_group_members_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_defined"], "fact_refs": ["m_alter_group_fact_existing"], "key": "group_member_state"}]
-- fixture_setup:
CREATE GROUP m_alter_group_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_alter_group_member_one NOLOGIN NOSYSADMIN IN ROLE m_alter_group_existing PASSWORD DISABLE;
CREATE ROLE m_alter_group_member_two NOLOGIN NOSYSADMIN IN ROLE m_alter_group_existing PASSWORD DISABLE;
-- test_sql:
ALTER GROUP m_alter_group_existing DROP USER m_alter_group_member_one;
-- fixture_teardown:
DROP ROLE IF EXISTS m_alter_group_member_two;
DROP ROLE IF EXISTS m_alter_group_member_one;
DROP ROLE IF EXISTS m_alter_group_existing;

-- case_id: manifest_m_alter_group_drop_d09da52343f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_group_action_drop", "members": "m_alter_group_members_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_defined"], "fact_refs": ["m_alter_group_fact_existing"], "key": "group_member_state"}]
-- fixture_setup:
CREATE GROUP m_alter_group_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE ROLE m_alter_group_member_one NOLOGIN NOSYSADMIN IN ROLE m_alter_group_existing PASSWORD DISABLE;
CREATE ROLE m_alter_group_member_two NOLOGIN NOSYSADMIN IN ROLE m_alter_group_existing PASSWORD DISABLE;
-- test_sql:
ALTER GROUP m_alter_group_existing DROP USER m_alter_group_member_one, m_alter_group_member_two;
-- fixture_teardown:
DROP ROLE IF EXISTS m_alter_group_member_two;
DROP ROLE IF EXISTS m_alter_group_member_one;
DROP ROLE IF EXISTS m_alter_group_existing;
