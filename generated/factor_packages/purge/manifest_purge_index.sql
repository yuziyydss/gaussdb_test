-- generated_from: manifest_purge_index
-- static_only: true
-- case_count: 1

-- case_id: manifest_purge_index_13731b526c0b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target_kind": "purge_target_kind_index"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["purge_fact_body_39"], "key": "enable_recyclebin"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_purge_source (col_1 INT, col_2 INT) WITH (storage_type=ustore);
CREATE INDEX b11_purge_index ON fp_cs_one.b11_purge_source (col_1);
DROP TABLE fp_cs_one.b11_purge_source;
-- test_sql:
PURGE INDEX fp_cs_one.b11_purge_index;
-- fixture_teardown:
PURGE TABLE fp_cs_one.b11_purge_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
