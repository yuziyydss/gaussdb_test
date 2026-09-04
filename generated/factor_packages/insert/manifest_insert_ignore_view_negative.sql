-- generated_from: manifest_insert_ignore_view_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_ignore_view_negative_65161caef160
-- expected: error
-- expected_error_category: ignore_target_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_keyword", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_view", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT IGNORE INTO v_insert_target (id, note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;

-- case_id: manifest_insert_ignore_view_negative_008f8d5cfb98
-- expected: error
-- expected_error_category: ignore_target_not_supported
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_conflict_none", "ignore_modifier": "insert_ignore_keyword", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_subquery", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
CREATE TABLE t_insert_view_base (id INTEGER, note VARCHAR(64));
DROP VIEW IF EXISTS v_insert_target CASCADE;
CREATE VIEW v_insert_target AS SELECT id, note FROM t_insert_view_base;
-- test_sql:
INSERT IGNORE INTO (SELECT id, note FROM t_insert_view_base) (id, note) VALUES (101, 'alpha');
-- fixture_teardown:
DROP VIEW IF EXISTS v_insert_target CASCADE;
DROP TABLE IF EXISTS t_insert_view_base CASCADE;
