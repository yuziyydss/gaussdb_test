-- generated_from: manifest_insert_all_unconditional
-- static_only: true
-- case_count: 2

-- case_id: manifest_insert_all_unconditional_1c616b8e3e2b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_unconditional", "match_mode": "insert_all_match_mode_default", "targets": "insert_all_targets_one"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["insert_all_fact_body_15"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_ia_source (col_1 INT, col_2 INT);
CREATE TABLE fp_cs_one.b11_ia_a (col_1 INT, col_2 INT);
CREATE TABLE fp_cs_one.b11_ia_b (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_ia_source VALUES (1,10),(2,20);
-- test_sql:
INSERT ALL INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_insert_all_unconditional_7e295ee08aec
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_unconditional", "match_mode": "insert_all_match_mode_default", "targets": "insert_all_targets_two"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["insert_all_fact_body_15"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_ia_source (col_1 INT, col_2 INT);
CREATE TABLE fp_cs_one.b11_ia_a (col_1 INT, col_2 INT);
CREATE TABLE fp_cs_one.b11_ia_b (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_ia_source VALUES (1,10),(2,20);
-- test_sql:
INSERT ALL INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
