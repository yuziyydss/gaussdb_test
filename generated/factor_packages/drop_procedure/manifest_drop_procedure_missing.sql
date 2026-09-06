-- generated_from: manifest_drop_procedure_missing
-- static_only: true
-- case_count: 1

-- case_id: manifest_drop_procedure_missing_89ae0931efa4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"if_exists": "drop_procedure_if_exists_yes", "name": "drop_procedure_name_missing"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_missing;
-- test_sql:
DROP PROCEDURE IF EXISTS fp_proc_missing;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_missing;
