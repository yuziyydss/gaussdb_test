-- generated_from: manifest_create_view_options_positive
-- static_only: true
-- case_count: 22

-- case_id: manifest_create_view_options_positive_a743f49b3131
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_a743f49b WITH (security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_03c87b6f14f4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "check_default", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_03c87b6f (c1, c2) WITH (security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_8375bb14db9d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_cascaded", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_8375bb14 WITH (security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_f234727ba5ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "check_local", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_f234727b (c1, c2) WITH (security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_3323ca75539a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_3323ca75 (c1, c2) WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_377c85fb47cb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "read_only", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_377c85fb WITH (security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_fb87f5fa64e8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_fb87f5fa WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_185acd0cd111
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_security_true_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_185acd0c WITH (security_barrier = true, check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_04cb23b57ff0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_security_false_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_04cb23b5 WITH (security_barrier = false, check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_2e51a331358b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_check_local_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_2e51a331 WITH (check_option = LOCAL, security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_f85699ce8965
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_check_cascaded_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_f85699ce WITH (check_option = CASCADED, security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_74feace1597b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "read_only", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_74feace1 (c1, c2) WITH (security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source WITH READ ONLY;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_c2e97a351d15
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_default", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_c2e97a35 WITH (security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source WITH CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_ca363328b2cc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "check_local", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_ca363328 WITH (security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0 WITH LOCAL CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_9b7c73eded47
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "check_cascaded", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_9b7c73ed (c1, c2) WITH (security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source WITH CASCADED CHECK OPTION;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_ee54191180db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_ee541911 (c1, c2) WITH (check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_1a90783a1ab8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_1a90783a WITH (check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_372ffdac0a27
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_security_true_check_local"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_372ffdac (c1, c2) WITH (security_barrier = true, check_option = LOCAL) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_5588a0550b36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_security_false_check_cascaded"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_5588a055 (c1, c2) WITH (security_barrier = false, check_option = CASCADED) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_c83ec2a2869e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_check_local_security_true"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_c83ec2a2 (c1, c2) WITH (check_option = LOCAL, security_barrier = true) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_f31ffe19bac4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_two_aliases", "force_modifier": "force_absent", "or_replace": "or_replace_keyword", "post_query_option": "post_query_none", "query_profile": "query_filtered_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_options_check_cascaded_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE OR REPLACE VIEW v_cv_options_f31ffe19 (c1, c2) WITH (check_option = CASCADED, security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source WHERE col_1 > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_create_view_options_positive_f3b585d1947c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"column_list": "column_list_inherited", "force_modifier": "force_absent", "or_replace": "or_replace_absent", "post_query_option": "post_query_none", "query_profile": "query_simple_two_columns", "temp_modifier": "temp_absent", "view_options_profile": "view_option_security_false"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
CREATE VIEW v_cv_options_f3b585d1 WITH (security_barrier = false) AS SELECT col_1, col_2 FROM t_view_source;
-- fixture_teardown:
DROP TABLE IF EXISTS t_view_source CASCADE;
