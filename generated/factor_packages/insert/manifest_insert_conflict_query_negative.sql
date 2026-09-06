-- generated_from: manifest_insert_conflict_query_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_conflict_query_negative_d77629272b13
-- expected: error
-- expected_error_category: conflict_query_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_on_conflict_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_query", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- environment_requirements: [{"allowed_values": ["PG"], "fact_refs": ["insert_fact_conflict_environment"], "key": "compatibility_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
-- test_sql:
INSERT INTO t_insert_unique (id, note) SELECT col_1, name FROM t_insert_source ON CONFLICT (id) DO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_source CASCADE;
DROP TABLE IF EXISTS t_insert_unique CASCADE;
