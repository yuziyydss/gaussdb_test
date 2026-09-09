-- generated_from: manifest_m_drop_user_dependency_free
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_drop_user_dependency_free_2cbe8c6fe45d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_user_behavior_default", "if_exists": "m_drop_user_if_exists_none", "targets": "m_drop_user_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["none_after_explicit_schema_cleanup"], "fact_refs": ["m_drop_user_fact_dependency_free"], "key": "user_dependencies"}, {"allowed_values": ["single_database_test_identity"], "fact_refs": ["m_drop_user_fact_cross_database"], "key": "identity_scope"}]
-- fixture_setup:
CREATE USER m_drop_user_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE USER m_drop_user_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
DROP SCHEMA m_drop_user_one;
DROP SCHEMA m_drop_user_two;
-- test_sql:
DROP USER m_drop_user_one;
-- fixture_teardown:
DROP USER IF EXISTS m_drop_user_two RESTRICT;
DROP USER IF EXISTS m_drop_user_one RESTRICT;

-- case_id: manifest_m_drop_user_dependency_free_9494f2956b8e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_user_behavior_restrict", "if_exists": "m_drop_user_if_exists_none", "targets": "m_drop_user_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["none_after_explicit_schema_cleanup"], "fact_refs": ["m_drop_user_fact_dependency_free"], "key": "user_dependencies"}, {"allowed_values": ["single_database_test_identity"], "fact_refs": ["m_drop_user_fact_cross_database"], "key": "identity_scope"}]
-- fixture_setup:
CREATE USER m_drop_user_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE USER m_drop_user_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
DROP SCHEMA m_drop_user_one;
DROP SCHEMA m_drop_user_two;
-- test_sql:
DROP USER m_drop_user_one, m_drop_user_two RESTRICT;
-- fixture_teardown:
DROP USER IF EXISTS m_drop_user_two RESTRICT;
DROP USER IF EXISTS m_drop_user_one RESTRICT;

-- case_id: manifest_m_drop_user_dependency_free_688e471bc323
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_user_behavior_restrict", "if_exists": "m_drop_user_if_exists_yes", "targets": "m_drop_user_targets_one"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["none_after_explicit_schema_cleanup"], "fact_refs": ["m_drop_user_fact_dependency_free"], "key": "user_dependencies"}, {"allowed_values": ["single_database_test_identity"], "fact_refs": ["m_drop_user_fact_cross_database"], "key": "identity_scope"}]
-- fixture_setup:
CREATE USER m_drop_user_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE USER m_drop_user_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
DROP SCHEMA m_drop_user_one;
DROP SCHEMA m_drop_user_two;
-- test_sql:
DROP USER IF EXISTS m_drop_user_one RESTRICT;
-- fixture_teardown:
DROP USER IF EXISTS m_drop_user_two RESTRICT;
DROP USER IF EXISTS m_drop_user_one RESTRICT;

-- case_id: manifest_m_drop_user_dependency_free_2839cebbfc8d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "m_drop_user_behavior_default", "if_exists": "m_drop_user_if_exists_yes", "targets": "m_drop_user_targets_two"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_drop_user_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["sysadmin"], "fact_refs": ["m_create_role::m_create_role_fact_disable_authority"], "key": "actor_authority"}, {"allowed_values": ["off"], "fact_refs": ["m_create_role::m_create_role_fact_creation_authority"], "key": "separation_of_duties"}, {"allowed_values": ["none_after_explicit_schema_cleanup"], "fact_refs": ["m_drop_user_fact_dependency_free"], "key": "user_dependencies"}, {"allowed_values": ["single_database_test_identity"], "fact_refs": ["m_drop_user_fact_cross_database"], "key": "identity_scope"}]
-- fixture_setup:
CREATE USER m_drop_user_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;
CREATE USER m_drop_user_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;
DROP SCHEMA m_drop_user_one;
DROP SCHEMA m_drop_user_two;
-- test_sql:
DROP USER IF EXISTS m_drop_user_one, m_drop_user_two;
-- fixture_teardown:
DROP USER IF EXISTS m_drop_user_two RESTRICT;
DROP USER IF EXISTS m_drop_user_one RESTRICT;
