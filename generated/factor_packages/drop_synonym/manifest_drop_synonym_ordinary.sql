-- generated_from: manifest_drop_synonym_ordinary
-- static_only: true
-- case_count: 6

-- case_id: manifest_drop_synonym_ordinary_b1af3ad1bb60
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_default", "if_exists": "drop_synonym_if_exists_no", "target": "drop_synonym_target_ordinary"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_syn FOR t_syn_source;
-- test_sql:
DROP SYNONYM s_drop_syn;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_drop_syn;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_ordinary_110169ef21d7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_restrict", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_ordinary"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_syn FOR t_syn_source;
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_syn RESTRICT;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_drop_syn;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_ordinary_5faea2e1020c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_cascade", "if_exists": "drop_synonym_if_exists_no", "target": "drop_synonym_target_ordinary"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_syn FOR t_syn_source;
-- test_sql:
DROP SYNONYM s_drop_syn CASCADE;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_drop_syn;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_ordinary_79eaecdeeb40
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_restrict", "if_exists": "drop_synonym_if_exists_no", "target": "drop_synonym_target_ordinary"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_syn FOR t_syn_source;
-- test_sql:
DROP SYNONYM s_drop_syn RESTRICT;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_drop_syn;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_ordinary_52872222f98f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_default", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_ordinary"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_syn FOR t_syn_source;
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_syn;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_drop_syn;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_drop_synonym_ordinary_01d5e1a320da
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"behavior": "drop_synonym_behavior_cascade", "if_exists": "drop_synonym_if_exists_yes", "target": "drop_synonym_target_ordinary"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE SYNONYM s_drop_syn FOR t_syn_source;
-- test_sql:
DROP SYNONYM IF EXISTS s_drop_syn CASCADE;
-- fixture_teardown:
DROP SYNONYM IF EXISTS s_drop_syn;
DROP TABLE IF EXISTS t_syn_source CASCADE;
