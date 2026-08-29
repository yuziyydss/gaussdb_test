-- generated_from: manifest_insert_duplicate_positive
-- static_only: true
-- case_count: 5

-- case_id: manifest_insert_duplicate_positive_429333d01f19
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_duplicate_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_0b106ed245ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_duplicate_update_note", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_columns", "source_profile": "insert_source_values_two", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (102, 'beta'), (103, 'gamma') ON DUPLICATE KEY UPDATE note = VALUES(note) RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_b793c88618e7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_duplicate_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_columns", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE NOTHING RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_88fb844936e8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_duplicate_update_note", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE note = VALUES(note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_90d4aaea34ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- params: {"conflict_clause": "insert_duplicate_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_two", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (102, 'beta'), (103, 'gamma') ON DUPLICATE KEY UPDATE NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
