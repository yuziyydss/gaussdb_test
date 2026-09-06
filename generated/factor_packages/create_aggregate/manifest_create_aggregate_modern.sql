-- generated_from: manifest_create_aggregate_modern
-- static_only: true
-- case_count: 9

-- case_id: manifest_create_aggregate_modern_08256f8fa222
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_default", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_default", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_6f02d95c82cd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_zero", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_false", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '0', SHIPPABLE = false);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_95be99d3f708
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_ten", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_true", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '10', SHIPPABLE = true);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_4aed2e2f2762
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_default", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_false", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, SHIPPABLE = false);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_936748e1af1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_default", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_true", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, SHIPPABLE = true);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_35cc95432003
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_zero", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_default", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '0');
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_079bff0211be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_zero", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_true", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '0', SHIPPABLE = true);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_ae234700b0c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_ten", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_default", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '10');
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_modern_b23160baf881
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_modern", "initial": "create_aggregate_initial_ten", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_false", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (INTEGER) (SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '10', SHIPPABLE = false);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
