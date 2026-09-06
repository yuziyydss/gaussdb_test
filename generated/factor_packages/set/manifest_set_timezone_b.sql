-- generated_from: manifest_set_timezone_b
-- static_only: true
-- case_count: 9

-- case_id: manifest_set_timezone_b_436550211345
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_est"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET TIME ZONE 'EST';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_2864bac57385
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_ny"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION TIME ZONE 'America/New_York';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_f2fc43353df9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_decimal"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL TIME ZONE '-12.5';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_688526563fca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_ny"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET TIME ZONE 'America/New_York';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_0cd661e98052
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_decimal"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET TIME ZONE '-12.5';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_441272741edd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_est"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION TIME ZONE 'EST';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_04c322c8f646
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_decimal"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION TIME ZONE '-12.5';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_4a45d709f365
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_est"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL TIME ZONE 'EST';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_timezone_b_1d031df70e8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_ny"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL TIME ZONE 'America/New_York';
-- fixture_teardown:
ROLLBACK;
