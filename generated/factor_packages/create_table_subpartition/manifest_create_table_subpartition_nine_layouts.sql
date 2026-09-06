-- generated_from: manifest_create_table_subpartition_nine_layouts
-- static_only: true
-- case_count: 18

-- case_id: manifest_create_table_subpartition_nine_layouts_9179687b9a0f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_range_range", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_4b83c2d297aa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_range_range", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_8e7a16e91db9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_range_list", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY LIST (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES (1, 2), SUBPARTITION p1s2 VALUES (3, 4)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES (1, 2), SUBPARTITION p2s2 VALUES (3, 4))) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_858caba597af
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_range_list", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY LIST (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1 VALUES (1, 2), SUBPARTITION p1s2 VALUES (3, 4)), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1 VALUES (1, 2), SUBPARTITION p2s2 VALUES (3, 4))) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_2c4ce43badd1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_range_hash", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY HASH (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1, SUBPARTITION p1s2), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1, SUBPARTITION p2s2)) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_5a40baeba638
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_range_hash", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY RANGE (col_1) SUBPARTITION BY HASH (col_2) (PARTITION p1 VALUES LESS THAN (10) (SUBPARTITION p1s1, SUBPARTITION p1s2), PARTITION p2 VALUES LESS THAN (20) (SUBPARTITION p2s1, SUBPARTITION p2s2)) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_20d082ac3f03
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_list_range", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY LIST (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES (1, 2) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES (3, 4) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_2ad8017e8032
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_list_range", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY LIST (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 VALUES (1, 2) (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 VALUES (3, 4) (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_32999ddf5b0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_list_list", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY LIST (col_1) SUBPARTITION BY LIST (col_2) (PARTITION p1 VALUES (1, 2) (SUBPARTITION p1s1 VALUES (1, 2), SUBPARTITION p1s2 VALUES (3, 4)), PARTITION p2 VALUES (3, 4) (SUBPARTITION p2s1 VALUES (1, 2), SUBPARTITION p2s2 VALUES (3, 4))) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_cf06275d2533
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_list_list", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY LIST (col_1) SUBPARTITION BY LIST (col_2) (PARTITION p1 VALUES (1, 2) (SUBPARTITION p1s1 VALUES (1, 2), SUBPARTITION p1s2 VALUES (3, 4)), PARTITION p2 VALUES (3, 4) (SUBPARTITION p2s1 VALUES (1, 2), SUBPARTITION p2s2 VALUES (3, 4))) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_4d7fcddcc4fe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_list_hash", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY LIST (col_1) SUBPARTITION BY HASH (col_2) (PARTITION p1 VALUES (1, 2) (SUBPARTITION p1s1, SUBPARTITION p1s2), PARTITION p2 VALUES (3, 4) (SUBPARTITION p2s1, SUBPARTITION p2s2)) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_10a0d90b5015
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_list_hash", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY LIST (col_1) SUBPARTITION BY HASH (col_2) (PARTITION p1 VALUES (1, 2) (SUBPARTITION p1s1, SUBPARTITION p1s2), PARTITION p2 VALUES (3, 4) (SUBPARTITION p2s1, SUBPARTITION p2s2)) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_e4356fea9332
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_hash_range", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY HASH (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_41d6a10c502f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_hash_range", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY HASH (col_1) SUBPARTITION BY RANGE (col_2) (PARTITION p1 (SUBPARTITION p1s1 VALUES LESS THAN (10), SUBPARTITION p1s2 VALUES LESS THAN (20)), PARTITION p2 (SUBPARTITION p2s1 VALUES LESS THAN (10), SUBPARTITION p2s2 VALUES LESS THAN (20))) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_3ce6dfbf15ab
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_hash_list", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY HASH (col_1) SUBPARTITION BY LIST (col_2) (PARTITION p1 (SUBPARTITION p1s1 VALUES (1, 2), SUBPARTITION p1s2 VALUES (3, 4)), PARTITION p2 (SUBPARTITION p2s1 VALUES (1, 2), SUBPARTITION p2s2 VALUES (3, 4))) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_d63043ff5595
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_hash_list", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY HASH (col_1) SUBPARTITION BY LIST (col_2) (PARTITION p1 (SUBPARTITION p1s1 VALUES (1, 2), SUBPARTITION p1s2 VALUES (3, 4)), PARTITION p2 (SUBPARTITION p2s1 VALUES (1, 2), SUBPARTITION p2s2 VALUES (3, 4))) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_83abcffe7b2e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_off", "layout": "create_table_subpartition_layout_hash_hash", "row_movement": "create_table_subpartition_row_movement_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY HASH (col_1) SUBPARTITION BY HASH (col_2) (PARTITION p1 (SUBPARTITION p1s1, SUBPARTITION p1s2), PARTITION p2 (SUBPARTITION p2s1, SUBPARTITION p2s2)) DISABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_table_subpartition_nine_layouts_86f8a75781b4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_not_exists": "create_table_subpartition_if_not_exists_on", "layout": "create_table_subpartition_layout_hash_hash", "row_movement": "create_table_subpartition_row_movement_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
-- test_sql:
CREATE TABLE IF NOT EXISTS fp_cs_one.b11_subpartition_new (col_1 INT, col_2 INT) WITH (storage_type=astore) PARTITION BY HASH (col_1) SUBPARTITION BY HASH (col_2) (PARTITION p1 (SUBPARTITION p1s1, SUBPARTITION p1s2), PARTITION p2 (SUBPARTITION p2s1, SUBPARTITION p2s2)) ENABLE ROW MOVEMENT;
-- fixture_teardown:
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
