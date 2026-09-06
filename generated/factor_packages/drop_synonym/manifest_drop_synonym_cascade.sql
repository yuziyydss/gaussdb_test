-- generated_from: manifest_drop_synonym_cascade
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_synonym_cascade_f2f6cbe5bead
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_cascade", "if_exists": "drop_synonym_if_exists_no", "target": "drop_synonym_target_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_dep FOR t_syn_source;
CREATE VIEW v_syn_dep AS SELECT col_1, col_2 FROM s_drop_dep;
-- test_sql:
DROP SYNONYM s_drop_dep CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_syn_dep;
DROP SYNONYM IF EXISTS s_drop_dep;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_cascade_d2f5f30dfec2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_cascade", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_dep FOR t_syn_source;
CREATE VIEW v_syn_dep AS SELECT col_1, col_2 FROM s_drop_dep;
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_dep CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_syn_dep;
DROP SYNONYM IF EXISTS s_drop_dep;
DROP TABLE IF EXISTS t_syn_source CASCADE;
