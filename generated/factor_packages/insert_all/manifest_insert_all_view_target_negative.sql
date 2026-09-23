-- generated_from: manifest_insert_all_view_target_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_insert_all_view_target_negative_d737d9137826
-- expected: error
-- expected_error_category: view_target_not_allowed
-- expected_sqlstates: -
-- expected_error_regex: Not allowed to insert into view
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"branch_mode": "insert_all_branch_mode_unconditional", "condition": "insert_all_condition_source_col", "match_mode": "insert_all_match_mode_default", "subquery_alias": "insert_all_subquery_alias_none", "subquery_presence": "insert_all_subquery_presence_present", "targets": "insert_all_targets_view"}
-- environment_requirements: [{"allowed_values": ["A"], "fact_refs": ["insert_all_fact_body_15"], "key": "sql_compatibility"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
BEGIN;
CREATE TABLE fp_cs_one.b11_ia_source (col_1 INT, col_2 INT);
CREATE TABLE fp_cs_one.b11_ia_a (col_1 INT, col_2 INT);
CREATE TABLE fp_cs_one.b11_ia_b (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_ia_source VALUES (1,10),(2,20);
CREATE VIEW fp_cs_one.b11_ia_view AS SELECT col_1,col_2 FROM fp_cs_one.b11_ia_a;
-- test_sql:
INSERT ALL INTO fp_cs_one.b11_ia_view (col_1,col_2) VALUES (col_1,col_2) SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;
-- fixture_teardown:
DROP VIEW IF EXISTS fp_cs_one.b11_ia_view;
ROLLBACK;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
