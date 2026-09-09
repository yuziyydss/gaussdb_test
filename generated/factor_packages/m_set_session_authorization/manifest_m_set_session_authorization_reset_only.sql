-- generated_from: manifest_m_set_session_authorization_reset_only
-- static_only: true
-- case_count: 4

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_set_session_authorization_reset_only_176caf40f48e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "m_set_session_authorization_reset_form_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_new_connection"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_session_authorization_reset_only_1f8519a88741
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "m_set_session_authorization_reset_form_session"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_new_connection"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_session_authorization_reset_only_b78d73133df2
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "m_set_session_authorization_reset_form_local"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_new_connection"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET LOCAL SESSION AUTHORIZATION DEFAULT;
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_set_session_authorization_reset_only_7637fe96454e
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"reset_form": "m_set_session_authorization_reset_form_parameter"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_new_connection"], "fact_refs": ["m_set_session_authorization_fact_mode"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
SET SESSION_AUTHORIZATION = DEFAULT;
-- fixture_teardown:
ROLLBACK;
