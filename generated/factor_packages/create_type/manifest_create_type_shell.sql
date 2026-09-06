-- generated_from: manifest_create_type_shell
-- static_only: true
-- case_count: 1

-- case_id: manifest_create_type_shell_b828a974e850
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"attributes": "create_type_attributes_empty", "form": "create_type_form_shell", "labels": "create_type_labels_empty"}
-- fixture_setup:
BEGIN;
-- test_sql:
CREATE TYPE typ_b7_b828a974;
-- fixture_teardown:
ROLLBACK;
