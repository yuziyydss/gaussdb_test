-- generated_from: manifest_create_cast_function_conversion
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_cast_function_conversion_998d4c95b44d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "create_cast_context_explicit"}
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
-- test_sql:
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_convert(double precision);
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_cast_function_conversion_639e027c2f53
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "create_cast_context_assignment"}
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
-- test_sql:
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_convert(double precision) AS ASSIGNMENT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_create_cast_function_conversion_525a040f0a88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"context": "create_cast_context_implicit"}
-- fixture_setup:
BEGIN;
CREATE FUNCTION fp_cast_convert(double precision) RETURNS timestamp with time zone AS 'SELECT to_timestamp($1);' LANGUAGE SQL STRICT;
-- test_sql:
CREATE CAST (double precision AS timestamp with time zone) WITH FUNCTION fp_cast_convert(double precision) AS IMPLICIT;
-- fixture_teardown:
ROLLBACK;
