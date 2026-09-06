-- generated_from: manifest_drop_view_missing_negative
-- static_only: true
-- case_count: 3

-- case_id: manifest_drop_view_missing_negative_029e8495258a
-- expected: error
-- expected_error_category: undefined_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_default", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_missing;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_missing_negative_a5debc8da0d3
-- expected: error
-- expected_error_category: undefined_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_restrict", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_missing RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_missing_negative_cabfbb03a04d
-- expected: error
-- expected_error_category: undefined_view
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_cascade", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_missing CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;
