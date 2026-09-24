-- generated_from: manifest_drop_index_online_cascade_negative
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_index_online_cascade_negative_59b3da070040
-- expected: error
-- expected_error_category: online_drop_cascade
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_cascade", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_absent", "targets": "drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY idx_di_one CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;

-- case_id: manifest_drop_index_online_cascade_negative_d0da0ebdd362
-- expected: error
-- expected_error_category: online_drop_cascade
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_index_behavior_cascade", "concurrently": "drop_index_concurrently_present", "if_exists": "drop_index_if_exists_present", "targets": "drop_index_targets_one"}
-- environment_requirements: [{"allowed_values": ["autocommit"], "fact_refs": ["drop_index_fact_transaction"], "key": "transaction_mode"}]
-- fixture_setup:
DROP TABLE IF EXISTS t_ci_astore CASCADE;
CREATE TABLE t_ci_astore (id INTEGER NOT NULL, note VARCHAR(64), name VARCHAR(64), postcode CHAR(6));
INSERT INTO t_ci_astore (id, note, name, postcode) VALUES (1, 'one', 'Alpha', '100001'), (2, 'two', 'Beta', '100002');
CREATE INDEX idx_di_one ON t_ci_astore(id);
CREATE INDEX idx_di_two ON t_ci_astore(note);
DROP INDEX IF EXISTS idx_di_missing;
-- test_sql:
DROP INDEX CONCURRENTLY IF EXISTS idx_di_one CASCADE;
-- fixture_teardown:
DROP INDEX IF EXISTS idx_di_online;
DROP INDEX IF EXISTS idx_di_two;
DROP INDEX IF EXISTS idx_di_one;
DROP TABLE IF EXISTS t_ci_astore CASCADE;
