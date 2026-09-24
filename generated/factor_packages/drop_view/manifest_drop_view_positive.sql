-- generated_from: manifest_drop_view_positive
-- static_only: true
-- case_count: 11

-- case_id: manifest_drop_view_positive_23307aa7e020
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_default", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_one;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_d57816abe32e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_restrict", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_one, v_dv_two RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_4d74bb673414
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_cascade", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_missing CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_c6d65b3f5261
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_default", "if_exists": "drop_view_if_exists_present", "targets": "drop_view_targets_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW IF EXISTS v_dv_one, v_dv_two;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_eb38e97d059f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_restrict", "if_exists": "drop_view_if_exists_present", "targets": "drop_view_targets_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW IF EXISTS v_dv_one RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_ae001a84ba92
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_cascade", "if_exists": "drop_view_if_exists_present", "targets": "drop_view_targets_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW IF EXISTS v_dv_base CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_49a3973c62fc
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_default", "if_exists": "drop_view_if_exists_present", "targets": "drop_view_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW IF EXISTS v_dv_missing;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_5625d5cee16f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_restrict", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_missing"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_missing RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_8585b0ee830f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_cascade", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_one"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_one CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_8727e52510a8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_cascade", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_two"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_one, v_dv_two CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_positive_79525feffbd9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_cascade", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_dependent"}
-- fixture_setup:
DROP TABLE IF EXISTS t_view_source CASCADE;
CREATE TABLE t_view_source (col_1 INTEGER, col_2 INTEGER);
INSERT INTO t_view_source (col_1, col_2) VALUES (1, 2), (3, 4);
CREATE VIEW v_dv_one AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_two AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_base AS SELECT col_1, col_2 FROM t_view_source;
CREATE VIEW v_dv_child AS SELECT col_1, col_2 FROM v_dv_base;
DROP VIEW IF EXISTS v_dv_missing;
-- test_sql:
DROP VIEW v_dv_base CASCADE;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;
