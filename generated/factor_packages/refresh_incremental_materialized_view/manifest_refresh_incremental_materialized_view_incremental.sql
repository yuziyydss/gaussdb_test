-- generated_from: manifest_refresh_incremental_materialized_view_incremental
-- static_only: true
-- case_count: 1

-- case_id: manifest_refresh_incremental_materialized_view_incremental_df98a6a048fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target": "refresh_incremental_materialized_view_target_incremental"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_ready AS SELECT col_1, col_2 FROM t_imv_source;
INSERT INTO t_imv_source VALUES (5, 6);
-- test_sql:
REFRESH INCREMENTAL MATERIALIZED VIEW mv_imv_ready;
-- fixture_teardown:
SELECT 1;
DROP MATERIALIZED VIEW IF EXISTS mv_imv_ready CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;
