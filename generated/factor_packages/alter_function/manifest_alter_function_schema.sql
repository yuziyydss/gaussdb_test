-- generated_from: manifest_alter_function_schema
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_function_schema_3fdc8347448e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a0", "form": "alter_function_form_schema", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_types"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE SCHEMA fp_af_schema;
-- test_sql:
ALTER FUNCTION fp_cf_callable (INTEGER, INTEGER) SET SCHEMA fp_af_schema;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_af_schema CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_function_schema_a32707ea6a38
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_function_action_a0", "form": "alter_function_form_schema", "name": "alter_function_name_base", "restrict": "alter_function_restrict_none", "signature": "alter_function_signature_named"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE SCHEMA fp_af_schema;
-- test_sql:
ALTER FUNCTION fp_cf_callable (num1 IN INTEGER, num2 IN INTEGER) SET SCHEMA fp_af_schema;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_af_schema CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
