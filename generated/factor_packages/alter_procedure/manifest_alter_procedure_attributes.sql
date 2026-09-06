-- generated_from: manifest_alter_procedure_attributes
-- static_only: true
-- case_count: 12

-- case_id: manifest_alter_procedure_attributes_40c73d938aa2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) IMMUTABLE;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_eb08431cd564
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_stable", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_yes", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) STABLE RESTRICT;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_640998ecba3e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_volatile", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_yes", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) VOLATILE RESTRICT;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_f9f247dc0c8b
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_invoker", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) SECURITY INVOKER;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_e317eed70aa9
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_current_user", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) AUTHID CURRENT_USER;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_28ea5795b4be
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_cost", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) COST 1;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_8f14da542fe5
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_stable", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) STABLE;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_cc4de8caae78
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_invoker", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_yes", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) SECURITY INVOKER RESTRICT;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_d24fd426c8d6
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_yes", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) IMMUTABLE RESTRICT;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_248890424407
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_volatile", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) VOLATILE;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_6769f99b2b09
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_current_user", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_yes", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) AUTHID CURRENT_USER RESTRICT;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_attributes_bf56039f29bf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_cost", "form": "alter_procedure_form_attributes", "restrict": "alter_procedure_restrict_yes", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) COST 1 RESTRICT;
-- fixture_teardown:
DROP PROCEDURE IF EXISTS fp_proc_ready;
