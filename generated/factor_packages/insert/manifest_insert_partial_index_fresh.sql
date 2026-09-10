-- generated_from: manifest_insert_partial_index_fresh
-- static_only: true
-- case_count: 3

-- case_id: manifest_insert_partial_index_fresh_cae2c79599e4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_partial_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partial_conflict", "target_profile": "insert_target_partial_index_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["builtin_integer_plus_and_gt"], "fact_refs": ["create_index::ci_fact_immutable_environment"], "key": "operator_binding"}, {"allowed_values": ["fixture_creator_insert_select_index"], "fact_refs": ["insert_fact_permissions", "create_index::ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_partial (id INTEGER NOT NULL, flag INTEGER NOT NULL) WITH (storage_type=ASTORE);
CREATE UNIQUE INDEX g_insert_partial_idx ON g_insert_partial USING btree ((id + 1)) WHERE flag > 0;
INSERT INTO g_insert_partial (id, flag) VALUES (1, 1), (1, 0);
-- test_sql:
INSERT INTO g_insert_partial (id, flag) VALUES (1, 2) ON CONFLICT ((id + 1)) WHERE flag > 0 DO NOTHING;
-- fixture_teardown:
DROP TABLE g_insert_partial RESTRICT;

-- case_id: manifest_insert_partial_index_fresh_abdfb172a84e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_partial_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partial_new_key", "target_profile": "insert_target_partial_index_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["builtin_integer_plus_and_gt"], "fact_refs": ["create_index::ci_fact_immutable_environment"], "key": "operator_binding"}, {"allowed_values": ["fixture_creator_insert_select_index"], "fact_refs": ["insert_fact_permissions", "create_index::ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_partial (id INTEGER NOT NULL, flag INTEGER NOT NULL) WITH (storage_type=ASTORE);
CREATE UNIQUE INDEX g_insert_partial_idx ON g_insert_partial USING btree ((id + 1)) WHERE flag > 0;
INSERT INTO g_insert_partial (id, flag) VALUES (1, 1), (1, 0);
-- test_sql:
INSERT INTO g_insert_partial (id, flag) VALUES (2, 1) ON CONFLICT ((id + 1)) WHERE flag > 0 DO NOTHING;
-- fixture_teardown:
DROP TABLE g_insert_partial RESTRICT;

-- case_id: manifest_insert_partial_index_fresh_45bacb16d2d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_on_conflict_partial_fresh", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_partial_outside", "target_profile": "insert_target_partial_index_fresh", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}, {"allowed_values": ["builtin_integer_plus_and_gt"], "fact_refs": ["create_index::ci_fact_immutable_environment"], "key": "operator_binding"}, {"allowed_values": ["fixture_creator_insert_select_index"], "fact_refs": ["insert_fact_permissions", "create_index::ci_fact_permissions"], "key": "actor_authority"}, {"allowed_values": ["isolated_user_schema"], "fact_refs": ["insert_fact_permissions"], "key": "case_namespace"}]
-- fixture_setup:
CREATE TABLE g_insert_partial (id INTEGER NOT NULL, flag INTEGER NOT NULL) WITH (storage_type=ASTORE);
CREATE UNIQUE INDEX g_insert_partial_idx ON g_insert_partial USING btree ((id + 1)) WHERE flag > 0;
INSERT INTO g_insert_partial (id, flag) VALUES (1, 1), (1, 0);
-- test_sql:
INSERT INTO g_insert_partial (id, flag) VALUES (1, 0) ON CONFLICT ((id + 1)) WHERE flag > 0 DO NOTHING;
-- fixture_teardown:
DROP TABLE g_insert_partial RESTRICT;
