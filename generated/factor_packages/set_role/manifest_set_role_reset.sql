-- generated_from: manifest_set_role_reset
-- static_only: true
-- case_count: 1

-- case_id: manifest_set_role_reset_d3f6da068659
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_role_form_reset"}
-- fixture_setup:
BEGIN;
-- test_sql:
RESET ROLE;
-- fixture_teardown:
RESET ROLE;
ROLLBACK;
