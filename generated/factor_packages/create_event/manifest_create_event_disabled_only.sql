-- generated_from: manifest_create_event_disabled_only
-- static_only: true
-- case_count: 8

-- case_id: manifest_create_event_disabled_only_3fe458ee3613
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_none", "completion": "create_event_completion_none", "disabled": "create_event_disabled_disable", "if_not_exists": "create_event_if_not_exists_none", "schedule": "create_event_schedule_once"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT fp_cs_one.b10_event_new ON SCHEDULE AT sysdate + INTERVAL 1 DAY DISABLE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_7c5ec96d36a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_text", "completion": "create_event_completion_preserve", "disabled": "create_event_disabled_slave", "if_not_exists": "create_event_if_not_exists_none", "schedule": "create_event_schedule_repeat"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT fp_cs_one.b10_event_new ON SCHEDULE EVERY 1 DAY ON COMPLETION PRESERVE DISABLE ON SLAVE COMMENT 'b10 disabled event' DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_b2e9ccbdd445
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_text", "completion": "create_event_completion_not_preserve", "disabled": "create_event_disabled_disable", "if_not_exists": "create_event_if_not_exists_yes", "schedule": "create_event_schedule_once"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT IF NOT EXISTS fp_cs_one.b10_event_new ON SCHEDULE AT sysdate + INTERVAL 1 DAY ON COMPLETION NOT PRESERVE DISABLE COMMENT 'b10 disabled event' DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_d105e4d661de
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_none", "completion": "create_event_completion_none", "disabled": "create_event_disabled_slave", "if_not_exists": "create_event_if_not_exists_yes", "schedule": "create_event_schedule_repeat"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT IF NOT EXISTS fp_cs_one.b10_event_new ON SCHEDULE EVERY 1 DAY DISABLE ON SLAVE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_6d4b1b52a91b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_none", "completion": "create_event_completion_not_preserve", "disabled": "create_event_disabled_slave", "if_not_exists": "create_event_if_not_exists_none", "schedule": "create_event_schedule_once"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT fp_cs_one.b10_event_new ON SCHEDULE AT sysdate + INTERVAL 1 DAY ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_a2fe6c47415a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_none", "completion": "create_event_completion_preserve", "disabled": "create_event_disabled_disable", "if_not_exists": "create_event_if_not_exists_yes", "schedule": "create_event_schedule_once"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT IF NOT EXISTS fp_cs_one.b10_event_new ON SCHEDULE AT sysdate + INTERVAL 1 DAY ON COMPLETION PRESERVE DISABLE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_ccc3d6fc505f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_text", "completion": "create_event_completion_none", "disabled": "create_event_disabled_disable", "if_not_exists": "create_event_if_not_exists_none", "schedule": "create_event_schedule_repeat"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT fp_cs_one.b10_event_new ON SCHEDULE EVERY 1 DAY DISABLE COMMENT 'b10 disabled event' DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;

-- case_id: manifest_create_event_disabled_only_88eb1369badc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"comment": "create_event_comment_none", "completion": "create_event_completion_not_preserve", "disabled": "create_event_disabled_disable", "if_not_exists": "create_event_if_not_exists_none", "schedule": "create_event_schedule_repeat"}
-- environment_requirements: [{"allowed_values": ["B"], "fact_refs": ["create_event_fact_compat_b"], "key": "sql_compatibility"}, {"allowed_values": ["true"], "fact_refs": ["create_event_fact_privilege"], "key": "event_operator_authorized"}]
-- fixture_setup:
CREATE SCHEMA fp_cs_one;
CREATE SCHEMA fp_cs_two;
CREATE TABLE fp_cs_one.b10_event_source (col_1 INTEGER,col_2 INTEGER);
-- test_sql:
CREATE EVENT fp_cs_one.b10_event_new ON SCHEDULE EVERY 1 DAY ON COMPLETION NOT PRESERVE DISABLE DO INSERT INTO fp_cs_one.b10_event_source VALUES (1,2);
-- fixture_teardown:
DROP EVENT IF EXISTS fp_cs_one.b10_event_new;
DROP TABLE fp_cs_one.b10_event_source;
DROP SCHEMA IF EXISTS fp_cs_two CASCADE;
DROP SCHEMA IF EXISTS fp_cs_one CASCADE;
