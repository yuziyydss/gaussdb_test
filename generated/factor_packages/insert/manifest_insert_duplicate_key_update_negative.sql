-- generated_from: manifest_insert_duplicate_key_update_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_duplicate_key_update_negative_5808ff8b21d7
-- expected: error
-- expected_error_category: duplicate_updates_unique_key
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_key_invalid", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE id = VALUES(id);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
