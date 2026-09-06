-- generated_from: manifest_set_b_expression
-- static_only: true
-- case_count: 12

-- case_id: manifest_set_b_expression_40dba470b32e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET codegen_cost_threshold = 10000;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_3e1297912132
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_double", "b_scope": "set_b_scope_session", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET SESSION codegen_cost_threshold = @@codegen_cost_threshold * 2;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_7eadc4323281
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_default", "b_scope": "set_b_scope_at", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET @@codegen_cost_threshold = DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_5f123450d624
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_session_at", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET @@SESSION.codegen_cost_threshold = 10000;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_816aace90171
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_double", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET codegen_cost_threshold = @@codegen_cost_threshold * 2;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_ca9c5ef8ff5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_default", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET codegen_cost_threshold = DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_ec924526b5a3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_session", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET SESSION codegen_cost_threshold = 10000;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_ff0bf952be2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_default", "b_scope": "set_b_scope_session", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET SESSION codegen_cost_threshold = DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_396c1ebdf30d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_at", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET @@codegen_cost_threshold = 10000;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_9c5d0eb1c6a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_double", "b_scope": "set_b_scope_at", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET @@codegen_cost_threshold = @@codegen_cost_threshold * 2;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_46940cabcdc4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_double", "b_scope": "set_b_scope_session_at", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET @@SESSION.codegen_cost_threshold = @@codegen_cost_threshold * 2;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_set_b_expression_a13e3e3d9070
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_default", "b_scope": "set_b_scope_session_at", "charset": "set_charset_utf8", "form": "set_form_b_expression", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}, {"allowed_values": ["B"], "fact_refs": ["set_fact_b_variables_gate"], "key": "sql_compatibility"}, {"allowed_values": ["enable_set_variables"], "fact_refs": ["set_fact_b_variables_gate"], "key": "b_format_behavior_compat_options_contains"}, {"allowed_values": ["user", "superuser"], "fact_refs": ["set_fact_b_context"], "key": "parameter_context"}]
-- fixture_setup:
BEGIN;
SET @@codegen_cost_threshold = 10000;
-- test_sql:
SET @@SESSION.codegen_cost_threshold = DEFAULT;
-- fixture_teardown:
ROLLBACK;
