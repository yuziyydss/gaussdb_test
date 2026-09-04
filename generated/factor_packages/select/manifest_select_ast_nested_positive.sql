-- generated_from: manifest_select_ast_nested_positive
-- static_only: true
-- case_count: 4

-- case_id: manifest_select_ast_nested_positive_f3358cfb1cdb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM (SELECT col_1 FROM t_select_source AS ast_inner) AS ast_s;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_nested_positive_0867820219c2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM (SELECT col_1 FROM t_select_source AS ast_inner) AS ast_s WHERE col_1 >= 0 ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_nested_positive_455132499e09
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM (SELECT col_1 FROM t_select_source AS ast_inner) AS ast_s ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_nested_positive_8c6622bdbb42
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_subquery", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
SELECT col_1 FROM (SELECT col_1 FROM t_select_source AS ast_inner) AS ast_s WHERE col_1 >= 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;
