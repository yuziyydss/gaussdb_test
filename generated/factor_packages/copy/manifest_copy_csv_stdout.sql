-- generated_from: manifest_copy_csv_stdout
-- static_only: true
-- case_count: 10

-- case_id: manifest_copy_csv_stdout_812d71d868c3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_comma", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_csv_stdout_f5813a5c3f12
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_pipe", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_on"}
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

-- case_id: manifest_copy_csv_stdout_0d8de41dcd4d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_comma", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_on"}
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

-- case_id: manifest_copy_csv_stdout_08fb7f604410
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_comma", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_csv_stdout_62db8461aa21
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_pipe", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_csv_stdout_f61f3df74bf7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_pipe", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_on"}
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

-- case_id: manifest_copy_csv_stdout_b5930305e5d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_comma", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_csv_stdout_689bc1b01f51
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_pipe", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_csv_stdout_f61ca9421069
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_pipe", "format": "copy_format_csv", "header": "copy_header_off", "quote_all": "copy_quote_all_on"}
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

-- case_id: manifest_copy_csv_stdout_264eefc87164
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_comma", "format": "copy_format_csv", "header": "copy_header_on", "quote_all": "copy_quote_all_on"}
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
