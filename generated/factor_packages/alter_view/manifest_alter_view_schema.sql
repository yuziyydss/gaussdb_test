-- generated_from: manifest_alter_view_schema
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_view_schema_253565d97260
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_schema", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_view_fact_schema_permission"], "key": "target_schema_create_permission"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP VIEW IF EXISTS fp_cs_one.v_av_base;
-- test_sql:
ALTER VIEW v_av_base SET SCHEMA fp_cs_one;
-- fixture_teardown:
DROP VIEW IF EXISTS fp_cs_one.v_av_base;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_schema_847ca02dc053
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_schema", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- environment_requirements: [{"allowed_values": ["true"], "fact_refs": ["alter_view_fact_schema_permission"], "key": "target_schema_create_permission"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
DROP VIEW IF EXISTS fp_cs_one.v_av_base;
-- test_sql:
ALTER VIEW IF EXISTS v_av_base SET SCHEMA fp_cs_one;
-- fixture_teardown:
DROP VIEW IF EXISTS fp_cs_one.v_av_base;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;
