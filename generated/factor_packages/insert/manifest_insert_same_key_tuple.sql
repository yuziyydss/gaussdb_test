-- generated_from: manifest_insert_same_key_tuple
-- static_only: true
-- case_count: 3

-- case_id: manifest_insert_same_key_tuple_45bebb6b8a7a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_same_key_tuple", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_same_key_conflict", "target_profile": "insert_target_same_key_tuple", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_key (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_key (id, note) VALUES (101, 'existing'), (-1, 'blocked');
-- test_sql:
INSERT INTO g_insert_pg_key (id, note) VALUES (101, 'alpha') ON CONFLICT (id) DO UPDATE SET (id, note) = (EXCLUDED.id, EXCLUDED.note) WHERE g_insert_pg_key.id > 0;
-- fixture_teardown:
DROP TABLE g_insert_pg_key;

-- case_id: manifest_insert_same_key_tuple_4333ccd0ceaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_same_key_tuple", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_same_key_new", "target_profile": "insert_target_same_key_tuple", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_key (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_key (id, note) VALUES (101, 'existing'), (-1, 'blocked');
-- test_sql:
INSERT INTO g_insert_pg_key (id, note) VALUES (102, 'beta') ON CONFLICT (id) DO UPDATE SET (id, note) = (EXCLUDED.id, EXCLUDED.note) WHERE g_insert_pg_key.id > 0;
-- fixture_teardown:
DROP TABLE g_insert_pg_key;

-- case_id: manifest_insert_same_key_tuple_fe882d57a46f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_same_key_tuple", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_same_key_filtered", "target_profile": "insert_target_same_key_tuple", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_key (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO g_insert_pg_key (id, note) VALUES (101, 'existing'), (-1, 'blocked');
-- test_sql:
INSERT INTO g_insert_pg_key (id, note) VALUES (-1, 'ignored') ON CONFLICT (id) DO UPDATE SET (id, note) = (EXCLUDED.id, EXCLUDED.note) WHERE g_insert_pg_key.id > 0;
-- fixture_teardown:
DROP TABLE g_insert_pg_key;
