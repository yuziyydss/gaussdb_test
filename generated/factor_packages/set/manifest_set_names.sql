-- generated_from: manifest_set_names
-- static_only: true
-- case_count: 6

-- case_id: manifest_set_names_9f62384e60e2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_names", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["client_encoding_only"], "fact_refs": ["set_fact_plain_names_environment"], "key": "names_semantics"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET NAMES 'UTF8';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_names_1b10550ba165
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_default", "form": "set_form_names", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["client_encoding_only"], "fact_refs": ["set_fact_plain_names_environment"], "key": "names_semantics"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION NAMES DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_names_0a49a2b769c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_names", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["client_encoding_only"], "fact_refs": ["set_fact_plain_names_environment"], "key": "names_semantics"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL NAMES 'UTF8';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_names_a1fb9461047c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_default", "form": "set_form_names", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["client_encoding_only"], "fact_refs": ["set_fact_plain_names_environment"], "key": "names_semantics"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET NAMES DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_names_b71035eac286
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_names", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["client_encoding_only"], "fact_refs": ["set_fact_plain_names_environment"], "key": "names_semantics"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION NAMES 'UTF8';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_names_c6199c817109
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_default", "form": "set_form_names", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["client_encoding_only"], "fact_refs": ["set_fact_plain_names_environment"], "key": "names_semantics"}]
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL NAMES DEFAULT;
-- fixture_teardown:
ROLLBACK;
