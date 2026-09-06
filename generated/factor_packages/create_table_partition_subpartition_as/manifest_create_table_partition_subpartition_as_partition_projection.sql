-- generated_from: manifest_create_table_partition_subpartition_as_partition_projection
-- static_only: true
-- case_count: 7

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_480e6d614080
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_inherit", "data": "create_table_partition_subpartition_as_data_default", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_off", "layout": "create_table_partition_subpartition_as_layout_single"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_as PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20)) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_4ee2f6d3a1dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_explicit", "data": "create_table_partition_subpartition_as_data_yes", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_on", "layout": "create_table_partition_subpartition_as_layout_single"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_as (col_1, col_2) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20)) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_f5dfb8d66c08
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_explicit", "data": "create_table_partition_subpartition_as_data_no", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_off", "layout": "create_table_partition_subpartition_as_layout_double"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_as (col_1, col_2) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_311d9f4c01c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_inherit", "data": "create_table_partition_subpartition_as_data_default", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_on", "layout": "create_table_partition_subpartition_as_layout_double"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_as PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_4fb22a6a8229
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_inherit", "data": "create_table_partition_subpartition_as_data_no", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_on", "layout": "create_table_partition_subpartition_as_layout_single"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_as PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20)) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source WITH NO DATA;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_08ded30f708c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_inherit", "data": "create_table_partition_subpartition_as_data_yes", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_off", "layout": "create_table_partition_subpartition_as_layout_double"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_as PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source WITH DATA;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_subpartition_as_partition_projection_168e8f803444
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "create_table_partition_subpartition_as_columns_explicit", "data": "create_table_partition_subpartition_as_data_default", "if_not_exists": "create_table_partition_subpartition_as_if_not_exists_off", "layout": "create_table_partition_subpartition_as_layout_single"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_as_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_as_source VALUES (1,1),(11,11);
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_as (col_1, col_2) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20)) AS SELECT col_1, col_2 FROM fp_cs_one.b11_as_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
