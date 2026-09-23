-- generated_from: manifest_drop_index_ordinary
-- static_only: true
-- case_count: 9

-- case_id: manifest_drop_index_ordinary_49c325329cff
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_default", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX idx_di_one;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_ff7e45112c20
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_restrict", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_present", "targets": "drop_index_targets_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX IF EXISTS idx_di_one, idx_di_two RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_a848a334227f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_cascade", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX idx_di_missing CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_25c9fe365ba2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_default", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_present", "targets": "drop_index_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX IF EXISTS idx_di_missing;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_00ac3f0c5df9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_cascade", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_present", "targets": "drop_index_targets_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX IF EXISTS idx_di_one CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_93763f92012a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_default", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX idx_di_one, idx_di_two;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_5760347dd5c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_restrict", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX idx_di_one RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_567fd6a0a03e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_restrict", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX idx_di_missing RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_ordinary_2db349bb3716
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_cascade", "concurrently": "drop_index_concurrently_absent", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX idx_di_one, idx_di_two CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;
