-- generated_from: manifest_m_set_schema
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_schema_792ef0744de5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_to", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET CURRENT_SCHEMA TO m_set_owned_namespace;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_595638b8bf41
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_equals", "scope": "m_set_scope_session", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET SESSION CURRENT_SCHEMA = m_set_owned_namespace;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_a935b1f72ee9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_string", "scope": "m_set_scope_local", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET LOCAL SCHEMA 'm_set_owned_namespace';
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_f26d42914ecc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_equals", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET CURRENT_SCHEMA = m_set_owned_namespace;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_f78bc1ad2bef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_string", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET SCHEMA 'm_set_owned_namespace';
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_f8ef93653e83
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_to", "scope": "m_set_scope_session", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET SESSION CURRENT_SCHEMA TO m_set_owned_namespace;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_a9f3426390d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_string", "scope": "m_set_scope_session", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET SESSION SCHEMA 'm_set_owned_namespace';
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_723ec93b160f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_to", "scope": "m_set_scope_local", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET LOCAL CURRENT_SCHEMA TO m_set_owned_namespace;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;

-- case_id: manifest_m_set_schema_f7f4400c652a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_schema_equals", "scope": "m_set_scope_local", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["database_create"], "fact_refs": ["m_create_schema::m_create_schema_fact_authority"], "key": "namespace_create_authority"}, {"allowed_values": ["fresh_non_system_non_user_named_schema"], "fact_refs": ["m_create_schema::m_create_schema_fact_namespace", "m_create_schema::m_create_schema_fact_same_name_owner"], "key": "namespace_identity"}, {"allowed_values": ["actual_case_schema_owner"], "fact_refs": ["m_drop_schema::m_drop_schema_fact_authority"], "key": "namespace_drop_authority"}, {"allowed_values": ["same_connection_transaction_creator"], "fact_refs": ["m_commit::m_commit_fact_authority"], "key": "transaction_owner"}, {"allowed_values": ["fresh_owned_non_current_namespace_restore_before_drop"], "fact_refs": ["m_set_fact_session"], "key": "schema_lifecycle"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
CREATE SCHEMA m_set_owned_namespace;
COMMIT;
START TRANSACTION;
-- test_sql:
SET LOCAL CURRENT_SCHEMA = m_set_owned_namespace;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA m_set_owned_namespace;
COMMIT;
