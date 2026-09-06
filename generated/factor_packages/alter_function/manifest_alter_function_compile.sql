-- generated_from: manifest_alter_function_compile
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_function_compile_11e0e0df4043
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a0", "form": "alter_function_form_compile", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
-- test_sql:
ALTER FUNCTION fp_cf_callable COMPILE;
-- fixture_teardown:
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
