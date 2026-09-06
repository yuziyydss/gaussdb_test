-- generated_from: manifest_alter_table_partition_merge
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_table_partition_merge_a349b5c6ddc6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_merge", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE fp_cs_one.b11_range_source MERGE PARTITIONS p1,p2 INTO PARTITION p2;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_merge_ae5b19a2dd4f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_merge", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS ONLY fp_cs_one.b11_range_source MERGE PARTITIONS p1,p2 INTO PARTITION p2;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_merge_22f27d27ba0c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_merge", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE ONLY (fp_cs_one.b11_range_source) MERGE PARTITIONS p1,p2 INTO PARTITION p2;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_merge_142dca5df7f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_merge", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE ONLY fp_cs_one.b11_range_source MERGE PARTITIONS p1,p2 INTO PARTITION p2;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_merge_b972f6a71618
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_merge", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS fp_cs_one.b11_range_source MERGE PARTITIONS p1,p2 INTO PARTITION p2;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_merge_0be94f8d33b2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_merge", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS ONLY (fp_cs_one.b11_range_source) MERGE PARTITIONS p1,p2 INTO PARTITION p2;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
