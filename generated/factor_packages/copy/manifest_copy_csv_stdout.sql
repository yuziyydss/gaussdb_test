-- generated_from: manifest_copy_csv_stdout
-- static_only: true
-- case_count: 10

-- case_id: manifest_copy_csv_stdout_fa06ffd33b5b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source TO STDOUT WITH (FORMAT 'csv', DELIMITER ',', HEADER FALSE);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_d0777e280330
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1, col_2) TO STDOUT WITH (FORMAT 'csv', DELIMITER '|', HEADER TRUE, FORCE_QUOTE *);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_5741a74da005
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1) TO STDOUT WITH (FORMAT 'csv', DELIMITER ',', HEADER FALSE, FORCE_QUOTE *);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_1308644497d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2) TO STDOUT WITH (FORMAT 'csv', DELIMITER ',', HEADER TRUE);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_dada914cb69a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2, col_1) TO STDOUT WITH (FORMAT 'csv', DELIMITER '|', HEADER FALSE);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_39fa4cc5999a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source TO STDOUT WITH (FORMAT 'csv', DELIMITER '|', HEADER TRUE, FORCE_QUOTE *);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_63280797f945
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1, col_2) TO STDOUT WITH (FORMAT 'csv', DELIMITER ',', HEADER FALSE);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_a731fa80f8c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1) TO STDOUT WITH (FORMAT 'csv', DELIMITER '|', HEADER TRUE);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_7a1e78dc40d1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2) TO STDOUT WITH (FORMAT 'csv', DELIMITER '|', HEADER FALSE, FORCE_QUOTE *);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_csv_stdout_8b964be8f15c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_on"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2, col_1) TO STDOUT WITH (FORMAT 'csv', DELIMITER ',', HEADER TRUE, FORCE_QUOTE *);
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
