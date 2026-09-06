-- generated_from: manifest_drop_procedure_existing
-- static_only: true
-- case_count: 2

-- case_id: manifest_drop_procedure_existing_276a6063403f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_procedure_if_exists_none", "name": "drop_procedure_name_existing"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
DROP PROCEDURE fp_proc_ready;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_drop_procedure_existing_364741386033
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_procedure_if_exists_yes", "name": "drop_procedure_name_existing"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
DROP PROCEDURE IF EXISTS fp_proc_ready;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;
