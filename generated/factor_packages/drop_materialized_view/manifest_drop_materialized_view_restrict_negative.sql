-- generated_from: manifest_drop_materialized_view_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_materialized_view_restrict_negative_374fab82877f
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_materialized_view_behavior_default", "if_exists": "drop_materialized_view_if_exists_none", "targets": "drop_materialized_view_targets_dependent"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
CREATE MATERIALIZED VIEW mv_drop_dep AS SELECT col_1, col_2 FROM t_mv_source;
CREATE VIEW v_mv_dep AS SELECT col_1, col_2 FROM mv_drop_dep;
-- test_sql:
DROP MATERIALIZED VIEW mv_drop_dep;
-- fixture_teardown:
DROP VIEW IF EXISTS v_mv_dep CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_drop_dep CASCADE;
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_restrict_negative_80abea1ad5a3
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_materialized_view_behavior_restrict", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_dependent"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
CREATE MATERIALIZED VIEW mv_drop_dep AS SELECT col_1, col_2 FROM t_mv_source;
CREATE VIEW v_mv_dep AS SELECT col_1, col_2 FROM mv_drop_dep;
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_drop_dep RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_mv_dep CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_drop_dep CASCADE;
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_restrict_negative_77c8d9b091bc
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_materialized_view_behavior_restrict", "if_exists": "drop_materialized_view_if_exists_none", "targets": "drop_materialized_view_targets_dependent"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
CREATE MATERIALIZED VIEW mv_drop_dep AS SELECT col_1, col_2 FROM t_mv_source;
CREATE VIEW v_mv_dep AS SELECT col_1, col_2 FROM mv_drop_dep;
-- test_sql:
DROP MATERIALIZED VIEW mv_drop_dep RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_mv_dep CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_drop_dep CASCADE;
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_drop_materialized_view_restrict_negative_c450e7a302e4
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_materialized_view_behavior_default", "if_exists": "drop_materialized_view_if_exists_yes", "targets": "drop_materialized_view_targets_dependent"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
CREATE MATERIALIZED VIEW mv_drop_dep AS SELECT col_1, col_2 FROM t_mv_source;
CREATE VIEW v_mv_dep AS SELECT col_1, col_2 FROM mv_drop_dep;
-- test_sql:
DROP MATERIALIZED VIEW IF EXISTS mv_drop_dep;
-- fixture_teardown:
DROP VIEW IF EXISTS v_mv_dep CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_drop_dep CASCADE;
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
