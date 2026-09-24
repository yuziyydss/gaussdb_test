-- generated_from: manifest_create_view_non_updatable_trailing_negative
-- static_only: true
-- case_count: 39

-- case_id: manifest_create_view_non_updatable_trailing_negative_b1e25ea03209
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_distinct_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_b1e25ea0 AS SELECT DISTINCT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_36093358a748
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_group_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_36093358 (c1, c2) AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_2ba3d17d13ca
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_having_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_2ba3d17d AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 HAVING count(*) > 0 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_67b05c7d8b1d
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_limit_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_67b05c7d AS SELECT col_1, col_2 FROM t_view_source LIMIT 1 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_1f6103d03a5d
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_offset_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_1f6103d0 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source OFFSET 1 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_fb00c6b0d8fa
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_for_update_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_fb00c6b0 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source FOR UPDATE WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_abfc1750ee0b
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_fetch_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_abfc1750 AS SELECT col_1, col_2 FROM t_view_source FETCH FIRST 1 ROW ONLY WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_7e50d84618d6
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_union_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_7e50d846 AS SELECT col_1, col_2 FROM t_view_source UNION SELECT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_760af3498eed
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_intersect_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_760af349 AS SELECT col_1, col_2 FROM t_view_source INTERSECT SELECT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_0da27968d9b0
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_except_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_0da27968 AS SELECT col_1, col_2 FROM t_view_source EXCEPT SELECT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_4f976bf6dffc
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_aggregate_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_4f976bf6 AS SELECT count(*) AS col_1, max(col_2) AS col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_4df7f1ce39ff
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_window_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_4df7f1ce AS SELECT col_1, row_number() OVER (ORDER BY col_1) AS col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_73f822e75c71
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_set_returning_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_73f822e7 AS SELECT col_1, generate_series(1, 2) AS col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_3dab942ae930
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_group_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_3dab942a AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_e73a78546bed
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_offset_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_e73a7854 AS SELECT col_1, col_2 FROM t_view_source OFFSET 1 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_c190061b6806
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_for_update_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_c190061b AS SELECT col_1, col_2 FROM t_view_source FOR UPDATE WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_f894c16b161c
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_distinct_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_f894c16b (c1, c2) AS SELECT DISTINCT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_b0852840490e
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_having_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_b0852840 (c1, c2) AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 HAVING count(*) > 0 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_02a66157046f
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_limit_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_02a66157 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source LIMIT 1 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_f494e827a62b
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_fetch_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_f494e827 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source FETCH FIRST 1 ROW ONLY WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_b50cab53258d
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_union_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_b50cab53 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source UNION SELECT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_5e519857bb26
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_intersect_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_5e519857 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source INTERSECT SELECT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_4f94372bcdf5
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_except_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_4f94372b (c1, c2) AS SELECT col_1, col_2 FROM t_view_source EXCEPT SELECT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_b0470e3af0a0
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_aggregate_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_b0470e3a (c1, c2) AS SELECT count(*) AS col_1, max(col_2) AS col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_443a97799cf4
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_window_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_443a9779 (c1, c2) AS SELECT col_1, row_number() OVER (ORDER BY col_1) AS col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_e73ed9304193
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_set_returning_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_e73ed930 (c1, c2) AS SELECT col_1, generate_series(1, 2) AS col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_2ca080556ae2
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_distinct_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_2ca08055 AS SELECT DISTINCT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_67b643e96888
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_group_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_67b643e9 AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_de34fcea4a10
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_having_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_de34fcea AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 HAVING count(*) > 0 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_43d452daa6d7
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_limit_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_43d452da AS SELECT col_1, col_2 FROM t_view_source LIMIT 1 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_20742a39bbdf
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_offset_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_20742a39 AS SELECT col_1, col_2 FROM t_view_source OFFSET 1 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_3444799ffe3a
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_for_update_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_3444799f AS SELECT col_1, col_2 FROM t_view_source FOR UPDATE WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_8095eaf3835f
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_fetch_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_8095eaf3 AS SELECT col_1, col_2 FROM t_view_source FETCH FIRST 1 ROW ONLY WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_3d49d0605b64
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_union_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_3d49d060 AS SELECT col_1, col_2 FROM t_view_source UNION SELECT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_f0b9dbfcf477
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_intersect_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_f0b9dbfc AS SELECT col_1, col_2 FROM t_view_source INTERSECT SELECT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_3a2f71e48350
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_except_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_3a2f71e4 AS SELECT col_1, col_2 FROM t_view_source EXCEPT SELECT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_1545e7c3c51f
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_aggregate_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_1545e7c3 AS SELECT count(*) AS col_1, max(col_2) AS col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_f1118fbd1e37
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_window_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_f1118fbd AS SELECT col_1, row_number() OVER (ORDER BY col_1) AS col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_trailing_negative_9209de82305f
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_set_returning_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_tail_check_9209de82 AS SELECT col_1, generate_series(1, 2) AS col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;
