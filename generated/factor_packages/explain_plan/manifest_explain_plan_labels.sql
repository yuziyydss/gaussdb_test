-- generated_from: manifest_explain_plan_labels
-- static_only: true
-- case_count: 6

-- case_id: manifest_explain_plan_labels_929042298bc3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "explain_plan_label_default", "query": "explain_plan_query_all"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN FOR SELECT col_1, col_2 FROM t_explain_plan;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;

-- case_id: manifest_explain_plan_labels_930bf3c48f0e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "explain_plan_label_default", "query": "explain_plan_query_where"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN FOR SELECT col_1 FROM t_explain_plan WHERE col_1 > 0;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;

-- case_id: manifest_explain_plan_labels_b5a306edc0f2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "explain_plan_label_basic", "query": "explain_plan_query_all"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN SET STATEMENT_ID = 'fp_ep_basic' FOR SELECT col_1, col_2 FROM t_explain_plan;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;

-- case_id: manifest_explain_plan_labels_ca32ef096b43
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "explain_plan_label_basic", "query": "explain_plan_query_where"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN SET STATEMENT_ID = 'fp_ep_basic' FOR SELECT col_1 FROM t_explain_plan WHERE col_1 > 0;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;

-- case_id: manifest_explain_plan_labels_296371e6def5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "explain_plan_label_ascii30", "query": "explain_plan_query_all"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN SET STATEMENT_ID = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' FOR SELECT col_1, col_2 FROM t_explain_plan;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;

-- case_id: manifest_explain_plan_labels_6122963f6349
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"label": "explain_plan_label_ascii30", "query": "explain_plan_query_where"}
-- environment_requirements: [{"allowed_values": ["fresh_dedicated"], "fact_refs": ["explain_plan_fact_isolation"], "key": "execution_session"}]
-- fixture_setup:
CREATE TABLE t_explain_plan (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_explain_plan VALUES (1, 2), (3, 4);
SELECT 1;
-- test_sql:
EXPLAIN PLAN SET STATEMENT_ID = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' FOR SELECT col_1 FROM t_explain_plan WHERE col_1 > 0;
-- fixture_teardown:
DELETE FROM plan_table WHERE statement_id IN ('fp_ep_basic', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
DROP TABLE IF EXISTS t_explain_plan CASCADE;
