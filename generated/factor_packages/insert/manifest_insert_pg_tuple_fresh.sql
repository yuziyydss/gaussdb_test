-- generated_from: manifest_insert_pg_tuple_fresh
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_pg_tuple_fresh_ba04bcc38983
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_tuple_pg_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_pg_tuple_conflict", "target_profile": "insert_target_pg_tuple_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_tuple (id INTEGER PRIMARY KEY, note VARCHAR(64), aux INTEGER);
INSERT INTO g_insert_pg_tuple (id, note, aux) VALUES (101, 'existing', 7);
-- test_sql:
INSERT INTO g_insert_pg_tuple (id, note, aux) VALUES (101, 'alpha', 9) ON CONFLICT (id) DO UPDATE SET (note, aux) = (EXCLUDED.note, EXCLUDED.aux);
-- fixture_teardown:
DROP TABLE g_insert_pg_tuple;

-- case_id: manifest_insert_pg_tuple_fresh_c6dd40194115
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_tuple_pg_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_pg_tuple_no_conflict", "target_profile": "insert_target_pg_tuple_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["fixture_creator_insert_select_update"], "fact_refs": ["insert_fact_permissions", "insert_fact_conflict_environment"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_pg_tuple (id INTEGER PRIMARY KEY, note VARCHAR(64), aux INTEGER);
INSERT INTO g_insert_pg_tuple (id, note, aux) VALUES (101, 'existing', 7);
-- test_sql:
INSERT INTO g_insert_pg_tuple (id, note, aux) VALUES (102, 'beta', 8) ON CONFLICT (id) DO UPDATE SET (note, aux) = (EXCLUDED.note, EXCLUDED.aux);
-- fixture_teardown:
DROP TABLE g_insert_pg_tuple;
