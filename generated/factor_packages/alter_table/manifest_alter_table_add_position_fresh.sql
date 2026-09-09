-- generated_from: manifest_alter_table_add_position_fresh
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_table_add_position_fresh_8f6b2b875305
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "at_action_add_first_fresh", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_add_position_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["at_fact_column_position"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_creation_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "namespace"}]
-- fixture_setup:
CREATE TABLE t_at_add_position (id INTEGER,code VARCHAR(32),note VARCHAR(64));
INSERT INTO t_at_add_position VALUES (1,'alpha','one'),(2,'beta','two');
-- test_sql:
ALTER TABLE t_at_add_position ADD COLUMN extra INTEGER FIRST;
-- fixture_teardown:
DROP TABLE t_at_add_position;

-- case_id: manifest_alter_table_add_position_fresh_60f49c3399da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "at_action_add_after_fresh", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_action", "table_profile": "at_table_add_position_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["at_fact_column_position"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}, {"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_creation_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "namespace"}]
-- fixture_setup:
CREATE TABLE t_at_add_position (id INTEGER,code VARCHAR(32),note VARCHAR(64));
INSERT INTO t_at_add_position VALUES (1,'alpha','one'),(2,'beta','two');
-- test_sql:
ALTER TABLE t_at_add_position ADD COLUMN extra INTEGER AFTER code;
-- fixture_teardown:
DROP TABLE t_at_add_position;
