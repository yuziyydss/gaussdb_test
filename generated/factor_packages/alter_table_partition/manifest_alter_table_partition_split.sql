-- generated_from: manifest_alter_table_partition_split
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_table_partition_split_0a69ced1e874
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_split", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE fp_cs_one.b11_range_source SPLIT PARTITION p2 AT (15) INTO (PARTITION p2a, PARTITION p2b);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_split_671d3c812b27
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_split", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS ONLY fp_cs_one.b11_range_source SPLIT PARTITION p2 AT (15) INTO (PARTITION p2a, PARTITION p2b);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_split_dbac411034a0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_split", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE ONLY (fp_cs_one.b11_range_source) SPLIT PARTITION p2 AT (15) INTO (PARTITION p2a, PARTITION p2b);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_split_55fa9bea2e7e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_split", "if_exists": "alter_table_partition_if_exists_off", "target": "alter_table_partition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE ONLY fp_cs_one.b11_range_source SPLIT PARTITION p2 AT (15) INTO (PARTITION p2a, PARTITION p2b);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_split_61376f995666
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_split", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS fp_cs_one.b11_range_source SPLIT PARTITION p2 AT (15) INTO (PARTITION p2a, PARTITION p2b);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_partition_split_f6638ff02919
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_partition_action_split", "if_exists": "alter_table_partition_if_exists_on", "target": "alter_table_partition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_range_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
INSERT INTO fp_cs_one.b11_range_source VALUES (1,2),(11,4);
-- test_sql:
ALTER TABLE IF EXISTS ONLY (fp_cs_one.b11_range_source) SPLIT PARTITION p2 AT (15) INTO (PARTITION p2a, PARTITION p2b);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
