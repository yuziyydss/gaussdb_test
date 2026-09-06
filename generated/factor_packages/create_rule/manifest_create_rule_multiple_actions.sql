-- generated_from: manifest_create_rule_multiple_actions
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_rule_multiple_actions_6e5fca0fb8ee
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_multiple", "actions": "create_rule_actions_two", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_none", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source DO ALSO (INSERT INTO t_rule_log VALUES (1, 2); INSERT INTO t_rule_log VALUES (3, 4));
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;
