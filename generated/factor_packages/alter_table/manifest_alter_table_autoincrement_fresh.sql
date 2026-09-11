-- generated_from: manifest_alter_table_autoincrement_fresh
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_table_autoincrement_fresh_b0d5f074101b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "at_action_autoincrement_ten_fresh", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_autoincrement_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table::ct_fact_auto_increment_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["at_fact_permissions"], "key": "case_namespace"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE g_b_at_autoinc (id INTEGER PRIMARY KEY AUTO_INCREMENT, note INTEGER) AUTO_INCREMENT = 1;
-- test_sql:
ALTER TABLE g_b_at_autoinc AUTO_INCREMENT = 10;
-- fixture_teardown:
DROP TABLE g_b_at_autoinc RESTRICT;

-- case_id: manifest_alter_table_autoincrement_fresh_c9845158617c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "at_action_autoincrement_zero_fresh", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_autoincrement_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table::ct_fact_auto_increment_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["at_fact_permissions"], "key": "case_namespace"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE g_b_at_autoinc (id INTEGER PRIMARY KEY AUTO_INCREMENT, note INTEGER) AUTO_INCREMENT = 1;
-- test_sql:
ALTER TABLE g_b_at_autoinc AUTO_INCREMENT = 0;
-- fixture_teardown:
DROP TABLE g_b_at_autoinc RESTRICT;
