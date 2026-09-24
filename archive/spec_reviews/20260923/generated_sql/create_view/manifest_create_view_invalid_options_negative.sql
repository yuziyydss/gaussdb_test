-- generated_from: manifest_create_view_invalid_options_negative
-- static_only: true
-- case_count: 3

-- case_id: manifest_create_view_invalid_options_negative_3b0787a70c88
-- expected: error
-- expected_error_category: invalid_view_option
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_unknown_name"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_3b0787a7 WITH (unknown_option = true) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_invalid_options_negative_91b91819d304
-- expected: error
-- expected_error_category: invalid_view_option
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_invalid"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_91b91819 WITH (security_barrier = not_bool) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_invalid_options_negative_b5cd856c5466
-- expected: error
-- expected_error_category: invalid_view_option
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_invalid"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_b5cd856c WITH (check_option = INVALID) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;
