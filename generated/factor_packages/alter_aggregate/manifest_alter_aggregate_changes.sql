-- generated_from: manifest_alter_aggregate_changes
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_aggregate_changes_7627ca6716de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_aggregate_action_rename", "name": "alter_aggregate_name_ready"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
SELECT 1;
-- test_sql:
ALTER AGGREGATE fp_ca_ready (INTEGER) RENAME TO fp_aa_renamed;
-- fixture_teardown:
DROP AGGREGATE IF EXISTS fp_aa_renamed(INTEGER) CASCADE;
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;

-- case_id: manifest_alter_aggregate_changes_baeae4bbdc99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_aggregate_action_schema", "name": "alter_aggregate_name_ready"}
-- fixture_setup:
CREATE FUNCTION fp_cf_callable(num1 INTEGER, num2 INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT AS 'SELECT $1 + $2;';
CREATE AGGREGATE fp_ca_ready(INTEGER) (SFUNC=fp_cf_callable, STYPE=INTEGER, INITCOND='0');
CREATE SCHEMA fp_aa_schema;
-- test_sql:
ALTER AGGREGATE fp_ca_ready (INTEGER) SET SCHEMA fp_aa_schema;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_aa_schema CASCADE;
DROP AGGREGATE IF EXISTS fp_ca_ready(INTEGER) CASCADE;
DROP FUNCTION IF EXISTS fp_cf_callable(INTEGER, INTEGER) CASCADE;
