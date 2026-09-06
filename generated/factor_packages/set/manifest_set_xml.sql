-- generated_from: manifest_set_xml
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_xml_aae053532076
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_xml", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET XML OPTION DOCUMENT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_xml_aa698479649c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_xml", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_content", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION XML OPTION CONTENT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_xml_c8e63ac1acbf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_xml", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL XML OPTION DOCUMENT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_xml_fe42d658a9f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_xml", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_content", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET XML OPTION CONTENT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_xml_e9a11bd66cb5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_xml", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION XML OPTION DOCUMENT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_xml_125ae727e22f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_xml", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_content", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL XML OPTION CONTENT;
-- fixture_teardown:
ROLLBACK;
