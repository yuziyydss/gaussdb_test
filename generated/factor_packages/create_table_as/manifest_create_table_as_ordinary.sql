-- generated_from: manifest_create_table_as_ordinary
-- static_only: true
-- case_count: 13

-- case_id: manifest_create_table_as_ordinary_319ba91a9ce1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_42b6be9feaba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_unlogged", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_values", "storage": "create_table_as_storage_row"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE UNLOGGED TABLE IF NOT EXISTS t_ctas_candidate (a, b) WITH (ORIENTATION=ROW) AS VALUES (1, 2), (3, 4) WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_8e64f0e6f172
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_values", "storage": "create_table_as_storage_low"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE IF NOT EXISTS t_ctas_candidate WITH (fillfactor=10) AS VALUES (1, 2), (3, 4) WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_505ecaf17daf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_unlogged", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_high"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE UNLOGGED TABLE t_ctas_candidate (a, b) WITH (fillfactor=100) AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_f5c25c2c29b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_row"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate WITH (ORIENTATION=ROW) AS SELECT col_1, col_2 FROM t_ctas_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_5ac978be31ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_values", "storage": "create_table_as_storage_high"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE IF NOT EXISTS t_ctas_candidate (a, b) WITH (fillfactor=100) AS VALUES (1, 2), (3, 4);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_7834295c7472
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_unlogged", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_low"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE UNLOGGED TABLE t_ctas_candidate WITH (fillfactor=10) AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_a7827beaee36
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_unlogged", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE UNLOGGED TABLE t_ctas_candidate (a, b) AS VALUES (1, 2), (3, 4) WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_1c2b898996b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_high"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE IF NOT EXISTS t_ctas_candidate WITH (fillfactor=100) AS SELECT col_1, col_2 FROM t_ctas_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_32fc0d48f4f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE IF NOT EXISTS t_ctas_candidate AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_b0a09cfd0b1c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_low"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate (a, b) WITH (fillfactor=10) AS SELECT col_1, col_2 FROM t_ctas_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_c40d593009f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_row"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate WITH (ORIENTATION=ROW) AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_ordinary_490988d3e0ae
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_regular", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_row"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TABLE t_ctas_candidate WITH (ORIENTATION=ROW) AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;
