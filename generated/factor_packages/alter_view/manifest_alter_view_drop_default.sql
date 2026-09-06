-- generated_from: manifest_alter_view_drop_default
-- static_only: true
-- case_count: 5

-- case_id: manifest_alter_view_drop_default_17db509ba2d9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base ALTER col_1 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_drop_default_61f1318c9356
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_present", "column_name": "alter_view_column_name_second", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW IF EXISTS v_av_base ALTER COLUMN col_2 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_drop_default_f1a46ae11756
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_present", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base ALTER COLUMN col_1 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_drop_default_3f626bdebcbc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_second", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base ALTER col_2 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_alter_view_drop_default_fd84100c12a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_view_action_drop_default", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_present", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_barrier_implicit", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW IF EXISTS v_av_base ALTER col_1 DROP DEFAULT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;
