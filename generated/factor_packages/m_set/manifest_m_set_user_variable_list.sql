-- generated_from: manifest_m_set_user_variable_list
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_user_variable_list_76f98fdee654
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_user_variable_list", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_first := 'initial first';
SET @m_set_second := 'initial second';
-- test_sql:
SET @m_set_first := 'first value', @m_set_second := 'factor value';
-- fixture_teardown:
SET @m_set_first := NULL;
SET @m_set_second := NULL;

-- case_id: manifest_m_set_user_variable_list_d54e9b75c0ce
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_equals", "form": "m_set_form_user_variable_list", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_null"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_first := 'initial first';
SET @m_set_second := 'initial second';
-- test_sql:
SET @m_set_first = 'first value', @m_set_second = NULL;
-- fixture_teardown:
SET @m_set_first := NULL;
SET @m_set_second := NULL;

-- case_id: manifest_m_set_user_variable_list_661f6accad4c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_user_variable_list", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_null"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_first := 'initial first';
SET @m_set_second := 'initial second';
-- test_sql:
SET @m_set_first := 'first value', @m_set_second := NULL;
-- fixture_teardown:
SET @m_set_first := NULL;
SET @m_set_second := NULL;

-- case_id: manifest_m_set_user_variable_list_7798ab42a048
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_equals", "form": "m_set_form_user_variable_list", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_first := 'initial first';
SET @m_set_second := 'initial second';
-- test_sql:
SET @m_set_first = 'first value', @m_set_second = 'factor value';
-- fixture_teardown:
SET @m_set_first := NULL;
SET @m_set_second := NULL;
