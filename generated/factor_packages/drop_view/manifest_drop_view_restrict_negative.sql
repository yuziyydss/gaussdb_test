-- generated_from: manifest_drop_view_restrict_negative
-- static_only: true
-- case_count: 4

-- case_id: manifest_drop_view_restrict_negative_f5a442b5702f
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_default", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_dependent"}
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
DROP VIEW v_dv_base;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_restrict_negative_dc973b60b4cf
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_restrict", "if_exists": "drop_view_if_exists_present", "targets": "drop_view_targets_dependent"}
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
DROP VIEW IF EXISTS v_dv_base RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_restrict_negative_bc4025cc498c
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_restrict", "if_exists": "drop_view_if_exists_absent", "targets": "drop_view_targets_dependent"}
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
DROP VIEW v_dv_base RESTRICT;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;

-- case_id: manifest_drop_view_restrict_negative_6f7b762622fb
-- expected: error
-- expected_error_category: dependent_objects_exist
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"behavior": "drop_view_behavior_default", "if_exists": "drop_view_if_exists_present", "targets": "drop_view_targets_dependent"}
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
DROP VIEW IF EXISTS v_dv_base;
-- fixture_teardown:
DROP VIEW IF EXISTS v_dv_child;
DROP VIEW IF EXISTS v_dv_base;
DROP VIEW IF EXISTS v_dv_two;
DROP VIEW IF EXISTS v_dv_one;
DROP TABLE IF EXISTS t_view_source CASCADE;
