-- generated_from: manifest_insert_duplicate_positive
-- static_only: true
-- case_count: 8

-- case_id: manifest_insert_duplicate_positive_429333d01f19
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_69572b1add6e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_values", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_many", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (102, 'beta'), (103, 'gamma') ON DUPLICATE KEY UPDATE note = VALUES(note) RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_0cfac2cbe4a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_excluded", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE note = EXCLUDED.note RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_1a29a29b35d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_multiple_where", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (102, 'beta'), (103, 'gamma') ON DUPLICATE KEY UPDATE note = VALUES(note), aux = DEFAULT WHERE id > 0;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_2c48f0a823f6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_values", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE note = VALUES(note);
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_ddabfe76a133
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_multiple_where", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_one", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') ON DUPLICATE KEY UPDATE note = VALUES(note), aux = DEFAULT WHERE id > 0 RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_0a82c7f8f324
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_nothing", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_expression", "source_profile": "insert_source_values_many", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (102, 'beta'), (103, 'gamma') ON DUPLICATE KEY UPDATE NOTHING RETURNING id, note AS inserted_note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;

-- case_id: manifest_insert_duplicate_positive_9fcb509f5b54
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"conflict_clause": "insert_duplicate_update_excluded", "ignore_modifier": "insert_ignore_none", "plan_hint": "insert_hint_none", "returning_clause": "insert_returning_none", "source_profile": "insert_source_values_many", "target_profile": "insert_target_unique_columns", "with_clause": "insert_with_none"}
-- fixture_setup:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
CREATE TABLE t_insert_unique (id INTEGER PRIMARY KEY, note VARCHAR(64), aux VARCHAR(64));
INSERT INTO t_insert_unique (id, note) VALUES (101, 'existing');
-- test_sql:
INSERT INTO t_insert_unique (id, note) VALUES (102, 'beta'), (103, 'gamma') ON DUPLICATE KEY UPDATE note = EXCLUDED.note;
-- fixture_teardown:
DROP TABLE IF EXISTS t_insert_unique CASCADE;
