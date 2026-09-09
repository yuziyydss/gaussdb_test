-- generated_from: manifest_m_alter_group_rename
-- static_only: true
-- case_count: 1

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_group_rename_e2db589b0da6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "m_alter_group_action_rename", "members": "m_alter_group_members_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["fixture_defined"], "fact_refs": ["m_alter_group_fact_existing"], "key": "group_member_state"}]
-- fixture_setup:
CREATE GROUP m_alter_group_before NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
ALTER GROUP m_alter_group_before RENAME TO m_alter_group_after;
-- fixture_teardown:
DROP ROLE IF EXISTS m_alter_group_after;
DROP ROLE IF EXISTS m_alter_group_before;
