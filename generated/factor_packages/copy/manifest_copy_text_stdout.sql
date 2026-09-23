-- generated_from: manifest_copy_text_stdout
-- static_only: true
-- case_count: 10

-- case_id: manifest_copy_text_stdout_3d60b83fc4a6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_bc9497df6af2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_864ff247a830
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_3df1249261c9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_897287c108be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_e84f69bfebf3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_7ad0aa5018f9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_explicit", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_93507eb2c607
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_first", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_fe4eebead9ec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_second", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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

-- case_id: manifest_copy_text_stdout_8a08361b997d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"columns": "copy_columns_reversed", "delimiter": "copy_delimiter_pipe", "direction": "copy_direction_stdout", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
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
