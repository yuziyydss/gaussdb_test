-- generated_from: manifest_drop_function_signature
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_function_signature_6d7d152369b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_none", "signature": "drop_function_signature_types", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION fp_cf_callable (INTEGER, INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_signature_7223186e8fd6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_cascade", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_named", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) CASCADE;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_signature_46326b7040d3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_restrict", "if_exists": "drop_function_if_exists_none", "signature": "drop_function_signature_named", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_signature_93fefe87abad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_restrict", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_types", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_cf_callable (INTEGER, INTEGER) RESTRICT;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_signature_71b23adbb339
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_cascade", "if_exists": "drop_function_if_exists_none", "signature": "drop_function_signature_types", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION fp_cf_callable (INTEGER, INTEGER) CASCADE;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_function_signature_da1e592b3e77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_function_behavior_none", "if_exists": "drop_function_if_exists_yes", "signature": "drop_function_signature_named", "target": "drop_function_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
DROP FUNCTION IF EXISTS fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER);
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
