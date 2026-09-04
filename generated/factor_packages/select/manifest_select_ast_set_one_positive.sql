-- generated_from: manifest_select_ast_set_one_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_select_ast_set_one_positive_0eec107c7da5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_union", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
DROP TABLE IF EXISTS t_select_right CASCADE;
CREATE TABLE t_select_right (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_right (col_1, col_2, name) VALUES (1, 100, 'one'), (4, 400, 'four');
-- test_sql:
SELECT col_1 FROM t_select_source AS ast_src UNION SELECT col_1 FROM t_select_right AS ast_r;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_right CASCADE;
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_set_one_positive_fa40db8ed929
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_intersect", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
DROP TABLE IF EXISTS t_select_right CASCADE;
CREATE TABLE t_select_right (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_right (col_1, col_2, name) VALUES (1, 100, 'one'), (4, 400, 'four');
-- test_sql:
SELECT col_1 FROM t_select_source AS ast_src INTERSECT SELECT col_1 FROM t_select_right AS ast_r ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_right CASCADE;
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_set_one_positive_84ef4bce1882
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_union", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
DROP TABLE IF EXISTS t_select_right CASCADE;
CREATE TABLE t_select_right (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_right (col_1, col_2, name) VALUES (1, 100, 'one'), (4, 400, 'four');
-- test_sql:
SELECT col_1 FROM t_select_source AS ast_src UNION SELECT col_1 FROM t_select_right AS ast_r ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_right CASCADE;
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_set_one_positive_384d305700b7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_intersect", "source_form": "select_source_table", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
DROP TABLE IF EXISTS t_select_right CASCADE;
CREATE TABLE t_select_right (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_right (col_1, col_2, name) VALUES (1, 100, 'one'), (4, 400, 'four');
-- test_sql:
SELECT col_1 FROM t_select_source AS ast_src INTERSECT SELECT col_1 FROM t_select_right AS ast_r;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_right CASCADE;
DROP TABLE IF EXISTS t_select_source CASCADE;
