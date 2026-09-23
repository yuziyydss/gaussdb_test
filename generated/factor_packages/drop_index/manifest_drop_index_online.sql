-- generated_from: manifest_drop_index_online
-- static_only: true
-- case_count: 5

-- case_id: manifest_drop_index_online_b4072f6bec70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_default", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY idx_di_one;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_online_775507e9a201
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_restrict", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_present", "targets": "drop_index_targets_missing"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY IF EXISTS idx_di_missing RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_online_0b2532caa2af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_default", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_missing"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY idx_di_missing;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_online_29d3d638ac6a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_restrict", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY idx_di_one RESTRICT;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_online_e1482dbcbbf0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_default", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_present", "targets": "drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY IF EXISTS idx_di_one;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;
