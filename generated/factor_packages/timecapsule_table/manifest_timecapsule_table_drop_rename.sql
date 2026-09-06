-- generated_from: manifest_timecapsule_table_drop_rename
-- static_only: true
-- case_count: 1

-- case_id: manifest_timecapsule_table_drop_rename_429b6ed995c6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"restore": "timecapsule_table_restore_drop_rename"}
-- environment_requirements: [{"allowed_values": ["on"], "fact_refs": ["timecapsule_table_fact_body_31"], "key": "enable_recyclebin"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b11_flash_source (col_1 INT, col_2 INT) WITH (storage_type=astore);
INSERT INTO fp_cs_one.b11_flash_source VALUES (1,10),(2,20);
DROP TABLE fp_cs_one.b11_flash_source;
-- test_sql:
TIMECAPSULE TABLE fp_cs_one.b11_flash_source TO BEFORE DROP RENAME TO b11_flash_restored;
-- fixture_teardown:
DROP TABLE IF EXISTS fp_cs_one.b11_flash_source PURGE;
DROP TABLE IF EXISTS fp_cs_one.b11_flash_restored PURGE;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
