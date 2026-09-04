-- generated_from: manifest_create_view_non_updatable_option_negative
-- static_only: true
-- case_count: 26

-- case_id: manifest_create_view_non_updatable_option_negative_a4d45b53daec
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_distinct_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_a4d45b53 WITH (check_option = CASCADED) AS SELECT DISTINCT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_79c2947c9652
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_group_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_79c2947c (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_a5c23cc15e7f
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_having_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_a5c23cc1 WITH (check_option = LOCAL) AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 HAVING count(*) > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_089727b35bb4
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_limit_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_089727b3 (c1, c2) WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source LIMIT 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_b84ea18cceb5
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_offset_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_b84ea18c WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source OFFSET 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_272d64e8df69
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_for_update_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_272d64e8 WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_a29b6ca098f1
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_fetch_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_a29b6ca0 WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source FETCH FIRST 1 ROW ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_e8b13ddeb93d
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_union_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_e8b13dde WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source UNION SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_5fc332260ba8
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_intersect_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_5fc33226 WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source INTERSECT SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_92356d5bd896
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_except_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_92356d5b WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source EXCEPT SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_2a6ffefd64d5
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_aggregate_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_2a6ffefd WITH (check_option = CASCADED) AS SELECT count(*) AS col_1, max(col_2) AS col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_dfa46d5e0ec1
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_window_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_dfa46d5e WITH (check_option = CASCADED) AS SELECT col_1, row_number() OVER (ORDER BY col_1) AS col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_33534e48da38
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_set_returning_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_33534e48 WITH (check_option = CASCADED) AS SELECT col_1, generate_series(1, 2) AS col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_b6a93907b369
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_group_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_b6a93907 WITH (check_option = CASCADED) AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_3d3382395fdc
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_limit_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_3d338239 WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source LIMIT 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_ba1f34b508b2
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_having_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_ba1f34b5 (c1, c2) WITH (check_option = CASCADED) AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 HAVING count(*) > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_b835b98ece0d
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_distinct_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_b835b98e (c1, c2) WITH (check_option = LOCAL) AS SELECT DISTINCT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_21caa65b23d5
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_offset_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_21caa65b (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source OFFSET 1;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_5aebda46d333
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_for_update_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_5aebda46 (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_0c87046730fb
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_fetch_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_0c870467 (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source FETCH FIRST 1 ROW ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_94ea4d29553e
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_union_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_94ea4d29 (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source UNION SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_405febafc67e
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_intersect_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_405febaf (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source INTERSECT SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_a0492bef004a
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_except_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_a0492bef (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source EXCEPT SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_32907aff5a19
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_aggregate_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_32907aff (c1, c2) WITH (check_option = LOCAL) AS SELECT count(*) AS col_1, max(col_2) AS col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_59025f9a84d2
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_window_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_59025f9a (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, row_number() OVER (ORDER BY col_1) AS col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_non_updatable_option_negative_12399977e528
-- expected: error
-- expected_error_category: check_option_requires_updatable_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_set_returning_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_bad_option_check_12399977 (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, generate_series(1, 2) AS col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;
