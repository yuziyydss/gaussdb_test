-- generated_from: manifest_purge_table
-- static_only: true
-- case_count: 1

-- case_id: manifest_purge_table_223afbee9e5a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"target_kind": "purge_target_kind_table"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["purge_fact_body_39"], "key": "enable_recyclebin"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_purge_source (col_1 INT, col_2 INT) WITH (storage_type=ustore);
DROP TABLE fp_cs_one.b11_purge_source;
-- test_sql:
PURGE TABLE fp_cs_one.b11_purge_source;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_one.b11_purge_source PURGE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
