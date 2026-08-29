-- generated_from: manifest_select_ast_core_positive
-- static_only: true
-- case_count: 11

-- case_id: manifest_select_ast_core_positive_39c35eeab337
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM t_select_source AS ast_src;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_45934506853e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1_col2", "limit_clause": "select_limit_five", "lock_clause": "select_lock_update", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_all", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT ALL col_1, col_2 FROM (SELECT col_1, col_2 FROM t_select_source AS ast_inner) AS ast_s WHERE col_1 >= 0 ORDER BY col_1 ASC LIMIT 5 FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_85a26c3e477d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_five", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1_col2", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_distinct", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT DISTINCT col_1, col_2 FROM t_select_source AS ast_src WHERE col_1 >= 0 ORDER BY col_1 ASC, col_2 DESC LIMIT 5;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_e0b9e663b256
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1_col2", "limit_clause": "select_limit_none", "lock_clause": "select_lock_update", "order_by_list": "select_order_col1_col2", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM (SELECT col_1, col_2 FROM t_select_source AS ast_inner) AS ast_s ORDER BY col_1 ASC, col_2 DESC FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_999b78c9bf44
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_all", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT ALL col_1 FROM t_select_source AS ast_src ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_81352047e100
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1_col2", "limit_clause": "select_limit_five", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_distinct", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT DISTINCT col_1 FROM (SELECT col_1, col_2 FROM t_select_source AS ast_inner) AS ast_s LIMIT 5;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_8fac46a6f82f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_update", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1, col_2 FROM t_select_source AS ast_src WHERE col_1 >= 0 FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_b39304197a39
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1_col2", "limit_clause": "select_limit_five", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM t_select_source AS ast_src WHERE col_1 >= 0 ORDER BY col_1 ASC LIMIT 5;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_43a51eb92d2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_distinct", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT DISTINCT col_1 FROM (SELECT col_1 FROM t_select_source AS ast_inner) AS ast_s ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_49a4b05ae18a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_all", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT ALL col_1, col_2 FROM t_select_source AS ast_src;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_core_positive_8950cedb582b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1_col2", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_all", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT ALL col_1 FROM t_select_source AS ast_src ORDER BY col_1 ASC, col_2 DESC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;
