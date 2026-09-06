-- generated_from: manifest_explain_plan_label_too_long
-- static_only: true
-- case_count: 1

-- case_id: manifest_explain_plan_label_too_long_1677a7630b5c
-- expected: error
-- expected_error_category: statement_id_too_long
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"label": "explain_plan_label_ascii31", "query": "explain_plan_query_all"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN SET STATEMENT_ID = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' FOR SELECT col_1, col_2 FROM t_explain_plan;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;
