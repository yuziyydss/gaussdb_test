-- generated_from: manifest_alter_event_disable
-- static_only: true
-- case_count: 1

-- case_id: manifest_alter_event_disable_364acdc5c2fb
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"operation": "alter_event_operation_disable"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["alter_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["alter_event_fact_privilege"], "key": "event_owner_or_admin"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
CREATE EVENT fp_cs_one.b10_event_existing ON SCHEDULE EVERY 1 DAY ON COMPLETION PRESERVE DISABLE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- test_sql:
ALTER EVENT fp_cs_one.b10_event_existing DISABLE;
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_existing;
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
