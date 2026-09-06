-- generated_from: manifest_create_materialized_view_positive
-- static_only: true
-- case_count: 6

-- case_id: manifest_create_materialized_view_positive_29e98bcdf425
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_materialized_view_columns_inherit", "data": "create_materialized_view_data_default", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_select"}
-- environment_requirements: [{"allowed_values": ["ASTORE_nonsegment"], "fact_refs": ["create_materialized_view_fact_no_ustore"], "key": "source_storage"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate AS SELECT col_1, col_2 FROM t_mv_source;
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_create_materialized_view_positive_b02be657f0a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_materialized_view_columns_two", "data": "create_materialized_view_data_data", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_values"}
-- environment_requirements: [{"allowed_values": ["ASTORE_nonsegment"], "fact_refs": ["create_materialized_view_fact_no_ustore"], "key": "source_storage"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate (a, b) AS VALUES (1, 2), (3, 4) WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_create_materialized_view_positive_1fef629e117e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_materialized_view_columns_inherit", "data": "create_materialized_view_data_data", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_table"}
-- environment_requirements: [{"allowed_values": ["ASTORE_nonsegment"], "fact_refs": ["create_materialized_view_fact_no_ustore"], "key": "source_storage"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate AS TABLE t_mv_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_create_materialized_view_positive_aa7b85918225
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_materialized_view_columns_two", "data": "create_materialized_view_data_default", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_table"}
-- environment_requirements: [{"allowed_values": ["ASTORE_nonsegment"], "fact_refs": ["create_materialized_view_fact_no_ustore"], "key": "source_storage"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate (a, b) AS TABLE t_mv_source;
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_create_materialized_view_positive_fc94f9cf69db
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_materialized_view_columns_inherit", "data": "create_materialized_view_data_default", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_values"}
-- environment_requirements: [{"allowed_values": ["ASTORE_nonsegment"], "fact_refs": ["create_materialized_view_fact_no_ustore"], "key": "source_storage"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate AS VALUES (1, 2), (3, 4);
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;

-- case_id: manifest_create_materialized_view_positive_958a8fc85b7b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_materialized_view_columns_two", "data": "create_materialized_view_data_data", "name": "create_materialized_view_name_candidate", "query": "create_materialized_view_query_select"}
-- environment_requirements: [{"allowed_values": ["ASTORE_nonsegment"], "fact_refs": ["create_materialized_view_fact_no_ustore"], "key": "source_storage"}]
-- fixture_setup:
CREATE TABLE t_mv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
BEGIN;
-- test_sql:
CREATE MATERIALIZED VIEW mv_candidate (a, b) AS SELECT col_1, col_2 FROM t_mv_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP MATERIALIZED VIEW IF EXISTS mv_candidate CASCADE;
DROP TABLE IF EXISTS t_mv_source CASCADE;
