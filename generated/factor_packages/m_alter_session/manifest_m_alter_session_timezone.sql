-- generated_from: manifest_m_alter_session_timezone
-- static_only: true
-- case_count: 2

-- environment_preparation: generated/m_compat_environment/plan.json
-- M database must be created from a non-M management connection, then reconnect and verify.
-- Inspection snapshot only: do not execute as one script; negatives and transaction fixtures need staged execution.

-- case_id: manifest_m_alter_session_timezone_c894c45f414c
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_read", "form": "m_alter_session_form_timezone", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_prc"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TIME ZONE 'PRC';
-- fixture_teardown:
ROLLBACK;

-- case_id: manifest_m_alter_session_timezone_3dbf762d5fdf
-- expected: success
-- expected_error_category: -
-- expected_sqlstates: -
-- expected_error_regex: -
-- expected_oracle_status: confirmed
-- expected_scope: syntax_only
-- params: {"characteristic": "m_alter_session_characteristic_read", "form": "m_alter_session_form_timezone", "parameter_change": "m_alter_session_parameter_change_set", "timezone": "m_alter_session_timezone_default"}
-- environment_requirements: [{"allowed_values": ["M"], "fact_refs": ["m_alter_session_fact_mode"], "key": "compatibility_mode"}, {"allowed_values": ["isolated_connection"], "fact_refs": ["m_alter_session_fact_session"], "key": "session_lifecycle"}]
-- fixture_setup:
START TRANSACTION;
-- test_sql:
ALTER SESSION SET TIME ZONE DEFAULT;
-- fixture_teardown:
ROLLBACK;
