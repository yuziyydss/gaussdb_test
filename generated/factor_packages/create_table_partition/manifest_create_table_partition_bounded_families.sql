-- generated_from: manifest_create_table_partition_bounded_families
-- static_only: true
-- case_count: 15

-- case_id: manifest_create_table_partition_bounded_families_07385e789e61
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_range", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_default"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20));
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_5d928c3dd4af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_start_end", "fillfactor": "create_table_partition_fillfactor_max", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=100) PARTITION BY RANGE (col_1) (PARTITION p1 START (1) END (10) EVERY (3), PARTITION p2 START (10) END (20)) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_93dc6f34742b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_range", "fillfactor": "create_table_partition_fillfactor_max", "if_not_exists": "create_table_partition_if_not_exists_on", "row_movement": "create_table_partition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=100) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20)) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_22a37e7087c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_list", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_on", "row_movement": "create_table_partition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY LIST (col_1) (PARTITION p1 VALUES (1, 2), PARTITION p2 VALUES (3, 4)) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_799cf9dece81
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_hash", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY HASH (col_1) (PARTITION p1, PARTITION p2) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_3dc834c2d047
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_hash", "fillfactor": "create_table_partition_fillfactor_max", "if_not_exists": "create_table_partition_if_not_exists_on", "row_movement": "create_table_partition_row_movement_default"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=100) PARTITION BY HASH (col_1) (PARTITION p1, PARTITION p2);
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_03dda7882de4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_list", "fillfactor": "create_table_partition_fillfactor_max", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_default"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=100) PARTITION BY LIST (col_1) (PARTITION p1 VALUES (1, 2), PARTITION p2 VALUES (3, 4));
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_92c515f092f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_interval", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_default"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 TIMESTAMP, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY RANGE (col_1) INTERVAL ('1 day') (PARTITION p1 VALUES LESS THAN (TIMESTAMP '2026-01-01'));
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_ffb0280e2436
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_start_end", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_on", "row_movement": "create_table_partition_row_movement_default"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY RANGE (col_1) (PARTITION p1 START (1) END (10) EVERY (3), PARTITION p2 START (10) END (20));
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_d4f32137ec6d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_interval", "fillfactor": "create_table_partition_fillfactor_max", "if_not_exists": "create_table_partition_if_not_exists_on", "row_movement": "create_table_partition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_partition_new (col_1 TIMESTAMP, col_2 INT) WITH (storage_type=astore, fillfactor=100) PARTITION BY RANGE (col_1) INTERVAL ('1 day') (PARTITION p1 VALUES LESS THAN (TIMESTAMP '2026-01-01')) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_11748b38aa01
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_range", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY RANGE (col_1) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20)) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_0d1a70068423
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_start_end", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY RANGE (col_1) (PARTITION p1 START (1) END (10) EVERY (3), PARTITION p2 START (10) END (20)) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_231767a28482
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_list", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY LIST (col_1) (PARTITION p1 VALUES (1, 2), PARTITION p2 VALUES (3, 4)) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_6f6984753ae0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_hash", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 INT, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY HASH (col_1) (PARTITION p1, PARTITION p2) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_partition_bounded_families_b7ffc9213b2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"family": "create_table_partition_family_interval", "fillfactor": "create_table_partition_fillfactor_min", "if_not_exists": "create_table_partition_if_not_exists_off", "row_movement": "create_table_partition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_partition_new (col_1 TIMESTAMP, col_2 INT) WITH (storage_type=astore, fillfactor=10) PARTITION BY RANGE (col_1) INTERVAL ('1 day') (PARTITION p1 VALUES LESS THAN (TIMESTAMP '2026-01-01')) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
