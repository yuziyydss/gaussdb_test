-- generated_from: manifest_set_not_settable_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_not_settable_negative_dd3ac04a28b0
-- expected: error
-- expected_error_category: parameter_not_settable
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_forbidden", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_default", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET max_datanodes TO DEFAULT;
-- fixture_teardown:
ROLLBACK;
