-- generated_from: manifest_select_common_type_pg
-- static_only: true
-- case_count: 7

-- case_id: manifest_select_common_type_pg_c12ba269788b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_case_integer", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT CASE WHEN flag THEN id ELSE qty END AS result FROM g_common_source;
-- fixture_teardown:
DROP TABLE g_common_source;

-- case_id: manifest_select_common_type_pg_d74af00364ef
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_case_null", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT CASE WHEN TRUE THEN id ELSE NULL END AS result FROM g_common_source;
-- fixture_teardown:
DROP TABLE g_common_source;

-- case_id: manifest_select_common_type_pg_44d8f1f3e88d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_union_integer", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT id FROM g_common_source UNION SELECT qty FROM g_common_source;
-- fixture_teardown:
DROP TABLE g_common_source;

-- case_id: manifest_select_common_type_pg_0094a5493475
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_union_null", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT id FROM g_common_source UNION ALL SELECT NULL;
-- fixture_teardown:
DROP TABLE g_common_source;

-- case_id: manifest_select_common_type_pg_16768fc535b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_union_unknown", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT NULL UNION SELECT NULL;
-- fixture_teardown:
DROP TABLE g_common_source;

-- case_id: manifest_select_common_type_pg_6162a09845fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_union_text", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT 'a' UNION SELECT 'b';
-- fixture_teardown:
DROP TABLE g_common_source;

-- case_id: manifest_select_common_type_pg_d9f5fcee13bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"group_by_list": "select_group_none", "inner_target_list": "select_inner_target_col1", "limit_clause": "select_limit_none", "lock_clause": "select_lock_none", "order_by_list": "select_order_none", "query_profile": "select_common_union_columns", "right_target_list": "select_right_target_col1", "select_modifier": "select_modifier_default", "set_operator": "select_set_none", "source_form": "select_source_table", "statement_form": "select_statement_legacy_profile", "table_target": "select_table_source", "target_list": "select_target_col1", "where_clause": "select_where_none", "with_clause": "select_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["create_database::create_database_fact_compatibility_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);
INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);
-- test_sql:
SELECT id, note FROM g_common_source UNION SELECT qty, NULL FROM g_common_source;
-- fixture_teardown:
DROP TABLE g_common_source;
