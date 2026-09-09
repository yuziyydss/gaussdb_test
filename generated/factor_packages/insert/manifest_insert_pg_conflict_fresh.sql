-- generated_from: manifest_insert_pg_conflict_fresh
-- static_only: true
-- case_count: 4

-- case_id: manifest_insert_pg_conflict_fresh_9645c0bb1794
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_nothing_pg_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_pg_conflict_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_conflict (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'alpha') ON CONFLICT DO NOTHING;
-- fixture_teardown:
DROP TABLE g_insert_pg_conflict;

-- case_id: manifest_insert_pg_conflict_fresh_46fcba7fd554
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_update_pg_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_pg_conflict_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_conflict (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'alpha') ON CONFLICT (id) DO UPDATE SET note = EXCLUDED.note;
-- fixture_teardown:
DROP TABLE g_insert_pg_conflict;

-- case_id: manifest_insert_pg_conflict_fresh_45e4da25dc9b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_nothing_pg_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_pg_conflict_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_conflict (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO g_insert_pg_conflict (id, note) VALUES (102, 'beta'), (103, 'gamma') ON CONFLICT DO NOTHING;
-- fixture_teardown:
DROP TABLE g_insert_pg_conflict;

-- case_id: manifest_insert_pg_conflict_fresh_7601c4136f4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_update_pg_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_pg_conflict_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_conflict (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO g_insert_pg_conflict (id, note) VALUES (102, 'beta'), (103, 'gamma') ON CONFLICT (id) DO UPDATE SET note = EXCLUDED.note;
-- fixture_teardown:
DROP TABLE g_insert_pg_conflict;
