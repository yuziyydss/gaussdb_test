-- generated_from: manifest_insert_duplicate_with_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_duplicate_with_negative_151791241574
-- expected: error
-- expected_error_category: duplicate_with_not_supported
-- expected_sqlstates: -
-- expected_error_regex: (?i)(with|duplicate|not support|syntax)
-- params: {"conflict_clause": "insert_duplicate_update_note", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_source"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_source CASCADE;
CREATE TABLE t_insert_source (col_1 INTEGER NOT NULL, name VARCHAR(64));
INSERT INTO t_insert_source (col_1, name) VALUES (201, 'from_query_a'), (202, 'from_query_b');
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
WITH src_insert AS (SELECT col_1, name FROM t_insert_source) INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE note = VALUES(note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
DROP TABLE IF EXISTS t_insert_source CASCADE;
