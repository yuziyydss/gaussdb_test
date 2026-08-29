-- generated_from: manifest_create_view_schema_qualified_positive
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_view_schema_qualified_positive_478d448a10cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW public.v_cv_schema_478d448a AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;
