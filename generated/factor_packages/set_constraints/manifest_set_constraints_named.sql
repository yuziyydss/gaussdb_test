-- generated_from: manifest_set_constraints_named
-- static_only: true
-- case_count: 4

-- case_id: manifest_set_constraints_named_af6a76ccffe7
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_constraints_form_named", "mode": "set_constraints_mode_deferred", "names": "set_constraints_names_one"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
-- test_sql:
SET CONSTRAINTS uq_sc_one DEFERRED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;

-- case_id: manifest_set_constraints_named_6e56244c6330
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_constraints_form_named", "mode": "set_constraints_mode_immediate", "names": "set_constraints_names_two"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
-- test_sql:
SET CONSTRAINTS uq_sc_one, uq_sc_two IMMEDIATE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;

-- case_id: manifest_set_constraints_named_9b3cc506c980
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_constraints_form_named", "mode": "set_constraints_mode_immediate", "names": "set_constraints_names_one"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
-- test_sql:
SET CONSTRAINTS uq_sc_one IMMEDIATE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;

-- case_id: manifest_set_constraints_named_efe251ebf8f0
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_constraints_form_named", "mode": "set_constraints_mode_deferred", "names": "set_constraints_names_two"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
-- test_sql:
SET CONSTRAINTS uq_sc_one, uq_sc_two DEFERRED;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;
