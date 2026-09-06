-- generated_from: manifest_alter_session_transaction
-- static_only: true
-- case_count: 10

-- case_id: manifest_alter_session_transaction_9d45d12a97cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_871c52830be9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_session", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_write", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET SESSION CHARACTERISTICS AS TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_4257b092e53e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_committed", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_add50604ccbc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_uncommitted", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_5b2e349fbb26
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_combined", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET TRANSACTION ISOLATION LEVEL READ COMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_3a08db75dcc0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_current", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_write", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET TRANSACTION READ WRITE;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_0591a34f14da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_session", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_read_only", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET SESSION CHARACTERISTICS AS TRANSACTION READ ONLY;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_0acfe4b73c15
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_session", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_committed", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_ecc922631b2d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_session", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_uncommitted", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_alter_session_transaction_4827c3cb168c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"assignment": "alter_session_assignment_to", "characteristics": "alter_session_characteristics_session", "form": "alter_session_form_transaction", "generic_value": "alter_session_generic_value_postgres", "schema_name": "alter_session_schema_name_existing", "timezone": "alter_session_timezone_prc", "transaction_modes": "alter_session_transaction_modes_combined", "xml_mode": "alter_session_xml_mode_content"}
-- fixture_setup:
BEGIN;
-- test_sql:
ALTER SESSION SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED, READ ONLY;
-- fixture_teardown:
ROLLBACK;
