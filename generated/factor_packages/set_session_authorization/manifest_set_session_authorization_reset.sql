-- generated_from: manifest_set_session_authorization_reset
-- static_only: true
-- case_count: 4

-- case_id: manifest_set_session_authorization_reset_b1f4d3b146ba
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "set_session_authorization_reset_form_reset"}
-- fixture_setup:
BEGIN;
-- test_sql:
RESET SESSION AUTHORIZATION;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;

-- case_id: manifest_set_session_authorization_reset_2cf13e6a1529
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "set_session_authorization_reset_form_default"}
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;

-- case_id: manifest_set_session_authorization_reset_4eedefe2557f
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "set_session_authorization_reset_form_session"}
-- fixture_setup:
BEGIN;
-- test_sql:
SET SESSION SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;

-- case_id: manifest_set_session_authorization_reset_8391dfb48406
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "set_session_authorization_reset_form_local"}
-- fixture_setup:
BEGIN;
-- test_sql:
SET LOCAL SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
RESET SESSION AUTHORIZATION;
ROLLBACK;
