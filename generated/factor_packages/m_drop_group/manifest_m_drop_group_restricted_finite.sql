-- generated_from: manifest_m_drop_group_restricted_finite
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_group_restricted_finite_2d31cda3baf0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_group_if_exists_none", "targets": "m_drop_group_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["m_management_tool_reviewed"], "fact_refs": ["m_drop_group_fact_management"], "key": "command_applicability"}]
-- fixture_setup:
CREATE GROUP m_drop_group_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE GROUP m_drop_group_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
DROP GROUP m_drop_group_one;
-- fixture_teardown:
DROP ROLE IF EXISTS m_drop_group_two;
DROP ROLE IF EXISTS m_drop_group_one;

-- case_id: manifest_m_drop_group_restricted_finite_5b0a8dbc6bb6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_group_if_exists_none", "targets": "m_drop_group_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["m_management_tool_reviewed"], "fact_refs": ["m_drop_group_fact_management"], "key": "command_applicability"}]
-- fixture_setup:
CREATE GROUP m_drop_group_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE GROUP m_drop_group_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
DROP GROUP m_drop_group_one, m_drop_group_two;
-- fixture_teardown:
DROP ROLE IF EXISTS m_drop_group_two;
DROP ROLE IF EXISTS m_drop_group_one;

-- case_id: manifest_m_drop_group_restricted_finite_be64bfcedbd5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_group_if_exists_yes", "targets": "m_drop_group_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["m_management_tool_reviewed"], "fact_refs": ["m_drop_group_fact_management"], "key": "command_applicability"}]
-- fixture_setup:
CREATE GROUP m_drop_group_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE GROUP m_drop_group_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
DROP GROUP IF EXISTS m_drop_group_one;
-- fixture_teardown:
DROP ROLE IF EXISTS m_drop_group_two;
DROP ROLE IF EXISTS m_drop_group_one;

-- case_id: manifest_m_drop_group_restricted_finite_a2e8de0cf270
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "m_drop_group_if_exists_yes", "targets": "m_drop_group_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_group_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["m_management_tool_reviewed"], "fact_refs": ["m_drop_group_fact_management"], "key": "command_applicability"}]
-- fixture_setup:
CREATE GROUP m_drop_group_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE GROUP m_drop_group_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
-- test_sql:
DROP GROUP IF EXISTS m_drop_group_one, m_drop_group_two;
-- fixture_teardown:
DROP ROLE IF EXISTS m_drop_group_two;
DROP ROLE IF EXISTS m_drop_group_one;
