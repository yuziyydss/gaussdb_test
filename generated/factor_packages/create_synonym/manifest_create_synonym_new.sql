-- generated_from: manifest_create_synonym_new
-- static_only: true
-- case_count: 10

-- case_id: manifest_create_synonym_new_1d9d8d208e21
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_absent", "target": "create_synonym_target_table"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE SYNONYM s_syn_create FOR t_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_259cb0b9a76b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_present", "target": "create_synonym_target_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE OR REPLACE SYNONYM s_syn_create FOR v_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_4581b67a98b0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_absent", "target": "create_synonym_target_sequence"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE SYNONYM s_syn_create FOR seq_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_51cfacba9037
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_absent", "target": "create_synonym_target_synonym"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE SYNONYM s_syn_create FOR s_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_c2933ebe362c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_absent", "target": "create_synonym_target_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE SYNONYM s_syn_create FOR fp_syn_absent_object;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_c7d69c9a950c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_absent", "target": "create_synonym_target_view"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE SYNONYM s_syn_create FOR v_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_220fe1f06d88
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_present", "target": "create_synonym_target_table"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE OR REPLACE SYNONYM s_syn_create FOR t_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_cb0cae7b83dc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_present", "target": "create_synonym_target_sequence"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE OR REPLACE SYNONYM s_syn_create FOR seq_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_971493a6c193
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_present", "target": "create_synonym_target_synonym"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE OR REPLACE SYNONYM s_syn_create FOR s_syn_source;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;

-- case_id: manifest_create_synonym_new_b11e7809dd99
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"name": "create_synonym_name_new", "replace": "create_synonym_replace_present", "target": "create_synonym_target_absent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_syn_source CASCADE;
CREATE TABLE t_syn_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_syn_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_syn_source AS SELECT col_1, col_2 FROM t_syn_source;
CREATE SEQUENCE seq_syn_source;
CREATE SYNONYM s_syn_source FOR t_syn_source;
BEGIN;
-- test_sql:
CREATE OR REPLACE SYNONYM s_syn_create FOR fp_syn_absent_object;
-- fixture_teardown:
ROLLBACK;
DROP SYNONYM IF EXISTS s_syn_create;
DROP SYNONYM IF EXISTS s_syn_source;
DROP SEQUENCE IF EXISTS seq_syn_source;
DROP VIEW IF EXISTS v_syn_source;
DROP TABLE IF EXISTS t_syn_source CASCADE;
