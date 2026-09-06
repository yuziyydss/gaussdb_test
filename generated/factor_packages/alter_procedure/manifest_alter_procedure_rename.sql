-- generated_from: manifest_alter_procedure_rename
-- static_only: true
-- case_count: 2

-- case_id: manifest_alter_procedure_rename_cef4a6a443a4
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_rename", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_typed"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
BEGIN;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(INTEGER) RENAME TO fp_proc_renamed;
-- fixture_teardown:
ROLLBACK;
DROP PROCEDURE IF EXISTS fp_proc_renamed;
DROP PROCEDURE IF EXISTS fp_proc_ready;

-- case_id: manifest_alter_procedure_rename_0d96426d181f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"action": "alter_procedure_action_immutable", "form": "alter_procedure_form_rename", "restrict": "alter_procedure_restrict_none", "signature": "alter_procedure_signature_named"}
-- fixture_setup:
CREATE PROCEDURE fp_proc_ready(a INTEGER) IS v INTEGER; BEGIN v := a; END;
BEGIN;
-- test_sql:
ALTER PROCEDURE fp_proc_ready(a IN INTEGER) RENAME TO fp_proc_renamed;
-- fixture_teardown:
ROLLBACK;
DROP PROCEDURE IF EXISTS fp_proc_renamed;
DROP PROCEDURE IF EXISTS fp_proc_ready;
