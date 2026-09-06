-- generated_from: manifest_prepare_two_parameters
-- static_only: true
-- case_count: 4

-- case_id: manifest_prepare_two_parameters_e621fa0277e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_select_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
-- test_sql:
PREPARE p_ps_new AS SELECT CAST($1 AS INTEGER) AS a, CAST($2 AS INTEGER) AS b;
-- fixture_teardown:
DEALLOCATE ALL;

-- case_id: manifest_prepare_two_parameters_707e44213368
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_two", "statement_form": "prepare_statement_form_select_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
-- test_sql:
PREPARE p_ps_new(INTEGER, INTEGER) AS SELECT CAST($1 AS INTEGER) + 1 AS a, CAST($2 AS INTEGER) AS b;
-- fixture_teardown:
DEALLOCATE ALL;

-- case_id: manifest_prepare_two_parameters_c884232c6b26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_plus", "name": "prepare_name_new", "signature": "prepare_signature_inferred", "statement_form": "prepare_statement_form_select_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
-- test_sql:
PREPARE p_ps_new AS SELECT CAST($1 AS INTEGER) + 1 AS a, CAST($2 AS INTEGER) AS b;
-- fixture_teardown:
DEALLOCATE ALL;

-- case_id: manifest_prepare_two_parameters_cae3d176a714
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"expression": "prepare_expression_cast", "name": "prepare_name_new", "signature": "prepare_signature_two", "statement_form": "prepare_statement_form_select_two"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["prepare_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
DEALLOCATE ALL;
-- test_sql:
PREPARE p_ps_new(INTEGER, INTEGER) AS SELECT CAST($1 AS INTEGER) AS a, CAST($2 AS INTEGER) AS b;
-- fixture_teardown:
DEALLOCATE ALL;
