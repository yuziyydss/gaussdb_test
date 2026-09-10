-- generated_from: manifest_insert_generated_query
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_generated_query_3a58fd0da5c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_finite_generated_query", "target_profile": "insert_target_finite_generated_query", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["create_any_table"], "fact_refs": ["create_table::ct_fact_create_permissions"], "key": "table_create_authority"}, {"allowed_values": ["target_write_and_referenced_select"], "fact_refs": ["insert_fact_permissions"], "key": "insert_authority"}, {"allowed_values": ["case_table_owner"], "fact_refs": ["drop_table::dt_fact_permissions"], "key": "fixture_cleanup_authority"}]
-- fixture_setup:
CREATE TABLE g_generated_src (x INT, y INT);
INSERT INTO g_generated_src (x, y) VALUES (2, 9), (3, 8);
CREATE TABLE g_generated_dst (id INT, qty INT, total INT GENERATED ALWAYS AS (id + qty) STORED);
-- test_sql:
INSERT INTO g_generated_dst SELECT x, y FROM g_generated_src WHERE x = 2;
-- fixture_teardown:
DROP TABLE g_generated_dst RESTRICT PURGE;
DROP TABLE g_generated_src RESTRICT PURGE;
