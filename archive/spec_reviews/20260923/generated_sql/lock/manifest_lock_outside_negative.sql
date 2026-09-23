-- generated_from: manifest_lock_outside_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_lock_outside_negative_ec5072de6d48
-- expected: error
-- expected_error_category: lock_requires_transaction
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"mode": "lock_mode_default", "nowait": "lock_nowait_nowait", "table_keyword": "lock_table_keyword_present", "targets": "lock_targets_outside"}
-- fixture_setup:
DROP TABLE IF EXISTS t_lock_outside CASCADE;
CREATE TABLE t_lock_outside (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_lock_outside (col_1, col_2) VALUES (1, 2), (3, 4);
-- test_sql:
LOCK TABLE t_lock_outside NOWAIT;
-- fixture_teardown:
DROP TABLE IF EXISTS t_lock_outside CASCADE;
