-- generated_from: manifest_create_rule_single_action
-- static_only: true
-- case_count: 9

-- case_id: manifest_create_rule_single_action_97a33b12b60e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_default", "condition": "create_rule_condition_none", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source DO INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_787a3cf7c1dd
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_true", "event": "create_rule_event_update"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON UPDATE TO t_rule_source WHERE TRUE DO ALSO INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_d83758d0517a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_instead", "condition": "create_rule_condition_false", "event": "create_rule_event_delete"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON DELETE TO t_rule_source WHERE FALSE DO INSTEAD INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_6609fa483d50
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_instead", "condition": "create_rule_condition_true", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source WHERE TRUE DO INSTEAD INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_d61238881f1d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_false", "event": "create_rule_event_insert"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON INSERT TO t_rule_source WHERE FALSE DO ALSO INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_d1b5c281de33
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_instead", "condition": "create_rule_condition_none", "event": "create_rule_event_update"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON UPDATE TO t_rule_source DO INSTEAD INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_779dc882eb1a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_default", "condition": "create_rule_condition_false", "event": "create_rule_event_update"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON UPDATE TO t_rule_source WHERE FALSE DO INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_1f38bca1e575
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_also", "condition": "create_rule_condition_none", "event": "create_rule_event_delete"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON DELETE TO t_rule_source DO ALSO INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_create_rule_single_action_3f2e75c03857
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action_form": "create_rule_action_form_single", "actions": "create_rule_actions_one", "behavior": "create_rule_behavior_default", "condition": "create_rule_condition_true", "event": "create_rule_event_delete"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE TABLE t_rule_log (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
-- test_sql:
CREATE RULE fp_rule AS ON DELETE TO t_rule_source WHERE TRUE DO INSERT INTO t_rule_log VALUES (1, 2);
-- fixture_teardown:
DROP TABLE IF EXISTS t_rule_log CASCADE;
DROP TABLE IF EXISTS t_rule_source CASCADE;
