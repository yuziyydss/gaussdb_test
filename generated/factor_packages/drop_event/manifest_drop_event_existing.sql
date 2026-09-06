-- generated_from: manifest_drop_event_existing
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_event_existing_4d17a54b514a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_event_if_exists_none"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["drop_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event::create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
CREATE EVENT fp_cs_one.b10_event_existing ON SCHEDULE EVERY 1 DAY ON COMPLETION PRESERVE DISABLE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- test_sql:
DROP EVENT fp_cs_one.b10_event_existing;
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_existing;
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_drop_event_existing_f1522d0e91c7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_event_if_exists_yes"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["drop_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event::create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
CREATE EVENT fp_cs_one.b10_event_existing ON SCHEDULE EVERY 1 DAY ON COMPLETION PRESERVE DISABLE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- test_sql:
DROP EVENT IF EXISTS fp_cs_one.b10_event_existing;
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_existing;
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
