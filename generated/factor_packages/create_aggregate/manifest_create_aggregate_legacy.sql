-- generated_from: manifest_create_aggregate_legacy
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_aggregate_legacy_965cc0eaa926
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_legacy", "initial": "create_aggregate_initial_default", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_default", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (BASETYPE = INTEGER, SFUNC = fp_cf_callable, STYPE = INTEGER);
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_legacy_676c70304435
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_legacy", "initial": "create_aggregate_initial_zero", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_default", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (BASETYPE = INTEGER, SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '0');
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_create_aggregate_legacy_ae4f4318fd88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "create_aggregate_form_legacy", "initial": "create_aggregate_initial_ten", "name": "create_aggregate_name_sum", "shipping": "create_aggregate_shipping_default", "transition": "create_aggregate_transition_sum"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
-- test_sql:
CREATE AGGREGATE fp_ca_sum (BASETYPE = INTEGER, SFUNC = fp_cf_callable, STYPE = INTEGER, INITCOND = '10');
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_ca_sum(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
