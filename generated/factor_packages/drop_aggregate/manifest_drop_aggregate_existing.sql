-- generated_from: manifest_drop_aggregate_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_aggregate_existing_6d9f3eb4425b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_none", "if_exists": "drop_aggregate_if_exists_none", "target": "drop_aggregate_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE fp_ca_ready (INTEGER);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_existing_78ba5c52af44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_restrict", "if_exists": "drop_aggregate_if_exists_yes", "target": "drop_aggregate_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE IF EXISTS fp_ca_ready (INTEGER) RESTRICT;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_existing_b145cab3a313
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_cascade", "if_exists": "drop_aggregate_if_exists_none", "target": "drop_aggregate_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE fp_ca_ready (INTEGER) CASCADE;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_existing_ce38e7bcaf93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_restrict", "if_exists": "drop_aggregate_if_exists_none", "target": "drop_aggregate_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE fp_ca_ready (INTEGER) RESTRICT;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_existing_6d040662d04f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_none", "if_exists": "drop_aggregate_if_exists_yes", "target": "drop_aggregate_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE IF EXISTS fp_ca_ready (INTEGER);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_drop_aggregate_existing_9c4eb8252cdb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_aggregate_behavior_cascade", "if_exists": "drop_aggregate_if_exists_yes", "target": "drop_aggregate_target_present"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
-- test_sql:
DROP AGGREGATE IF EXISTS fp_ca_ready (INTEGER) CASCADE;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
