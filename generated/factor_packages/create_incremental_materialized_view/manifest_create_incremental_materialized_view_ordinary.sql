-- generated_from: manifest_create_incremental_materialized_view_ordinary
-- static_only: true
-- case_count: 8

-- case_id: manifest_create_incremental_materialized_view_ordinary_e969947624c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_none", "query": "create_incremental_materialized_view_query_select"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new AS SELECT col_1, col_2 FROM t_imv_source;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_58645fd3567c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_none", "query": "create_incremental_materialized_view_query_filter"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new AS SELECT col_1, col_2 FROM t_imv_source WHERE col_1 > 0;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_9a3f354f3c89
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_none", "query": "create_incremental_materialized_view_query_union"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new AS SELECT col_1, col_2 FROM t_imv_source UNION ALL SELECT col_1, col_2 FROM t_imv_right;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_3b6db197cc46
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_none", "query": "create_incremental_materialized_view_query_table"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new AS TABLE t_imv_source;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_217ad53cd450
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_two", "query": "create_incremental_materialized_view_query_select"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new (c1, c2) AS SELECT col_1, col_2 FROM t_imv_source;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_ad887d767955
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_two", "query": "create_incremental_materialized_view_query_filter"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new (c1, c2) AS SELECT col_1, col_2 FROM t_imv_source WHERE col_1 > 0;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_7c5b1957aef9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_two", "query": "create_incremental_materialized_view_query_union"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new (c1, c2) AS SELECT col_1, col_2 FROM t_imv_source UNION ALL SELECT col_1, col_2 FROM t_imv_right;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;

-- case_id: manifest_create_incremental_materialized_view_ordinary_2fcee545d60d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_incremental_materialized_view_columns_two", "query": "create_incremental_materialized_view_query_table"}
-- fixture_setup:
CREATE TABLE t_imv_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_source VALUES (1, 2), (3, 4);
CREATE TABLE t_imv_right (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_imv_right VALUES (1, 2), (3, 4);
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
-- test_sql:
CREATE INCREMENTAL MATERIALIZED VIEW mv_imv_new (c1, c2) AS TABLE t_imv_source;
-- fixture_teardown:
DROP MATERIALIZED VIEW IF EXISTS mv_imv_new CASCADE;
DROP TABLE IF EXISTS t_imv_right CASCADE;
DROP TABLE IF EXISTS t_imv_source CASCADE;
