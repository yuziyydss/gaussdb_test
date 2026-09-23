-- generated_from: manifest_create_view_basic_positive
-- static_only: true
-- case_count: 21

-- case_id: manifest_create_view_basic_positive_7849f06cf335
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_select_star", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_7849f06c AS SELECT * FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_1184ef8e073a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "check_default", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE TEMP FORCE VIEW v_cv_basic_1184ef8e (c1, c2) AS SELECT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_2623e2f14715
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_filtered_two_columns", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMPORARY VIEW v_cv_basic_2623e2f1 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_f8a4d12388f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "check_local", "query_profile": "query_values_two_columns", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE OR REPLACE TEMPORARY FORCE VIEW v_cv_basic_f8a4d123 AS VALUES (1, 2), (3, 4) WITH LOCAL CHECK OPTION;

-- case_id: manifest_create_view_basic_positive_a1959e04c3da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_keyword", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_values_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE FORCE VIEW v_cv_basic_a1959e04 (c1, c2) AS VALUES (1, 2), (3, 4) WITH READ ONLY;

-- case_id: manifest_create_view_basic_positive_a3e991b358d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "read_only", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE TEMP VIEW v_cv_basic_a3e991b3 AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_726923adef48
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_726923ad AS SELECT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_4f736321c4c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_select_star", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMP VIEW v_cv_basic_4f736321 (c1, c2) AS SELECT * FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_2b7e84be177a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "check_cascaded", "query_profile": "query_select_star", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE FORCE VIEW v_cv_basic_2b7e84be AS SELECT * FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_82409a013d2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE FORCE VIEW v_cv_basic_82409a01 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_fe7a1b2bda93
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_values_two_columns", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE TEMP VIEW v_cv_basic_fe7a1b2b AS VALUES (1, 2), (3, 4);

-- case_id: manifest_create_view_basic_positive_3e9f85ff5f99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_select_star", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMPORARY VIEW v_cv_basic_3e9f85ff AS SELECT * FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_0cddb22f84bb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMPORARY VIEW v_cv_basic_0cddb22f AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_80b6bec96a96
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_80b6bec9 AS SELECT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_550d1422014a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMP VIEW v_cv_basic_550d1422 AS SELECT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_ad6bcf463f0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_select_star", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMPORARY VIEW v_cv_basic_ad6bcf46 AS SELECT * FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_ec10894bec08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_ec10894b AS SELECT col_1, col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_aede9d742ca1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_aede9d74 AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_bd8e0265832c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_bd8e0265 AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_550ec40c4378
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_values_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE VIEW v_cv_basic_550ec40c AS VALUES (1, 2), (3, 4) WITH CHECK OPTION;

-- case_id: manifest_create_view_basic_positive_f2c363a56f20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_values_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE VIEW v_cv_basic_f2c363a5 AS VALUES (1, 2), (3, 4) WITH CASCADED CHECK OPTION;
