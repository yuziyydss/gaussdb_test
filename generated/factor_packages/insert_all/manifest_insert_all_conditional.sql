-- generated_from: manifest_insert_all_conditional
-- static_only: true
-- case_count: 6

-- case_id: manifest_insert_all_conditional_f725614cdc25
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "match_mode": "insert_all_match_mode_default", "targets": "insert_all_targets_one"}
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
INSERT WHEN col_1 > 0 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_insert_all_conditional_909a030c24e9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "match_mode": "insert_all_match_mode_all", "targets": "insert_all_targets_two"}
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
INSERT ALL WHEN col_1 > 0 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_insert_all_conditional_74ed36437a52
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "match_mode": "insert_all_match_mode_first", "targets": "insert_all_targets_one"}
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
INSERT FIRST WHEN col_1 > 0 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_insert_all_conditional_df422c597afd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "match_mode": "insert_all_match_mode_default", "targets": "insert_all_targets_two"}
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
INSERT WHEN col_1 > 0 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_insert_all_conditional_e8d9db07136d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "match_mode": "insert_all_match_mode_all", "targets": "insert_all_targets_one"}
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
INSERT ALL WHEN col_1 > 0 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_insert_all_conditional_036c3bd9cc04
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "match_mode": "insert_all_match_mode_first", "targets": "insert_all_targets_two"}
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
INSERT FIRST WHEN col_1 > 0 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
