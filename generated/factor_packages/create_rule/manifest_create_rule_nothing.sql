-- generated_from: manifest_create_rule_nothing
-- static_only: true
-- case_count: 9

-- case_id: manifest_create_rule_nothing_d28fa8f6706e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_default", "condition": "create_rule_condition_none", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source DO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_d42b5f247068
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_true", "event": "create_rule_event_update"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON UPDATE TO t_rule_source WHERE TRUE DO ALSO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_f8aa80588efe
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_instead", "condition": "create_rule_condition_false", "event": "create_rule_event_delete"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON DELETE TO t_rule_source WHERE FALSE DO INSTEAD NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_486c0c2e432f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_instead", "condition": "create_rule_condition_true", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source WHERE TRUE DO INSTEAD NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_c6acf1ac373c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_false", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source WHERE FALSE DO ALSO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_247dfbd8d78d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_instead", "condition": "create_rule_condition_none", "event": "create_rule_event_update"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON UPDATE TO t_rule_source DO INSTEAD NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_2bbe9a19ebdd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_default", "condition": "create_rule_condition_false", "event": "create_rule_event_update"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON UPDATE TO t_rule_source WHERE FALSE DO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_c39a7d6853d0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_none", "event": "create_rule_event_delete"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON DELETE TO t_rule_source DO ALSO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_nothing_c2b30ebffba5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_nothing", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_default", "condition": "create_rule_condition_true", "event": "create_rule_event_delete"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
-- test_sql:
CREATE RULE fp_rule AS ON DELETE TO t_rule_source WHERE TRUE DO NOTHING;
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_source CASCADE;
