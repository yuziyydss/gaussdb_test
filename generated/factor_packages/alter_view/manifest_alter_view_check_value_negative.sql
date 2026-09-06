-- generated_from: manifest_alter_view_check_value_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_view_check_value_negative_5bfae8bebb80
-- expected: error
-- expected_error_category: missing_check_option_value
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"action": "alter_view_action_set", "column_keyword": "alter_view_column_keyword_absent", "column_name": "alter_view_column_name_first", "expression": "alter_view_expression_integer", "if_exists": "alter_view_if_exists_absent", "new_name": "alter_view_new_name_new", "new_owner": "alter_view_new_owner_role", "new_schema": "alter_view_new_schema_schema", "options": "alter_view_options_missing_check", "reset_options": "alter_view_reset_options_barrier", "view_name": "alter_view_view_name_base"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP VIEW IF EXISTS v_av_missing;
DROP VIEW IF EXISTS v_av_new;
CREATE VIEW v_av_base AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- test_sql:
ALTER VIEW v_av_base SET (check_option);
-- fixture_teardown:
DROP VIEW IF EXISTS v_av_new;
DROP VIEW IF EXISTS v_av_base;
DROP TABLE IF EXISTS t_view_source CASCADE;
