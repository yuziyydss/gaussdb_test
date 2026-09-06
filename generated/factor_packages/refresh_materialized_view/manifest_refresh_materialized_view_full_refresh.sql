-- generated_from: manifest_refresh_materialized_view_full_refresh
-- static_only: true
-- case_count: 2

-- case_id: manifest_refresh_materialized_view_full_refresh_26b6e256d999
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "refresh_materialized_view_name_full"}
-- environment_requirements: [{"allowed_values": ["granted"], "fact_refs": ["refresh_materialized_view_fact_select_privilege"], "key": "base_select_privilege"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
REFRESH MATERIALIZED VIEW mv_full;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_refresh_materialized_view_full_refresh_b253e5aba71b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "refresh_materialized_view_name_incremental"}
-- environment_requirements: [{"allowed_values": ["granted"], "fact_refs": ["refresh_materialized_view_fact_select_privilege"], "key": "base_select_privilege"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
CREATE MATERIALIZED VIEW mv_full AS SELECT col_1, col_2 FROM t_mv_source;
CREATE INCREMENTAL MATERIALIZED VIEW mv_incremental AS SELECT col_1, col_2 FROM t_mv_source;
INSERT INTO t_mv_source VALUES (1, 2), (3, 4);
-- test_sql:
REFRESH MATERIALIZED VIEW mv_incremental;
-- fixture_teardown:
DELETE FROM t_mv_source;
DROP MATERIALIZED VIEW IF EXISTS mv_incremental CASCADE;
DROP MATERIALIZED VIEW IF EXISTS mv_full CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
