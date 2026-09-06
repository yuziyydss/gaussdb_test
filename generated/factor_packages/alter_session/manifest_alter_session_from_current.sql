-- generated_from: manifest_alter_session_from_current
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_session_from_current_4e3f93bf602c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_from_current", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET DATESTYLE FROM CURRENT;
-- fixture_teardown:
ROLLBACK;
