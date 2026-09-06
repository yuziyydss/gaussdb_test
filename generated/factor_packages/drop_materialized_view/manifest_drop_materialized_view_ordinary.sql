-- generated_from: manifest_drop_materialized_view_ordinary
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_materialized_view_ordinary_92064591739e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_default", "if_exists": "drop_materialized_view_if_exists_none", "targets": "drop_materialized_view_targets_full"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
DROP MATERIALIZED VIEW mv_full;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_ordinary_19ee9f804d3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_restrict", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_full"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_full RESTRICT;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_ordinary_220aa3877f08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_restrict", "if_exists": "drop_materialized_view_if_exists_none", "targets": "drop_materialized_view_targets_both"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
DROP MATERIALIZED VIEW mv_full, mv_incremental RESTRICT;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_ordinary_843c84ac1682
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_default", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_both"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_full, mv_incremental;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_ordinary_09bd86f5964d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_cascade", "if_exists": "drop_materialized_view_if_exists_none", "targets": "drop_materialized_view_targets_full"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
DROP MATERIALIZED VIEW mv_full CASCADE;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_ordinary_ee1900375489
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_materialized_view_behavior_cascade", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_both"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_full, mv_incremental CASCADE;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
