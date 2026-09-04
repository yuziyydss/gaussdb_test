-- generated_from: manifest_select_ast_no_from_positive
-- static_only: true
-- case_count: 2

-- case_id: manifest_select_ast_no_from_positive_c60535cef55c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_none", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_constant", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- test_sql:
SELECT 42 AS answer;

-- case_id: manifest_select_ast_no_from_positive_a36a12ffad99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_five", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_basic_star", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_none", "statement_form": "select_statement_ast", "table_target": "select_table_source", "target_list": "select_target_constant", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- test_sql:
SELECT 42 AS answer LIMIT 5;
