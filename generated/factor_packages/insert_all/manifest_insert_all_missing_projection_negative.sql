-- generated_from: manifest_insert_all_missing_projection_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_all_missing_projection_negative_4dc8b1a4857d
-- expected: error
-- expected_error_category: missing_projection_column
-- expected_sqlstates: -
-- expected_error_regex: Column "missing_col" does not exist
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"branch_mode": "insert_all_branch_mode_conditional", "condition": "insert_all_condition_missing_projection", "match_mode": "insert_all_match_mode_all", "subquery_alias": "insert_all_subquery_alias_none", "subquery_presence": "insert_all_subquery_presence_present", "targets": "insert_all_targets_one"}
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
INSERT ALL WHEN missing_col > 1 THEN INTO fp_cs_one.b11_ia_a (col_1,col_2) VALUES (col_1,col_2) WHEN col_1 > 1 THEN INTO fp_cs_one.b11_ia_b (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
