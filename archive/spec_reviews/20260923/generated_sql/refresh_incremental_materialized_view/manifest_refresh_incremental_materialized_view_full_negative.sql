-- generated_from: manifest_refresh_incremental_materialized_view_full_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_refresh_incremental_materialized_view_full_negative_360553310856
-- expected: error
-- expected_error_category: wrong_materialized_view_kind
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"target": "refresh_incremental_materialized_view_target_full"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
-- test_sql:
REFRESH INCREMENTAL MATERIALIZED VIEW mv_full;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
