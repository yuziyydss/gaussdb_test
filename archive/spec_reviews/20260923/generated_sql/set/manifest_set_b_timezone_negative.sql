-- generated_from: manifest_set_b_timezone_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_b_timezone_negative_efe932832d88
-- expected: error
-- expected_error_category: b_timezone_hour_minute_unsupported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_zone", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_hhmm"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_zone_environment"], "key": "sql_compatibility"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET TIME ZONE '-12:30';
-- fixture_teardown:
ROLLBACK;
