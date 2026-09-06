-- generated_from: manifest_replace_query
-- static_only: true
-- case_count: 4

-- case_id: manifest_replace_query_b852c849635f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_off", "form": "replace_form_query", "into": "replace_into_off", "rows": "replace_rows_one"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE fp_cs_one.b11_replace_target SELECT col_1,col_2 FROM fp_cs_one.b11_replace_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_query_f093c965abe2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_on", "form": "replace_form_query", "into": "replace_into_on", "rows": "replace_rows_one"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE INTO fp_cs_one.b11_replace_target (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_replace_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_query_5f0fb0b8c8ed
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_on", "form": "replace_form_query", "into": "replace_into_off", "rows": "replace_rows_one"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE fp_cs_one.b11_replace_target (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_replace_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_query_68fa79c3b83d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_off", "form": "replace_form_query", "into": "replace_into_on", "rows": "replace_rows_one"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE INTO fp_cs_one.b11_replace_target SELECT col_1,col_2 FROM fp_cs_one.b11_replace_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
