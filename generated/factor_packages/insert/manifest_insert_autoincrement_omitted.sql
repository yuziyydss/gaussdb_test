-- generated_from: manifest_insert_autoincrement_omitted
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_autoincrement_omitted_dcb9aec42dab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_autoincrement_omitted", "target_profile": "insert_target_autoincrement_omitted", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_table::ct_fact_auto_increment_mode"], "key": "compatibility_mode"}, {"allowed_values": ["fresh_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}, {"allowed_values": ["fixture_table_creator"], "fact_refs": ["insert_fact_permissions"], "key": "table_authority"}]
-- fixture_setup:
CREATE TABLE g_b_insert_autoinc (id INTEGER PRIMARY KEY AUTO_INCREMENT, note INTEGER) AUTO_INCREMENT = 1;
-- test_sql:
INSERT INTO g_b_insert_autoinc (note) VALUES (1);
-- fixture_teardown:
DROP TABLE g_b_insert_autoinc RESTRICT;
