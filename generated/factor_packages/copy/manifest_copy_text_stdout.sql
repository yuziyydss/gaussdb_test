-- generated_from: manifest_copy_text_stdout
-- static_only: true
-- case_count: 10

-- case_id: manifest_copy_text_stdout_679490fc02cf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_comma", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source TO STDOUT WITH (FORMAT 'text', DELIMITER ',');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_0c3c3a83f529
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_pipe", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1, col_2) TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_bf1b5874a12b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_comma", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1) TO STDOUT WITH (FORMAT 'text', DELIMITER ',');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_da3d30c6e0ca
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_comma", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2) TO STDOUT WITH (FORMAT 'text', DELIMITER ',');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_9280af243212
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_comma", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2, col_1) TO STDOUT WITH (FORMAT 'text', DELIMITER ',');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_9cedc876d357
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_pipe", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_a171b56d0a77
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_comma", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1, col_2) TO STDOUT WITH (FORMAT 'text', DELIMITER ',');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_a0a34142fbe9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_pipe", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_1) TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_148c0fe2afec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_pipe", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2) TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_copy_text_stdout_23c54864b4b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_pipe", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source (col_2, col_1) TO STDOUT WITH (FORMAT 'text', DELIMITER '|');
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
