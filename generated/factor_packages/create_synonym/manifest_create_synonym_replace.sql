-- generated_from: manifest_create_synonym_replace
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_synonym_replace_5306442ee3a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_existing", "replace": "create_synonym_replace_present", "target": "create_synonym_target_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
CREATE SYNONYM s_syn_replace FOR t_syn_source;
-- test_sql:
CREATE OR REPLACE SYNONYM s_syn_replace FOR v_syn_source;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_syn_replace;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;
