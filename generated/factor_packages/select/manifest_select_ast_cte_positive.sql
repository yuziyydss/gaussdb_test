-- generated_from: manifest_select_ast_cte_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_select_ast_cte_positive_3a9a2bb7cea3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_cte", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_simple"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
WITH cte_ast AS (SELECT col_1, col_2 FROM t_select_source) SELECT col_1 FROM cte_ast;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_cte_positive_a217d373afff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_cte", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_recursive"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
WITH RECURSIVE cte_ast(col_1, col_2) AS (VALUES (1, 10) UNION ALL SELECT col_1 + 1, col_2 + 10 FROM cte_ast WHERE col_1 < 3) SELECT col_1, col_2 FROM cte_ast WHERE col_1 >= 0 ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_cte_positive_bd1367b677ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_cte", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_simple"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
WITH cte_ast AS (SELECT col_1, col_2 FROM t_select_source) SELECT col_1 FROM cte_ast WHERE col_1 >= 0 ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_cte_positive_c6bf0e224b4e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_cte", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_none", "with_clause": "select_with_recursive"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
WITH RECURSIVE cte_ast(col_1, col_2) AS (VALUES (1, 10) UNION ALL SELECT col_1 + 1, col_2 + 10 FROM cte_ast WHERE col_1 < 3) SELECT col_1, col_2 FROM cte_ast;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_cte_positive_fac19278b41d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_col1", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_cte", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1_col2", "where_clause": "select_where_none", "with_clause": "select_with_simple"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
WITH cte_ast AS (SELECT col_1, col_2 FROM t_select_source) SELECT col_1, col_2 FROM cte_ast ORDER BY col_1 ASC;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;

-- case_id: manifest_select_ast_cte_positive_e794eddd82c5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_cte", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_col1_nonnegative", "with_clause": "select_with_recursive"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
-- test_sql:
WITH RECURSIVE cte_ast(col_1, col_2) AS (VALUES (1, 10) UNION ALL SELECT col_1 + 1, col_2 + 10 FROM cte_ast WHERE col_1 < 3) SELECT col_1 FROM cte_ast WHERE col_1 >= 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_source CASCADE;
