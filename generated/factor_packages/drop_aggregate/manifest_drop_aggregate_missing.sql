-- generated_from: manifest_drop_aggregate_missing
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_aggregate_missing_e494b281d962
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_none", "if_exists": "drop_aggregate_if_exists_yes", "target": "drop_aggregate_target_missing"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE IF EXISTS fp_da_missing (INTEGER);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_missing_bdc3628b60f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_restrict", "if_exists": "drop_aggregate_if_exists_yes", "target": "drop_aggregate_target_missing"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE IF EXISTS fp_da_missing (INTEGER) RESTRICT;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_missing_f4cb8fef2a28
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_cascade", "if_exists": "drop_aggregate_if_exists_yes", "target": "drop_aggregate_target_missing"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE IF EXISTS fp_da_missing (INTEGER) CASCADE;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
