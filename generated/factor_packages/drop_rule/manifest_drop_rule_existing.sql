-- generated_from: manifest_drop_rule_existing
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_rule_existing_7de9046dcc3d
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_rule_behavior_default", "if_exists": "drop_rule_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE RULE fp_rule_ready AS ON INSERT TO t_rule_source DO ALSO NOTHING;
-- test_sql:
DROP RULE fp_rule_ready ON t_rule_source;
-- fixture_teardown:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_drop_rule_existing_23e51ed5471a
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_rule_behavior_cascade", "if_exists": "drop_rule_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE RULE fp_rule_ready AS ON INSERT TO t_rule_source DO ALSO NOTHING;
-- test_sql:
DROP RULE fp_rule_ready ON t_rule_source CASCADE;
-- fixture_teardown:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_drop_rule_existing_c0311a2d12a2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_rule_behavior_restrict", "if_exists": "drop_rule_if_exists_none"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE RULE fp_rule_ready AS ON INSERT TO t_rule_source DO ALSO NOTHING;
-- test_sql:
DROP RULE fp_rule_ready ON t_rule_source RESTRICT;
-- fixture_teardown:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_drop_rule_existing_759f9e5175b1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_rule_behavior_default", "if_exists": "drop_rule_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE RULE fp_rule_ready AS ON INSERT TO t_rule_source DO ALSO NOTHING;
-- test_sql:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
-- fixture_teardown:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_drop_rule_existing_685b22c0f1da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_rule_behavior_cascade", "if_exists": "drop_rule_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE RULE fp_rule_ready AS ON INSERT TO t_rule_source DO ALSO NOTHING;
-- test_sql:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source CASCADE;
-- fixture_teardown:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
DROP TABLE IF EXISTS t_rule_source CASCADE;

-- case_id: manifest_drop_rule_existing_3f1576bb4764
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_rule_behavior_restrict", "if_exists": "drop_rule_if_exists_yes"}
-- fixture_setup:
CREATE TABLE t_rule_source (col_1 INTEGER, col_2 INTEGER) WITH (STORAGE_TYPE=ASTORE, segment=off);
INSERT INTO t_rule_source VALUES (1, 2), (3, 4);
CREATE RULE fp_rule_ready AS ON INSERT TO t_rule_source DO ALSO NOTHING;
-- test_sql:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source RESTRICT;
-- fixture_teardown:
DROP RULE IF EXISTS fp_rule_ready ON t_rule_source;
DROP TABLE IF EXISTS t_rule_source CASCADE;
