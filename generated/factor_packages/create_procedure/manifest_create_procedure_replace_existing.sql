-- generated_from: manifest_create_procedure_replace_existing
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_procedure_replace_existing_54df60c34303
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_none", "argmode": "create_procedure_argmode_in", "body_keyword": "create_procedure_body_keyword_as", "name": "create_procedure_name_replace", "replace": "create_procedure_replace_replace"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_replace(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
CREATE OR REPLACE PROCEDURE fp_proc_replace (a IN INTEGER ) SECURITY INVOKER AS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_replace;
