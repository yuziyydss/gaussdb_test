-- generated_from: manifest_snapshot_create_as
-- static_only: true
-- case_count: 4

-- case_id: manifest_snapshot_create_as_b02c7fb48925
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "snapshot_comment_off", "query": "snapshot_query_all"}
-- environment_requirements: [{"allowed_values": ["off"], "fact_refs": ["snapshot_fact_body_11"], "key": "enable_separation_of_duty"}, {"allowed_values": ["MSS", "CSS"], "fact_refs": ["snapshot_fact_body_8"], "key": "db4ai_snapshot_mode"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_snapshot_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_snapshot_source VALUES (1,10),(2,20);
-- test_sql:
CREATE SNAPSHOT fp_cs_one.b11_snapshot @1.0 AS SELECT col_1,col_2 FROM fp_cs_one.b11_snapshot_source;
-- fixture_teardown:
PURGE SNAPSHOT fp_cs_one.b11_snapshot @1.0;
DROP TABLE fp_cs_one.b11_snapshot_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_snapshot_create_as_ada5319c553c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "snapshot_comment_off", "query": "snapshot_query_where"}
-- environment_requirements: [{"allowed_values": ["off"], "fact_refs": ["snapshot_fact_body_11"], "key": "enable_separation_of_duty"}, {"allowed_values": ["MSS", "CSS"], "fact_refs": ["snapshot_fact_body_8"], "key": "db4ai_snapshot_mode"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_snapshot_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_snapshot_source VALUES (1,10),(2,20);
-- test_sql:
CREATE SNAPSHOT fp_cs_one.b11_snapshot @1.0 AS SELECT col_1,col_2 FROM fp_cs_one.b11_snapshot_source WHERE col_1 > 1;
-- fixture_teardown:
PURGE SNAPSHOT fp_cs_one.b11_snapshot @1.0;
DROP TABLE fp_cs_one.b11_snapshot_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_snapshot_create_as_57619636b971
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "snapshot_comment_on", "query": "snapshot_query_all"}
-- environment_requirements: [{"allowed_values": ["off"], "fact_refs": ["snapshot_fact_body_11"], "key": "enable_separation_of_duty"}, {"allowed_values": ["MSS", "CSS"], "fact_refs": ["snapshot_fact_body_8"], "key": "db4ai_snapshot_mode"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_snapshot_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_snapshot_source VALUES (1,10),(2,20);
-- test_sql:
CREATE SNAPSHOT fp_cs_one.b11_snapshot @1.0 COMMENT IS 'first_version' AS SELECT col_1,col_2 FROM fp_cs_one.b11_snapshot_source;
-- fixture_teardown:
PURGE SNAPSHOT fp_cs_one.b11_snapshot @1.0;
DROP TABLE fp_cs_one.b11_snapshot_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_snapshot_create_as_b79a31d14a76
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "snapshot_comment_on", "query": "snapshot_query_where"}
-- environment_requirements: [{"allowed_values": ["off"], "fact_refs": ["snapshot_fact_body_11"], "key": "enable_separation_of_duty"}, {"allowed_values": ["MSS", "CSS"], "fact_refs": ["snapshot_fact_body_8"], "key": "db4ai_snapshot_mode"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_snapshot_source (col_1 INT, col_2 INT);
INSERT INTO fp_cs_one.b11_snapshot_source VALUES (1,10),(2,20);
-- test_sql:
CREATE SNAPSHOT fp_cs_one.b11_snapshot @1.0 COMMENT IS 'first_version' AS SELECT col_1,col_2 FROM fp_cs_one.b11_snapshot_source WHERE col_1 > 1;
-- fixture_teardown:
PURGE SNAPSHOT fp_cs_one.b11_snapshot @1.0;
DROP TABLE fp_cs_one.b11_snapshot_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
