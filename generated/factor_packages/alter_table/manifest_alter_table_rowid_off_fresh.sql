-- generated_from: manifest_alter_table_rowid_off_fresh
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_table_rowid_off_fresh_8e48b81f6399
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "at_action_set_rowid_fresh", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_rowid_off_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["at_fact_rowid"], "key": "compatibility_mode"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["at_fact_permissions"], "key": "case_namespace"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE g_a3_at_rowid (id INTEGER) WITH (hasrowid = off);
-- test_sql:
ALTER TABLE g_a3_at_rowid SET WITH ROWID;
-- fixture_teardown:
DROP TABLE g_a3_at_rowid RESTRICT;
