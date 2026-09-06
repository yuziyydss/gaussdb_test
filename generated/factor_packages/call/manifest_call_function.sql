-- generated_from: manifest_call_function
-- static_only: true
-- case_count: 4

-- case_id: manifest_call_function_e58caed842ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "call_arguments_positional", "name": "call_name_local"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
CALL fp_cf_callable (1, 3);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_call_function_0328d519efb9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "call_arguments_arrow", "name": "call_name_local"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
CALL fp_cf_callable (num1 => 1, num2 => 3);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_call_function_11663e737a00
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "call_arguments_assign", "name": "call_name_local"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
CALL fp_cf_callable (num2 := 3, num1 := 1);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_call_function_084053d8b930
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "call_arguments_reversed", "name": "call_name_local"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
CALL fp_cf_callable (num2 => 3, num1 => 1);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
