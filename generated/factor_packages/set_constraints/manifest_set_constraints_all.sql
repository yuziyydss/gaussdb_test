-- generated_from: manifest_set_constraints_all
-- static_only: true
-- case_count: 2

-- case_id: manifest_set_constraints_all_17b3eef3e953
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_constraints_form_all", "mode": "set_constraints_mode_deferred", "names": "set_constraints_names_one"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
-- test_sql:
SET CONSTRAINTS ALL DEFERRED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;

-- case_id: manifest_set_constraints_all_08626319f3d5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_constraints_form_all", "mode": "set_constraints_mode_immediate", "names": "set_constraints_names_one"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
-- test_sql:
SET CONSTRAINTS ALL IMMEDIATE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;
