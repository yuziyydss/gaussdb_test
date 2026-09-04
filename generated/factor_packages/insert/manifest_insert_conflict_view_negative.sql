-- generated_from: manifest_insert_conflict_view_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_conflict_view_negative_5e1acb6da8b9
-- expected: error
-- expected_error_category: conflict_target_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_on_conflict_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO v_insert_target (id, note) VALUES (101, 'alpha') ON CONFLICT (id) DO NOTHING;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_conflict_view_negative_9676a03aa14d
-- expected: error
-- expected_error_category: conflict_target_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_on_conflict_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT INTO (SELECT id, note FROM t_insert_view_base) (id, note) VALUES (101, 'alpha') ON CONFLICT (id) DO NOTHING;
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
