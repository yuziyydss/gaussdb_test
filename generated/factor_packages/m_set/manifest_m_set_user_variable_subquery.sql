-- generated_from: manifest_m_set_user_variable_subquery
-- static_only: true
-- case_count: 8

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_user_variable_subquery_210914a3c252
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value := (SELECT 'factor value');
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_054906456646
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_equals", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_null"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value = (SELECT NULL);
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_384aa5bfb5df
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_integer_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value := (SELECT 7);
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_8f921f6444b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_integer_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value := (SELECT -7);
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_76482fb73859
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_colon", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_null"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value := (SELECT NULL);
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_85c9f3034f06
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_equals", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_string"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value = (SELECT 'factor value');
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_4b37d784f6b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_equals", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_integer_positive"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value = (SELECT 7);
-- fixture_teardown:
SET @m_set_subquery_value := NULL;

-- case_id: manifest_m_set_user_variable_subquery_bb9e86bf3de6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment_operator": "m_set_assignment_operator_equals", "form": "m_set_form_user_variable_subquery", "scope": "m_set_scope_default", "timezone": "m_set_timezone_prc", "variable_value": "m_set_variable_value_integer_negative"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_set_fact_session"], "key": "session_lifecycle"}, {"allowed_values": ["close_case_connection"], "fact_refs": ["m_set_fact_session"], "key": "variable_lifecycle"}]
-- fixture_setup:
SET @m_set_subquery_value := 'initial subquery value';
-- test_sql:
SET @m_set_subquery_value = (SELECT -7);
-- fixture_teardown:
SET @m_set_subquery_value := NULL;
