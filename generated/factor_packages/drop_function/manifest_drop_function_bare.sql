-- generated_from: manifest_drop_function_bare
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_function_bare_f2d87f4ebb3d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_none", "signature": "drop_function_signature_bare", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION fp_cf_callable;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_bare_5c48e371af8f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_bare", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_cf_callable;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
