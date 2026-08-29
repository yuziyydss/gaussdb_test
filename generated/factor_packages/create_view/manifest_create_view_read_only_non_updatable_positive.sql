-- generated_from: manifest_create_view_read_only_non_updatable_positive
-- static_only: true
-- case_count: 16

-- case_id: manifest_create_view_read_only_non_updatable_positive_02731038659d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_distinct_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_02731038 AS SELECT DISTINCT col_1, col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_968f9473777f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_group_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_968f9473 AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_63eb257d661d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_having_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_63eb257d AS SELECT col_1, count(*) AS col_2 FROM t_view_source GROUP BY col_1 HAVING count(*) > 0 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_438796cdbdde
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_limit_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_438796cd AS SELECT col_1, col_2 FROM t_view_source LIMIT 1 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_eddd4e7e0ba3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_offset_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_eddd4e7e AS SELECT col_1, col_2 FROM t_view_source OFFSET 1 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_c57384dce3c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_for_update_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_c57384dc AS SELECT col_1, col_2 FROM t_view_source FOR UPDATE WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_9d5b2aeecfb2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_fetch_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_9d5b2aee AS SELECT col_1, col_2 FROM t_view_source FETCH FIRST 1 ROW ONLY WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_a9581a236330
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_union_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_a9581a23 AS SELECT col_1, col_2 FROM t_view_source UNION SELECT col_1, col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_703844a9d1cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_intersect_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_703844a9 AS SELECT col_1, col_2 FROM t_view_source INTERSECT SELECT col_1, col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_09357b7aa13f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_except_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_09357b7a AS SELECT col_1, col_2 FROM t_view_source EXCEPT SELECT col_1, col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_01113eda4170
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_aggregate_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_01113eda AS SELECT count(*) AS col_1, max(col_2) AS col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_607a56ec73fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_window_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_607a56ec AS SELECT col_1, row_number() OVER (ORDER BY col_1) AS col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_c920f82f1593
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_set_returning_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_c920f82f AS SELECT col_1, generate_series(1, 2) AS col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_951ae70efe51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_unpivot_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_951ae70e AS SELECT metric_name, metric_value FROM t_view_source UNPIVOT (metric_value FOR metric_name IN (col_1 AS 'COL_1', col_2 AS 'COL_2')) WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_cfef5634d5d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_start_with_connect_by_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_cfef5634 AS SELECT col_1, col_2 FROM t_view_source START WITH col_1 = 1 CONNECT BY PRIOR col_1 = col_2 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_read_only_non_updatable_positive_97bc1338fa89
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_flashback_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
CREATE TABLE t_cv_flashback_source (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=ustore);
INSERT INTO t_cv_flashback_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_read_only_97bc1338 AS SELECT col_1, col_2 FROM t_cv_flashback_source TIMECAPSULE TIMESTAMP (CURRENT_TIMESTAMP - INTERVAL '1 minute') WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_cv_flashback_source CASCADE;
DROP TABLE IF EXISTS t_view_source CASCADE;
