-- generated_from: manifest_merge_constant_defaults
-- static_only: true
-- case_count: 3

-- case_id: manifest_merge_constant_defaults_36b6bafe64d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "merge_action_scalar_defaults", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_constant_defaults", "target_profile": "merge_target_constant_defaults"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_update_insert_and_source_select"], "fact_refs": ["merge_fact_permissions"], "key": "merge_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_merge_default_target (id INTEGER, name VARCHAR(64) DEFAULT 'fallback-name', category VARCHAR(64));
INSERT INTO g_merge_default_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
CREATE TABLE g_merge_default_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_default_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO g_merge_default_target AS dst USING g_merge_default_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = DEFAULT, category = 'matched' WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, DEFAULT, DEFAULT);
-- fixture_teardown:
DROP TABLE g_merge_default_source RESTRICT PURGE;
DROP TABLE g_merge_default_target RESTRICT PURGE;

-- case_id: manifest_merge_constant_defaults_da0c7a983f54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "merge_action_tuple_omitted_defaults", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_constant_defaults", "target_profile": "merge_target_constant_defaults"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_update_insert_and_source_select"], "fact_refs": ["merge_fact_permissions"], "key": "merge_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_merge_default_target (id INTEGER, name VARCHAR(64) DEFAULT 'fallback-name', category VARCHAR(64));
INSERT INTO g_merge_default_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
CREATE TABLE g_merge_default_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_default_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO g_merge_default_target AS dst USING g_merge_default_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET (name, category) = (DEFAULT, DEFAULT) WHEN NOT MATCHED THEN INSERT (id) VALUES (src.id);
-- fixture_teardown:
DROP TABLE g_merge_default_source RESTRICT PURGE;
DROP TABLE g_merge_default_target RESTRICT PURGE;

-- case_id: manifest_merge_constant_defaults_20f29561b19a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "merge_action_default_values", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_constant_defaults", "target_profile": "merge_target_constant_defaults"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_update_insert_and_source_select"], "fact_refs": ["merge_fact_permissions"], "key": "merge_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_merge_default_target (id INTEGER, name VARCHAR(64) DEFAULT 'fallback-name', category VARCHAR(64));
INSERT INTO g_merge_default_target (id, name, category) VALUES (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
CREATE TABLE g_merge_default_source (id INTEGER NOT NULL, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_default_source (id, name, category) VALUES (1, 'new-one', 'updated'), (2, 'new-two', 'inserted');
-- test_sql:
MERGE INTO g_merge_default_target AS dst USING g_merge_default_source AS src ON (dst.id = src.id) WHEN NOT MATCHED THEN INSERT DEFAULT VALUES;
-- fixture_teardown:
DROP TABLE g_merge_default_source RESTRICT PURGE;
DROP TABLE g_merge_default_target RESTRICT PURGE;
