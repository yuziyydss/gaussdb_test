-- generated_from: manifest_set_generic
-- static_only: true
-- case_count: 12

-- case_id: manifest_set_generic_1b598a6801dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET client_encoding TO utf8;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_1b1dc4bbcc5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_equal", "parameter": "set_parameter_date", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_date", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET SESSION datestyle = postgres, dmy;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_ccdb699250fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_path", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_path", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET LOCAL search_path TO fp_cs_one, public;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_f86e58d0ef84
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_equal", "parameter": "set_parameter_path", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_default", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET search_path = DEFAULT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_b2c5e9a172b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_default", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET SESSION client_encoding TO DEFAULT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_bf6361ffa58a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_equal", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET LOCAL client_encoding = utf8;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_a01f7e451b33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_date", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_date", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET datestyle TO postgres, dmy;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_72ba715fe02f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_equal", "parameter": "set_parameter_path", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_path", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET SESSION search_path = fp_cs_one, public;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_a914cc0b7c4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_date", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_default", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET LOCAL datestyle TO DEFAULT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_34953a5471f7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_path", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_path", "schema_name": "set_schema_name_one", "scope": "set_scope_implicit", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET search_path TO fp_cs_one, public;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_76a8c4d7004b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_encoding", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_encoding", "schema_name": "set_schema_name_one", "scope": "set_scope_session", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET SESSION client_encoding TO utf8;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_set_generic_168468fd3be2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"b_expr": "set_b_expr_number", "b_scope": "set_b_scope_implicit", "charset": "set_charset_utf8", "form": "set_form_generic", "operator": "set_operator_to", "parameter": "set_parameter_date", "quoted_schema": "set_quoted_schema_one", "rhs": "set_rhs_date", "schema_name": "set_schema_name_one", "scope": "set_scope_local", "xml_mode": "set_xml_mode_document", "zone": "set_zone_pst"}
-- environment_requirements: [{"allowed_values": ["exclusive_test_connection"], "fact_refs": ["set_fact_session_scope"], "key": "session_ownership"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
SET LOCAL datestyle TO postgres, dmy;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
