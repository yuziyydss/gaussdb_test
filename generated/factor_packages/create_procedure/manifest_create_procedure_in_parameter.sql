-- generated_from: manifest_create_procedure_in_parameter
-- static_only: true
-- case_count: 8

-- case_id: manifest_create_procedure_in_parameter_3a7000056daa
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_none", "argmode": "create_procedure_argmode_default", "body_keyword": "create_procedure_body_keyword_is", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a INTEGER ) SECURITY INVOKER IS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_f5eafbcdbaf9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_default", "argmode": "create_procedure_argmode_in", "body_keyword": "create_procedure_body_keyword_as", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a IN INTEGER DEFAULT 1) SECURITY INVOKER AS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_36b208a97178
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_assign", "argmode": "create_procedure_argmode_default", "body_keyword": "create_procedure_body_keyword_as", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a INTEGER := 1) SECURITY INVOKER AS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_c43b9ee8fdea
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_equal", "argmode": "create_procedure_argmode_in", "body_keyword": "create_procedure_body_keyword_is", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a IN INTEGER = 1) SECURITY INVOKER IS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_848d06e62737
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_default", "argmode": "create_procedure_argmode_default", "body_keyword": "create_procedure_body_keyword_is", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a INTEGER DEFAULT 1) SECURITY INVOKER IS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_8fcd53c88f9c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_equal", "argmode": "create_procedure_argmode_default", "body_keyword": "create_procedure_body_keyword_as", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a INTEGER = 1) SECURITY INVOKER AS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_fa44471c6ea3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_none", "argmode": "create_procedure_argmode_in", "body_keyword": "create_procedure_body_keyword_as", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a IN INTEGER ) SECURITY INVOKER AS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;

-- case_id: manifest_create_procedure_in_parameter_83b3d84a4ef3
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"arg_default": "create_procedure_arg_default_assign", "argmode": "create_procedure_argmode_in", "body_keyword": "create_procedure_body_keyword_is", "name": "create_procedure_name_basic", "replace": "create_procedure_replace_new"}
-- fixture_setup:
DROP PROCEDURE IF EXISTS fp_proc_create;
-- test_sql:
CREATE PROCEDURE fp_proc_create (a IN INTEGER := 1) SECURITY INVOKER IS v INTEGER; BEGIN v := a; END;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_create;
