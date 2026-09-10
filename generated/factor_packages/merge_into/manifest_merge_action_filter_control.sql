-- generated_from: manifest_merge_action_filter_control
-- static_only: true
-- case_count: 2

-- case_id: manifest_merge_action_filter_control_67bd058a2236
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "merge_action_name_only_both", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_on_filter", "target_profile": "merge_target_on_filter"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_update_insert_and_source_select"], "fact_refs": ["merge_fact_permissions"], "key": "merge_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_merge_on_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_on_target (id, name, category) VALUES (-1, 'old-negative', 'old'), (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
CREATE TABLE g_merge_on_source (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_on_source (id, name, category) VALUES (-1, 'new-negative', 'incoming'), (1, 'new-one', 'incoming'), (2, 'new-two', 'incoming');
INSERT INTO g_merge_on_source (id, name, category) VALUES (-2, 'new-unmatched', 'incoming');
-- test_sql:
MERGE INTO g_merge_on_target AS dst USING g_merge_on_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category);
-- fixture_teardown:
DELETE FROM g_merge_on_source WHERE id = -2 AND name = 'new-unmatched' AND category = 'incoming';
DROP TABLE g_merge_on_source RESTRICT PURGE;
DROP TABLE g_merge_on_target RESTRICT PURGE;

-- case_id: manifest_merge_action_filter_control_9b29d52b2188
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_profile": "merge_action_with_where", "on_condition": "merge_on_id_equal", "plan_hint": "merge_hint_none", "source_profile": "merge_source_on_filter", "target_profile": "merge_target_on_filter"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_update_insert_and_source_select"], "fact_refs": ["merge_fact_permissions"], "key": "merge_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_merge_on_target (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_on_target (id, name, category) VALUES (-1, 'old-negative', 'old'), (1, 'old-one', 'old'), (3, 'keep-three', 'keep');
CREATE TABLE g_merge_on_source (id INTEGER, name VARCHAR(64), category VARCHAR(64));
INSERT INTO g_merge_on_source (id, name, category) VALUES (-1, 'new-negative', 'incoming'), (1, 'new-one', 'incoming'), (2, 'new-two', 'incoming');
INSERT INTO g_merge_on_source (id, name, category) VALUES (-2, 'new-unmatched', 'incoming');
-- test_sql:
MERGE INTO g_merge_on_target AS dst USING g_merge_on_source AS src ON (dst.id = src.id) WHEN MATCHED THEN UPDATE SET name = src.name WHERE src.id > 0 WHEN NOT MATCHED THEN INSERT (id, name, category) VALUES (src.id, src.name, src.category) WHERE src.id > 0;
-- fixture_teardown:
DELETE FROM g_merge_on_source WHERE id = -2 AND name = 'new-unmatched' AND category = 'incoming';
DROP TABLE g_merge_on_source RESTRICT PURGE;
DROP TABLE g_merge_on_target RESTRICT PURGE;
