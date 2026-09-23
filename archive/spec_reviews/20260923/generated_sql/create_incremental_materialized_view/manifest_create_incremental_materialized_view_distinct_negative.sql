-- generated_from: manifest_create_incremental_materialized_view_distinct_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_incremental_materialized_view_distinct_negative_772bfdf48966
-- expected: error
-- expected_error_category: unsupported_incremental_query
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "create_incremental_materialized_view_columns_none", "query": "create_incremental_materialized_view_query_distinct"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new AS SELECT DISTINCT col_1, col_2 FROM t_imv_source;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;
