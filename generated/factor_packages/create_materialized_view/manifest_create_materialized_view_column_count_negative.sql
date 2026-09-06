-- generated_from: manifest_create_materialized_view_column_count_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_materialized_view_column_count_negative_f36d113d9a96
-- expected: error
-- expected_error_category: projection_column_count_mismatch
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"columns": "create_materialized_view_columns_one", "data": "create_materialized_view_data_default", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_select"}
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate (a) AS SELECT col_1, col_2 FROM t_mv_source;
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
