-- generated_from: manifest_alter_session_generic
-- static_only: true
-- case_count: 4

-- case_id: manifest_alter_session_generic_d10847463551
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_generic", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET DATESTYLE TO postgres, dmy;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_generic_8b240c6425f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_equal", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_generic", "generic_value": "alter_session_generic_value_default", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET DATESTYLE = DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_generic_7b9f5b4089e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_generic", "generic_value": "alter_session_generic_value_default", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET DATESTYLE TO DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_generic_6315494b0957
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_equal", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_generic", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET DATESTYLE = postgres, dmy;
-- fixture_teardown:
ROLLBACK;
