-- generated_from: manifest_alter_session_current_schema
-- static_only: true
-- case_count: 4

-- case_id: manifest_alter_session_current_schema_d4724f7abaae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_current_schema", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
ALTER SESSION SET CURRENT_SCHEMA TO fp_cs_one;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_session_current_schema_48c661e18457
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_equal", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_current_schema", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_default", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
ALTER SESSION SET CURRENT_SCHEMA = DEFAULT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_session_current_schema_5d10ec27f889
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_current_schema", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_default", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
ALTER SESSION SET CURRENT_SCHEMA TO DEFAULT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_session_current_schema_c863e3b6f92d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_equal", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_current_schema", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
-- test_sql:
ALTER SESSION SET CURRENT_SCHEMA = fp_cs_one;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
