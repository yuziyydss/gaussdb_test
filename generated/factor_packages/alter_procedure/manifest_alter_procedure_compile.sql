-- generated_from: manifest_alter_procedure_compile
-- static_only: true
-- case_count: 3

-- case_id: manifest_alter_procedure_compile_67ef96bfb547
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_compile", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) COMPILE;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_compile_f180daefb9b8
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_compile", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) COMPILE;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_compile_756900a11954
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_compile", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_none"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready COMPILE;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;
