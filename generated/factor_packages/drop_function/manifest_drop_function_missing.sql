-- generated_from: manifest_drop_function_missing
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_function_missing_3ec0cf7b0459
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_bare", "target": "drop_function_target_missing"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_df_missing;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_missing_1fae752a92e0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_types", "target": "drop_function_target_missing"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_df_missing (INTEGER, INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_missing_4e98c2452ed1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_named", "target": "drop_function_target_missing"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_df_missing (num1 IN INTEGER, num2 IN INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
