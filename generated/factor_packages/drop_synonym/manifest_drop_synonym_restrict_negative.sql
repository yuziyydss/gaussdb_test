-- generated_from: manifest_drop_synonym_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_synonym_restrict_negative_84df20bf6c03
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_synonym_behavior_default", "if_exists": "drop_synonym_if_exists_no", "target": "drop_synonym_target_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_dep FOR t_syn_source;
CREATE VIEW v_syn_dep AS SELECT col_1, col_2 FROM s_drop_dep;
-- test_sql:
DROP SYNONYM s_drop_dep;
-- fixture_teardown:
DROP VIEW IF EXISTS v_syn_dep;
DROP SYNONYM IF EXISTS s_drop_dep;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_restrict_negative_f3c0bd0d44b7
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_synonym_behavior_restrict", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_dep FOR t_syn_source;
CREATE VIEW v_syn_dep AS SELECT col_1, col_2 FROM s_drop_dep;
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_dep RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_syn_dep;
DROP SYNONYM IF EXISTS s_drop_dep;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_restrict_negative_9395b623b0ac
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_synonym_behavior_restrict", "if_exists": "drop_synonym_if_exists_no", "target": "drop_synonym_target_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_dep FOR t_syn_source;
CREATE VIEW v_syn_dep AS SELECT col_1, col_2 FROM s_drop_dep;
-- test_sql:
DROP SYNONYM s_drop_dep RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_syn_dep;
DROP SYNONYM IF EXISTS s_drop_dep;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_restrict_negative_f44baa8327c9
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_synonym_behavior_default", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_dep FOR t_syn_source;
CREATE VIEW v_syn_dep AS SELECT col_1, col_2 FROM s_drop_dep;
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_dep;
-- fixture_teardown:
DROP VIEW IF EXISTS v_syn_dep;
DROP SYNONYM IF EXISTS s_drop_dep;
DROP TABLE IF EXISTS t_syn_source CASCADE;
