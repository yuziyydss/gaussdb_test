-- generated_from: manifest_alter_table_subpartition_rename
-- static_only: true
-- case_count: 6

-- case_id: manifest_alter_table_subpartition_rename_6d449ab60eb5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_subpartition_action_rename", "if_exists": "alter_table_subpartition_if_exists_off", "target": "alter_table_subpartition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_sub_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_cs_one.b11_sub_source VALUES (1,1),(1,11),(11,1),(11,11);
-- test_sql:
ALTER TABLE fp_cs_one.b11_sub_source RENAME SUBPARTITION p1s1 TO p1s_renamed;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_subpartition_rename_21b4714f559a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_subpartition_action_rename", "if_exists": "alter_table_subpartition_if_exists_on", "target": "alter_table_subpartition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_sub_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_cs_one.b11_sub_source VALUES (1,1),(1,11),(11,1),(11,11);
-- test_sql:
ALTER TABLE IF EXISTS ONLY fp_cs_one.b11_sub_source RENAME SUBPARTITION p1s1 TO p1s_renamed;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_subpartition_rename_00c1860e7a25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_subpartition_action_rename", "if_exists": "alter_table_subpartition_if_exists_off", "target": "alter_table_subpartition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_sub_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_cs_one.b11_sub_source VALUES (1,1),(1,11),(11,1),(11,11);
-- test_sql:
ALTER TABLE ONLY (fp_cs_one.b11_sub_source) RENAME SUBPARTITION p1s1 TO p1s_renamed;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_subpartition_rename_3a2920f8a9f5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_subpartition_action_rename", "if_exists": "alter_table_subpartition_if_exists_off", "target": "alter_table_subpartition_target_only"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_sub_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_cs_one.b11_sub_source VALUES (1,1),(1,11),(11,1),(11,11);
-- test_sql:
ALTER TABLE ONLY fp_cs_one.b11_sub_source RENAME SUBPARTITION p1s1 TO p1s_renamed;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_subpartition_rename_709829cddea9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_subpartition_action_rename", "if_exists": "alter_table_subpartition_if_exists_on", "target": "alter_table_subpartition_target_plain"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_sub_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_cs_one.b11_sub_source VALUES (1,1),(1,11),(11,1),(11,11);
-- test_sql:
ALTER TABLE IF EXISTS fp_cs_one.b11_sub_source RENAME SUBPARTITION p1s1 TO p1s_renamed;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_alter_table_subpartition_rename_57b936db7ac1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_table_subpartition_action_rename", "if_exists": "alter_table_subpartition_if_exists_on", "target": "alter_table_subpartition_target_only_parenthesized"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_sub_source (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20)));
INSERT INTO fp_cs_one.b11_sub_source VALUES (1,1),(1,11),(11,1),(11,11);
-- test_sql:
ALTER TABLE IF EXISTS ONLY (fp_cs_one.b11_sub_source) RENAME SUBPARTITION p1s1 TO p1s_renamed;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
