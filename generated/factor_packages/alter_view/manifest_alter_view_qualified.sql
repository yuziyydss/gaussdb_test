-- generated_from: manifest_alter_view_qualified
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_view_qualified_4fd5e2b7d050
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_qualified"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE VIEW fp_cs_one.v_av_qualified AS SELECT col_1, col_2 FROM t_view_source;
-- test_sql:
ALTER VIEW fp_cs_one.v_av_qualified ALTER col_1 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS fp_cs_one.v_av_qualified;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_qualified_136bdb0edc01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_qualified"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE VIEW fp_cs_one.v_av_qualified AS SELECT col_1, col_2 FROM t_view_source;
-- test_sql:
ALTER VIEW IF EXISTS fp_cs_one.v_av_qualified ALTER col_1 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS fp_cs_one.v_av_qualified;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;
