-- generated_from: manifest_rename_table_ordinary
-- static_only: true
-- case_count: 4

-- case_id: manifest_rename_table_ordinary_58ff67cd7fc2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "rename_table_keyword_table", "targets": "rename_table_targets_one"}
-- fixture_setup:
CREATE TABLE t_rename_one (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_one VALUES (1, 2), (3, 4);
CREATE TABLE t_rename_two (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_two VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
RENAME TABLE t_rename_one TO t_renamed_one;
-- fixture_teardown:
DROP TABLE IF EXISTS t_renamed_two CASCADE;
DROP TABLE IF EXISTS t_renamed_one CASCADE;
DROP TABLE IF EXISTS t_rename_two CASCADE;
DROP TABLE IF EXISTS t_rename_one CASCADE;

-- case_id: manifest_rename_table_ordinary_ff46aeca95bc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "rename_table_keyword_table", "targets": "rename_table_targets_two"}
-- fixture_setup:
CREATE TABLE t_rename_one (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_one VALUES (1, 2), (3, 4);
CREATE TABLE t_rename_two (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_two VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
RENAME TABLE t_rename_one TO t_renamed_one, t_rename_two TO t_renamed_two;
-- fixture_teardown:
DROP TABLE IF EXISTS t_renamed_two CASCADE;
DROP TABLE IF EXISTS t_renamed_one CASCADE;
DROP TABLE IF EXISTS t_rename_two CASCADE;
DROP TABLE IF EXISTS t_rename_one CASCADE;

-- case_id: manifest_rename_table_ordinary_a20f69152230
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "rename_table_keyword_tables", "targets": "rename_table_targets_one"}
-- fixture_setup:
CREATE TABLE t_rename_one (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_one VALUES (1, 2), (3, 4);
CREATE TABLE t_rename_two (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_two VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
RENAME TABLES t_rename_one TO t_renamed_one;
-- fixture_teardown:
DROP TABLE IF EXISTS t_renamed_two CASCADE;
DROP TABLE IF EXISTS t_renamed_one CASCADE;
DROP TABLE IF EXISTS t_rename_two CASCADE;
DROP TABLE IF EXISTS t_rename_one CASCADE;

-- case_id: manifest_rename_table_ordinary_326f54398cf6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"keyword": "rename_table_keyword_tables", "targets": "rename_table_targets_two"}
-- fixture_setup:
CREATE TABLE t_rename_one (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_one VALUES (1, 2), (3, 4);
CREATE TABLE t_rename_two (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rename_two VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
RENAME TABLES t_rename_one TO t_renamed_one, t_rename_two TO t_renamed_two;
-- fixture_teardown:
DROP TABLE IF EXISTS t_renamed_two CASCADE;
DROP TABLE IF EXISTS t_renamed_one CASCADE;
DROP TABLE IF EXISTS t_rename_two CASCADE;
DROP TABLE IF EXISTS t_rename_one CASCADE;
