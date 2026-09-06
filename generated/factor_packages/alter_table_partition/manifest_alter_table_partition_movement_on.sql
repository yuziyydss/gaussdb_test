-- generated_from: manifest_alter_table_partition_movement_on
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_table_partition_movement_on_7af15dc912bd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_movement_on", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE fp_cs_one.b11_range_source ENABLE ROW MOVEMENT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_movement_on_e602aea65f1f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_movement_on", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS ONLY fp_cs_one.b11_range_source ENABLE ROW MOVEMENT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_movement_on_5a2f1414eaca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_movement_on", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE ONLY (fp_cs_one.b11_range_source) ENABLE ROW MOVEMENT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_movement_on_4aca67baeeb7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_movement_on", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE ONLY fp_cs_one.b11_range_source ENABLE ROW MOVEMENT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_movement_on_df05b0424a70
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_movement_on", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS fp_cs_one.b11_range_source ENABLE ROW MOVEMENT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_movement_on_3dfacafa9c50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_movement_on", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS ONLY (fp_cs_one.b11_range_source) ENABLE ROW MOVEMENT;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
