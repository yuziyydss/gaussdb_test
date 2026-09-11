-- generated_from: manifest_select_common_type_a_integer
-- static_only: true
-- case_count: 4

-- case_id: manifest_select_common_type_a_integer_78ccc92d0843
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_a_union_small_int", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database::create_database_fact_compatibility_environment", "select_fact_a_integer_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
-- test_sql:
SELECT lo FROM a_common_source UNION SELECT mid FROM a_common_source;
-- fixture_teardown:
DROP TABLE a_common_source;

-- case_id: manifest_select_common_type_a_integer_3906d6c8b463
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_a_union_int_small", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database::create_database_fact_compatibility_environment", "select_fact_a_integer_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
-- test_sql:
SELECT mid FROM a_common_source UNION SELECT lo FROM a_common_source;
-- fixture_teardown:
DROP TABLE a_common_source;

-- case_id: manifest_select_common_type_a_integer_ab352f9ba5b6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_a_case_small_big", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database::create_database_fact_compatibility_environment", "select_fact_a_integer_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
-- test_sql:
SELECT CASE WHEN TRUE THEN lo ELSE hi END AS result FROM a_common_source;
-- fixture_teardown:
DROP TABLE a_common_source;

-- case_id: manifest_select_common_type_a_integer_47362f74d3c0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_a_case_big_small", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["create_database::create_database_fact_compatibility_environment", "select_fact_a_integer_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);
INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);
-- test_sql:
SELECT CASE WHEN TRUE THEN hi ELSE lo END AS result FROM a_common_source;
-- fixture_teardown:
DROP TABLE a_common_source;
