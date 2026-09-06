-- generated_from: manifest_replace_value
-- static_only: true
-- case_count: 6

-- case_id: manifest_replace_value_0a062522c1fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_off", "form": "replace_form_value", "into": "replace_into_off", "rows": "replace_rows_one"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE fp_cs_one.b11_replace_target VALUE (1,11);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_value_5a45d8915048
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_on", "form": "replace_form_value", "into": "replace_into_on", "rows": "replace_rows_two"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE INTO fp_cs_one.b11_replace_target (col_1,col_2) VALUE (1,11), (3,30);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_value_e43cc63e9f29
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_on", "form": "replace_form_value", "into": "replace_into_off", "rows": "replace_rows_three"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE fp_cs_one.b11_replace_target (col_1,col_2) VALUE (1,11), (1,12), (3,30);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_value_9a757cf5915b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_off", "form": "replace_form_value", "into": "replace_into_on", "rows": "replace_rows_three"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE INTO fp_cs_one.b11_replace_target VALUE (1,11), (1,12), (3,30);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_value_b2eaf489afaa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_off", "form": "replace_form_value", "into": "replace_into_off", "rows": "replace_rows_two"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE fp_cs_one.b11_replace_target VALUE (1,11), (3,30);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_replace_value_12ea03eceed1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "replace_columns_on", "form": "replace_form_value", "into": "replace_into_on", "rows": "replace_rows_one"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_replace_target (col_1 INT PRIMARY KEY DEFAULT 0, col_2 INT DEFAULT 2);
CREATE TABLE fp_cs_one.b11_replace_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_replace_target VALUES (1,10),(2,20);
INSERT INTO fp_cs_one.b11_replace_source VALUES (1,11),(3,30);
-- test_sql:
REPLACE INTO fp_cs_one.b11_replace_target (col_1,col_2) VALUE (1,11);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
