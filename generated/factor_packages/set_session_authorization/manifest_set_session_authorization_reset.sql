-- generated_from: manifest_set_session_authorization_reset
-- static_only: true
-- case_count: 4

-- case_id: manifest_set_session_authorization_reset_7641ec5bd4c1
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_session_authorization_reset_form_reset"}
-- fixture_setup:
BEGIN;
-- test_sql:
RESET SESSION AUTHORIZATION;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;

-- case_id: manifest_set_session_authorization_reset_74aa5b55bd86
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_session_authorization_reset_form_default"}
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;

-- case_id: manifest_set_session_authorization_reset_d71b1e41f47e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_session_authorization_reset_form_session"}
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;

-- case_id: manifest_set_session_authorization_reset_d9cc0d3524ad
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"form": "set_session_authorization_reset_form_local"}
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;
