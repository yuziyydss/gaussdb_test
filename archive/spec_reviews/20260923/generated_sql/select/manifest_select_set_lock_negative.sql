-- generated_from: manifest_select_set_lock_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_select_set_lock_negative_b40ae8701a91
-- expected: error
-- expected_error_category: set_operation_lock_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_invalid_union_lock", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_source CASCADE;
CREATE TABLE t_select_source (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_source (col_1, col_2, name) VALUES (1, 10, 'alpha'), (2, 20, 'Beta'), (3, NULL, 'gamma');
DROP TABLE IF EXISTS t_select_right CASCADE;
CREATE TABLE t_select_right (col_1 INTEGER NOT NULL, col_2 INTEGER, name VARCHAR(64));
INSERT INTO t_select_right (col_1, col_2, name) VALUES (1, 100, 'one'), (4, 400, 'four');
-- test_sql:
SELECT col_1 FROM t_select_source UNION SELECT col_1 FROM t_select_right FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_right CASCADE;
DROP TABLE IF EXISTS t_select_source CASCADE;
