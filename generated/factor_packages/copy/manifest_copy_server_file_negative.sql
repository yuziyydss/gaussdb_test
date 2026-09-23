-- generated_from: manifest_copy_server_file_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_copy_server_file_negative_cf3252dff20c
-- expected: error
-- expected_error_category: server_file_copy_prohibited
-- expected_sqlstates: -
-- expected_error_regex: COPY to or from a file is prohibited for security concerns
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"columns": "copy_columns_inherit", "delimiter": "copy_delimiter_comma", "direction": "copy_direction_server_file", "format": "copy_format_text", "header": "copy_header_off", "quote_all": "copy_quote_all_off"}
-- environment_requirements: [{"allowed_values": ["disabled_for_non_initial_user_without_role"], "fact_refs": ["copy_fact_body_997", "copy_fact_body_1003"], "key": "server_file_copy_authorization"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_copy_source (col_1 INT, col_2 TEXT);
INSERT INTO fp_cs_one.b11_copy_source VALUES (1,'plain'),(2,'comma,value'),(3,NULL);
-- test_sql:
COPY fp_cs_one.b11_copy_source FROM '/tmp/gaussdb_copy_static_input.csv';
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
