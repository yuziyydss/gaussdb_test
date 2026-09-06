-- generated_from: manifest_alter_resource_label_add
-- static_only: true
-- case_count: 3

-- case_id: manifest_alter_resource_label_add_506bc26e148e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_resource_label_action_add", "items": "alter_resource_label_items_column_one"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_change ADD TABLE(b9_rl_source_two);
-- test_sql:
ALTER RESOURCE LABEL b9_rl_change ADD COLUMN (b9_rl_source.col_1);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_change;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_resource_label_add_81ba7526f755
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_resource_label_action_add", "items": "alter_resource_label_items_column_two"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_change ADD TABLE(b9_rl_source_two);
-- test_sql:
ALTER RESOURCE LABEL b9_rl_change ADD COLUMN (b9_rl_source.col_2);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_change;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_resource_label_add_96aadced5f12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_resource_label_action_add", "items": "alter_resource_label_items_two_columns"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_resource_label_fact_privilege"], "key": "resource_label_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE b9_rl_source (col_1 INTEGER, col_2 INTEGER);
CREATE TABLE b9_rl_source_two (col_1 INTEGER, col_2 INTEGER);
CREATE VIEW b9_rl_view AS SELECT col_1 FROM b9_rl_source;
CREATE FUNCTION b9_rl_fn() RETURNS INTEGER AS $$ SELECT 1 $$ LANGUAGE SQL;
CREATE RESOURCE LABEL b9_rl_change ADD TABLE(b9_rl_source_two);
-- test_sql:
ALTER RESOURCE LABEL b9_rl_change ADD COLUMN (b9_rl_source.col_1, b9_rl_source.col_2);
-- fixture_teardown:
DROP RESOURCE LABEL IF EXISTS b9_rl_change;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
