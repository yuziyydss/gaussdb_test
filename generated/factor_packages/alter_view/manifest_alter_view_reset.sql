-- generated_from: manifest_alter_view_reset
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_view_reset_c26fde285cfa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_reset", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base RESET (security_barrier);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_reset_26f40fe43445
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_reset", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_check", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW IF EXISTS v_av_base RESET (check_option);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_reset_bad303104769
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_reset", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_both", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base RESET (security_barrier, check_option);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_reset_358e73b20ba1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_reset", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_check", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base RESET (check_option);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_reset_70d88b46c528
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_reset", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW IF EXISTS v_av_base RESET (security_barrier);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_reset_730df8d5f559
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_reset", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_both", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW IF EXISTS v_av_base RESET (security_barrier, check_option);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;
