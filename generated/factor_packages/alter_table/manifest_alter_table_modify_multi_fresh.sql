-- generated_from: manifest_alter_table_modify_multi_fresh
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_table_modify_multi_fresh_bf765af5881a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "at_action_default", "add_column_items": "at_add_columns_two", "column_keyword": "at_column_keyword", "ddl_mode": "at_mode_default", "if_exists": "at_if_exists_none", "modify_column_items": "at_modify_columns_two", "rename_operator": "at_rename_to", "statement_form": "at_statement_modify_multi_fresh", "table_profile": "at_table_modify_multi_fresh", "target_form": "at_target_plain"}
-- environment_requirements: [{"allowed_values": ["fixture_table_creator"], "fact_refs": ["at_fact_permissions"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE t_at_modify_multi (id INTEGER,note VARCHAR(64),amount INTEGER);
INSERT INTO t_at_modify_multi VALUES (1,'alpha',10),(2,'beta',20);
-- test_sql:
ALTER TABLE t_at_modify_multi MODIFY (note VARCHAR(96), amount NOT NULL);
-- fixture_teardown:
DROP TABLE t_at_modify_multi;
