-- generated_from: manifest_set_constraints_pending_negative
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_constraints_pending_negative_c40ee73b54ab
-- expected: error
-- expected_error_category: deferred_unique_violation
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: needs_verification
-- expected_scope: syntax_and_semantics
-- params: {"form": "set_constraints_form_named", "mode": "set_constraints_mode_immediate", "names": "set_constraints_names_pending"}
-- fixture_setup:
CREATE TABLE t_constraints (col_1 INTEGER, col_2 INTEGER, CONSTRAINT uq_sc_one UNIQUE (col_1) DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT uq_sc_two UNIQUE (col_2) DEFERRABLE INITIALLY DEFERRED);
BEGIN;
SET CONSTRAINTS uq_sc_two DEFERRED;
INSERT INTO t_constraints VALUES (1, 2), (3, 2);
-- test_sql:
SET CONSTRAINTS uq_sc_two IMMEDIATE;
-- fixture_teardown:
ROLLBACK;
DROP TABLE IF EXISTS t_constraints;
