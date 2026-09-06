-- generated_from: manifest_create_function_replace_existing
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_function_replace_existing_a8c5331616a3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arguments": "create_function_arguments_implicit", "cost": "create_function_cost_c0", "name": "create_function_name_existing", "nulls": "create_function_nulls_n3", "replace": "create_function_replace_yes", "security": "create_function_security_s0", "volatility": "create_function_volatility_v1"}
-- fixture_setup:
CREATE FUNCTION fp_cf_replace(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1 + $2;';
-- test_sql:
CREATE OR REPLACE FUNCTION fp_cf_replace (num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE STRICT SECURITY INVOKER AS 'SELECT $1 + $2;';
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_replace(INTEGER, INTEGER) CASCADE;
