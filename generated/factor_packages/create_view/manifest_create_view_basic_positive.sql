-- generated_from: manifest_create_view_basic_positive
-- static_only: true
-- case_count: 18

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

-- case_id: manifest_create_view_basic_positive_cd90ca8ae73f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "read_only", "query_profile": "query_values_two_columns", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE OR REPLACE TEMPORARY FORCE VIEW v_cv_basic_cd90ca8a AS VALUES (1, 2), (3, 4) WITH READ ONLY;

-- case_id: manifest_create_view_basic_positive_f61f7b4c56e5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMP VIEW v_cv_basic_f61f7b4c AS SELECT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_ef2eab43ef40
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "check_local", "query_profile": "query_select_star", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE FORCE VIEW v_cv_basic_ef2eab43 (c1, c2) AS SELECT * FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_7f80c765a5fa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_values_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- test_sql:
CREATE VIEW v_cv_basic_7f80c765 (c1, c2) AS VALUES (1, 2), (3, 4) WITH READ ONLY;

-- case_id: manifest_create_view_basic_positive_018fe5facc9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_keyword", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE FORCE VIEW v_cv_basic_018fe5fa AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_a809ed899a74
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE TEMP VIEW v_cv_basic_a809ed89 (c1, c2) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_dc9834a412c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_keyword", "or_replace": "or_replace_keyword", "post_query_option": "check_cascaded", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE FORCE VIEW v_cv_basic_dc9834a4 AS SELECT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

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

-- case_id: manifest_create_view_basic_positive_2f80880affa4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_keyword", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMPORARY FORCE VIEW v_cv_basic_2f80880a AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_3e5b378b23a7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_select_star", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMP VIEW v_cv_basic_3e5b378b AS SELECT * FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_basic_positive_3c2d58ccd9e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_select_star", "temp_modifier": "temp_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMP VIEW v_cv_basic_3c2d58cc AS SELECT * FROM t_view_source WITH READ ONLY;
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

-- case_id: manifest_create_view_basic_positive_f7f1836b1ce2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_filtered_two_columns", "temp_modifier": "temporary_keyword", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE TEMPORARY VIEW v_cv_basic_f7f1836b AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH LOCAL CHECK OPTION;
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

-- case_id: manifest_create_view_basic_positive_331caa4e8f89
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_basic_331caa4e AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;
