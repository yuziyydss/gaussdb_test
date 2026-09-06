-- generated_from: manifest_create_table_as_temporary
-- static_only: true
-- case_count: 18

-- case_id: manifest_create_table_as_temporary_e3028e2a9f12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp0", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TEMP TABLE t_ctas_candidate AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_39fbc0cda060
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_temp1", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_preserve", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TEMPORARY TABLE IF NOT EXISTS t_ctas_candidate (a, b) ON COMMIT PRESERVE ROWS AS VALUES (1, 2), (3, 4) WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_fdb78655dca6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp2", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_delete", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE LOCAL TEMP TABLE t_ctas_candidate ON COMMIT DELETE ROWS AS VALUES (1, 2), (3, 4) WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_2d34eadd128c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_temp3", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_delete", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE LOCAL TEMPORARY TABLE IF NOT EXISTS t_ctas_candidate (a, b) ON COMMIT DELETE ROWS AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_c390277984e1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp4", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_preserve", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE GLOBAL TEMP TABLE t_ctas_candidate ON COMMIT PRESERVE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_8e1878f06cc1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_temp5", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE GLOBAL TEMPORARY TABLE IF NOT EXISTS t_ctas_candidate (a, b) AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_9e593e5732cf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp3", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE LOCAL TEMPORARY TABLE t_ctas_candidate AS VALUES (1, 2), (3, 4) WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_7ec6f924e954
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp5", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_preserve", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE GLOBAL TEMPORARY TABLE t_ctas_candidate ON COMMIT PRESERVE ROWS AS VALUES (1, 2), (3, 4);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_fdaa7342835a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_temp0", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_delete", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TEMP TABLE IF NOT EXISTS t_ctas_candidate ON COMMIT DELETE ROWS AS VALUES (1, 2), (3, 4) WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_58bbd5d1fe16
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp0", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_preserve", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TEMP TABLE t_ctas_candidate (a, b) ON COMMIT PRESERVE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_2a2b9649f5d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp1", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TEMPORARY TABLE t_ctas_candidate AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_4b918af42522
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_temp2", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE LOCAL TEMP TABLE IF NOT EXISTS t_ctas_candidate (a, b) AS SELECT col_1, col_2 FROM t_ctas_source;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_287dd3392c1b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_two", "data": "create_table_as_data_default", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_yes", "modifier": "create_table_as_modifier_temp4", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_none", "query": "create_table_as_query_values", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE GLOBAL TEMP TABLE IF NOT EXISTS t_ctas_candidate (a, b) AS VALUES (1, 2), (3, 4);
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_01a7eb6c3d3c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp1", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_delete", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE TEMPORARY TABLE t_ctas_candidate ON COMMIT DELETE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_2e3dc470bdf7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp2", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_preserve", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE LOCAL TEMP TABLE t_ctas_candidate ON COMMIT PRESERVE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_6ea363263c38
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp3", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_preserve", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE LOCAL TEMPORARY TABLE t_ctas_candidate ON COMMIT PRESERVE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_9de9906822b3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_no", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp4", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_delete", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE GLOBAL TEMP TABLE t_ctas_candidate ON COMMIT DELETE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;

-- case_id: manifest_create_table_as_temporary_572d52d2a056
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_as_columns_inherit", "data": "create_table_as_data_yes", "engine": "create_table_as_engine_none", "if_not_exists": "create_table_as_if_not_exists_none", "modifier": "create_table_as_modifier_temp5", "name": "create_table_as_name_new", "on_commit": "create_table_as_on_commit_delete", "query": "create_table_as_query_select", "storage": "create_table_as_storage_default"}
-- fixture_setup:
DROP TABLE IF EXISTS t_ctas_source CASCADE;
CREATE TABLE t_ctas_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_ctas_source (col_1, col_2) VALUES (1, 2), (3, 4);
BEGIN;
-- test_sql:
CREATE GLOBAL TEMPORARY TABLE t_ctas_candidate ON COMMIT DELETE ROWS AS SELECT col_1, col_2 FROM t_ctas_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_ctas_candidate CASCADE;
DROP TABLE IF EXISTS t_ctas_source CASCADE;
