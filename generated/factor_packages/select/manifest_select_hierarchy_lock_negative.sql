-- generated_from: manifest_select_hierarchy_lock_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_select_hierarchy_lock_negative_62612e4b43e4
-- expected: error
-- expected_error_category: hierarchy_lock_not_supported
-- expected_sqlstates: -
-- expected_error_regex: (?i)(start with|connect by|for update|lock)
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_invalid_hierarchy_lock", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_select_hierarchy CASCADE;
CREATE TABLE t_select_hierarchy (name VARCHAR(64) NOT NULL, id INTEGER NOT NULL, parent_id INTEGER);
INSERT INTO t_select_hierarchy (name, id, parent_id) VALUES ('root', 1, 0), ('child_a', 2, 1), ('child_b', 3, 1);
-- test_sql:
SELECT name, id FROM t_select_hierarchy START WITH id = 1 CONNECT BY PRIOR id = parent_id FOR UPDATE;
-- fixture_teardown:
DROP TABLE IF EXISTS t_select_hierarchy CASCADE;
