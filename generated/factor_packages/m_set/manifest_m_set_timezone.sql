-- generated_from: manifest_m_set_timezone
-- static_only: true
-- case_count: 9

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_timezone_fc3b8bede70f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TIME ZONE 'PRC';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_1e53b7e5d46a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_session", "timezone": "m_set_timezone_local", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TIME ZONE LOCAL;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_f3f71abd481f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_local", "timezone": "m_set_timezone_default", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TIME ZONE DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_3722d08d4b36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_default", "timezone": "m_set_timezone_local", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TIME ZONE LOCAL;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_7d6cc06cec10
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_default", "timezone": "m_set_timezone_default", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET TIME ZONE DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_fac64e3a1c6b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_session", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TIME ZONE 'PRC';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_7075010f8b25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_session", "timezone": "m_set_timezone_default", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION TIME ZONE DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_3526fb93ea58
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_local", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TIME ZONE 'PRC';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_timezone_57b9ff909c5d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_timezone", "scope": "m_set_scope_local", "timezone": "m_set_timezone_local", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL TIME ZONE LOCAL;
-- fixture_teardown:
ROLLBACK;
